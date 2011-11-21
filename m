Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1KUNTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 08:19:14 -0500
Received: by iage36 with SMTP id e36so7262830iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 05:19:14 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 17:19:14 +0400
Message-ID: <CAG5dHkTq6NYZMxRs1G3HcTZ_FL6nmdKTDGsiTKuC5dj=DVx6=A@mail.gmail.com> (sfid-20111121_141917_370789_61A72A70)
Subject: [RFC v2 6/8] cfg80211 and nl80211: Setting local link-specific power mode
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Local link-specific power mode defines a mesh power mode in which
itoperates for the mesh peering with the station. Possibility of
settinglocal link-specific power mode is added.
Signed-off-by: Ivan Bezyazychnyy
<ivan.bezyazychnyy@gmail.com>Signed-off-by: Mike Krinkin
<krinkin.m.u@gmail.com>--- include/linux/nl80211.h |    3 +++
include/net/cfg80211.h  |    2 ++ net/mac80211/cfg.c      |    5 +++++
net/wireless/nl80211.c  |    8 ++++++++ 4 files changed, 18
insertions(+), 0 deletions(-)
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.hindex
001e9e3..ce789ce 100644--- a/include/linux/nl80211.h+++
b/include/linux/nl80211.h@@ -1054,6 +1054,7 @@ enum nl80211_commands {
 *	%NL80211_ATTR_SUPPORTED_IFTYPES) containing the interface types
that  *	are managed in software: interfaces of these types aren't
subject to  *	any restrictions in their number or combinations.+ *
@NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific
power mode  *  * @%NL80211_ATTR_REKEY_DATA: nested attribute
containing the information  *	necessary for GTK rekeying in the
device, see &enum nl80211_rekey_data.@@ -1337,6 +1338,8 @@ enum
nl80211_attrs { 	NL80211_ATTR_TDLS_SUPPORT,
	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,+ 	/* add attributes here, update
the policy in nl80211.c */  	__NL80211_ATTR_AFTER_LAST,diff --git
a/include/net/cfg80211.h b/include/net/cfg80211.hindex
e00e04e..2204222 100644--- a/include/net/cfg80211.h+++
b/include/net/cfg80211.h@@ -456,6 +456,7 @@ enum
station_parameters_apply_mask {  *	as the AC bitmap in the QoS info
field  * @max_sp: max Service Period. same format as the MAX_SP in the
 *	QoS info field (but already shifted down)+ * @local_ps_mode: local
link-specific mesh power save mode  */ struct station_parameters { 	u8
*supported_rates;@@ -470,6 +471,7 @@ struct station_parameters {
	struct ieee80211_ht_cap *ht_capa; 	u8 uapsd_queues; 	u8 max_sp;+	u8
local_ps_mode; };  /**diff --git a/net/mac80211/cfg.c
b/net/mac80211/cfg.cindex e253afa..78c61ee 100644---
a/net/mac80211/cfg.c+++ b/net/mac80211/cfg.c@@ -804,6 +804,11 @@
static void sta_apply_parameters(struct ieee80211_local *local,
				mesh_plink_block(sta); 				break; 			}++		if
(params->local_ps_mode)
{+			ieee80211s_set_local_ps_mode(sta,+				params->local_ps_mode);+		}
#endif 	} }diff --git a/net/wireless/nl80211.c
b/net/wireless/nl80211.cindex 48260c2..80bc2a7 100644---
a/net/wireless/nl80211.c+++ b/net/wireless/nl80211.c@@ -2517,6
+2517,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct
genl_info *info) 		params.plink_state = 		
nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]); +	if
(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE])+		params.local_ps_mode
=+			nla_get_u8(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);+
	err = get_vlan(info, rdev, &params.vlan); 	if (err) 		goto out;@@
-2531,6 +2535,8 @@ static int nl80211_set_station(struct sk_buff *skb,
struct genl_info *info) 		/* disallow mesh-specific things */ 		if
(params.plink_action) 			err = -EINVAL;+		if
(params.local_ps_mode)+			err = -EINVAL; 		break; 	case
NL80211_IFTYPE_P2P_CLIENT: 	case NL80211_IFTYPE_STATION:@@ -2554,6
+2560,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct
genl_info *info) 		if (!(params.sta_flags_set &
BIT(NL80211_STA_FLAG_TDLS_PEER)) && 		    (params.sta_flags_mask &
BIT(NL80211_STA_FLAG_TDLS_PEER))) 			err = -EINVAL;+		if
(params.local_ps_mode)+			err = -EINVAL; 		break; 	case
NL80211_IFTYPE_MESH_POINT: 		/* disallow things mesh doesn't support
*/-- 1.7.3.4
