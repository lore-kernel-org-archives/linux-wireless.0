Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [62.193.232.24] ([62.193.232.24]:34306 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S964974AbXCOBNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 21:13:48 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 592828CAD2
	for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2007 02:13:10 +0100 (CET)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 723B0FDE5
	for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2007 01:14:35 +0000 (UTC)
Received: from [127.0.0.1] (meerkat.home.warmcat.com [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id DC6B318D1D85
	for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2007 01:13:09 +0000 (GMT)
Message-ID: <45F89DA5.8000206@warmcat.com>
Date: Thu, 15 Mar 2007 01:13:09 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH] Add radiotap-based packet injection capability to monitor  mode
Content-Type: multipart/mixed;
 boundary="------------030408080505020905050105"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030408080505020905050105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi folks -

This patch adds the monitor mode packet injection stuff that was talked 
about a week or so ago to mac80211.  Using a radiotap header prepended 
to the injection payload was felt to be a reasonable way forward.

The patch can deal with a variable-sized radiotap header containing any 
fields that are understood by Linux, although currently it skips 
everything except antenna, power and rate selection.  You just put an 
interface in monitor mode and direct packets at it, selecting rate and 
so on by using radiotap semantics.

Along with this patch I have also updated packetspammer

http://warmcat.com/packetspammer-0.3.tar.gz

to allow it to send [ radiotap + ieee80211 + payload ] packets from 
userspace into a Monitor mode interface.  The --help and README both 
show how to do it.  At the moment it simply injects a 54Mbps packet with 
a ping-type payload in it to fixed fake MAC addresses, you can see these 
packets from another box running in Monitor mode on the same channel.

I tested the rate action with a zd1211rw-mac80211 USB device and it 
seems to be happy.  I'm not sure how to test the antenna selection 
action and didn't try to test the tx power selection action yet.

The patch is against Linville's FC7 #4 test kernel sources, which are 
only a few days old.

-Andy

--------------030408080505020905050105
Content-Type: text/x-patch;
 name="mac80211-injection.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mac80211-injection.patch"

--- /usr/src/redhat/BUILD/kernel-2.6.20-orig/linux-2.6.20.i386/include/net/mac80211.h	2007-03-13 13:36:16.000000000 +0000
+++ /usr/src/redhat/BUILD/kernel-2.6.20/linux-2.6.20.i386/include/net/mac80211.h	2007-03-14 18:25:04.000000000 +0000
@@ -189,6 +189,7 @@
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
 #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
+#define IEEE80211_TXCTL_INJECTED_PACKET (1<<10) /* tx into monitor IF */
 	u32 flags;			       /* tx control flags defined
 						* above */
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
--- /usr/src/redhat/BUILD/kernel-2.6.20-orig/linux-2.6.20.i386/net/mac80211/ieee80211.c	2007-03-13 13:36:16.000000000 +0000
+++ /usr/src/redhat/BUILD/kernel-2.6.20/linux-2.6.20.i386/net/mac80211/ieee80211.c	2007-03-15 00:30:46.000000000 +0000
@@ -34,6 +34,7 @@
 #include "ieee80211_led.h"
 #include "ieee80211_cfg.h"
 #include "ieee80211_sysfs.h"
+#include <net/ieee80211_radiotap.h>
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
@@ -839,6 +840,7 @@
 }
 
 
+
 static ieee80211_txrx_result
 ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 {
@@ -1045,7 +1047,123 @@
 }
 
 
-static void inline
+/* deal with packet injection down monitor interface
+with Radiotap Header -- only called for monitor mode interface */
+
+static ieee80211_txrx_result
+__ieee80211_convert_radiotap_to_control_and_remove(struct ieee80211_txrx_data *tx,
+		       struct sk_buff *skb,
+		       struct ieee80211_tx_control *control)
+{
+		/* this is the moment to interpret the radiotap header that
+			must be at the start of the packet injected in Monitor
+			mode into control and then discard the radiotap header
+			Note all radiotap is native-endian since it stays on the box*/
+
+	struct ieee80211_radiotap_header *rthdr =
+		(struct ieee80211_radiotap_header *) skb->data;
+
+		/* small length lookup table for all radiotap types we heard of
+			starting from b0 in the bitmap, so we can walk the payload
+			area of the radiotap header */
+
+	static const u8 u8aRadiotapEntrySizes[] = {
+		8, /* IEEE80211_RADIOTAP_TSFT */
+		1, /* IEEE80211_RADIOTAP_FLAGS */
+		1, /* IEEE80211_RADIOTAP_RATE */
+		4, /* IEEE80211_RADIOTAP_CHANNEL */
+		2, /* IEEE80211_RADIOTAP_FHSS */
+		1, /* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
+		1, /* IEEE80211_RADIOTAP_DBM_ANTNOISE */
+		2, /* IEEE80211_RADIOTAP_LOCK_QUALITY */
+		2, /* IEEE80211_RADIOTAP_TX_ATTENUATION */
+		2, /* IEEE80211_RADIOTAP_DB_TX_ATTENUATION */
+		1, /* IEEE80211_RADIOTAP_DBM_TX_POWER */
+		1, /* IEEE80211_RADIOTAP_ANTENNA */
+		1, /* IEEE80211_RADIOTAP_DB_ANTSIGNAL */
+		1  /* IEEE80211_RADIOTAP_DB_ANTNOISE */
+	};
+	int nTapIndex=0;
+	u8 * pu8Tap=skb->data + sizeof(struct ieee80211_radiotap_header);
+	u32 *pu32Bitmap=&rthdr->it_present;
+
+	if(rthdr->it_version) return TXRX_DROP; /* version byte used as magic */
+
+		/* sanity check for skb length and radiotap length field */
+	if (skb->len < (rthdr->it_len+sizeof(struct ieee80211_hdr)))
+		return TXRX_DROP;
+
+		/* find payload start allowing for extended bitmap(s) */
+
+	if(rthdr->it_present & 0x80000000) {
+		while( *((u32 *)pu8Tap) & 0x80000000) pu8Tap+=sizeof(u32);
+		pu8Tap+=sizeof(u32);
+	}
+
+		/* default control situation for all injected packets */
+
+	control->retry_limit=1; /* no retry */
+	control->key_idx=-1; /* no encryption key */
+	control->flags&=~(IEEE80211_TXCTL_USE_RTS_CTS|IEEE80211_TXCTL_USE_CTS_PROTECT);
+	control->flags|=(IEEE80211_TXCTL_DO_NOT_ENCRYPT|IEEE80211_TXCTL_NO_ACK);
+	control->antenna_sel_tx=0; /* default to default/diversity */
+
+		/* for every radiotap entry we can at least skip (by knowing the length)... */
+
+	while(nTapIndex<sizeof(u8aRadiotapEntrySizes)) {
+		if( (*pu32Bitmap) & 1) { /* it is present */
+
+			switch(nTapIndex) { /* deal with if interested */
+
+				case IEEE80211_RADIOTAP_RATE:
+					{
+							/* radio tap "rate" u8 is in 500kbps units, eg, 0x02=1Mbps
+								ieee80211 "rate" int is in 100kbps units, eg, 0x0a=1Mbps */
+						int i, nTargetRate=(*pu8Tap)*5;
+
+						for (i = 0; i < tx->local->num_curr_rates; i++) {
+							struct ieee80211_rate *r = &tx->local->curr_rates[i];
+
+							if(r->rate <= nTargetRate) {
+								control->tx_rate=r->val;
+							}
+						}
+					}
+					break;
+
+				case IEEE80211_RADIOTAP_ANTENNA:
+						/* radiotap uses 0 for 1st ant, mac80211 is 1 for 1st ant
+							absence of IEEE80211_RADIOTAP_ANTENNA gives default/diversity */
+					control->antenna_sel_tx=(*pu8Tap)+1;
+					break;
+
+				case IEEE80211_RADIOTAP_DBM_TX_POWER:
+					control->power_level=*pu8Tap;
+					break;
+
+				default:
+					break;
+			}
+
+			pu8Tap+=u8aRadiotapEntrySizes[nTapIndex];
+		}
+
+		(*pu32Bitmap)>>=1;
+
+		nTapIndex++;
+		if(unlikely((nTapIndex & 31)==0)) { // completed current u32 bitmap
+			pu32Bitmap++; // move to next u32 bitmap
+		}
+	}
+
+		/* remove the radiotap header */
+	skb_pull(skb, rthdr->it_len);
+
+	return TXRX_CONTINUE;
+}
+
+
+static ieee80211_txrx_result inline
 __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		       struct sk_buff *skb,
 		       struct net_device *dev,
@@ -1062,7 +1180,26 @@
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	tx->sta = sta_info_get(local, hdr->addr1);
 	tx->fc = le16_to_cpu(hdr->frame_control);
+
+		/* set defaults for things that can be set by
+			injected radiotap headers */
+
 	control->power_level = local->hw.conf.power_level;
+	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta )
+		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
+
+		/* process and remove the injection radiotap header */
+
+	if(control->flags & IEEE80211_TXCTL_INJECTED_PACKET) {
+		if(__ieee80211_convert_radiotap_to_control_and_remove(tx, skb, control)==TXRX_DROP) {
+			return TXRX_DROP;
+		}
+		/* we removed the radiotap header after this point, 
+			we filled control with what we could use */
+		hdr = (struct ieee80211_hdr *) skb->data; /* set to the actual ieee header now */
+	}
+
 	tx->u.tx.control = control;
 	tx->u.tx.unicast = !is_multicast_ether_addr(hdr->addr1);
 	if (is_multicast_ether_addr(hdr->addr1))
@@ -1079,9 +1216,6 @@
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
 		tx->sta->clear_dst_mask = 0;
 	}
-	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta)
-		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
@@ -1089,6 +1223,7 @@
 	}
 	control->flags |= IEEE80211_TXCTL_FIRST_FRAGMENT;
 
+	return TXRX_CONTINUE;
 }
 
 static int inline is_ieee80211_device(struct net_device *dev,
@@ -1206,14 +1341,22 @@
 		return 0;
 	}
 
-	__ieee80211_tx_prepare(&tx, skb, dev, control);
+	if(__ieee80211_tx_prepare(&tx, skb, dev, control)==TXRX_DROP) {
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
 	sta = tx.sta;
 	tx.u.tx.mgmt_interface = mgmt;
 
-	for (handler = local->tx_handlers; *handler != NULL; handler++) {
-		res = (*handler)(&tx);
-		if (res != TXRX_CONTINUE)
-			break;
+	if(unlikely((control->flags & IEEE80211_TXCTL_INJECTED_PACKET))) {
+		res=TXRX_CONTINUE;
+	} else {
+		for (handler = local->tx_handlers; *handler != NULL; handler++) {
+			res = (*handler)(&tx);
+			if (res != TXRX_CONTINUE)
+				break;
+		}
 	}
 
 	skb = tx.skb; /* handlers are allowed to change skb */
@@ -1251,6 +1394,7 @@
 	}
 
 retry:
+
 	ret = __ieee80211_tx(local, skb, &tx);
 	if (ret) {
 		struct ieee80211_tx_stored_packet *store =
@@ -1364,6 +1508,7 @@
 	/*
 	 * copy control out of the skb so other people can use skb->cb
 	 */
+
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(&control, 0, sizeof(struct ieee80211_tx_control));
 
@@ -1401,6 +1546,8 @@
 	if (pkt_data->requeue)
 		control.flags |= IEEE80211_TXCTL_REQUEUE;
 	control.queue = pkt_data->queue;
+	if(pkt_data->is_injected_into_monitor)
+		control.flags |= IEEE80211_TXCTL_INJECTED_PACKET;
 
 	ret = ieee80211_tx(odev, skb, &control,
 			   control.type == IEEE80211_IF_TYPE_MGMT);
@@ -1447,6 +1594,40 @@
 		goto fail;
 	}
 
+	if(unlikely(sdata->type==IEEE80211_IF_TYPE_MNTR)) {
+		struct ieee80211_radiotap_header * prthdr=(struct ieee80211_radiotap_header *)skb->data;
+
+			/* there must be a radiotap header at the start in this case */
+
+		if(unlikely(prthdr->it_version)) { /* radiotap version used as magic */
+			ret=0;
+			goto fail;
+		}
+
+		skb->dev = local->mdev;
+
+		pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
+		memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
+		pkt_data->ifindex =  local->mdev/*sdata->dev*/->ifindex;
+		pkt_data->mgmt_iface = 0;
+		pkt_data->do_not_encrypt = 1;
+		pkt_data->is_injected_into_monitor = 1; /* needed because we set skb device to master */
+
+			/* fix up the pointers accounting for the radiotap header still being in there
+				we are being given a precooked IEEE80211 header so no need for
+				normal processing */
+
+		skb->mac.raw = skb->data+prthdr->it_len;
+		skb->nh.raw = skb->data+prthdr->it_len+sizeof(struct ieee80211_hdr);
+		skb->h.raw = skb->data+prthdr->it_len+sizeof(struct ieee80211_hdr);
+
+			/* pass the radiotap header up to the next stage intact */
+
+		dev_queue_xmit(skb);
+	
+		return 0;
+	}
+
 	nh_pos = skb->nh.raw - skb->data;
 	h_pos = skb->h.raw - skb->data;
 
--- /usr/src/redhat/BUILD/kernel-2.6.20-orig/linux-2.6.20.i386/net/mac80211/ieee80211_i.h	2007-03-13 13:36:16.000000000 +0000
+++ /usr/src/redhat/BUILD/kernel-2.6.20/linux-2.6.20.i386/net/mac80211/ieee80211_i.h	2007-03-14 18:23:52.000000000 +0000
@@ -162,6 +162,7 @@
 	unsigned int requeue:1;
 	unsigned int mgmt_iface:1;
 	unsigned int queue:4;
+	unsigned int is_injected_into_monitor:1;
 };
 
 struct ieee80211_tx_stored_packet {

--------------030408080505020905050105--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
