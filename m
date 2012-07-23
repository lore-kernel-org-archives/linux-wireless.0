Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:20802
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab2GWJNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 05:13:54 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: VHT (11ac) Association
Date: Mon, 23 Jul 2012 09:13:53 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E31@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120723_111358_103111_ABDED144)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Partial changes to request VHT (11ac) association.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bb61f77..f0db2af 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -359,6 +359,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
 	IEEE80211_STA_DISABLE_40MHZ	= BIT(10),
+	IEEE80211_STA_DISABLE_11AC	= BIT(11),
 };
 
 struct ieee80211_mgd_auth_data {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7c0613c..80489e9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -326,6 +326,27 @@ static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_ht_cap(pos, &ht_cap, cap);
 }
 
+static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
+				 struct sk_buff *skb,
+				 struct ieee80211_supported_band *sband)
+{
+	u8 *pos;
+	u32 cap;
+	struct ieee80211_sta_vht_cap vht_cap;
+
+	BUILD_BUG_ON(sizeof(vht_cap) != sizeof(sband->vht_cap));
+
+	memcpy(&vht_cap, &sband->vht_cap, sizeof(vht_cap));
+	//ieee80211_apply_vhtcap_overrides(sdata, &ht_cap);
+
+	/* determine capability flags */
+	cap = vht_cap.cap;
+
+	/* reserve and fill IE */
+	pos = skb_put(skb, sizeof(struct ieee80211_vht_capabilities) + 2);
+	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
+}
+
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -503,6 +524,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
 				    sband, local->oper_channel, ifmgd->ap_smps);
 
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11AC))
+		ieee80211_add_vht_ie(sdata, skb, sband);
+
+
 	/* if present, add any custom non-vendor IEs that go after HT */
 	if (assoc_data->ie_len && assoc_data->ie) {
 		noffset = ieee80211_ie_split_vendor(assoc_data->ie,
@@ -3304,6 +3329,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11AC;
 
 	ifmgd->beacon_crc_valid = false;
 
@@ -3319,13 +3345,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104) {
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+			ifmgd->flags |= IEEE80211_STA_DISABLE_11AC;
 			netdev_info(sdata->dev,
-				    "disabling HT due to WEP/TKIP use\n");
+				    "disabling HT/VHT due to WEP/TKIP use\n");
 		}
 	}
 
-	if (req->flags & ASSOC_REQ_DISABLE_HT)
+	if (req->flags & ASSOC_REQ_DISABLE_HT) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11AC;
+	}
 
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
@@ -3336,6 +3365,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			    "disabling HT as WMM/QoS is not supported\n");
 	}
 
+	/* disable VHT if we don't support it or the AP doesn't use WMM */
+	if (!sband->vht_cap.vht_supported ||
+	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11AC;
+		netdev_info(sdata->dev,
+			    "disabling VHT as WMM/QoS is not supported\n");
+	}
+
 	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
 	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,
 	       sizeof(ifmgd->ht_capa_mask));