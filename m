Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48687 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KQGst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:49 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFC 08/14] {cfg,nl}80211: get local and peer mesh power modes
Date: Fri, 16 Nov 2012 22:48:00 -0800
Message-Id: <1353134886-13256-9-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074859_359068_3D2CCB22)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit adds the possibility of getting the local link-specific
power mode and the tracked link-specific and non-peer power mode of
the peer.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |   12 ++++++++++++
 include/uapi/linux/nl80211.h |    9 +++++++++
 net/mac80211/cfg.c           |    8 +++++++-
 net/wireless/nl80211.c       |   12 ++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index efec888..ad6fabe 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -553,6 +553,9 @@ struct station_parameters {
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
  * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
  * @STATION_INFO_T_OFFSET: @t_offset filled
+ * @STATION_INFO_LOCAL_MESH_PS_MODE: @local_ps_mode filled
+ * @STATION_INFO_PEER_MESH_PS_MODE: @peer_ps_mode filled
+ * @STATION_INFO_NONPEER_MESH_PS_MODE: @nonpeer_ps_mode filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -576,6 +579,9 @@ enum station_info_flags {
 	STATION_INFO_STA_FLAGS		= 1<<18,
 	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
 	STATION_INFO_T_OFFSET		= 1<<20,
+	STATION_INFO_LOCAL_MESH_PS_MODE = 1<<21,
+	STATION_INFO_PEER_MESH_PS_MODE  = 1<<22,
+	STATION_INFO_NONPEER_MESH_PS_MODE  = 1<<23,
 };
 
 /**
@@ -679,6 +685,9 @@ struct sta_bss_parameters {
  * @sta_flags: station flags mask & values
  * @beacon_loss_count: Number of times beacon loss event has triggered.
  * @t_offset: Time offset of the station relative to this host.
+ * @local_ps_mode: local mesh STA power save mode
+ * @peer_ps_mode: peer mesh STA power save mode
+ * @nonpeer_ps_mode: non-peer mesh STA power save mode
  */
 struct station_info {
 	u32 filled;
@@ -708,6 +717,9 @@ struct station_info {
 
 	u32 beacon_loss_count;
 	s64 t_offset;
+	enum nl80211_mesh_power_mode local_ps_mode;
+	enum nl80211_mesh_power_mode peer_ps_mode;
+	enum nl80211_mesh_power_mode nonpeer_ps_mode;
 
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0e7528f..baac4e5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1793,6 +1793,12 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
  * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
  * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
+ * @NL80211_STA_INFO_LOCAL_MESH_PS_MODE: local mesh STA link-specific power
+ * 	save mode
+ * @NL80211_STA_INFO_PEER_MESH_PS_MODE: peer mesh STA link-specific power
+ * 	save mode
+ * @NL80211_STA_INFO_NONPEER_MESH_PS_MODE: neighbor mesh STA power save mode
+ * 	towards non-peer STA
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1817,6 +1823,9 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_STA_FLAGS,
 	NL80211_STA_INFO_BEACON_LOSS,
 	NL80211_STA_INFO_T_OFFSET,
+	NL80211_STA_INFO_LOCAL_MESH_PS_MODE,
+	NL80211_STA_INFO_PEER_MESH_PS_MODE,
+	NL80211_STA_INFO_NONPEER_MESH_PS_MODE,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d0f936d..32a1dbf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -456,7 +456,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |= STATION_INFO_LLID |
 				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE;
+				 STATION_INFO_PLINK_STATE |
+				 STATION_INFO_LOCAL_MESH_PS_MODE |
+				 STATION_INFO_PEER_MESH_PS_MODE |
+				 STATION_INFO_NONPEER_MESH_PS_MODE;
 
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
@@ -465,6 +468,9 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			sinfo->filled |= STATION_INFO_T_OFFSET;
 			sinfo->t_offset = sta->t_offset;
 		}
+		sinfo->local_ps_mode = sta->local_ps_mode;
+		sinfo->peer_ps_mode = sta->peer_ps_mode;
+		sinfo->nonpeer_ps_mode = sta->nonpeer_ps_mode;
 #endif
 	}
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d3ebdc6..dca2aac 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2891,6 +2891,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 	    nla_put_u32(msg, NL80211_STA_INFO_BEACON_LOSS,
 			sinfo->beacon_loss_count))
 		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_LOCAL_MESH_PS_MODE) &&
+	    nla_put_u8(msg, NL80211_STA_INFO_LOCAL_MESH_PS_MODE,
+			sinfo->local_ps_mode))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_PEER_MESH_PS_MODE) &&
+	    nla_put_u8(msg, NL80211_STA_INFO_PEER_MESH_PS_MODE,
+			sinfo->peer_ps_mode))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_NONPEER_MESH_PS_MODE) &&
+	    nla_put_u8(msg, NL80211_STA_INFO_NONPEER_MESH_PS_MODE,
+			sinfo->nonpeer_ps_mode))
+		goto nla_put_failure;
 	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
-- 
1.7.9.5

