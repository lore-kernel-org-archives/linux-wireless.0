Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab2CLXrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 19:47:06 -0400
Received: by dajr28 with SMTP id r28so5849191daj.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 16:47:05 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 2/3] cfg80211: Fill Toffset for each station
Date: Mon, 12 Mar 2012 16:46:59 -0700
Message-Id: <1331596020-29695-2-git-send-email-ashok@cozybit.com> (sfid-20120313_004712_885361_3D1FA6DB)
In-Reply-To: <1331596020-29695-1-git-send-email-ashok@cozybit.com>
References: <1331596020-29695-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/net/cfg80211.h |    6 +++++-
 net/mac80211/cfg.c     |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 66f4603..22c42bb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -520,6 +520,7 @@ struct station_parameters {
  * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
  * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
+ * @STATION_INFO_T_OFFSET: @t_offset filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -541,7 +542,8 @@ enum station_info_flags {
 	STATION_INFO_CONNECTED_TIME	= 1<<16,
 	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
 	STATION_INFO_STA_FLAGS		= 1<<18,
-	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19
+	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
+	STATION_INFO_T_OFFSET		= 1<<20,
 };
 
 /**
@@ -640,6 +642,7 @@ struct sta_bss_parameters {
  * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
  * @sta_flags: station flags mask & values
  * @beacon_loss_count: Number of times beacon loss event has triggered.
+ * @t_offset: Time offset of the station relative to this host.
  */
 struct station_info {
 	u32 filled;
@@ -668,6 +671,7 @@ struct station_info {
 	size_t assoc_req_ies_len;
 
 	u32 beacon_loss_count;
+	s64 t_offset;
 
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 677d659..5639157 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -407,11 +407,13 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |= STATION_INFO_LLID |
 				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE;
+				 STATION_INFO_PLINK_STATE |
+				 STATION_INFO_T_OFFSET;
 
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
 		sinfo->plink_state = sta->plink_state;
+		sinfo->t_offset = sta->t_offset;
 #endif
 	}
 
-- 
1.7.5.4

