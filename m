Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbXH2If5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 04:35:57 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <87sl63prsg.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 02:12:26 +0200
Message-Id: <1188346346.7837.139.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-08-28 at 19:06 +0300, Kalle Valo wrote:

> I also some really odd frames sent by b43 when N800 had PSM enabled.
> Never seen it before, no idea what it is. Dump at the of this message.

>     QoS Control
>         Priority: 4 (Controlled Load) (Video)
>         .... 0... = EOSP: Service period
>         Ack Policy: Block Ack (0x03)
>         Payload Type: A-MSDU
>         QAP PS Buffer State: 0xd5
> IEEE 802.11 Aggregate MSDU
>     A-MSDU Subframe #1

That's just f'ed up. We shouldn't be sending aggregated MSDUs, but we
do due to the uninitialised header. But it's a bug in the N800 that it
accepts such frames. Try the patch below with qos enabled.

johannes

--- wireless-dev.orig/net/mac80211/tx.c	2007-08-28 21:25:44.804618695 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-28 21:37:22.394618695 +0200
@@ -1346,7 +1346,15 @@ int ieee80211_subif_start_xmit(struct sk
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen, fc;
-	struct ieee80211_hdr hdr;
+	/*
+	 * QoS headers are 2 bytes longer (32 bytes with a
+	 * 4-addr format frame) and the QoS control field
+	 * needs to be initialised to zero.
+	 */
+	union {
+		struct ieee80211_hdr hdr;
+		char __buf[32];
+	} hdr = { .__buf = {0} };
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1374,40 +1382,40 @@ int ieee80211_subif_start_xmit(struct sk
 	case IEEE80211_IF_TYPE_VLAN:
 		fc |= IEEE80211_FCTL_FROMDS;
 		/* DA BSSID SA */
-		memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
+		memcpy(hdr.hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 24;
 		break;
 	case IEEE80211_IF_TYPE_WDS:
 		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
 		/* RA TA DA SA */
-		memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
-		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-		memcpy(hdr.addr3, skb->data, ETH_ALEN);
-		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+		memcpy(hdr.hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
+		memcpy(hdr.hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.hdr.addr3, skb->data, ETH_ALEN);
+		memcpy(hdr.hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
 		break;
 	case IEEE80211_IF_TYPE_STA:
 		if (dls_link_status(local, skb->data) == DLS_STATUS_OK) {
 			/* DA SA BSSID */
-			memcpy(hdr.addr1, skb->data, ETH_ALEN);
-			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-			memcpy(hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
+			memcpy(hdr.hdr.addr1, skb->data, ETH_ALEN);
+			memcpy(hdr.hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+			memcpy(hdr.hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
 		} else {
 			fc |= IEEE80211_FCTL_TODS;
 			/* BSSID SA DA */
-			memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
-			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-			memcpy(hdr.addr3, skb->data, ETH_ALEN);
+			memcpy(hdr.hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
+			memcpy(hdr.hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+			memcpy(hdr.hdr.addr3, skb->data, ETH_ALEN);
 		}
 		hdrlen = 24;
 		break;
 	case IEEE80211_IF_TYPE_IBSS:
 		/* DA SA BSSID */
-		memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-		memcpy(hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
+		memcpy(hdr.hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		memcpy(hdr.hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
 		hdrlen = 24;
 		break;
 	default:
@@ -1416,7 +1424,7 @@ int ieee80211_subif_start_xmit(struct sk
 	}
 
 	/* receiver is QoS enabled, use a QoS type frame */
-	sta = sta_info_get(local, hdr.addr1);
+	sta = sta_info_get(local, hdr.hdr.addr1);
 	if (sta) {
 		if (sta->flags & WLAN_STA_WME) {
 			fc |= IEEE80211_STYPE_QOS_DATA;
@@ -1425,9 +1433,9 @@ int ieee80211_subif_start_xmit(struct sk
 		sta_info_put(sta);
 	}
 
-	hdr.frame_control = cpu_to_le16(fc);
-	hdr.duration_id = 0;
-	hdr.seq_ctrl = 0;
+	hdr.hdr.frame_control = cpu_to_le16(fc);
+	hdr.hdr.duration_id = 0;
+	hdr.hdr.seq_ctrl = 0;
 
 	skip_header_bytes = ETH_HLEN;
 	if (ethertype == ETH_P_AARP || ethertype == ETH_P_IPX) {


