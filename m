Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43488 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbXC2Nkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 09:40:45 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id F3FEC8D0F4
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 15:40:39 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 5E7EE100CC
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 13:41:03 +0000 (UTC)
Message-Id: <20070329134041.636125921@warmcat.com>
References: <20070329133814.841581235@warmcat.com>
Date: Thu, 29 Mar 2007 14:38:19 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] mac80211: Monitor mode radiotap-based packet injection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy@warmcat.com>

Try #6
 - Accounted for various comments from Johannes Berg
 - Radiotap parsing is moved to cfg80211 as requested in a separate patch

Try #5
 - De-indent last few indented comments

Try #4
 - All from Michael Wu's feedback: further style heresies removed
 - took account of radiotap arg alignment requirement.  n-byte arg must be
   placed on n-byte boundary using padding where necessary

Try #3
 - moved to Michael Wu's method of tracking if we came in on a
   monitor interface by using ifindex
 - removed older proposed monitor interface tracking method and flags
 - style fixes
 - removed duped #include that is present in Michael Wu's patch already

Try #2
 - took Michael Wu's advice about better tools and basing on wireless-dev
 - took Luis Rodriguez's advice about coding style makeover
 - took Pavel Roskin's advice about little-endian radiotap

===================================================

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e6a0a0e..95b041e 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1070,7 +1070,111 @@ ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data *tx)
 }
 
 
-static void inline
+/* deal with packet injection down monitor interface
+ * with Radiotap Header -- only called for monitor mode interface
+ */
+
+static ieee80211_txrx_result
+__ieee80211_convert_radiotap_to_control_and_remove(
+	struct ieee80211_txrx_data *tx,
+	struct sk_buff *skb, struct ieee80211_tx_control *control)
+{
+	/* this is the moment to interpret and discard the radiotap header that
+	 * must be at the start of the packet injected in Monitor mode
+	 *
+	 * Need to take some care with endian-ness since radiotap
+	 * args are little-endian
+	 */
+
+	struct ieee80211_radiotap_iterator iterator;
+	struct ieee80211_radiotap_header *rthdr =
+		(struct ieee80211_radiotap_header *) skb->data;
+	struct ieee80211_hw_mode *hw_mode=tx->local->hw.conf.mode;
+
+	/* this can fail some sanity checks, drop packet if it does so */
+
+	if (ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len) < 0)
+		return TXRX_DROP;
+
+	/* default control situation for all injected packets
+	 * FIXME: this does not suit all usage cases, expand to allow control
+	 */
+
+	control->retry_limit = 1; /* no retry */
+	control->key_idx = -1; /* no encryption key */
+	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
+			    IEEE80211_TXCTL_USE_CTS_PROTECT);
+	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT |
+			  IEEE80211_TXCTL_NO_ACK;
+	control->antenna_sel_tx = 0; /* default to default antenna */
+
+	/* for every radiotap entry that is present (returns -ve on end or
+	 * on error)
+	 */
+
+	while (ieee80211_radiotap_iterator_next(&iterator) >= 0) {
+		int i, target_rate;
+
+		/* see if this argument is something we can use */
+
+		switch (iterator.this_arg_index) {
+
+		case IEEE80211_RADIOTAP_RATE:
+			/* radiotap "rate" u8 is in
+			 * 500kbps units, eg, 0x02=1Mbps
+			 * ieee80211 "rate" int is
+			 * in 100kbps units, eg, 0x0a=1Mbps
+			 */
+			target_rate = (*iterator.this_arg) * 5;
+			for (i = 0; i < hw_mode->num_rates; i++) {
+				struct ieee80211_rate *r = &hw_mode->rates[i];
+
+				if (r->rate > target_rate)
+					continue;
+
+				control->rate = r;
+
+				if (r->flags & IEEE80211_RATE_PREAMBLE2)
+					control->tx_rate = r->val2;
+				else
+					control->tx_rate = r->val;
+
+				/* end on exact match */
+				if (r->rate == target_rate)
+					i = hw_mode->num_rates;
+
+			}
+			break;
+
+		case IEEE80211_RADIOTAP_ANTENNA:
+			/* radiotap uses 0 for 1st ant,
+			 * mac80211 is 1 for 1st ant
+			 * absence of IEEE80211_RADIOTAP_ANTENNA
+			 * gives default/diversity
+			 */
+			control->antenna_sel_tx = (*iterator.this_arg) + 1;
+			break;
+
+		case IEEE80211_RADIOTAP_DBM_TX_POWER:
+			control->power_level = *iterator.this_arg;
+			break;
+
+		default:
+			break;
+		}
+
+	}
+
+	/* remove the radiotap header
+	 * rthdr->it_len was sanity-checked against skb->len by iterator init
+	 */
+	skb_pull(skb, le16_to_cpu(rthdr->it_len));
+
+	return TXRX_CONTINUE;
+}
+
+
+static ieee80211_txrx_result inline
 __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		       struct sk_buff *skb,
 		       struct net_device *dev,
@@ -1078,6 +1182,9 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sub_if_data *sdata;
+	ieee80211_txrx_result res = TXRX_CONTINUE;
+
 	int hdrlen;
 
 	memset(tx, 0, sizeof(*tx));
@@ -1087,7 +1194,32 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	tx->sta = sta_info_get(local, hdr->addr1);
 	tx->fc = le16_to_cpu(hdr->frame_control);
+
+	/* set defaults for things that can be set by
+	 * injected radiotap headers
+	 */
+
 	control->power_level = local->hw.conf.power_level;
+	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta)
+		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
+
+	/* process and remove the injection radiotap header */
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (unlikely(sdata->type == IEEE80211_IF_TYPE_MNTR)) {
+		if (__ieee80211_convert_radiotap_to_control_and_remove(
+		    tx, skb, control) == TXRX_DROP) {
+			return TXRX_DROP;
+		}
+		/* we removed the radiotap header after this point,
+		 * we filled control with what we could use
+		 * set to the actual ieee header now
+		 */
+		hdr = (struct ieee80211_hdr *) skb->data;
+		res = TXRX_QUEUED; /* indication it was monitor packet */
+	}
+
 	tx->u.tx.control = control;
 	tx->u.tx.unicast = !is_multicast_ether_addr(hdr->addr1);
 	if (is_multicast_ether_addr(hdr->addr1))
@@ -1104,9 +1236,6 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
 		tx->sta->clear_dst_mask = 0;
 	}
-	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta)
-		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
@@ -1114,6 +1243,7 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 	}
 	control->flags |= IEEE80211_TXCTL_FIRST_FRAGMENT;
 
+	return res;
 }
 
 static int inline is_ieee80211_device(struct net_device *dev,
@@ -1221,7 +1351,7 @@ static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
-	ieee80211_txrx_result res = TXRX_DROP;
+	ieee80211_txrx_result res = TXRX_DROP, res_prepare;
 	int ret, i;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
@@ -1231,15 +1361,26 @@ static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
 		return 0;
 	}
 
-	__ieee80211_tx_prepare(&tx, skb, dev, control);
+	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev, control);
+
+	if (res_prepare == TXRX_DROP) {
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
 	sta = tx.sta;
 	tx.u.tx.mgmt_interface = mgmt;
 	tx.u.tx.mode = local->hw.conf.mode;
 
-	for (handler = local->tx_handlers; *handler != NULL; handler++) {
-		res = (*handler)(&tx);
-		if (res != TXRX_CONTINUE)
-			break;
+	if (res_prepare == TXRX_QUEUED) { /* if it was an injected packet */
+		res = TXRX_CONTINUE;
+	} else {
+		for (handler = local->tx_handlers; *handler != NULL;
+		     handler++) {
+			res = (*handler)(&tx);
+			if (res != TXRX_CONTINUE)
+				break;
+		}
 	}
 
 	skb = tx.skb; /* handlers are allowed to change skb */
@@ -1473,6 +1614,51 @@ static int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
+	if (unlikely(sdata->type == IEEE80211_IF_TYPE_MNTR)) {
+		struct ieee80211_radiotap_header * prthdr =
+			(struct ieee80211_radiotap_header *)skb->data;
+
+		/* there must be a radiotap header at the
+		 * start in this case
+		 */
+
+		if (unlikely(prthdr->it_version)) {
+			/* only version 0 is supported  */
+			ret = 0;
+			goto fail;
+		}
+
+		skb->dev = local->mdev;
+
+		pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
+		memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
+		pkt_data->ifindex = sdata->dev->ifindex;
+		pkt_data->mgmt_iface = 0;
+		pkt_data->do_not_encrypt = 1;
+
+		/* above needed because we set skb device to master */
+
+		/* fix up the pointers accounting for the radiotap
+		 * header still being in there.  We are being given
+		 * a precooked IEEE80211 header so no need for
+		 * normal processing
+		 */
+
+		skb->mac.raw = skb->data+prthdr->it_len;
+		skb->nh.raw = skb->data+prthdr->it_len+
+			sizeof(struct ieee80211_hdr);
+		skb->h.raw = skb->data+prthdr->it_len+
+			sizeof(struct ieee80211_hdr);
+
+		/* pass the radiotap header up to
+		 * the next stage intact
+		 */
+
+		dev_queue_xmit(skb);
+
+		return 0;
+	}
+
 	nh_pos = skb->nh.raw - skb->data;
 	h_pos = skb->h.raw - skb->data;
 

-- 
