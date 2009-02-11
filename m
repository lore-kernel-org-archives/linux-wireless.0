Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbZBKWSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 17:18:47 -0500
Subject: [PATCH] hostap: convert usage of net/ieee80211.h to
	linux/ieee80211.h
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 17:17:10 -0500
Message-Id: <1234390630.14687.9.camel@localhost> (sfid-20090211_231853_267540_25A4F600)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that net/ieee80211.h can be made private to ipw2x00 in a follow-up.

Signed-off-by: Dan Williams <dcbw@redhat.com>

---

diff --git a/drivers/net/wireless/hostap/hostap.h b/drivers/net/wireless/hostap/hostap.h
index 2453dea..ce8721f 100644
--- a/drivers/net/wireless/hostap/hostap.h
+++ b/drivers/net/wireless/hostap/hostap.h
@@ -31,7 +31,7 @@ void hostap_dump_rx_header(const char *name,
 void hostap_dump_tx_header(const char *name,
 			   const struct hfa384x_tx_frame *tx);
 extern const struct header_ops hostap_80211_ops;
-int hostap_80211_get_hdrlen(u16 fc);
+int hostap_80211_get_hdrlen(__le16 fc);
 struct net_device_stats *hostap_get_stats(struct net_device *dev);
 void hostap_setup_dev(struct net_device *dev, local_info_t *local,
 		      int type);
diff --git a/drivers/net/wireless/hostap/hostap_80211.h b/drivers/net/wireless/hostap/hostap_80211.h
index 3a9474d..2e9fb0f 100644
--- a/drivers/net/wireless/hostap/hostap_80211.h
+++ b/drivers/net/wireless/hostap/hostap_80211.h
@@ -2,7 +2,7 @@
 #define HOSTAP_80211_H
 
 #include <linux/types.h>
-#include <net/ieee80211.h>
+#include <linux/skbuff.h>
 
 struct hostap_ieee80211_mgmt {
 	__le16 frame_control;
diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index 2417563..f55c9dc 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -1,5 +1,6 @@
 #include <linux/etherdevice.h>
 #include <net/lib80211.h>
+#include <linux/if_arp.h>
 
 #include "hostap_80211.h"
 #include "hostap.h"
@@ -17,10 +18,10 @@ static unsigned char bridge_tunnel_header[] =
 void hostap_dump_rx_80211(const char *name, struct sk_buff *skb,
 			  struct hostap_80211_rx_status *rx_stats)
 {
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 
 	printk(KERN_DEBUG "%s: RX signal=%d noise=%d rate=%d len=%d "
 	       "jiffies=%ld\n",
@@ -30,9 +31,10 @@ void hostap_dump_rx_80211(const char *name, struct sk_buff *skb,
 	if (skb->len < 2)
 		return;
 
-	fc = le16_to_cpu(hdr->frame_ctl);
+	fc = le16_to_cpu(hdr->frame_control);
 	printk(KERN_DEBUG "   FC=0x%04x (type=%d:%d)%s%s",
-	       fc, WLAN_FC_GET_TYPE(fc) >> 2, WLAN_FC_GET_STYPE(fc) >> 4,
+	       fc, (fc & IEEE80211_FCTL_FTYPE) >> 2,
+	       (fc & IEEE80211_FCTL_STYPE) >> 4,
 	       fc & IEEE80211_FCTL_TODS ? " [ToDS]" : "",
 	       fc & IEEE80211_FCTL_FROMDS ? " [FromDS]" : "");
 
@@ -42,7 +44,7 @@ void hostap_dump_rx_80211(const char *name, struct sk_buff *skb,
 	}
 
 	printk(" dur=0x%04x seq=0x%04x\n", le16_to_cpu(hdr->duration_id),
-	       le16_to_cpu(hdr->seq_ctl));
+	       le16_to_cpu(hdr->seq_ctrl));
 
 	printk(KERN_DEBUG "   A1=%pM", hdr->addr1);
 	printk(" A2=%pM", hdr->addr2);
@@ -63,7 +65,7 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 	int hdrlen, phdrlen, head_need, tail_need;
 	u16 fc;
 	int prism_header, ret;
-	struct ieee80211_hdr_4addr *fhdr;
+	struct ieee80211_hdr *fhdr;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -84,9 +86,9 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 		phdrlen = 0;
 	}
 
-	fhdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(fhdr->frame_ctl);
+	fhdr = (struct ieee80211_hdr *) skb->data;
+	fc = le16_to_cpu(fhdr->frame_control);
 
 	if (type == PRISM2_RX_MGMT && (fc & IEEE80211_FCTL_VERS)) {
 		printk(KERN_DEBUG "%s: dropped management frame with header "
 		       "version %d\n", dev->name, fc & IEEE80211_FCTL_VERS);
@@ -94,7 +96,7 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 		return 0;
 	}
 
-	hdrlen = hostap_80211_get_hdrlen(fc);
+	hdrlen = hostap_80211_get_hdrlen(fhdr->frame_control);
 
 	/* check if there is enough room for extra data; if not, expand skb
 	 * buffer to be large enough for the changes */
@@ -247,21 +249,21 @@ prism2_frag_cache_find(local_info_t *local, unsigned int seq,
 
 /* Called only as a tasklet (software IRQ) */
 static struct sk_buff *
-prism2_frag_cache_get(local_info_t *local, struct ieee80211_hdr_4addr *hdr)
+prism2_frag_cache_get(local_info_t *local, struct ieee80211_hdr *hdr)
 {
 	struct sk_buff *skb = NULL;
 	u16 sc;
 	unsigned int frag, seq;
 	struct prism2_frag_entry *entry;
 
-	sc = le16_to_cpu(hdr->seq_ctl);
-	frag = WLAN_GET_SEQ_FRAG(sc);
-	seq = WLAN_GET_SEQ_SEQ(sc) >> 4;
+	sc = le16_to_cpu(hdr->seq_ctrl);
+	frag = sc & IEEE80211_SCTL_FRAG;
+	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
 
 	if (frag == 0) {
 		/* Reserve enough space to fit maximum frame length */
 		skb = dev_alloc_skb(local->dev->mtu +
-				    sizeof(struct ieee80211_hdr_4addr) +
+				    sizeof(struct ieee80211_hdr) +
 				    8 /* LLC */ +
 				    2 /* alignment */ +
 				    8 /* WEP */ + ETH_ALEN /* WDS */);
@@ -299,14 +301,14 @@ prism2_frag_cache_get(local_info_t *local, struct ieee80211_hdr_4addr *hdr)
 
 /* Called only as a tasklet (software IRQ) */
 static int prism2_frag_cache_invalidate(local_info_t *local,
-					struct ieee80211_hdr_4addr *hdr)
+					struct ieee80211_hdr *hdr)
 {
 	u16 sc;
 	unsigned int seq;
 	struct prism2_frag_entry *entry;
 
-	sc = le16_to_cpu(hdr->seq_ctl);
-	seq = WLAN_GET_SEQ_SEQ(sc) >> 4;
+	sc = le16_to_cpu(hdr->seq_ctrl);
+	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
 
 	entry = prism2_frag_cache_find(local, seq, -1, hdr->addr2, hdr->addr1);
 
@@ -472,10 +474,8 @@ hostap_rx_frame_mgmt(local_info_t *local, struct sk_buff *skb,
 		     struct hostap_80211_rx_status *rx_stats, u16 type,
 		     u16 stype)
 {
-	if (local->iw_mode == IW_MODE_MASTER) {
-		hostap_update_sta_ps(local, (struct ieee80211_hdr_4addr *)
-				     skb->data);
-	}
+	if (local->iw_mode == IW_MODE_MASTER)
+		hostap_update_sta_ps(local, (struct ieee80211_hdr *) skb->data);
 
 	if (local->hostapd && type == IEEE80211_FTYPE_MGMT) {
 		if (stype == IEEE80211_STYPE_BEACON &&
@@ -552,8 +552,8 @@ static struct net_device *prism2_rx_get_wds(local_info_t *local,
 
 
 static int
-hostap_rx_frame_wds(local_info_t *local, struct ieee80211_hdr_4addr *hdr,
-		    u16 fc, struct net_device **wds)
+hostap_rx_frame_wds(local_info_t *local, struct ieee80211_hdr *hdr, u16 fc,
+		    struct net_device **wds)
 {
 	/* FIX: is this really supposed to accept WDS frames only in Master
 	 * mode? What about Repeater or Managed with WDS frames? */
@@ -611,14 +611,14 @@ static int hostap_is_eapol_frame(local_info_t *local, struct sk_buff *skb)
 {
 	struct net_device *dev = local->dev;
 	u16 fc, ethertype;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u8 *pos;
 
 	if (skb->len < 24)
 		return 0;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
 
 	/* check that the frame is unicast frame to us */
 	if ((fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
@@ -651,14 +651,14 @@ static int
 hostap_rx_frame_decrypt(local_info_t *local, struct sk_buff *skb,
 			struct lib80211_crypt_data *crypt)
 {
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	int res, hdrlen;
 
 	if (crypt == NULL || crypt->ops->decrypt_mpdu == NULL)
 		return 0;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	hdrlen = hostap_80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = hostap_80211_get_hdrlen(hdr->frame_control);
 
 	if (local->tkip_countermeasures &&
 	    strcmp(crypt->ops->name, "TKIP") == 0) {
@@ -689,14 +689,14 @@ static int
 hostap_rx_frame_decrypt_msdu(local_info_t *local, struct sk_buff *skb,
 			     int keyidx, struct lib80211_crypt_data *crypt)
 {
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	int res, hdrlen;
 
 	if (crypt == NULL || crypt->ops->decrypt_msdu == NULL)
 		return 0;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	hdrlen = hostap_80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = hostap_80211_get_hdrlen(hdr->frame_control);
 
 	atomic_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
@@ -720,7 +720,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	size_t hdrlen;
 	u16 fc, type, stype, sc;
 	struct net_device *wds = NULL;
@@ -747,18 +747,18 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 	dev = local->ddev;
 	iface = netdev_priv(dev);
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 	stats = hostap_get_stats(dev);
 
 	if (skb->len < 10)
 		goto rx_dropped;
 
-	fc = le16_to_cpu(hdr->frame_ctl);
-	type = WLAN_FC_GET_TYPE(fc);
-	stype = WLAN_FC_GET_STYPE(fc);
-	sc = le16_to_cpu(hdr->seq_ctl);
-	frag = WLAN_GET_SEQ_FRAG(sc);
-	hdrlen = hostap_80211_get_hdrlen(fc);
+	fc = le16_to_cpu(hdr->frame_control);
+	type = fc & IEEE80211_FCTL_FTYPE;
+	stype = fc & IEEE80211_FCTL_STYPE;
+	sc = le16_to_cpu(hdr->seq_ctrl);
+	frag = sc & IEEE80211_SCTL_FRAG;
+	hdrlen = hostap_80211_get_hdrlen(hdr->frame_control);
 
 	/* Put this code here so that we avoid duplicating it in all
 	 * Rx paths. - Jean II */
@@ -918,7 +918,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 	if (local->host_decrypt && (fc & IEEE80211_FCTL_PROTECTED) &&
 	    (keyidx = hostap_rx_frame_decrypt(local, skb, crypt)) < 0)
 		goto rx_dropped;
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 
 	/* skb: hdr + (possibly fragmented) plaintext payload */
 
@@ -931,7 +931,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 			printk(KERN_DEBUG "%s: Rx cannot get skb from "
 			       "fragment cache (morefrag=%d seq=%u frag=%u)\n",
 			       dev->name, (fc & IEEE80211_FCTL_MOREFRAGS) != 0,
-			       WLAN_GET_SEQ_SEQ(sc) >> 4, frag);
+			       (sc & IEEE80211_SCTL_SEQ) >> 4, frag);
 			goto rx_dropped;
 		}
 
@@ -972,7 +972,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 		/* this was the last fragment and the frame will be
 		 * delivered, so remove skb from fragment cache */
 		skb = frag_skb;
-		hdr = (struct ieee80211_hdr_4addr *) skb->data;
+		hdr = (struct ieee80211_hdr *) skb->data;
 		prism2_frag_cache_invalidate(local, hdr);
 	}
 
@@ -983,7 +983,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 	    hostap_rx_frame_decrypt_msdu(local, skb, keyidx, crypt))
 		goto rx_dropped;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 	if (crypt && !(fc & IEEE80211_FCTL_PROTECTED) && !local->open_wep) {
 		if (local->ieee_802_1x &&
 		    hostap_is_eapol_frame(local, skb)) {
diff --git a/drivers/net/wireless/hostap/hostap_80211_tx.c b/drivers/net/wireless/hostap/hostap_80211_tx.c
index 078a010..6693423 100644
--- a/drivers/net/wireless/hostap/hostap_80211_tx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_tx.c
@@ -15,10 +15,10 @@ static unsigned char bridge_tunnel_header[] =
 
 void hostap_dump_tx_80211(const char *name, struct sk_buff *skb)
 {
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 
 	printk(KERN_DEBUG "%s: TX len=%d jiffies=%ld\n",
 	       name, skb->len, jiffies);
@@ -26,9 +26,10 @@ void hostap_dump_tx_80211(const char *name, struct sk_buff *skb)
 	if (skb->len < 2)
 		return;
 
-	fc = le16_to_cpu(hdr->frame_ctl);
+	fc = le16_to_cpu(hdr->frame_control);
 	printk(KERN_DEBUG "   FC=0x%04x (type=%d:%d)%s%s",
-	       fc, WLAN_FC_GET_TYPE(fc) >> 2, WLAN_FC_GET_STYPE(fc) >> 4,
+	       fc, (fc & IEEE80211_FCTL_FTYPE) >> 2,
+	       (fc & IEEE80211_FCTL_STYPE) >> 4,
 	       fc & IEEE80211_FCTL_TODS ? " [ToDS]" : "",
 	       fc & IEEE80211_FCTL_FROMDS ? " [FromDS]" : "");
 
@@ -38,7 +39,7 @@ void hostap_dump_tx_80211(const char *name, struct sk_buff *skb)
 	}
 
 	printk(" dur=0x%04x seq=0x%04x\n", le16_to_cpu(hdr->duration_id),
-	       le16_to_cpu(hdr->seq_ctl));
+	       le16_to_cpu(hdr->seq_ctrl));
 
 	printk(KERN_DEBUG "   A1=%pM", hdr->addr1);
 	printk(" A2=%pM", hdr->addr2);
@@ -57,7 +58,7 @@ int hostap_data_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int need_headroom, need_tailroom = 0;
-	struct ieee80211_hdr_4addr hdr;
+	struct ieee80211_hdr hdr;
 	u16 fc, ethertype = 0;
 	enum {
 		WDS_NO = 0, WDS_OWN_FRAME, WDS_COMPLIANT_FRAME
@@ -201,7 +202,7 @@ int hostap_data_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		memcpy(&hdr.addr3, local->bssid, ETH_ALEN);
 	}
 
-	hdr.frame_ctl = cpu_to_le16(fc);
+	hdr.frame_control = cpu_to_le16(fc);
 
 	skb_pull(skb, skip_header_bytes);
 	need_headroom = local->func->need_tx_headroom + hdr_len + encaps_len;
@@ -265,7 +266,7 @@ int hostap_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hostap_interface *iface;
 	local_info_t *local;
 	struct hostap_skb_tx_data *meta;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 
 	iface = netdev_priv(dev);
@@ -287,10 +288,10 @@ int hostap_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	meta->iface = iface;
 
 	if (skb->len >= IEEE80211_DATA_HDR3_LEN + sizeof(rfc1042_header) + 2) {
-		hdr = (struct ieee80211_hdr_4addr *) skb->data;
-		fc = le16_to_cpu(hdr->frame_ctl);
-		if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA &&
-		    WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_DATA) {
+		hdr = (struct ieee80211_hdr *) skb->data;
+		fc = le16_to_cpu(hdr->frame_control);
+		if (ieee80211_is_data(hdr->frame_control) &&
+		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DATA) {
 			u8 *pos = &skb->data[IEEE80211_DATA_HDR3_LEN +
 					     sizeof(rfc1042_header)];
 			meta->ethertype = (pos[0] << 8) | pos[1];
@@ -310,8 +311,7 @@ static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
-	struct ieee80211_hdr_4addr *hdr;
-	u16 fc;
+	struct ieee80211_hdr *hdr;
 	int prefix_len, postfix_len, hdr_len, res;
 
 	iface = netdev_priv(skb->dev);
@@ -324,7 +324,7 @@ static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
 
 	if (local->tkip_countermeasures &&
 	    strcmp(crypt->ops->name, "TKIP") == 0) {
-		hdr = (struct ieee80211_hdr_4addr *) skb->data;
+		hdr = (struct ieee80211_hdr *) skb->data;
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: TKIP countermeasures: dropped "
 			       "TX packet to %pM\n",
@@ -349,9 +349,8 @@ static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
 		return NULL;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
- 	fc = le16_to_cpu(hdr->frame_ctl);
-	hdr_len = hostap_80211_get_hdrlen(fc);
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdr_len = hostap_80211_get_hdrlen(hdr->frame_control);
 
 	/* Host-based IEEE 802.11 fragmentation for TX is not yet supported, so
 	 * call both MSDU and MPDU encryption functions from here. */
@@ -384,7 +383,7 @@ int hostap_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	ap_tx_ret tx_ret;
 	struct hostap_skb_tx_data *meta;
 	int no_encrypt = 0;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -427,14 +426,14 @@ int hostap_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_ret = hostap_handle_sta_tx(local, &tx);
 	skb = tx.skb;
 	meta = (struct hostap_skb_tx_data *) skb->cb;
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
- 	fc = le16_to_cpu(hdr->frame_ctl);
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
 	switch (tx_ret) {
 	case AP_TX_CONTINUE:
 		break;
 	case AP_TX_CONTINUE_NOT_AUTHORIZED:
 		if (local->ieee_802_1x &&
-		    WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA &&
+		    ieee80211_is_data(hdr->frame_control) &&
 		    meta->ethertype != ETH_P_PAE &&
 		    !(meta->flags & HOSTAP_TX_FLAGS_WDS)) {
 			printk(KERN_DEBUG "%s: dropped frame to unauthorized "
@@ -469,10 +468,10 @@ int hostap_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* remove special version from the frame header */
 		fc &= ~IEEE80211_FCTL_VERS;
-		hdr->frame_ctl = cpu_to_le16(fc);
+		hdr->frame_control = cpu_to_le16(fc);
 	}
 
-	if (WLAN_FC_GET_TYPE(fc) != IEEE80211_FTYPE_DATA) {
+	if (!ieee80211_is_data(hdr->frame_control)) {
 		no_encrypt = 1;
 		tx.crypt = NULL;
 	}
@@ -493,9 +492,9 @@ int hostap_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Add ISWEP flag both for firmware and host based encryption
 		 */
 		fc |= IEEE80211_FCTL_PROTECTED;
-		hdr->frame_ctl = cpu_to_le16(fc);
+		hdr->frame_control = cpu_to_le16(fc);
 	} else if (local->drop_unencrypted &&
-		   WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA &&
+		   ieee80211_is_data(hdr->frame_control) &&
 		   meta->ethertype != ETH_P_PAE) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: dropped unencrypted TX data "
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 0a4bf94..645862f 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -19,6 +19,7 @@
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
 #include <linux/random.h>
+#include <linux/if_arp.h>
 
 #include "hostap_wlan.h"
 #include "hostap.h"
@@ -588,26 +589,22 @@ void hostap_check_sta_fw_version(struct ap_data *ap, int sta_fw_ver)
 static void hostap_ap_tx_cb(struct sk_buff *skb, int ok, void *data)
 {
 	struct ap_data *ap = data;
-	u16 fc;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 
 	if (!ap->local->hostapd || !ap->local->apdev) {
 		dev_kfree_skb(skb);
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
-
 	/* Pass the TX callback frame to the hostapd; use 802.11 header version
 	 * 1 to indicate failure (no ACK) and 2 success (frame ACKed) */
 
-	fc &= ~IEEE80211_FCTL_VERS;
-	fc |= ok ? BIT(1) : BIT(0);
-	hdr->frame_ctl = cpu_to_le16(fc);
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_VERS);
+	hdr->frame_control |= cpu_to_le16(ok ? BIT(1) : BIT(0));
 
 	skb->dev = ap->local->apdev;
-	skb_pull(skb, hostap_80211_get_hdrlen(fc));
+	skb_pull(skb, hostap_80211_get_hdrlen(hdr->frame_control));
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = cpu_to_be16(ETH_P_802_2);
 	memset(skb->cb, 0, sizeof(skb->cb));
@@ -621,8 +618,8 @@ static void hostap_ap_tx_cb_auth(struct sk_buff *skb, int ok, void *data)
 {
 	struct ap_data *ap = data;
 	struct net_device *dev = ap->local->dev;
-	struct ieee80211_hdr_4addr *hdr;
-	u16 fc, auth_alg, auth_transaction, status;
+	struct ieee80211_hdr *hdr;
+	u16 auth_alg, auth_transaction, status;
 	__le16 *pos;
 	struct sta_info *sta = NULL;
 	char *txt = NULL;
@@ -632,10 +629,8 @@ static void hostap_ap_tx_cb_auth(struct sk_buff *skb, int ok, void *data)
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
-	if (WLAN_FC_GET_TYPE(fc) != IEEE80211_FTYPE_MGMT ||
-	    WLAN_FC_GET_STYPE(fc) != IEEE80211_STYPE_AUTH ||
+	hdr = (struct ieee80211_hdr *) skb->data;
+	if (!ieee80211_is_auth(hdr->frame_control) ||
 	    skb->len < IEEE80211_MGMT_HDR_LEN + 6) {
 		printk(KERN_DEBUG "%s: hostap_ap_tx_cb_auth received invalid "
 		       "frame\n", dev->name);
@@ -691,7 +686,7 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 {
 	struct ap_data *ap = data;
 	struct net_device *dev = ap->local->dev;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u16 fc, status;
 	__le16 *pos;
 	struct sta_info *sta = NULL;
@@ -702,11 +697,10 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
-	if (WLAN_FC_GET_TYPE(fc) != IEEE80211_FTYPE_MGMT ||
-	    (WLAN_FC_GET_STYPE(fc) != IEEE80211_STYPE_ASSOC_RESP &&
-	     WLAN_FC_GET_STYPE(fc) != IEEE80211_STYPE_REASSOC_RESP) ||
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
+	if ((!ieee80211_is_assoc_resp(hdr->frame_control) &&
+	     !ieee80211_is_reassoc_resp(hdr->frame_control)) ||
 	    skb->len < IEEE80211_MGMT_HDR_LEN + 4) {
 		printk(KERN_DEBUG "%s: hostap_ap_tx_cb_assoc received invalid "
 		       "frame\n", dev->name);
@@ -757,12 +751,12 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 static void hostap_ap_tx_cb_poll(struct sk_buff *skb, int ok, void *data)
 {
 	struct ap_data *ap = data;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	struct sta_info *sta;
 
 	if (skb->len < 24)
 		goto fail;
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 	if (ok) {
 		spin_lock(&ap->sta_table_lock);
 		sta = ap_get_sta(ap, hdr->addr1);
@@ -917,7 +911,7 @@ static void prism2_send_mgmt(struct net_device *dev,
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 	struct sk_buff *skb;
 	struct hostap_skb_tx_data *meta;
@@ -942,8 +936,8 @@ static void prism2_send_mgmt(struct net_device *dev,
 	}
 
 	fc = type_subtype;
-	hdrlen = hostap_80211_get_hdrlen(fc);
-	hdr = (struct ieee80211_hdr_4addr *) skb_put(skb, hdrlen);
+	hdrlen = hostap_80211_get_hdrlen(cpu_to_le16(type_subtype));
+	hdr = (struct ieee80211_hdr *) skb_put(skb, hdrlen);
 	if (body)
 		memcpy(skb_put(skb, body_len), body, body_len);
 
@@ -954,11 +948,11 @@ static void prism2_send_mgmt(struct net_device *dev,
 
 
 	memcpy(hdr->addr1, addr, ETH_ALEN); /* DA / RA */
-	if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA) {
+	if (ieee80211_is_data(hdr->frame_control)) {
 		fc |= IEEE80211_FCTL_FROMDS;
 		memcpy(hdr->addr2, dev->dev_addr, ETH_ALEN); /* BSSID */
 		memcpy(hdr->addr3, dev->dev_addr, ETH_ALEN); /* SA */
-	} else if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_CTL) {
+	} else if (ieee80211_is_ctl(hdr->frame_control)) {
 		/* control:ACK does not have addr2 or addr3 */
 		memset(hdr->addr2, 0, ETH_ALEN);
 		memset(hdr->addr3, 0, ETH_ALEN);
@@ -967,7 +961,7 @@ static void prism2_send_mgmt(struct net_device *dev,
 		memcpy(hdr->addr3, dev->dev_addr, ETH_ALEN); /* BSSID */
 	}
 
-	hdr->frame_ctl = cpu_to_le16(fc);
+	hdr->frame_control = cpu_to_le16(fc);
 
 	meta = (struct hostap_skb_tx_data *) skb->cb;
 	memset(meta, 0, sizeof(*meta));
@@ -1284,22 +1278,21 @@ static void handle_authen(local_info_t *local, struct sk_buff *skb,
 			  struct hostap_80211_rx_status *rx_stats)
 {
 	struct net_device *dev = local->dev;
-	struct ieee80211_hdr_4addr *hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	size_t hdrlen;
 	struct ap_data *ap = local->ap;
 	char body[8 + WLAN_AUTH_CHALLENGE_LEN], *challenge = NULL;
 	int len, olen;
 	u16 auth_alg, auth_transaction, status_code;
 	__le16 *pos;
-	u16 resp = WLAN_STATUS_SUCCESS, fc;
+	u16 resp = WLAN_STATUS_SUCCESS;
 	struct sta_info *sta = NULL;
 	struct lib80211_crypt_data *crypt;
 	char *txt = "";
 
 	len = skb->len - IEEE80211_MGMT_HDR_LEN;
 
-	fc = le16_to_cpu(hdr->frame_ctl);
-	hdrlen = hostap_80211_get_hdrlen(fc);
+	hdrlen = hostap_80211_get_hdrlen(hdr->frame_control);
 
 	if (len < 6) {
 		PDEBUG(DEBUG_AP, "%s: handle_authen - too short payload "
@@ -1435,7 +1428,7 @@ static void handle_authen(local_info_t *local, struct sk_buff *skb,
 			    challenge == NULL ||
 			    memcmp(sta->u.sta.challenge, challenge,
 				   WLAN_AUTH_CHALLENGE_LEN) != 0 ||
-			    !(fc & IEEE80211_FCTL_PROTECTED)) {
+			    !ieee80211_has_protected(hdr->frame_control)) {
 				txt = "challenge response incorrect";
 				resp = WLAN_STATUS_CHALLENGE_FAIL;
 				goto fail;
@@ -1488,7 +1481,7 @@ static void handle_authen(local_info_t *local, struct sk_buff *skb,
 		       "trans#=%d stat=%d len=%d fc=%04x) ==> %d (%s)\n",
 		       dev->name, hdr->addr2,
 		       auth_alg, auth_transaction, status_code, len,
-		       fc, resp, txt);
+		       le16_to_cpu(hdr->frame_control), resp, txt);
 	}
 }
 
@@ -1498,7 +1491,7 @@ static void handle_assoc(local_info_t *local, struct sk_buff *skb,
 			 struct hostap_80211_rx_status *rx_stats, int reassoc)
 {
 	struct net_device *dev = local->dev;
-	struct ieee80211_hdr_4addr *hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	char body[12], *p, *lpos;
 	int len, left;
 	__le16 *pos;
@@ -1707,7 +1700,7 @@ static void handle_deauth(local_info_t *local, struct sk_buff *skb,
 			  struct hostap_80211_rx_status *rx_stats)
 {
 	struct net_device *dev = local->dev;
-	struct ieee80211_hdr_4addr *hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	char *body = (char *) (skb->data + IEEE80211_MGMT_HDR_LEN);
 	int len;
 	u16 reason_code;
@@ -1749,7 +1742,7 @@ static void handle_disassoc(local_info_t *local, struct sk_buff *skb,
 			    struct hostap_80211_rx_status *rx_stats)
 {
 	struct net_device *dev = local->dev;
-	struct ieee80211_hdr_4addr *hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	char *body = skb->data + IEEE80211_MGMT_HDR_LEN;
 	int len;
 	u16 reason_code;
@@ -1788,7 +1781,7 @@ static void handle_disassoc(local_info_t *local, struct sk_buff *skb,
 
 /* Called only as a scheduled task for pending AP frames. */
 static void ap_handle_data_nullfunc(local_info_t *local,
-				    struct ieee80211_hdr_4addr *hdr)
+				    struct ieee80211_hdr *hdr)
 {
 	struct net_device *dev = local->dev;
 
@@ -1805,7 +1798,7 @@ static void ap_handle_data_nullfunc(local_info_t *local,
 
 /* Called only as a scheduled task for pending AP frames. */
 static void ap_handle_dropped_data(local_info_t *local,
-				   struct ieee80211_hdr_4addr *hdr)
+				   struct ieee80211_hdr *hdr)
 {
 	struct net_device *dev = local->dev;
 	struct sta_info *sta;
@@ -1863,7 +1856,7 @@ static void pspoll_send_buffered(local_info_t *local, struct sta_info *sta,
 
 /* Called only as a scheduled task for pending AP frames. */
 static void handle_pspoll(local_info_t *local,
-			  struct ieee80211_hdr_4addr *hdr,
+			  struct ieee80211_hdr *hdr,
 			  struct hostap_80211_rx_status *rx_stats)
 {
 	struct net_device *dev = local->dev;
@@ -1872,8 +1865,7 @@ static void handle_pspoll(local_info_t *local,
 	struct sk_buff *skb;
 
 	PDEBUG(DEBUG_PS2, "handle_pspoll: BSSID=%pM, TA=%pM PWRMGT=%d\n",
-	       hdr->addr1, hdr->addr2,
-	       !!(le16_to_cpu(hdr->frame_ctl) & IEEE80211_FCTL_PM));
+	       hdr->addr1, hdr->addr2, !!ieee80211_has_pm(hdr->frame_control));
 
 	if (memcmp(hdr->addr1, dev->dev_addr, ETH_ALEN)) {
 		PDEBUG(DEBUG_AP,
@@ -1984,7 +1976,7 @@ static void handle_wds_oper_queue(struct work_struct *work)
 static void handle_beacon(local_info_t *local, struct sk_buff *skb,
 			  struct hostap_80211_rx_status *rx_stats)
 {
-	struct ieee80211_hdr_4addr *hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	char *body = skb->data + IEEE80211_MGMT_HDR_LEN;
 	int len, left;
 	u16 beacon_int, capability;
@@ -2143,14 +2135,14 @@ static void handle_ap_item(local_info_t *local, struct sk_buff *skb,
 	struct net_device *dev = local->dev;
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 	u16 fc, type, stype;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 
 	/* FIX: should give skb->len to handler functions and check that the
 	 * buffer is long enough */
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
-	type = WLAN_FC_GET_TYPE(fc);
-	stype = WLAN_FC_GET_STYPE(fc);
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
+	type = fc & IEEE80211_FCTL_FTYPE;
+	stype = fc & IEEE80211_FCTL_STYPE;
 
 #ifndef PRISM2_NO_KERNEL_IEEE80211_MGMT
 	if (!local->hostapd && type == IEEE80211_FTYPE_DATA) {
@@ -2262,8 +2254,7 @@ void hostap_rx(struct net_device *dev, struct sk_buff *skb,
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
-	u16 fc;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -2273,12 +2264,10 @@ void hostap_rx(struct net_device *dev, struct sk_buff *skb,
 
 	local->stats.rx_packets++;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
+	hdr = (struct ieee80211_hdr *) skb->data;
 
 	if (local->ap->ap_policy == AP_OTHER_AP_SKIP_ALL &&
-	    WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT &&
-	    WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_BEACON)
+	    ieee80211_is_beacon(hdr->frame_control))
 		goto drop;
 
 	skb->protocol = cpu_to_be16(ETH_P_HOSTAP);
@@ -2294,7 +2283,7 @@ void hostap_rx(struct net_device *dev, struct sk_buff *skb,
 static void schedule_packet_send(local_info_t *local, struct sta_info *sta)
 {
 	struct sk_buff *skb;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	struct hostap_80211_rx_status rx_stats;
 
 	if (skb_queue_empty(&sta->tx_buf))
@@ -2307,10 +2296,10 @@ static void schedule_packet_send(local_info_t *local, struct sta_info *sta)
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *) skb_put(skb, 16);
+	hdr = (struct ieee80211_hdr *) skb_put(skb, 16);
 
 	/* Generate a fake pspoll frame to start packet delivery */
-	hdr->frame_ctl = cpu_to_le16(
+	hdr->frame_control = cpu_to_le16(
 		IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
 	memcpy(hdr->addr1, local->dev->dev_addr, ETH_ALEN);
 	memcpy(hdr->addr2, sta->addr, ETH_ALEN);
@@ -2689,7 +2678,7 @@ ap_tx_ret hostap_handle_sta_tx(local_info_t *local, struct hostap_tx_data *tx)
 	struct sta_info *sta = NULL;
 	struct sk_buff *skb = tx->skb;
 	int set_tim, ret;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	struct hostap_skb_tx_data *meta;
 
 	meta = (struct hostap_skb_tx_data *) skb->cb;
@@ -2698,7 +2687,7 @@ ap_tx_ret hostap_handle_sta_tx(local_info_t *local, struct hostap_tx_data *tx)
 	    meta->iface->type == HOSTAP_INTERFACE_STA)
 		goto out;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 
 	if (hdr->addr1[0] & 0x01) {
 		/* broadcast/multicast frame - no AP related processing */
@@ -2753,7 +2742,7 @@ ap_tx_ret hostap_handle_sta_tx(local_info_t *local, struct hostap_tx_data *tx)
 
 	if (meta->flags & HOSTAP_TX_FLAGS_ADD_MOREDATA) {
 		/* indicate to STA that more frames follow */
-		hdr->frame_ctl |=
+		hdr->frame_control |=
 			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	}
 
@@ -2828,10 +2817,10 @@ void hostap_handle_sta_release(void *ptr)
 void hostap_handle_sta_tx_exc(local_info_t *local, struct sk_buff *skb)
 {
 	struct sta_info *sta;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	struct hostap_skb_tx_data *meta;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 	meta = (struct hostap_skb_tx_data *) skb->cb;
 
 	spin_lock(&local->ap->sta_table_lock);
@@ -2898,8 +2887,8 @@ static void hostap_update_sta_ps2(local_info_t *local, struct sta_info *sta,
 
 
 /* Called only as a tasklet (software IRQ). Called for each RX frame to update
- * STA power saving state. pwrmgt is a flag from 802.11 frame_ctl field. */
-int hostap_update_sta_ps(local_info_t *local, struct ieee80211_hdr_4addr *hdr)
+ * STA power saving state. pwrmgt is a flag from 802.11 frame_control field. */
+int hostap_update_sta_ps(local_info_t *local, struct ieee80211_hdr *hdr)
 {
 	struct sta_info *sta;
 	u16 fc;
@@ -2913,9 +2902,10 @@ int hostap_update_sta_ps(local_info_t *local, struct ieee80211_hdr_4addr *hdr)
 	if (!sta)
 		return -1;
 
-	fc = le16_to_cpu(hdr->frame_ctl);
+	fc = le16_to_cpu(hdr->frame_control);
 	hostap_update_sta_ps2(local, sta, fc & IEEE80211_FCTL_PM,
-			      WLAN_FC_GET_TYPE(fc), WLAN_FC_GET_STYPE(fc));
+			      fc & IEEE80211_FCTL_FTYPE,
+			      fc & IEEE80211_FCTL_STYPE);
 
 	atomic_dec(&sta->users);
 	return 0;
@@ -2932,16 +2922,16 @@ ap_rx_ret hostap_handle_sta_rx(local_info_t *local, struct net_device *dev,
 	int ret;
 	struct sta_info *sta;
 	u16 fc, type, stype;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 
 	if (local->ap == NULL)
 		return AP_RX_CONTINUE;
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 
-	fc = le16_to_cpu(hdr->frame_ctl);
-	type = WLAN_FC_GET_TYPE(fc);
-	stype = WLAN_FC_GET_STYPE(fc);
+	fc = le16_to_cpu(hdr->frame_control);
+	type = fc & IEEE80211_FCTL_FTYPE;
+	stype = fc & IEEE80211_FCTL_STYPE;
 
 	spin_lock(&local->ap->sta_table_lock);
 	sta = ap_get_sta(local->ap, hdr->addr2);
@@ -3064,7 +3054,7 @@ ap_rx_ret hostap_handle_sta_rx(local_info_t *local, struct net_device *dev,
 
 /* Called only as a tasklet (software IRQ) */
 int hostap_handle_sta_crypto(local_info_t *local,
-			     struct ieee80211_hdr_4addr *hdr,
+			     struct ieee80211_hdr *hdr,
 			     struct lib80211_crypt_data **crypt,
 			     void **sta_ptr)
 {
@@ -3166,7 +3156,7 @@ int hostap_add_sta(struct ap_data *ap, u8 *sta_addr)
 
 /* Called only as a tasklet (software IRQ) */
 int hostap_update_rx_stats(struct ap_data *ap,
-			   struct ieee80211_hdr_4addr *hdr,
+			   struct ieee80211_hdr *hdr,
 			   struct hostap_80211_rx_status *rx_stats)
 {
 	struct sta_info *sta;
diff --git a/drivers/net/wireless/hostap/hostap_ap.h b/drivers/net/wireless/hostap/hostap_ap.h
index d36e4b1..655ceeb 100644
--- a/drivers/net/wireless/hostap/hostap_ap.h
+++ b/drivers/net/wireless/hostap/hostap_ap.h
@@ -235,7 +235,7 @@ struct hostap_tx_data {
 ap_tx_ret hostap_handle_sta_tx(local_info_t *local, struct hostap_tx_data *tx);
 void hostap_handle_sta_release(void *ptr);
 void hostap_handle_sta_tx_exc(local_info_t *local, struct sk_buff *skb);
-int hostap_update_sta_ps(local_info_t *local, struct ieee80211_hdr_4addr *hdr);
+int hostap_update_sta_ps(local_info_t *local, struct ieee80211_hdr *hdr);
 typedef enum {
 	AP_RX_CONTINUE, AP_RX_DROP, AP_RX_EXIT, AP_RX_CONTINUE_NOT_AUTHORIZED
 } ap_rx_ret;
@@ -243,13 +243,13 @@ ap_rx_ret hostap_handle_sta_rx(local_info_t *local, struct net_device *dev,
 			       struct sk_buff *skb,
 			       struct hostap_80211_rx_status *rx_stats,
 			       int wds);
-int hostap_handle_sta_crypto(local_info_t *local, struct ieee80211_hdr_4addr *hdr,
+int hostap_handle_sta_crypto(local_info_t *local, struct ieee80211_hdr *hdr,
 			     struct lib80211_crypt_data **crypt,
 			     void **sta_ptr);
 int hostap_is_sta_assoc(struct ap_data *ap, u8 *sta_addr);
 int hostap_is_sta_authorized(struct ap_data *ap, u8 *sta_addr);
 int hostap_add_sta(struct ap_data *ap, u8 *sta_addr);
-int hostap_update_rx_stats(struct ap_data *ap, struct ieee80211_hdr_4addr *hdr,
+int hostap_update_rx_stats(struct ap_data *ap, struct ieee80211_hdr *hdr,
 			   struct hostap_80211_rx_status *rx_stats);
 void hostap_update_rates(local_info_t *local);
 void hostap_add_wds_links(local_info_t *local);
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 0f27059..3d9e7b7 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -46,7 +46,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 #include <net/lib80211.h>
 #include <asm/irq.h>
 
@@ -1840,8 +1839,8 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	hdr_len = 24;
 	skb_copy_from_linear_data(skb, &txdesc.frame_control, hdr_len);
  	fc = le16_to_cpu(txdesc.frame_control);
-	if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA &&
-	    (fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS) &&
+	if (ieee80211_is_data(txdesc.frame_control) &&
+	    ieee80211_has_a4(txdesc.frame_control) &&
 	    skb->len >= 30) {
 		/* Addr4 */
 		skb_copy_from_linear_data_offset(skb, hdr_len, txdesc.addr4,
@@ -2082,7 +2081,7 @@ static void hostap_rx_skb(local_info_t *local, struct sk_buff *skb)
 	stats.rate = rxdesc->rate;
 
 	/* Convert Prism2 RX structure into IEEE 802.11 header */
-	hdrlen = hostap_80211_get_hdrlen(le16_to_cpu(rxdesc->frame_control));
+	hdrlen = hostap_80211_get_hdrlen(rxdesc->frame_control);
 	if (hdrlen > rx_hdrlen)
 		hdrlen = rx_hdrlen;
 
@@ -2204,7 +2203,7 @@ static void hostap_tx_callback(local_info_t *local,
 		return;
 	}
 
-	hdrlen = hostap_80211_get_hdrlen(le16_to_cpu(txdesc->frame_control));
+	hdrlen = hostap_80211_get_hdrlen(txdesc->frame_control);
 	len = le16_to_cpu(txdesc->data_len);
 	skb = dev_alloc_skb(hdrlen + len);
 	if (skb == NULL) {
@@ -2315,8 +2314,7 @@ static void hostap_sta_tx_exc_tasklet(unsigned long data)
 		if (skb->len >= sizeof(*txdesc)) {
 			/* Convert Prism2 RX structure into IEEE 802.11 header
 			 */
-			u16 fc = le16_to_cpu(txdesc->frame_control);
-			int hdrlen = hostap_80211_get_hdrlen(fc);
+			int hdrlen = hostap_80211_get_hdrlen(txdesc->frame_control);
 			memmove(skb_pull(skb, sizeof(*txdesc) - hdrlen),
 				&txdesc->frame_control, hdrlen);
 
@@ -2394,12 +2392,12 @@ static void prism2_txexc(local_info_t *local)
 	PDEBUG(DEBUG_EXTRA, "   retry_count=%d tx_rate=%d fc=0x%04x "
 	       "(%s%s%s::%d%s%s)\n",
 	       txdesc.retry_count, txdesc.tx_rate, fc,
-	       WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT ? "Mgmt" : "",
-	       WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_CTL ? "Ctrl" : "",
-	       WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA ? "Data" : "",
-	       WLAN_FC_GET_STYPE(fc) >> 4,
-	       fc & IEEE80211_FCTL_TODS ? " ToDS" : "",
-	       fc & IEEE80211_FCTL_FROMDS ? " FromDS" : "");
+	       ieee80211_is_mgmt(txdesc.frame_control) ? "Mgmt" : "",
+	       ieee80211_is_ctl(txdesc.frame_control) ? "Ctrl" : "",
+	       ieee80211_is_data(txdesc.frame_control) ? "Data" : "",
+	       (fc & IEEE80211_FCTL_STYPE) >> 4,
+	       ieee80211_has_tods(txdesc.frame_control) ? " ToDS" : "",
+	       ieee80211_has_fromds(txdesc.frame_control) ? " FromDS" : "");
 	PDEBUG(DEBUG_EXTRA, "   A1=%pM A2=%pM A3=%pM A4=%pM\n",
 	       txdesc.addr1, txdesc.addr2,
 	       txdesc.addr3, txdesc.addr4);
diff --git a/drivers/net/wireless/hostap/hostap_info.c b/drivers/net/wireless/hostap/hostap_info.c
index 99b4cf4..6fa14a4 100644
--- a/drivers/net/wireless/hostap/hostap_info.c
+++ b/drivers/net/wireless/hostap/hostap_info.c
@@ -1,5 +1,6 @@
 /* Host AP driver Info Frame processing (part of hostap.o module) */
 
+#include <linux/if_arp.h>
 #include "hostap_wlan.h"
 #include "hostap.h"
 #include "hostap_ap.h"
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 8618b33..3f2bda8 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2,6 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/ethtool.h>
+#include <linux/if_arp.h>
 #include <net/lib80211.h>
 
 #include "hostap_wlan.h"
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index 02a312c..5d55f92 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -26,7 +26,6 @@
 #include <linux/etherdevice.h>
 #include <net/net_namespace.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 #include <net/lib80211.h>
 #include <asm/uaccess.h>
 
@@ -543,7 +542,8 @@ void hostap_dump_rx_header(const char *name, const struct hfa384x_rx_frame *rx)
 	fc = __le16_to_cpu(rx->frame_control);
 	printk(KERN_DEBUG "   FC=0x%04x (type=%d:%d) dur=0x%04x seq=0x%04x "
 	       "data_len=%d%s%s\n",
-	       fc, WLAN_FC_GET_TYPE(fc) >> 2, WLAN_FC_GET_STYPE(fc) >> 4,
+	       fc, (fc & IEEE80211_FCTL_FTYPE) >> 2,
+	       (fc & IEEE80211_FCTL_STYPE) >> 4,
 	       __le16_to_cpu(rx->duration_id), __le16_to_cpu(rx->seq_ctrl),
 	       __le16_to_cpu(rx->data_len),
 	       fc & IEEE80211_FCTL_TODS ? " [ToDS]" : "",
@@ -570,7 +570,8 @@ void hostap_dump_tx_header(const char *name, const struct hfa384x_tx_frame *tx)
 	fc = __le16_to_cpu(tx->frame_control);
 	printk(KERN_DEBUG "   FC=0x%04x (type=%d:%d) dur=0x%04x seq=0x%04x "
 	       "data_len=%d%s%s\n",
-	       fc, WLAN_FC_GET_TYPE(fc) >> 2, WLAN_FC_GET_STYPE(fc) >> 4,
+	       fc, (fc & IEEE80211_FCTL_FTYPE) >> 2,
+	       (fc & IEEE80211_FCTL_STYPE) >> 4,
 	       __le16_to_cpu(tx->duration_id), __le16_to_cpu(tx->seq_ctrl),
 	       __le16_to_cpu(tx->data_len),
 	       fc & IEEE80211_FCTL_TODS ? " [ToDS]" : "",
@@ -593,29 +594,16 @@ static int hostap_80211_header_parse(const struct sk_buff *skb,
 }
 
 
-int hostap_80211_get_hdrlen(u16 fc)
+int hostap_80211_get_hdrlen(__le16 fc)
 {
-	int hdrlen = 24;
-
-	switch (WLAN_FC_GET_TYPE(fc)) {
-	case IEEE80211_FTYPE_DATA:
-		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
-			hdrlen = 30; /* Addr4 */
-		break;
-	case IEEE80211_FTYPE_CTL:
-		switch (WLAN_FC_GET_STYPE(fc)) {
-		case IEEE80211_STYPE_CTS:
-		case IEEE80211_STYPE_ACK:
-			hdrlen = 10;
-			break;
-		default:
-			hdrlen = 16;
-			break;
-		}
-		break;
-	}
-
-	return hdrlen;
+	if (ieee80211_is_data(fc) && ieee80211_has_a4 (fc))
+		return 30; /* Addr4 */
+	else if (ieee80211_is_cts(fc) || ieee80211_is_ack(fc))
+		return 10;
+	else if (ieee80211_is_ctl(fc))
+		return 16;
+
+	return 24;
 }
 
 


