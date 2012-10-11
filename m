Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:23232
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602Ab2JKFoi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 01:44:38 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Subject: [PATCH v2] {nl,cfg}80211: Peer STA VHT caps
Date: Thu, 11 Oct 2012 05:44:37 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB4B0@mbx022-e1-nj-10.exch022.domain.local> (sfid-20121011_074442_256097_BA83DF29)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

To save STAs VHT caps in AP mode

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
Patch version 2 to take care of Jouni Malinen's comment

 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    2 ++
 net/mac80211/cfg.c      |    5 +++++
 net/wireless/nl80211.c  |    5 +++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 179a0c2..b82ab80 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1535,6 +1535,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SAE_DATA,
 
+	NL80211_ATTR_VHT_CAPABILITY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1578,6 +1580,7 @@ enum nl80211_attrs {
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
 #define NL80211_HT_CAPABILITY_LEN		26
+#define NL80211_VHT_CAPABILITY_LEN		12
 
 #define NL80211_MAX_NR_CIPHER_SUITES		5
 #define NL80211_MAX_NR_AKM_SUITES		2
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 04df773..1f9ca03 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -498,6 +498,7 @@ enum station_parameters_apply_mask {
  * @plink_action: plink action to take
  * @plink_state: set the peer link state for a station
  * @ht_capa: HT capabilities of station
+ * @vht_capa: VHT capabilities of station
  * @uapsd_queues: bitmap of queues configured for uapsd. same format
  *	as the AC bitmap in the QoS info field
  * @max_sp: max Service Period. same format as the MAX_SP in the
@@ -517,6 +518,7 @@ struct station_parameters {
 	u8 plink_action;
 	u8 plink_state;
 	struct ieee80211_ht_cap *ht_capa;
+	struct ieee80211_vht_cap *vht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 03216b0..ed27988 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1157,6 +1157,11 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
+	if (params->vht_capa)
+		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
+						    params->vht_capa,
+						    &sta->sta.vht_cap);
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 746f649..8303a2a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -355,6 +355,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
+	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
 };
 
 /* policy for the key attributes */
@@ -3223,6 +3224,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY])
+		params.vht_capa =
+			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
+
 	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
 		params.plink_action =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);