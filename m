Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:55222 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0BQX0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 18:26:19 -0500
Date: Thu, 18 Feb 2010 00:25:26 +0100
From: Frederic Leroy <fredo@starox.org>
To: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] staging: rtl8192su: fix compile error from wireless-testing
 commit
Message-ID: <20100218002526.01d1de5f@houba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wireless-testing, commit 7044cc56 added struct ieee80211_hdr_3addr
to include/linux/ieee80211.h. This definition collides with one that is
in the rtl8192su driver in staging.

The conflict is resolved by changing rtl8192su
to use the definition from include/linux/ieee80211.h.

---
In http://marc.info/?l=linux-wireless&m=126642497300368&w=2, I reported
that rtl8192su doesn't compile on wireless-testing tree.
checkpatch.pl makes a lot of error on this patch but all these errors
come from the staging code quality.
I didn't test this patch, only compile it.

Only this line is not a variable name change :
  -                return ((struct ieee80211_hdr_3addr *)hdr)->payload;
  +                return (void *)hdr+sizeof(struct ieee80211_hdr_3addr);

Thank you Larry

 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |   12 +------
 .../staging/rtl8192su/ieee80211/ieee80211_r8192s.h |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |   18 +++++-----
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |   38 ++++++++++----------
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |    4 +-
 drivers/staging/rtl8192su/r8192U_core.c            |    4 +-
 6 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211.h b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
index 9a4c858..2b8c855 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
@@ -609,16 +609,6 @@ struct ieee80211_hdr_2addr {
         u8 payload[0];
 } __attribute__ ((packed));
 
-struct ieee80211_hdr_3addr {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
-	__le16 seq_ctl;
-        u8 payload[0];
-} __attribute__ ((packed));
-
 struct ieee80211_hdr_4addr {
 	__le16 frame_ctl;
 	__le16 duration_id;
@@ -1672,7 +1662,7 @@ static inline u8 *ieee80211_get_payload(struct rtl_ieee80211_hdr *hdr)
         case IEEE80211_2ADDR_LEN:
                 return ((struct ieee80211_hdr_2addr *)hdr)->payload;
         case IEEE80211_3ADDR_LEN:
-                return ((struct ieee80211_hdr_3addr *)hdr)->payload;
+                return (void *)hdr+sizeof(struct ieee80211_hdr_3addr);
         case IEEE80211_4ADDR_LEN:
                 return ((struct ieee80211_hdr_4addr *)hdr)->payload;
         }
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_r8192s.h b/drivers/staging/rtl8192su/ieee80211/ieee80211_r8192s.h
index 123abcf..7d6c3bc 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_r8192s.h
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_r8192s.h
@@ -201,7 +201,7 @@ typedef union _frameqos {
 static inline u8 Frame_QoSTID(u8 *buf)
 {
 	struct ieee80211_hdr_3addr *hdr = (struct ieee80211_hdr_3addr *)buf;
-	u16 fc = le16_to_cpu(hdr->frame_ctl);
+	u16 fc = le16_to_cpu(hdr->frame_control);
 
 	return (u8)((frameqos *)(buf +
 		(((fc & IEEE80211_FCTL_TODS) &&
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
index fecfa12..095b8c6 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
@@ -744,7 +744,7 @@ u8 parse_subframe(struct sk_buff *skb,
 		  struct ieee80211_rxb *rxb,u8* src,u8* dst)
 {
 	struct ieee80211_hdr_3addr  *hdr = (struct ieee80211_hdr_3addr* )skb->data;
-	u16		fc = le16_to_cpu(hdr->frame_ctl);
+	u16		fc = le16_to_cpu(hdr->frame_control);
 
 	u16		LLCOffset= sizeof(struct ieee80211_hdr_3addr);
 	u16		ChkLength;
@@ -756,7 +756,7 @@ u8 parse_subframe(struct sk_buff *skb,
 	struct sk_buff *sub_skb;
 	u8             *data_ptr;
 	/* just for debug purpose */
-	SeqNum = WLAN_GET_SEQ_SEQ(le16_to_cpu(hdr->seq_ctl));
+	SeqNum = WLAN_GET_SEQ_SEQ(le16_to_cpu(hdr->seq_ctrl));
 
 	if((IEEE80211_QOS_HAS_SEQ(fc))&&\
 			(((frameqos *)(skb->data + IEEE80211_3ADDR_LEN))->field.reserved)) {
@@ -2370,7 +2370,7 @@ static inline void ieee80211_process_probe_response(
 				     escape_essid(info_element->data,
 						  info_element->len),
 				     MAC_ARG(beacon->header.addr3),
-				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
+				     WLAN_FC_GET_STYPE(beacon->header.frame_control) ==
 				     IEEE80211_STYPE_PROBE_RESP ?
 				     "PROBE RESPONSE" : "BEACON");
 		return;
@@ -2387,7 +2387,7 @@ static inline void ieee80211_process_probe_response(
 		return;
 	if(ieee->bGlobalDomain)
 	{
-		if (WLAN_FC_GET_STYPE(beacon->header.frame_ctl) == IEEE80211_STYPE_PROBE_RESP)
+		if (WLAN_FC_GET_STYPE(beacon->header.frame_control) == IEEE80211_STYPE_PROBE_RESP)
 		{
 			// Case 1: Country code
 			if(IS_COUNTRY_IE_VALID(ieee) )
@@ -2454,7 +2454,7 @@ static inline void ieee80211_process_probe_response(
 		else
 			ieee->current_network.buseprotection = false;
 		}
-		if(is_beacon(beacon->header.frame_ctl))
+		if(is_beacon(beacon->header.frame_control))
 		{
 			if(ieee->state == IEEE80211_LINKED)
 				ieee->LinkDetectInfo.NumRecvBcnInPeriod++;
@@ -2496,7 +2496,7 @@ static inline void ieee80211_process_probe_response(
 				     escape_essid(network.ssid,
 						  network.ssid_len),
 				     MAC_ARG(network.bssid),
-				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
+				     WLAN_FC_GET_STYPE(beacon->header.frame_control) ==
 				     IEEE80211_STYPE_PROBE_RESP ?
 				     "PROBE RESPONSE" : "BEACON");
 #endif
@@ -2509,7 +2509,7 @@ static inline void ieee80211_process_probe_response(
 				     escape_essid(target->ssid,
 						  target->ssid_len),
 				     MAC_ARG(target->bssid),
-				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
+				     WLAN_FC_GET_STYPE(beacon->header.frame_control) ==
 				     IEEE80211_STYPE_PROBE_RESP ?
 				     "PROBE RESPONSE" : "BEACON");
 
@@ -2519,7 +2519,7 @@ static inline void ieee80211_process_probe_response(
 		 */
 		renew = !time_after(target->last_scanned + ieee->scan_age, jiffies);
 		//YJ,add,080819,for hidden ap
-		if(is_beacon(beacon->header.frame_ctl) == 0)
+		if(is_beacon(beacon->header.frame_control) == 0)
 			network.flags = (~NETWORK_EMPTY_ESSID & network.flags)|(NETWORK_EMPTY_ESSID & target->flags);
 		//if(strncmp(network.ssid, "linksys-c",9) == 0)
 		//	printk("====>2 network.ssid=%s FLAG=%d target.ssid=%s FLAG=%d\n", network.ssid, network.flags, target->ssid, target->flags);
@@ -2535,7 +2535,7 @@ static inline void ieee80211_process_probe_response(
 	}
 
 	spin_unlock_irqrestore(&ieee->lock, flags);
-	if (is_beacon(beacon->header.frame_ctl)&&is_same_network(&ieee->current_network, &network, ieee)&&\
+	if (is_beacon(beacon->header.frame_control)&&is_same_network(&ieee->current_network, &network, ieee)&&\
 		(ieee->state == IEEE80211_LINKED)) {
 		if(ieee->handle_beacon != NULL) {
 			ieee->handle_beacon(ieee->dev,beacon,&ieee->current_network);
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
index 95d4f84..0ba2a01 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
@@ -242,7 +242,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *ieee
 		if(ieee->queue_stop){
 			enqueue_mgmt(ieee,skb);
 		}else{
-			header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0]<<4);
+			header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0]<<4);
 
 			if (ieee->seq_ctrl[0] == 0xFFF)
 				ieee->seq_ctrl[0] = 0;
@@ -260,7 +260,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *ieee
 		spin_unlock_irqrestore(&ieee->lock, flags);
 		spin_lock_irqsave(&ieee->mgmt_tx_lock, flags);
 
-		header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+		header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
@@ -302,7 +302,7 @@ inline void softmac_ps_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *i
 	//printk("=============>%s()\n", __FUNCTION__);
 	if(single){
 
-		header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+		header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
@@ -315,7 +315,7 @@ inline void softmac_ps_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *i
 
 	}else{
 
-		header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+		header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
@@ -347,7 +347,7 @@ inline struct sk_buff *ieee80211_probe_req(struct ieee80211_device *ieee)
 	skb_reserve(skb, ieee->tx_headroom);
 
 	req = (struct ieee80211_probe_request *) skb_put(skb,sizeof(struct ieee80211_probe_request));
-	req->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+	req->header.frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
 	req->header.duration_id = 0; //FIXME: is this OK ?
 
 	memset(req->header.addr1, 0xff, ETH_ALEN);
@@ -662,8 +662,8 @@ inline struct sk_buff *ieee80211_authentication_req(struct ieee80211_network *be
 	auth = (struct ieee80211_authentication *)
 		skb_put(skb, sizeof(struct ieee80211_authentication));
 
-	auth->header.frame_ctl = IEEE80211_STYPE_AUTH;
-	if (challengelen) auth->header.frame_ctl |= IEEE80211_FCTL_WEP;
+	auth->header.frame_control = IEEE80211_STYPE_AUTH;
+	if (challengelen) auth->header.frame_control |= IEEE80211_FCTL_WEP;
 
 	auth->header.duration_id = 0x013a; //FIXME
 
@@ -801,7 +801,7 @@ static struct sk_buff* ieee80211_probe_resp(struct ieee80211_device *ieee, u8 *d
 		beacon_buf->capability |= cpu_to_le16(WLAN_CAPABILITY_PRIVACY);
 
 
-	beacon_buf->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_RESP);
+	beacon_buf->header.frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_RESP);
 	beacon_buf->info_element[0].id = MFIE_TYPE_SSID;
 	beacon_buf->info_element[0].len = ssid_len;
 
@@ -880,7 +880,7 @@ struct sk_buff* ieee80211_assoc_resp(struct ieee80211_device *ieee, u8 *dest)
 	assoc = (struct ieee80211_assoc_response_frame *)
 		skb_put(skb,sizeof(struct ieee80211_assoc_response_frame));
 
-	assoc->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP);
+	assoc->header.frame_control = cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP);
 	memcpy(assoc->header.addr1, dest,ETH_ALEN);
 	memcpy(assoc->header.addr3, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(assoc->header.addr2, ieee->dev->dev_addr, ETH_ALEN);
@@ -935,7 +935,7 @@ struct sk_buff* ieee80211_auth_resp(struct ieee80211_device *ieee,int status, u8
 	memcpy(auth->header.addr3, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(auth->header.addr2, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(auth->header.addr1, dest, ETH_ALEN);
-	auth->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_AUTH);
+	auth->header.frame_control = cpu_to_le16(IEEE80211_STYPE_AUTH);
 	return skb;
 
 
@@ -957,7 +957,7 @@ struct sk_buff* ieee80211_null_func(struct ieee80211_device *ieee,short pwr)
 	memcpy(hdr->addr2, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(hdr->addr3, ieee->current_network.bssid, ETH_ALEN);
 
-	hdr->frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 		IEEE80211_STYPE_NULLFUNC | IEEE80211_FCTL_TODS |
 		(pwr ? IEEE80211_FCTL_PM:0));
 
@@ -1083,7 +1083,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 		skb_put(skb, sizeof(struct ieee80211_assoc_request_frame)+2);
 
 
-	hdr->header.frame_ctl = IEEE80211_STYPE_ASSOC_REQ;
+	hdr->header.frame_control = IEEE80211_STYPE_ASSOC_REQ;
 	hdr->header.duration_id= 37; //FIXME
 	memcpy(hdr->header.addr1, beacon->bssid, ETH_ALEN);
 	memcpy(hdr->header.addr2, ieee->dev->dev_addr, ETH_ALEN);
@@ -1940,13 +1940,13 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if(!ieee->proto_started)
 		return 0;
 
-	switch (WLAN_FC_GET_STYPE(header->frame_ctl)) {
+	switch (WLAN_FC_GET_STYPE(header->frame_control)) {
 
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
 
 			IEEE80211_DEBUG_MGMT("received [RE]ASSOCIATION RESPONSE (%d)\n",
-					WLAN_FC_GET_STYPE(header->frame_ctl));
+					WLAN_FC_GET_STYPE(header->frame_control));
 			if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
 				ieee->state == IEEE80211_ASSOCIATING_AUTHENTICATED &&
 				ieee->iw_mode == IW_MODE_INFRA){
@@ -2088,7 +2088,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 			if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
 				ieee->state == IEEE80211_LINKED &&
 				ieee->iw_mode == IW_MODE_INFRA){
-				printk("==========>received disassoc/deauth(%x) frame, reason code:%x\n",WLAN_FC_GET_STYPE(header->frame_ctl), ((struct ieee80211_disassoc*)skb->data)->reason);
+				printk("==========>received disassoc/deauth(%x) frame, reason code:%x\n",WLAN_FC_GET_STYPE(header->frame_control), ((struct ieee80211_disassoc*)skb->data)->reason);
 				ieee->state = IEEE80211_ASSOCIATING;
 				ieee->softmac_stats.reassoc++;
 				ieee->is_roaming = true;
@@ -2239,7 +2239,7 @@ void ieee80211_rtl_wake_queue(struct ieee80211_device *ieee)
 
 			header = (struct ieee80211_hdr_3addr  *) skb->data;
 
-			header->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+			header->seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 			if (ieee->seq_ctrl[0] == 0xFFF)
 				ieee->seq_ctrl[0] = 0;
@@ -2574,7 +2574,7 @@ struct sk_buff *ieee80211_get_beacon_(struct ieee80211_device *ieee)
 		return NULL;
 
 	b = (struct ieee80211_probe_response *) skb->data;
-	b->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_BEACON);
+	b->header.frame_control = cpu_to_le16(IEEE80211_STYPE_BEACON);
 
 	return skb;
 
@@ -2590,7 +2590,7 @@ struct sk_buff *ieee80211_get_beacon(struct ieee80211_device *ieee)
 		return NULL;
 
 	b = (struct ieee80211_probe_response *) skb->data;
-	b->header.seq_ctl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
+	b->header.seq_ctrl = cpu_to_le16(ieee->seq_ctrl[0] << 4);
 
 	if (ieee->seq_ctrl[0] == 0xFFF)
 		ieee->seq_ctrl[0] = 0;
@@ -3139,7 +3139,7 @@ inline struct sk_buff *ieee80211_disassociate_skb(
 		return NULL;
 
 	disass = (struct ieee80211_disassoc *) skb_put(skb,sizeof(struct ieee80211_disassoc));
-	disass->header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_DISASSOC);
+	disass->header.frame_control = cpu_to_le16(IEEE80211_STYPE_DISASSOC);
 	disass->header.duration_id = 0;
 
 	memcpy(disass->header.addr1, beacon->bssid, ETH_ALEN);
diff --git a/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
index 8d12ffc..c696245 100644
--- a/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
@@ -136,7 +136,7 @@ static struct sk_buff* ieee80211_ADDBA(struct ieee80211_device* ieee, u8* Dst, P
 
 	memcpy(BAReq->addr3, ieee->current_network.bssid, ETH_ALEN);
 
-	BAReq->frame_ctl = cpu_to_le16(IEEE80211_STYPE_MANAGE_ACT); //action frame
+	BAReq->frame_control = cpu_to_le16(IEEE80211_STYPE_MANAGE_ACT); //action frame
 
 	//tag += sizeof( struct ieee80211_hdr_3addr); //move to action field
 	tag = (u8*)skb_put(skb, 9);
@@ -221,7 +221,7 @@ static struct sk_buff* ieee80211_DELBA(
 	memcpy(Delba->addr1, dst, ETH_ALEN);
 	memcpy(Delba->addr2, ieee->dev->dev_addr, ETH_ALEN);
 	memcpy(Delba->addr3, ieee->current_network.bssid, ETH_ALEN);
-	Delba->frame_ctl = cpu_to_le16(IEEE80211_STYPE_MANAGE_ACT); //action frame
+	Delba->frame_control = cpu_to_le16(IEEE80211_STYPE_MANAGE_ACT); //action frame
 
 	tag = (u8*)skb_put(skb, 6);
 
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index ccb9d5b..6f424fe 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -6168,7 +6168,7 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 	u16 sc ;
 	unsigned int frag,seq;
 	hdr = (struct ieee80211_hdr_3addr *)buffer;
-	sc = le16_to_cpu(hdr->seq_ctl);
+	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = WLAN_GET_SEQ_FRAG(sc);
 	seq = WLAN_GET_SEQ_SEQ(sc);
 	//cosa add 04292008 to record the sequence number
@@ -6827,7 +6827,7 @@ void rtl8192SU_TranslateRxSignalStuff(struct sk_buff *skb,
 	tmp_buf = (u8*)skb->data;// + get_rxpacket_shiftbytes_819xusb(pstats);
 
 	hdr = (struct ieee80211_hdr_3addr *)tmp_buf;
-	fc = le16_to_cpu(hdr->frame_ctl);
+	fc = le16_to_cpu(hdr->frame_control);
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
 
-- 
1.6.4.4

-- 
Frédéric Leroy
