Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:49703 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbXCTKlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 06:41:07 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id A9B448D100
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2007 11:41:05 +0100 (CET)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 455DB10092
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2007 10:41:08 +0000 (UTC)
Message-Id: <20070320104104.318699229@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
Date: Tue, 20 Mar 2007 10:39:57 +0000
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: Add radiotap support for Monitor mode RX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try #2
 - Fix radiotap bitmap generation (Andy Green)
 - Fix radiotap padding (Michael Wu)

From: Michael Wu <flamingice@sourmilk.net>

---

 include/net/mac80211.h         |    3 ++
 net/mac80211/ieee80211.c       |   67 +++++++++++++++++++++++++++++++++-------
 net/mac80211/ieee80211_iface.c |    2 +
 3 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 916b21b..27cffdc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -518,6 +518,9 @@ struct ieee80211_hw {
 	 * normal operation. */
 #define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
 
+	/* Driver supports radiotap. */
+#define IEEE80211_HW_RADIOTAP_SUPPORTED (1<<10)
+
 	/* please fill this gap when adding new flags */
 
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 0b7cb35..6bffc29 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -8,6 +8,7 @@
  */
 
 #include <net/mac80211.h>
+#include <net/ieee80211_radiotap.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
@@ -286,6 +287,14 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
+static int ieee80211_get_radiotap_len(struct sk_buff *skb)
+{
+	struct ieee80211_radiotap_header *hdr =
+		(struct ieee80211_radiotap_header *) skb->data;
+
+	return le16_to_cpu(hdr->it_len);
+}
+
 #ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP
 static void ieee80211_dump_frame(const char *ifname, const char *title,
 				 const struct sk_buff *skb)
@@ -2741,26 +2750,48 @@ ieee80211_rx_monitor(struct net_device *dev, struct sk_buff *skb,
 		     struct ieee80211_rx_status *status)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_frame_info *fi;
 	struct ieee80211_sub_if_data *sdata;
-	const size_t hlen = sizeof(struct ieee80211_frame_info)
-				- sizeof(fi->msg_type);
+	struct ieee80211_rtap_hdr {
+		struct ieee80211_radiotap_header hdr;
+		u8 flags;
+		u8 rate;
+		__le16 chan_freq;
+		__le16 chan_flags;
+		u8 antsignal;
+	} __attribute__ ((packed)) *rthdr;
 
 	skb->dev = dev;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (skb_headroom(skb) < hlen) {
-		I802_DEBUG_INC(local->rx_expand_skb_head);
-		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return;
+	if (!(local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED)) {
+		if (skb_headroom(skb) < sizeof(*rthdr)) {
+			I802_DEBUG_INC(local->rx_expand_skb_head);
+			if (pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC)) {
+				dev_kfree_skb(skb);
+				return;
+			}
 		}
-	}
 
-	fi = (struct ieee80211_frame_info *) skb_push(skb, hlen);
+		rthdr = (struct ieee80211_rtap_hdr *) skb_push(skb, sizeof(*rthdr));
+		memset(rthdr, 0, sizeof(*rthdr));
+		rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
+		rthdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+				    (1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL));
+		rthdr->flags = local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
+			       IEEE80211_RADIOTAP_F_FCS : 0;
+		rthdr->rate = status->rate / 5;
+		rthdr->chan_freq = cpu_to_le16(status->freq);
+		rthdr->chan_flags =
+			status->phymode == MODE_IEEE80211A ?
+			cpu_to_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ) :
+			cpu_to_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ);
+		rthdr->antsignal = status->ssi;
+	}
 
-	ieee80211_fill_frame_info(local, fi, status);
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes += skb->len;
 
@@ -3164,6 +3195,10 @@ ieee80211_rx_h_monitor(struct ieee80211_txrx_data *rx)
 		return TXRX_QUEUED;
 	}
 
+	if (rx->local->monitors &&
+	    rx->local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED)
+		skb_pull(rx->skb, ieee80211_get_radiotap_len(rx->skb));
+
 	return TXRX_CONTINUE;
 }
 
@@ -3731,6 +3766,13 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_txrx_data rx;
 	u16 type;
 	int multicast;
+	int radiotap_len = 0;
+
+	if (local->monitors &&
+	    local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED) {
+		radiotap_len = ieee80211_get_radiotap_len(skb);
+		skb_pull(skb, radiotap_len);
+	}
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	memset(&rx, 0, sizeof(rx));
@@ -3767,6 +3809,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto end;
 	skb = rx.skb;
 
+	skb_push(skb, radiotap_len);
 	if (sta && !sta->assoc_ap && !(sta->flags & WLAN_STA_WDS) &&
 	    !local->iff_promiscs && !multicast) {
 		rx.u.rx.ra_match = 1;
@@ -3775,7 +3818,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	} else {
 		struct ieee80211_sub_if_data *prev = NULL;
 		struct sk_buff *skb_new;
-		u8 *bssid = ieee80211_get_bssid(hdr, skb->len);
+		u8 *bssid = ieee80211_get_bssid(hdr, skb->len - radiotap_len);
 
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			rx.u.rx.ra_match = 1;
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 3e0b4fa..51197b1 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -199,7 +199,7 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		break;
 	}
 	case IEEE80211_IF_TYPE_MNTR:
-		dev->type = ARPHRD_IEEE80211_PRISM;
+		dev->type = ARPHRD_IEEE80211_RADIOTAP;
 		break;
 	default:
 		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",

-- 
