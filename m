Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50875 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1JUIhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:37:41 -0400
Received: by mail-yx0-f174.google.com with SMTP id 42so1073085yxl.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:37:41 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:37:41 +0400
Message-ID: <CAG5dHkRtN+VRFyvG=JiYrggqFj-3L3YVSMt+HqsVvJUPsaBJrg@mail.gmail.com> (sfid-20111021_103744_787862_40E4B84B)
Subject: [RFC 6/7] cfg80211 and nl80211: getting local and peer mesh power modes
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |   10 +++++++++-
 net/mac80211/cfg.c      |    6 +++++-
 net/wireless/nl80211.c  |    6 ++++++
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ce789ce..4f4bfb8 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1552,6 +1552,10 @@ enum nl80211_sta_bss_param {
  *     containing info as possible, see &enum nl80211_sta_bss_param
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
+ * @NL80211_STA_INFO_LOCAL_MESH_PS_MODE: local mesh STA link-specific power
+ * 	save mode
+ * @NL80211_STA_INFO_PEER_MESH_PS_MODE: peer mesh STA link-specific power
+ * 	save mode
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1574,6 +1578,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_BSS_PARAM,
 	NL80211_STA_INFO_CONNECTED_TIME,
 	NL80211_STA_INFO_STA_FLAGS,
+	NL80211_STA_INFO_LOCAL_MESH_PS_MODE,
+	NL80211_STA_INFO_PEER_MESH_PS_MODE,

 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2204222..845937c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -500,6 +500,8 @@ struct station_parameters {
  * @STATION_INFO_CONNECTED_TIME: @connected_time filled
  * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
+ * @STATION_INFO_LOCAL_MESH_PS_MODE: @local_ps_mode filled
+ * @STATION_INFO_PEER_MESH_PS_MODE: @peer_ps_mode filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -520,7 +522,9 @@ enum station_info_flags {
 	STATION_INFO_BSS_PARAM          = 1<<15,
 	STATION_INFO_CONNECTED_TIME	= 1<<16,
 	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
-	STATION_INFO_STA_FLAGS		= 1<<18
+	STATION_INFO_STA_FLAGS		= 1<<18,
+	STATION_INFO_LOCAL_MESH_PS_MODE = 1<<17,
+	STATION_INFO_PEER_MESH_PS_MODE  = 1<<18
 };

 /**
@@ -608,6 +612,8 @@ struct sta_bss_parameters {
  * @tx_failed: number of failed transmissions (retries exceeded, no ACK)
  * @rx_dropped_misc:  Dropped for un-specified reason.
  * @bss_param: current BSS parameters
+ * @local_ps_mode: local mesh STA power save mode
+ * @peer_ps_mode: peer mesh STA power save mode
  * @generation: generation number for nl80211 dumps.
  *	This number should increase every time the list of stations
  *	changes, i.e. when a station is added or removed, so that
@@ -638,6 +644,8 @@ struct station_info {
 	u32 rx_dropped_misc;
 	struct sta_bss_parameters bss_param;
 	struct nl80211_sta_flag_update sta_flags;
+	u8 local_ps_mode;
+	u8 peer_ps_mode;

 	int generation;

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 78c61ee..2b0cc2c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -388,11 +388,15 @@ static void sta_set_sinfo(struct sta_info *sta,
struct station_info *sinfo)
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |= STATION_INFO_LLID |
 				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE;
+				 STATION_INFO_PLINK_STATE |
+				 STATION_INFO_LOCAL_MESH_PS_MODE |
+				 STATION_INFO_PEER_MESH_PS_MODE;

 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
 		sinfo->plink_state = sta->plink_state;
+		sinfo->local_ps_mode = sta->local_ps_mode;
+		sinfo->peer_ps_mode = sta->peer_ps_mode;
 #endif
 	}

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 80bc2a7..c53c8bb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2325,6 +2325,12 @@ static int nl80211_send_station(struct sk_buff
*msg, u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_TX_FAILED)
 		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_FAILED,
 			    sinfo->tx_failed);
+	if (sinfo->filled & STATION_INFO_LOCAL_MESH_PS_MODE)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_LOCAL_MESH_PS_MODE,
+			sinfo->local_ps_mode);
+	if (sinfo->filled & STATION_INFO_PEER_MESH_PS_MODE)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_PEER_MESH_PS_MODE,
+			sinfo->peer_ps_mode);
 	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
-- 
1.7.3.4
