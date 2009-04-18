Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:33274 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZDRFZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 01:25:09 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id 3183CFAADA63
	for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 07:25:06 +0200 (CEST)
Received: from [91.22.221.200] (helo=debian64.daheim)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1Lv333-0005ZF-00
	for linux-wireless@vger.kernel.org; Sat, 18 Apr 2009 07:25:06 +0200
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpa (Exim 4.69)
	(envelope-from <chunkeey@web.de>)
	id 1Lv33k-0003bR-DM
	for linux-wireless@vger.kernel.org; Sat, 18 Apr 2009 07:25:48 +0200
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2] ar9170: 802.11n RX Part
Date: Sat, 18 Apr 2009 07:25:47 +0200
References: <200904142159.59511.chunkeey@web.de>
In-Reply-To: <200904142159.59511.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200904180725.47981.chunkeey@web.de> (sfid-20090418_072518_472274_8BD98FDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this patch you can finally tune your ar9170 radio to the next network
and listen to the sound of HT.

---

For HT TX we need:
 - rate algo that gives us MCS indexes and sets 40MHz and SGI flags.
 - Aggregation ( handle & initiate BlockAck (aka BA) sessions )
 - and maybe even more...

changes:
	- handle & workaround almost all common errors that broke rxstream and
	  caused frame loss.
	- added a informative messages if the rxstream is unstable/corrupted too often
	- rewrote rx_status code => split mac_status and phy_status into separate codepaths
	- don't pass frames that failed plcp & fcs check to the stack, if the appropriate
	   FIF_ flags aren't set.
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index f797495..acc2783 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -89,6 +89,11 @@ enum ar9170_device_state {
 	AR9170_ASSOCIATED,
 };
 
+struct ar9170_rxstream_mpdu_merge {
+	struct ar9170_rx_head plcp;
+	bool has_plcp;
+};
+
 struct ar9170 {
 	struct ieee80211_hw *hw;
 	struct mutex mutex;
@@ -120,6 +125,7 @@ struct ar9170 {
 	u64 cur_mc_hash, want_mc_hash;
 	u32 cur_filter, want_filter;
 	unsigned int filter_changed;
+	unsigned int filter_state;
 	bool sniffer_enabled;
 
 	/* PHY */
@@ -159,6 +165,12 @@ struct ar9170 {
 	struct sk_buff_head global_tx_status;
 	struct sk_buff_head global_tx_status_waste;
 	struct delayed_work tx_status_janitor;
+
+	/* rxstream mpdu merge */
+	struct ar9170_rxstream_mpdu_merge rx_mpdu;
+	struct sk_buff *rx_failover;
+	unsigned long bad_hw_nagger;
+	int rx_failover_missing;
 };
 
 struct ar9170_sta_info {
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 53e250a..55d402e 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -312,7 +312,7 @@ struct ar9170_rx_head {
 	u8 plcp[12];
 } __packed;
 
-struct ar9170_rx_tail {
+struct ar9170_rx_phystatus {
 	union {
 		struct {
 			u8 rssi_ant0, rssi_ant1, rssi_ant2,
@@ -324,6 +324,9 @@ struct ar9170_rx_tail {
 
 	u8 evm_stream0[6], evm_stream1[6];
 	u8 phy_err;
+} __packed;
+
+struct ar9170_rx_macstatus {
 	u8 SAidx, DAidx;
 	u8 error;
 	u8 status;
@@ -339,7 +342,7 @@ struct ar9170_rx_tail {
 
 #define AR9170_RX_ENC_SOFTWARE			0x8
 
-static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_tail *t)
+static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_macstatus *t)
 {
 	return (t->SAidx & 0xc0) >> 4 |
 	       (t->DAidx & 0xc0) >> 6;
@@ -357,10 +360,9 @@ static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_tail *t)
 
 #define AR9170_RX_STATUS_MPDU_MASK		0x30
 #define AR9170_RX_STATUS_MPDU_SINGLE		0x00
-#define AR9170_RX_STATUS_MPDU_FIRST		0x10
-#define AR9170_RX_STATUS_MPDU_MIDDLE		0x20
-#define AR9170_RX_STATUS_MPDU_LAST		0x30
-
+#define AR9170_RX_STATUS_MPDU_FIRST		0x20
+#define AR9170_RX_STATUS_MPDU_MIDDLE		0x30
+#define AR9170_RX_STATUS_MPDU_LAST		0x10
 
 #define AR9170_RX_ERROR_RXTO			0x01
 #define AR9170_RX_ERROR_OVERRUN			0x02
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 857416c..21e3ada 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -436,214 +436,395 @@ static void ar9170_handle_command_response(struct ar9170 *ar,
 	}
 }
 
-/*
- * If the frame alignment is right (or the kernel has
- * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS), and there
- * is only a single MPDU in the USB frame, then we can
- * submit to mac80211 the SKB directly. However, since
- * there may be multiple packets in one SKB in stream
- * mode, and we need to observe the proper ordering,
- * this is non-trivial.
- */
-static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
+static void ar9170_rx_reset_rx_mpdu(struct ar9170 *ar)
 {
-	struct sk_buff *skb;
-	struct ar9170_rx_head *head = (void *)buf;
-	struct ar9170_rx_tail *tail;
-	struct ieee80211_rx_status status;
-	int mpdu_len, i;
-	u8 error, antennas = 0, decrypt;
-	__le16 fc;
-	int reserved;
+	memset(&ar->rx_mpdu.plcp, 0, sizeof(struct ar9170_rx_head));
+	ar->rx_mpdu.has_plcp = false;
+}
 
-	if (unlikely(!IS_STARTED(ar)))
-		return ;
+static int ar9170_rx_mac_status(struct ar9170 *ar,
+				struct ar9170_rx_head *head,
+				struct ar9170_rx_macstatus *mac,
+				struct ieee80211_rx_status *status)
+{
+	u8 error, decrypt;
 
-	/* Received MPDU */
-	mpdu_len = len;
-	mpdu_len -= sizeof(struct ar9170_rx_head);
-	mpdu_len -= sizeof(struct ar9170_rx_tail);
 	BUILD_BUG_ON(sizeof(struct ar9170_rx_head) != 12);
-	BUILD_BUG_ON(sizeof(struct ar9170_rx_tail) != 24);
+	BUILD_BUG_ON(sizeof(struct ar9170_rx_macstatus) != 4);
 
-	if (mpdu_len <= FCS_LEN)
-		return;
-
-	tail = (void *)(buf + sizeof(struct ar9170_rx_head) + mpdu_len);
+	status->band = ar->channel->band;
+	status->freq = ar->channel->center_freq;
 
-	for (i = 0; i < 3; i++)
-		if (tail->rssi[i] != 0x80)
-			antennas |= BIT(i);
-
-	/* post-process RSSI */
-	for (i = 0; i < 7; i++)
-		if (tail->rssi[i] & 0x80)
-			tail->rssi[i] = ((tail->rssi[i] & 0x7f) + 1) & 0x7f;
-
-	memset(&status, 0, sizeof(status));
-
-	status.band = ar->channel->band;
-	status.freq = ar->channel->center_freq;
-	status.signal = ar->noise[0] + tail->rssi_combined;
-	status.noise = ar->noise[0];
-	status.antenna = antennas;
-
-	switch (tail->status & AR9170_RX_STATUS_MODULATION_MASK) {
+	switch (mac->status & AR9170_RX_STATUS_MODULATION_MASK) {
 	case AR9170_RX_STATUS_MODULATION_CCK:
-		if (tail->status & AR9170_RX_STATUS_SHORT_PREAMBLE)
-			status.flag |= RX_FLAG_SHORTPRE;
+		if (mac->status & AR9170_RX_STATUS_SHORT_PREAMBLE)
+			status->flag |= RX_FLAG_SHORTPRE;
 		switch (head->plcp[0]) {
 		case 0x0a:
-			status.rate_idx = 0;
+			status->rate_idx = 0;
 			break;
 		case 0x14:
-			status.rate_idx = 1;
+			status->rate_idx = 1;
 			break;
 		case 0x37:
-			status.rate_idx = 2;
+			status->rate_idx = 2;
 			break;
 		case 0x6e:
-			status.rate_idx = 3;
+			status->rate_idx = 3;
 			break;
 		default:
 			if ((!ar->sniffer_enabled) && (net_ratelimit()))
 				printk(KERN_ERR "%s: invalid plcp cck rate "
 				       "(%x).\n", wiphy_name(ar->hw->wiphy),
 				       head->plcp[0]);
-			return;
+			return -EINVAL;
 		}
 		break;
+
 	case AR9170_RX_STATUS_MODULATION_OFDM:
 		switch (head->plcp[0] & 0xF) {
 		case 0xB:
-			status.rate_idx = 0;
+			status->rate_idx = 0;
 			break;
 		case 0xF:
-			status.rate_idx = 1;
+			status->rate_idx = 1;
 			break;
 		case 0xA:
-			status.rate_idx = 2;
+			status->rate_idx = 2;
 			break;
 		case 0xE:
-			status.rate_idx = 3;
+			status->rate_idx = 3;
 			break;
 		case 0x9:
-			status.rate_idx = 4;
+			status->rate_idx = 4;
 			break;
 		case 0xD:
-			status.rate_idx = 5;
+			status->rate_idx = 5;
 			break;
 		case 0x8:
-			status.rate_idx = 6;
+			status->rate_idx = 6;
 			break;
 		case 0xC:
-			status.rate_idx = 7;
+			status->rate_idx = 7;
 			break;
 		default:
 			if ((!ar->sniffer_enabled) && (net_ratelimit()))
 				printk(KERN_ERR "%s: invalid plcp ofdm rate "
 				       "(%x).\n", wiphy_name(ar->hw->wiphy),
 				       head->plcp[0]);
-			return;
+			return -EINVAL;
 		}
-		if (status.band == IEEE80211_BAND_2GHZ)
-			status.rate_idx += 4;
+		if (status->band == IEEE80211_BAND_2GHZ)
+			status->rate_idx += 4;
 		break;
-	case AR9170_RX_STATUS_MODULATION_HT:
+
 	case AR9170_RX_STATUS_MODULATION_DUPOFDM:
 		/* XXX */
-
 		if (net_ratelimit())
 			printk(KERN_ERR "%s: invalid modulation\n",
 			       wiphy_name(ar->hw->wiphy));
-		return;
+		return -EINVAL;
+
+	case AR9170_RX_STATUS_MODULATION_HT:
+		if (head->plcp[3] & 0x80)
+			status->flag |= RX_FLAG_40MHZ;
+		if (head->plcp[6] & 0x80)
+			status->flag |= RX_FLAG_SHORT_GI;
+
+		status->rate_idx = clamp(0, 75, head->plcp[6] & 0x7f);
+		status->flag |= RX_FLAG_HT;
+		break;
 	}
 
-	error = tail->error;
+	error = mac->error;
 
 	if (error & AR9170_RX_ERROR_MMIC) {
-		status.flag |= RX_FLAG_MMIC_ERROR;
+		status->flag |= RX_FLAG_MMIC_ERROR;
 		error &= ~AR9170_RX_ERROR_MMIC;
 	}
 
 	if (error & AR9170_RX_ERROR_PLCP) {
-		status.flag |= RX_FLAG_FAILED_PLCP_CRC;
+		status->flag |= RX_FLAG_FAILED_PLCP_CRC;
 		error &= ~AR9170_RX_ERROR_PLCP;
+
+		if (!(ar->filter_state & FIF_PLCPFAIL))
+			return -EINVAL;
 	}
 
 	if (error & AR9170_RX_ERROR_FCS) {
-		status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 		error &= ~AR9170_RX_ERROR_FCS;
+
+		if (!(ar->filter_state & FIF_FCSFAIL))
+			return -EINVAL;
 	}
 
-	decrypt = ar9170_get_decrypt_type(tail);
+	decrypt = ar9170_get_decrypt_type(mac);
 	if (!(decrypt & AR9170_RX_ENC_SOFTWARE) &&
 	    decrypt != AR9170_ENC_ALG_NONE)
-		status.flag |= RX_FLAG_DECRYPTED;
+		status->flag |= RX_FLAG_DECRYPTED;
 
 	/* ignore wrong RA errors */
 	error &= ~AR9170_RX_ERROR_WRONG_RA;
 
 	if (error & AR9170_RX_ERROR_DECRYPT) {
 		error &= ~AR9170_RX_ERROR_DECRYPT;
-
 		/*
 		 * Rx decryption is done in place,
 		 * the original data is lost anyway.
 		 */
-		return ;
+
+		return -EINVAL;
 	}
 
 	/* drop any other error frames */
-	if ((error) && (net_ratelimit())) {
-		printk(KERN_DEBUG "%s: errors: %#x\n",
-		       wiphy_name(ar->hw->wiphy), error);
-		return;
+	if (error) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: errors: %#x\n",
+			       wiphy_name(ar->hw->wiphy), error);
+
+		return -EINVAL;
 	}
 
-	buf += sizeof(struct ar9170_rx_head);
-	fc = *(__le16 *)buf;
+	return 0;
+}
 
-	if (ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc))
-		reserved = 32 + 2;
-	else
-		reserved = 32;
+static void ar9170_rx_phy_status(struct ar9170 *ar,
+				 struct ar9170_rx_phystatus *phy,
+				 struct ieee80211_rx_status *status)
+{
+	int i;
 
-	skb = dev_alloc_skb(mpdu_len + reserved);
-	if (!skb)
-		return;
+	BUILD_BUG_ON(sizeof(struct ar9170_rx_phystatus) != 20);
+
+	for (i = 0; i < 3; i++)
+		if (phy->rssi[i] != 0x80)
+			status->antenna |= BIT(i);
+
+	/* post-process RSSI */
+	for (i = 0; i < 7; i++)
+		if (phy->rssi[i] & 0x80)
+			phy->rssi[i] = ((phy->rssi[i] & 0x7f) + 1) & 0x7f;
+
+	/* FIXME: parse phy errors */
+
+	status->signal = ar->noise[0] + phy->rssi_combined;
+	status->noise = ar->noise[0];
+}
+
+static struct sk_buff *ar9170_rx_copy_data(u8 *buf, int len)
+{
+	struct sk_buff *skb;
+	int reserved = 0;
+	struct ieee80211_hdr *hdr = (void *) buf;
+
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
+		reserved += NET_IP_ALIGN;
+
+		if (*qc & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+			reserved += NET_IP_ALIGN;
+	}
+
+	if (ieee80211_has_a4(hdr->frame_control))
+		reserved += NET_IP_ALIGN;
+
+	reserved = 32 + (reserved & NET_IP_ALIGN);
+
+	skb = dev_alloc_skb(len + reserved);
+	if (likely(skb)) {
+		skb_reserve(skb, reserved);
+		memcpy(skb_put(skb, len), buf, len);
+	}
+
+	return skb;
+}
+
+/*
+ * If the frame alignment is right (or the kernel has
+ * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS), and there
+ * is only a single MPDU in the USB frame, then we can
+ * submit to mac80211 the SKB directly. However, since
+ * there may be multiple packets in one SKB in stream
+ * mode, and we need to observe the proper ordering,
+ * this is non-trivial.
+ */
+
+static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
+{
+	struct ar9170_rx_head *head;
+	struct ar9170_rx_macstatus *mac;
+	struct ar9170_rx_phystatus *phy;
+	struct ieee80211_rx_status status;
+	struct sk_buff *skb;
+	int mpdu_len;
+
+	if (unlikely(!IS_STARTED(ar) || len < (sizeof(*mac))))
+		return ;
+
+	/* Received MPDU */
+	mpdu_len = len - sizeof(*mac);
+
+	mac = (void *)(buf + mpdu_len);
+	switch (mac->status & AR9170_RX_STATUS_MPDU_MASK) {
+	case AR9170_RX_STATUS_MPDU_FIRST:
+		/* first mpdu packet has the plcp header */
+		if (likely(mpdu_len >= sizeof(struct ar9170_rx_head))) {
+			head = (void *) buf;
+			memcpy(&ar->rx_mpdu.plcp, (void *) buf,
+			       sizeof(struct ar9170_rx_head));
+
+			mpdu_len -= sizeof(struct ar9170_rx_head);
+			buf += sizeof(struct ar9170_rx_head);
+			ar->rx_mpdu.has_plcp = true;
+		} else {
+			if (net_ratelimit())
+				printk(KERN_ERR "%s: plcp info is clipped.\n",
+				       wiphy_name(ar->hw->wiphy));
+			return ;
+		}
+		break;
 
-	skb_reserve(skb, reserved);
-	memcpy(skb_put(skb, mpdu_len), buf, mpdu_len);
-	ieee80211_rx_irqsafe(ar->hw, skb, &status);
+	case AR9170_RX_STATUS_MPDU_LAST:
+		/* last mpdu has a extra tail with phy status information */
+
+		if (likely(mpdu_len >= sizeof(struct ar9170_rx_phystatus))) {
+			mpdu_len -= sizeof(struct ar9170_rx_phystatus);
+			phy = (void *)(buf + mpdu_len);
+		} else {
+			if (net_ratelimit())
+				printk(KERN_ERR "%s: frame tail is clipped.\n",
+				       wiphy_name(ar->hw->wiphy));
+			return ;
+		}
+
+	case AR9170_RX_STATUS_MPDU_MIDDLE:
+		/* middle mpdus are just data */
+		if (unlikely(!ar->rx_mpdu.has_plcp)) {
+			if (!net_ratelimit())
+				return ;
+
+			printk(KERN_ERR "%s: rx stream did not start "
+					"with a first_mpdu frame.\n",
+			       wiphy_name(ar->hw->wiphy));
+
+			return ;
+		}
+
+		head = &ar->rx_mpdu.plcp;
+		break;
+
+	case AR9170_RX_STATUS_MPDU_SINGLE:
+		/* single mpdu - has plcp (head) and phy status (tail) */
+		head = (void *) buf;
+
+		mpdu_len -= sizeof(struct ar9170_rx_head);
+		mpdu_len -= sizeof(struct ar9170_rx_phystatus);
+
+		buf += sizeof(struct ar9170_rx_head);
+		phy = (void *)(buf + mpdu_len);
+		break;
+
+	default:
+		BUG_ON(1);
+		break;
+	}
+
+	if (unlikely(mpdu_len < FCS_LEN))
+		return ;
+
+	memset(&status, 0, sizeof(status));
+	if (unlikely(ar9170_rx_mac_status(ar, head, mac, &status)))
+		return ;
+
+	if (phy)
+		ar9170_rx_phy_status(ar, phy, &status);
+
+	skb = ar9170_rx_copy_data(buf, mpdu_len);
+	if (likely(skb))
+		ieee80211_rx_irqsafe(ar->hw, skb, &status);
 }
 
 void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb)
 {
-	unsigned int i, tlen, resplen;
+	unsigned int i, tlen, resplen, wlen = 0, clen = 0;
 	u8 *tbuf, *respbuf;
 
 	tbuf = skb->data;
 	tlen = skb->len;
 
 	while (tlen >= 4) {
-		int clen = tbuf[1] << 8 | tbuf[0];
-		int wlen = (clen + 3) & ~3;
+		clen = tbuf[1] << 8 | tbuf[0];
+		wlen = ALIGN(clen, 4);
 
-		/*
-		 * parse stream (if any)
-		 */
+		/* check if this is stream has a valid tag.*/
 		if (tbuf[2] != 0 || tbuf[3] != 0x4e) {
-			printk(KERN_ERR "%s: missing tag!\n",
-			       wiphy_name(ar->hw->wiphy));
+			/*
+			 * TODO: handle the highly unlikely event that the
+			 * corrupted stream has the TAG at the right position.
+			 */
+
+			/* check if the frame can be repaired. */
+			if (!ar->rx_failover_missing) {
+				/* this is no "short read". */
+				if (net_ratelimit())
+					printk(KERN_ERR "%s: missing tag!\n",
+					       wiphy_name(ar->hw->wiphy));
+
+				goto err_telluser;
+			}
+
+			if (ar->rx_failover_missing > tlen) {
+				if (net_ratelimit())
+					printk(KERN_ERR "%s: possible multi "
+					       "stream corruption!\n",
+					       wiphy_name(ar->hw->wiphy));
+
+				goto err_telluser;
+			}
+
+			memcpy(skb_put(ar->rx_failover, tlen), tbuf, tlen);
+			ar->rx_failover_missing -= tlen;
+
+			if (ar->rx_failover_missing <= 0) {
+				/*
+				 * nested ar9170_rx call!
+				 * termination is guranteed, even when the
+				 * combined frame also have a element with
+				 * a bad tag.
+				 */
+
+				ar->rx_failover_missing = 0;
+				ar9170_rx(ar, ar->rx_failover);
+
+				skb_reset_tail_pointer(ar->rx_failover);
+				skb_trim(ar->rx_failover, 0);
+			}
+
 			return ;
 		}
+
+		/* check if stream is clipped */
 		if (wlen > tlen - 4) {
-			printk(KERN_ERR "%s: invalid RX (%d, %d, %d)\n",
-			       wiphy_name(ar->hw->wiphy), clen, wlen, tlen);
-			print_hex_dump(KERN_DEBUG, "data: ",
-				       DUMP_PREFIX_OFFSET,
-				       16, 1, tbuf, tlen, true);
+			if (ar->rx_failover_missing) {
+
+				/* TODO: handle double stream corruption. */
+				if (net_ratelimit())
+					printk(KERN_ERR "%s: double rx stream "
+					       "corruption!\n",
+						wiphy_name(ar->hw->wiphy));
+
+				goto err_telluser;
+			}
+
+			/*
+			 * save incomplete data set.
+			 * the firmware will resend the missing bits when
+			 * the rx - descriptor comes round again.
+			 */
+
+			memcpy(skb_put(ar->rx_failover, tlen), tbuf, tlen);
+			ar->rx_failover_missing = clen - tlen;
 			return ;
 		}
 		resplen = clen;
@@ -668,12 +849,41 @@ void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb)
 		if (i == 12)
 			ar9170_handle_command_response(ar, respbuf, resplen);
 		else
-			ar9170_handle_mpdu(ar, respbuf, resplen);
+			ar9170_handle_mpdu(ar, respbuf, clen);
 	}
 
-	if (tlen)
-		printk(KERN_ERR "%s: buffer remains!\n",
-		       wiphy_name(ar->hw->wiphy));
+	if (tlen) {
+		if (net_ratelimit())
+			printk(KERN_ERR "%s: %d bytes of unprocessed "
+					"data left in rx stream!\n",
+			       wiphy_name(ar->hw->wiphy), tlen);
+
+		goto err_telluser;
+	}
+
+	return ;
+
+err_telluser:
+	skb_reset_tail_pointer(ar->rx_failover);
+	skb_trim(ar->rx_failover, 0);
+	ar->rx_failover_missing = 0;
+
+	/* only bark errors are rather frequent. */
+	if (!net_ratelimit() && (time_after(jiffies, ar->bad_hw_nagger)))
+		return ;
+
+	printk(KERN_ERR "%s: damaged RX stream data [want:%d, "
+			"data:%d, rx:%d, pending:%d ]\n",
+	       wiphy_name(ar->hw->wiphy), clen, wlen, tlen,
+	       ar->rx_failover_missing);
+
+	print_hex_dump_bytes("DUMP:", DUMP_PREFIX_OFFSET, skb->data, skb->len);
+
+	printk(KERN_ERR "%s: please check your hardware and cables, if "
+			"you see this message frequently.\n",
+	       wiphy_name(ar->hw->wiphy));
+
+	ar->bad_hw_nagger = jiffies + HZ;
 }
 
 #define AR9170_FILL_QUEUE(queue, ai_fs, cwmin, cwmax, _txop)		\
@@ -703,6 +913,8 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 	AR9170_FILL_QUEUE(ar->edcf[3], 2, 3,     7, 47); /* VOICE */
 	AR9170_FILL_QUEUE(ar->edcf[4], 2, 3,     7,  0); /* SPECIAL */
 
+	ar->bad_hw_nagger = jiffies;
+
 	err = ar->open(ar);
 	if (err)
 		goto out;
@@ -1156,8 +1368,8 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 
 	/* mask supported flags */
 	*new_flags &= FIF_ALLMULTI | FIF_CONTROL | FIF_BCN_PRBRESP_PROMISC |
-		      FIF_PROMISC_IN_BSS;
-
+		      FIF_PROMISC_IN_BSS | FIF_FCSFAIL | FIF_PLCPFAIL;
+	ar->filter_state = *new_flags;
 	/*
 	 * We can support more by setting the sniffer bit and
 	 * then checking the error flags, later.
@@ -1521,20 +1733,33 @@ void *ar9170_alloc(size_t priv_size)
 {
 	struct ieee80211_hw *hw;
 	struct ar9170 *ar;
+	struct sk_buff *skb;
 	int i;
 
+	/*
+	 * this buffer is used for rx stream reconstruction.
+	 * Under heavy load this device (or the transport layer?)
+	 * tends to split the streams into seperate rx descriptors.
+	 */
+
+	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE, GFP_KERNEL);
+	if (!skb)
+		goto err_nomem;
+
 	hw = ieee80211_alloc_hw(priv_size, &ar9170_ops);
 	if (!hw)
-		return ERR_PTR(-ENOMEM);
+		goto err_nomem;
 
 	ar = hw->priv;
 	ar->hw = hw;
+	ar->rx_failover = skb;
 
 	mutex_init(&ar->mutex);
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_stats_lock);
 	skb_queue_head_init(&ar->global_tx_status);
 	skb_queue_head_init(&ar->global_tx_status_waste);
+	ar9170_rx_reset_rx_mpdu(ar);
 	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
 	INIT_DELAYED_WORK(&ar->tx_status_janitor, ar9170_tx_status_janitor);
@@ -1562,6 +1787,10 @@ void *ar9170_alloc(size_t priv_size)
 		ar->noise[i] = -95; /* ATH_DEFAULT_NOISE_FLOOR */
 
 	return ar;
+
+err_nomem:
+	kfree_skb(skb);
+	return ERR_PTR(-ENOMEM);
 }
 
 static int ar9170_read_eeprom(struct ar9170 *ar)
@@ -1687,6 +1916,7 @@ void ar9170_unregister(struct ar9170 *ar)
 	ar9170_unregister_leds(ar);
 #endif /* CONFIG_AR9170_LEDS */
 
+	kfree_skb(ar->rx_failover);
 	ieee80211_unregister_hw(ar->hw);
 	mutex_destroy(&ar->mutex);
 }
 
