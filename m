Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:12190
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab2JJRzn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 13:55:43 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] {nl,cfg}80211: peer STA VHT caps
Date: Wed, 10 Oct 2012 17:55:42 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB3C5@mbx022-e1-nj-10.exch022.domain.local> (sfid-20121010_195547_658046_33492C67)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

To save STAs VHT caps in AP mode

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 include/linux/nl80211.h |    1 +
 include/net/cfg80211.h  |    2 ++
 net/mac80211/cfg.c      |    5 +++++
 net/wireless/nl80211.c  |    4 ++++
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 179a0c2..d5ec2e2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1324,6 +1324,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_BSS_SHORT_SLOT_TIME,
 
 	NL80211_ATTR_HT_CAPABILITY,
+	NL80211_ATTR_VHT_CAPABILITY,
 
 	NL80211_ATTR_SUPPORTED_IFTYPES,
 
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
index 746f649..2759e96 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3223,6 +3223,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY])
+		params.vht_capa =
+			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
+
 	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
 		params.plink_action =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);