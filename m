Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYE2Ih4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 38/43] mac80211: allow disable FAT in specific configurations
Date: Thu, 29 May 2008 16:35:23 +0800
Message-Id: <1212050128-17132-39-git-send-email-yi.zhu@intel.com> (sfid-20080529_103809_959161_C421771F)
In-Reply-To: <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch allows to disable FAT channel in specific configurations.

For example the configuration (8, +1), (primary channel 8, extension
channel 12) isn't permitted in U.S., but (8, -1), (primary channel 8,
extension channel 4) is. When FAT channel configuration is not
permitted, FAT channel should be reported as not supported in the
capabilities of the HT IE in association request. And sssociation is
performed on 20Mhz channel.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/ieee80211.h  |    2 +
 include/net/wireless.h     |    6 +++++
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/mlme.c        |   46 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3c2ac0c..9300f37 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -320,6 +320,8 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_CAP_MCS_TX_UEQM		0x10
 /* 802.11n HT IE masks */
 #define IEEE80211_HT_IE_CHA_SEC_OFFSET		0x03
+#define IEEE80211_HT_IE_CHA_SEC_ABOVE 		0x01
+#define IEEE80211_HT_IE_CHA_SEC_BELOW 		0x03
 #define IEEE80211_HT_IE_CHA_WIDTH		0x04
 #define IEEE80211_HT_IE_HT_PROTECTION		0x0003
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 667b408..9324f8d 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -39,12 +39,18 @@ enum ieee80211_band {
  *	on this channel.
  * @IEEE80211_CHAN_NO_IBSS: IBSS is not allowed on this channel.
  * @IEEE80211_CHAN_RADAR: Radar detection is required on this channel.
+ * @IEEE80211_CHAN_NO_FAT_ABOVE: extension channel above this channel
+ * 	is not permitted.
+ * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channel
+ * 	is not permitted.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
 	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
 	IEEE80211_CHAN_NO_IBSS		= 1<<2,
 	IEEE80211_CHAN_RADAR		= 1<<3,
+	IEEE80211_CHAN_NO_FAT_ABOVE	= 1<<4,
+	IEEE80211_CHAN_NO_FAT_BELOW	= 1<<5,
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3f8601c..432011c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -92,6 +92,8 @@ struct ieee80211_sta_bss {
 	size_t wmm_ie_len;
 	u8 *ht_ie;
 	size_t ht_ie_len;
+	u8 *ht_add_ie;
+	size_t ht_add_ie_len;
 #ifdef CONFIG_MAC80211_MESH
 	u8 *mesh_id;
 	size_t mesh_id_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bfc4d80..c220bed 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -815,8 +815,29 @@ static void ieee80211_send_assoc(struct net_device *dev,
 
 	/* wmm support is a must to HT */
 	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
-	    sband->ht_info.ht_supported) {
-		__le16 tmp = cpu_to_le16(sband->ht_info.cap);
+	    sband->ht_info.ht_supported && bss->ht_add_ie) {
+		struct ieee80211_ht_addt_info *ht_add_info =
+			(struct ieee80211_ht_addt_info *)bss->ht_add_ie;
+		u16 cap = sband->ht_info.cap;
+		__le16 tmp;
+		u32 flags = local->hw.conf.channel->flags;
+
+		switch (ht_add_info->ht_param & IEEE80211_HT_IE_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_IE_CHA_SEC_ABOVE:
+			if (flags & IEEE80211_CHAN_NO_FAT_ABOVE) {
+				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH;
+				cap &= ~IEEE80211_HT_CAP_SGI_40;
+			}
+			break;
+		case IEEE80211_HT_IE_CHA_SEC_BELOW:
+			if (flags & IEEE80211_CHAN_NO_FAT_BELOW) {
+				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH;
+				cap &= ~IEEE80211_HT_CAP_SGI_40;
+			}
+			break;
+		}
+
+		tmp = cpu_to_le16(cap);
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
@@ -2271,6 +2292,7 @@ static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
 	kfree(bss->ht_ie);
+	kfree(bss->ht_add_ie);
 	kfree(bss_mesh_id(bss));
 	kfree(bss_mesh_cfg(bss));
 	kfree(bss);
@@ -2645,6 +2667,26 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		bss->ht_ie_len = 0;
 	}
 
+	if (elems.ht_info_elem &&
+	     (!bss->ht_add_ie ||
+	     bss->ht_add_ie_len != elems.ht_info_elem_len ||
+	     memcmp(bss->ht_add_ie, elems.ht_info_elem,
+			elems.ht_info_elem_len))) {
+		kfree(bss->ht_add_ie);
+		bss->ht_add_ie =
+			kmalloc(elems.ht_info_elem_len + 2, GFP_ATOMIC);
+		if (bss->ht_add_ie) {
+			memcpy(bss->ht_add_ie, elems.ht_info_elem - 2,
+				elems.ht_info_elem_len + 2);
+			bss->ht_add_ie_len = elems.ht_info_elem_len + 2;
+		} else
+			bss->ht_add_ie_len = 0;
+	} else if (!elems.ht_info_elem && bss->ht_add_ie) {
+		kfree(bss->ht_add_ie);
+		bss->ht_add_ie = NULL;
+		bss->ht_add_ie_len = 0;
+	}
+
 	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
 	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
 
-- 
1.5.3.6

