Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab0ANTNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 14:13:49 -0500
Date: Thu, 14 Jan 2010 13:13:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Staging: r8187se: Fix compile error from wireless-testing commit 7044cc56
Message-ID: <4b4f6ceb.f1tJ5gXsVTLW6gWJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wireless-testing, commit 7044cc56 added struct ieee80211_hdr_3addr
to include/linux/ieee80211.h. This definition collides with one that is
in the r8187se driver in staging.

The conflict is resolved by changing r8187se to use the definition from
include/linuc/ieee80211.h.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Although fixes for staging drivers normally go through GregKH, This problem
does not exist in mainline, and will not until the above commit is pushed.
As a result, I'm sending it to you.

Larry
---

Index: wireless-testing/drivers/staging/rtl8187se/ieee80211/ieee80211.h
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ wireless-testing/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -482,15 +482,6 @@ struct ieee80211_header_data {
 	u16 seq_ctrl;
 };
 
-struct ieee80211_hdr_3addr {
-	u16 frame_ctl;
-	u16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
-	u16 seq_ctl;
-} __attribute__ ((packed));
-
 struct ieee80211_hdr_4addr {
 	u16 frame_ctl;
 	u16 duration_id;
Index: wireless-testing/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ wireless-testing/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -203,7 +203,7 @@ inline void softmac_mgmt_xmit(struct sk_
 
 			enqueue_mgmt(ieee,skb);
 		}else{
-			header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0]<<4);
+			header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0]<<4);
 
 			if (ieee->seq_ctrl[0] == 0xFFF)
 				ieee->seq_ctrl[0] = 0;
@@ -220,7 +220,7 @@ inline void softmac_mgmt_xmit(struct sk_
 		spin_unlock_irqrestore(&ieee->lock, flags);
 		spin_lock_irqsave(&ieee->mgmt_tx_lock, flags);
 
-		header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+		header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
@@ -246,7 +246,7 @@ inline void softmac_ps_mgmt_xmit(struct
 
 	if(single){
 
-		header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+		header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
@@ -259,7 +259,7 @@ inline void softmac_ps_mgmt_xmit(struct
 
 	}else{
 
-		header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+		header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
@@ -287,7 +287,7 @@ inline struct sk_buff *ieee80211_disasso
 		return NULL;
 
 	disass = (struct ieee80211_disassoc_frame *) skb_put(skb,sizeof(struct ieee80211_disassoc_frame));
-	disass->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_DISASSOC);
+	disass->header.frame_control = cpu_to_le16(IEEE80211_STYPE_DISASSOC);
 	disass->header.duration_id = 0;
 
 	memcpy(disass->header.addr1, beacon->bssid, ETH_ALEN);
@@ -905,7 +905,7 @@ struct sk_buff* ieee80211_assoc_resp(str
 	assoc = (struct ieee80211_assoc_response_frame *)
 		skb_put(skb,sizeof(struct ieee80211_assoc_response_frame));
 
-	assoc->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP);
+	assoc->header.frame_control = cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP);
 	memcpy(assoc->header.addr1, dest,ETH_ALEN);
 	memcpy(assoc->header.addr3, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(assoc->header.addr2, ieee->dev->dev_addr, ETH_ALEN);
@@ -981,7 +981,7 @@ struct sk_buff* ieee80211_null_func(stru
 	memcpy(hdr->addr2, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(hdr->addr3, ieee->current_network.bssid, ETH_ALEN);
 
-	hdr->frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 		IEEE80211_STYPE_NULLFUNC | IEEE80211_FCTL_TODS |
 		(pwr ? IEEE80211_FCTL_PM:0));
 
@@ -1084,7 +1084,7 @@ inline struct sk_buff *ieee80211_associa
 		skb_put(skb, sizeof(struct ieee80211_assoc_request_frame));
 
 
-	hdr->header.frame_ctl = IEEE80211_STYPE_ASSOC_REQ;
+	hdr->header.frame_control = IEEE80211_STYPE_ASSOC_REQ;
 	hdr->header.duration_id= 37; //FIXME
 	memcpy(hdr->header.addr1, beacon->bssid, ETH_ALEN);
 	memcpy(hdr->header.addr2, ieee->dev->dev_addr, ETH_ALEN);
@@ -1786,11 +1786,11 @@ ieee80211_rx_frame_softmac(struct ieee80
 
 		tasklet_schedule(&ieee->ps_task);
 
-	if(WLAN_FC_GET_STYPE(header->frame_ctl) != IEEE80211_STYPE_PROBE_RESP &&
-		WLAN_FC_GET_STYPE(header->frame_ctl) != IEEE80211_STYPE_BEACON)
+	if (WLAN_FC_GET_STYPE(header->frame_control) != IEEE80211_STYPE_PROBE_RESP &&
+		WLAN_FC_GET_STYPE(header->frame_control) != IEEE80211_STYPE_BEACON)
 		ieee->last_rx_ps_time = jiffies;
 
-	switch (WLAN_FC_GET_STYPE(header->frame_ctl)) {
+	switch (WLAN_FC_GET_STYPE(header->frame_control)) {
 
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
@@ -2064,7 +2064,7 @@ void ieee80211_rtl_wake_queue(struct iee
 
 			header = (struct ieee80211_hdr_3addr  *) skb->data;
 
-			header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+			header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 			if (ieee->seq_ctrl[0] == 0xFFF)
 				ieee->seq_ctrl[0] = 0;
Index: wireless-testing/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/r8180_core.c
+++ wireless-testing/drivers/staging/rtl8187se/r8180_core.c
@@ -1890,7 +1890,7 @@ rate)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	int mode;
 	struct ieee80211_hdr_3addr  *h = (struct ieee80211_hdr_3addr  *) skb->data;
-	short morefrag = (h->frame_ctl) & IEEE80211_FCTL_MOREFRAGS;
+	short morefrag = (h->frame_control) & IEEE80211_FCTL_MOREFRAGS;
 	unsigned long flags;
 	int priority;
 
@@ -2158,7 +2158,7 @@ short rtl8180_tx(struct net_device *dev,
 				TxDescDuration = ThisFrameTime + aSifsTime + AckTime;
 			}
 
-			if(!(frag_hdr->frame_ctl & IEEE80211_FCTL_MOREFRAGS)) { //no more fragment
+			if (!(frag_hdr->frame_control & IEEE80211_FCTL_MOREFRAGS)) {
 				// ThisFrame-ACK.
 				Duration = aSifsTime + AckTime;
 			} else { // One or more fragments remained.
