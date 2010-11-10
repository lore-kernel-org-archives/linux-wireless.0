Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:62189 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0KJHDt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 02:03:49 -0500
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2] mac80211: Add function to get probe request template for current AP
Date: Wed, 10 Nov 2010 09:03:36 +0200
Message-Id: <1289372616-15378-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Chipsets with hardware based connection monitoring need to autonomically
send directed probe-request frames to the AP (in the event of beacon loss,
for example.)

For the hardware to be able to do this, it requires a template for the frame
to transmit to the AP, filled in with the BSSID and SSID of the AP, but also
the supported rate IE's.

This patch adds a function to mac80211, which allows the hardware driver to
fetch this template after association, so it can be configured to the hardware.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
v2: Add more documentation to the ieee80211_ap_probereq_get function

 include/net/mac80211.h     |   14 ++++++++++++++
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/mlme.c        |   24 ++++++++++++++++++++++++
 net/mac80211/util.c        |   23 ++++++++++++++++++-----
 4 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..c0b6378 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2501,6 +2501,20 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *pubsta, bool block);
 
 /**
+ * ieee80211_ap_probereq_get - retrieve a Probe Request template
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Creates a Probe Request template which can, for example, be uploaded to
+ * hardware. The template is filled with bssid, ssid and supported rate
+ * information. This function must only be called from within the
+ * .bss_info_changed callback function. The function is only useful in managed
+ * mode while the interface is associated, otherwise it will return NULL.
+ */
+struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif);
+
+/**
  * ieee80211_beacon_loss - inform hardware does not receive beacons
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b80c386..59a1d38 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1287,6 +1287,10 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel);
+struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
+					  u8 *dst,
+					  const u8 *ssid, size_t ssid_len,
+					  const u8 *ie, size_t ie_len);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a3a9421..dfc4a31 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1108,6 +1108,30 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&ifmgd->mtx);
 }
 
+struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct sk_buff *skb;
+	const u8 *ssid;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return NULL;
+
+	ASSERT_MGD_MTX(ifmgd);
+
+	if (!ifmgd->associated)
+		return NULL;
+
+	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
+	skb = ieee80211_build_probe_req(sdata, ifmgd->associated->bssid,
+					ssid + 2, ssid[1], NULL, 0);
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_ap_probereq_get);
+
 static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0b6fc92..885713d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1011,9 +1011,10 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	return pos - buffer;
 }
 
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      const u8 *ssid, size_t ssid_len,
-			      const u8 *ie, size_t ie_len)
+struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
+					  u8 *dst,
+					  const u8 *ssid, size_t ssid_len,
+					  const u8 *ie, size_t ie_len)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -1027,7 +1028,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 	if (!buf) {
 		printk(KERN_DEBUG "%s: failed to allocate temporary IE "
 		       "buffer\n", sdata->name);
-		return;
+		return NULL;
 	}
 
 	chan = ieee80211_frequency_to_channel(
@@ -1050,8 +1051,20 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 	}
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	ieee80211_tx_skb(sdata, skb);
 	kfree(buf);
+
+	return skb;
+}
+
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+			      const u8 *ssid, size_t ssid_len,
+			      const u8 *ie, size_t ie_len)
+{
+	struct sk_buff *skb;
+
+	skb = ieee80211_build_probe_req(sdata, dst, ssid, ssid_len, ie, ie_len);
+	if (skb)
+		ieee80211_tx_skb(sdata, skb);
 }
 
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
-- 
1.7.1

