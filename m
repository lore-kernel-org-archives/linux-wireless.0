Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50875 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1JUIhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:37:35 -0400
Received: by yxl42 with SMTP id 42so1073085yxl.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:37:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:37:34 +0400
Message-ID: <CAG5dHkTTomVwMD9-wrneQCyJzrTJT+S6amnhLbEN+xTGucBzMA@mail.gmail.com> (sfid-20111021_103739_014461_A7FBCD2D)
Subject: [RFC 5/7] cfg80211 and nl80211: Setting local link-specific power mode
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    2 ++
 net/mac80211/cfg.c      |    5 +++++
 net/wireless/nl80211.c  |    8 ++++++++
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 001e9e3..ce789ce 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1054,6 +1054,7 @@ enum nl80211_commands {
  *	%NL80211_ATTR_SUPPORTED_IFTYPES) containing the interface types that
  *	are managed in software: interfaces of these types aren't subject to
  *	any restrictions in their number or combinations.
+ * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
  *
  * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
  *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
@@ -1337,6 +1338,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,

+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */

 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e00e04e..2204222 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -456,6 +456,7 @@ enum station_parameters_apply_mask {
  *	as the AC bitmap in the QoS info field
  * @max_sp: max Service Period. same format as the MAX_SP in the
  *	QoS info field (but already shifted down)
+ * @local_ps_mode: local link-specific mesh power save mode
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -470,6 +471,7 @@ struct station_parameters {
 	struct ieee80211_ht_cap *ht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
+	u8 local_ps_mode;
 };

 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e253afa..78c61ee 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -804,6 +804,11 @@ static void sta_apply_parameters(struct
ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
+
+		if (params->local_ps_mode) {
+			ieee80211s_set_local_ps_mode(sta,
+				params->local_ps_mode);
+		}
 #endif
 	}
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48260c2..80bc2a7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2517,6 +2517,10 @@ static int nl80211_set_station(struct sk_buff
*skb, struct genl_info *info)
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);

+	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE])
+		params.local_ps_mode =
+			nla_get_u8(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
+
 	err = get_vlan(info, rdev, &params.vlan);
 	if (err)
 		goto out;
@@ -2531,6 +2535,8 @@ static int nl80211_set_station(struct sk_buff
*skb, struct genl_info *info)
 		/* disallow mesh-specific things */
 		if (params.plink_action)
 			err = -EINVAL;
+		if (params.local_ps_mode)
+			err = -EINVAL;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
@@ -2554,6 +2560,8 @@ static int nl80211_set_station(struct sk_buff
*skb, struct genl_info *info)
 		if (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
 		    (params.sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)))
 			err = -EINVAL;
+		if (params.local_ps_mode)
+			err = -EINVAL;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		/* disallow things mesh doesn't support */
-- 
1.7.3.4
