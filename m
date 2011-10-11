Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35314 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1JKQJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 12:09:28 -0400
Received: by gyg10 with SMTP id 10so6678790gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 09:09:28 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] mac80211: Build TX radiotap header dynamically
Date: Tue, 11 Oct 2011 18:08:54 +0200
Message-Id: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111011_180933_749263_153C15F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of the ieee80211_tx_status_rtap_hdr struct and instead build the
rtap header dynamically. This makes it easier to extend the rtap header
generation in the future.

Add ieee80211_tx_radiotap_len to calculate the expected size of the
rtap header before generating it. Since we can't check if the rtap
header fits into the requested headroom during compile time anymore
add a WARN_ON_ONCE.

Also move the actual rtap header generation into its own function.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/ieee80211_i.h |   12 -----
 net/mac80211/main.c        |    6 +--
 net/mac80211/status.c      |  112 ++++++++++++++++++++++++++++++--------------
 3 files changed, 78 insertions(+), 52 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9fa5f8a..6e56dc8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1178,18 +1178,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 
-/*
- * radiotap header for status frames
- */
-struct ieee80211_tx_status_rtap_hdr {
-	struct ieee80211_radiotap_header hdr;
-	u8 rate;
-	u8 padding_for_rate;
-	__le16 tx_flags;
-	u8 data_retries;
-} __packed;
-
-
 /* HT */
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 17b038a..d4ee6d2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -904,12 +904,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	 * and we need some headroom for passing the frame to monitor
 	 * interfaces, but never both at the same time.
 	 */
-#ifndef __CHECKER__
-	BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=
-			sizeof(struct ieee80211_tx_status_rtap_hdr));
-#endif
 	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
-				   sizeof(struct ieee80211_tx_status_rtap_hdr));
+				   IEEE80211_TX_STATUS_HEADROOM);
 
 	debugfs_hw_add(local);
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 864a9c3..a9dc7b7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -228,6 +228,79 @@ static void ieee80211_set_bar_pending(struct sta_info *sta, u8 tid, u16 ssn)
 	tid_tx->bar_pending = true;
 }
 
+static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
+{
+	int len = sizeof(struct ieee80211_radiotap_header);
+
+	/* IEEE80211_RADIOTAP_RATE rate */
+	if (info->status.rates[0].idx >= 0 &&
+	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
+		len += 2;
+
+	/* IEEE80211_RADIOTAP_TX_FLAGS */
+	len += 2;
+
+	/* IEEE80211_RADIOTAP_DATA_RETRIES */
+	len += 1;
+	
+	return len;
+}
+
+static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
+					     *sband, struct sk_buff *skb,
+					     int retry_count, int rtap_len)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_radiotap_header *rthdr;
+	unsigned char *pos;
+	__le16 txflags;
+
+	rthdr = (struct ieee80211_radiotap_header *) skb_push(skb, rtap_len);
+
+	memset(rthdr, 0, rtap_len);
+	rthdr->it_len = cpu_to_le16(rtap_len);
+	rthdr->it_present =
+		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
+			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES));
+	pos = (unsigned char *)(rthdr + 1);
+
+	/*
+	 * XXX: Once radiotap gets the bitmap reset thing the vendor
+	 *	extensions proposal contains, we can actually report
+	 *	the whole set of tries we did.
+	 */
+
+	/* IEEE80211_RADIOTAP_RATE */
+	if (info->status.rates[0].idx >= 0 &&
+	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+		*pos = sband->bitrates[info->status.rates[0].idx].bitrate / 5;
+		/* padding for tx flags */
+		pos += 2;
+	}
+
+	/* IEEE80211_RADIOTAP_TX_FLAGS */
+	txflags = 0;
+	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
+	    !is_multicast_ether_addr(hdr->addr1))
+		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_FAIL);
+
+	if ((info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
+	    (info->status.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
+		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
+	else if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
+
+	put_unaligned_le16(txflags, pos);
+	pos += 2;
+
+	/* IEEE80211_RADIOTAP_DATA_RETRIES */
+	/* for now report the total retry_count */
+	*pos = retry_count;
+	pos++;
+}
+
 /*
  * Use a static threshold for now, best value to be determined
  * by testing ...
@@ -246,7 +319,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	u16 frag, type;
 	__le16 fc;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
 	struct sta_info *sta, *tmp;
@@ -256,6 +328,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool acked;
 	struct ieee80211_bar *bar;
 	u16 tid;
+	int rtap_len;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if (info->status.rates[i].idx < 0) {
@@ -460,44 +533,13 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	/* send frame to monitor interfaces now */
-
-	if (skb_headroom(skb) < sizeof(*rthdr)) {
+	rtap_len = ieee80211_tx_radiotap_len(info);
+	if (WARN_ON_ONCE(skb_headroom(skb) < rtap_len)) {
 		printk(KERN_ERR "ieee80211_tx_status: headroom too small\n");
 		dev_kfree_skb(skb);
 		return;
 	}
-
-	rthdr = (struct ieee80211_tx_status_rtap_hdr *)
-				skb_push(skb, sizeof(*rthdr));
-
-	memset(rthdr, 0, sizeof(*rthdr));
-	rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
-	rthdr->hdr.it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES) |
-			    (1 << IEEE80211_RADIOTAP_RATE));
-
-	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
-	    !is_multicast_ether_addr(hdr->addr1))
-		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_FAIL);
-
-	/*
-	 * XXX: Once radiotap gets the bitmap reset thing the vendor
-	 *	extensions proposal contains, we can actually report
-	 *	the whole set of tries we did.
-	 */
-	if ((info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
-	    (info->status.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
-		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
-	else if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
-		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
-	if (info->status.rates[0].idx >= 0 &&
-	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
-		rthdr->rate = sband->bitrates[
-				info->status.rates[0].idx].bitrate / 5;
-
-	/* for now report the total retry_count */
-	rthdr->data_retries = retry_count;
+	ieee80211_add_tx_radiotap_header(sband, skb, retry_count, rtap_len);
 
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
-- 
1.7.3.4

