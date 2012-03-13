Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43022 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2CMTrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 15:47:39 -0400
Received: by dadp12 with SMTP id p12so1456332dad.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 12:47:39 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH v2 2/3] cfg80211: Fill Toffset for each station
Date: Tue, 13 Mar 2012 12:47:24 -0700
Message-Id: <1331668045-16384-2-git-send-email-ashok@cozybit.com> (sfid-20120313_204749_400469_512E87B6)
In-Reply-To: <1331668045-16384-1-git-send-email-ashok@cozybit.com>
References: <1331668045-16384-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2:
Report toffset to userspace only when RX_FLAG_MACTIME_MPDU is set (Johannes)

 include/net/cfg80211.h |    6 +++++-
 net/mac80211/cfg.c     |    4 ++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 69b7ad3..5daffad 100644
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
index 677d659..25e25d5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -412,6 +412,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
 		sinfo->plink_state = sta->plink_state;
+		if (sta->last_rx_rate_flag & RX_FLAG_MACTIME_MPDU) {
+			sinfo->filled |= STATION_INFO_T_OFFSET;
+			sinfo->t_offset = sta->t_offset;
+		}
 #endif
 	}
 
-- 
1.7.5.4

