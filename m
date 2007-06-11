Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:38984 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757914AbXFKJ6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 05:58:50 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id C4A3C8D763
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 11:58:45 +0200 (CEST)
Message-Id: <20070611095846.604134786@warmcat.com>
References: <20070611095400.206844675@warmcat.com>
Date: Mon, 11 Jun 2007 10:54:04 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH Try#8 4/4] mac80211: Monitor mode radiotap-based packet injection
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

Signed-off-by: Andy Green <andy@warmcat.com>


---
 net/mac80211/ieee80211.c |  209 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 199 insertions(+), 10 deletions(-)

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -1118,7 +1118,111 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
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
@@ -1126,6 +1230,9 @@ __ieee80211_tx_prepare(struct ieee80211_
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sub_if_data *sdata;
+	ieee80211_txrx_result res = TXRX_CONTINUE;
+
 	int hdrlen;
 
 	memset(tx, 0, sizeof(*tx));
@@ -1135,7 +1242,32 @@ __ieee80211_tx_prepare(struct ieee80211_
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
@@ -1152,9 +1284,6 @@ __ieee80211_tx_prepare(struct ieee80211_
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
 		tx->sta->clear_dst_mask = 0;
 	}
-	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta)
-		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
@@ -1162,6 +1291,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 	}
 	control->flags |= IEEE80211_TXCTL_FIRST_FRAGMENT;
 
+	return res;
 }
 
 static int inline is_ieee80211_device(struct net_device *dev,
@@ -1274,7 +1404,7 @@ static int ieee80211_tx(struct net_devic
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
-	ieee80211_txrx_result res = TXRX_DROP;
+	ieee80211_txrx_result res = TXRX_DROP, res_prepare;
 	int ret, i;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
@@ -1284,15 +1414,26 @@ static int ieee80211_tx(struct net_devic
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
@@ -1531,6 +1672,54 @@ static int ieee80211_subif_start_xmit(st
 		goto fail;
 	}
 
+	if (unlikely(sdata->type == IEEE80211_IF_TYPE_MNTR)) {
+		struct ieee80211_radiotap_header * prthdr =
+			(struct ieee80211_radiotap_header *)skb->data;
+
+		/*
+		 * there must be a radiotap header at the
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
+		/*
+		 * fix up the pointers accounting for the radiotap
+		 * header still being in there.  We are being given
+		 * a precooked IEEE80211 header so no need for
+		 * normal processing
+		 */
+
+		skb_set_mac_header(skb, prthdr->it_len);
+		skb_set_network_header(skb, prthdr->it_len +
+		    sizeof(struct ieee80211_hdr));
+		skb_set_transport_header(skb, prthdr->it_len +
+		    sizeof(struct ieee80211_hdr));
+
+		/*
+		 * pass the radiotap header up to
+		 * the next stage intact
+		 */
+
+		dev_queue_xmit(skb);
+
+		return 0;
+	}
+
 	nh_pos = skb_network_header(skb) - skb->data;
 	h_pos = skb_transport_header(skb) - skb->data;
 

-- 
