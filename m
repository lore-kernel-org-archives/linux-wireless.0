Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50109 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1JMOaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:30:46 -0400
Received: by ggnv2 with SMTP id v2so64750ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2011 07:30:46 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] nl80211: Add sta_flags to the station info
Date: Thu, 13 Oct 2011 16:30:39 +0200
Message-Id: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111013_163050_348046_A84DB4BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reuse the already existing struct nl80211_sta_flag_update to specify
both, a flag mask and the flag set itself. This means
nl80211_sta_flag_update is now used for setting station flags and also
for getting station flags.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

I think this is reasonable since even if we add read-only flags in
the future we can just ignore them when userspace tries to set them.

Helmut

 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    5 ++++-
 net/wireless/nl80211.c  |    4 ++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9d797f2..013ec4b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1548,6 +1548,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
  *     containing info as possible, see &enum nl80211_sta_bss_param
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
+ * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update. 
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1569,6 +1570,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_BITRATE,
 	NL80211_STA_INFO_BSS_PARAM,
 	NL80211_STA_INFO_CONNECTED_TIME,
+	NL80211_STA_INFO_STA_FLAGS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 74f4f85..92cf1c2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -497,6 +497,7 @@ struct station_parameters {
  * @STATION_INFO_BSS_PARAM: @bss_param filled
  * @STATION_INFO_CONNECTED_TIME: @connected_time filled
  * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
+ * @STATION_INFO_STA_FLAGS: @sta_flags filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -516,7 +517,8 @@ enum station_info_flags {
 	STATION_INFO_RX_BITRATE		= 1<<14,
 	STATION_INFO_BSS_PARAM          = 1<<15,
 	STATION_INFO_CONNECTED_TIME	= 1<<16,
-	STATION_INFO_ASSOC_REQ_IES	= 1<<17
+	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
+	STATION_INFO_STA_FLAGS		= 1<<18
 };
 
 /**
@@ -633,6 +635,7 @@ struct station_info {
 	u32 tx_failed;
 	u32 rx_dropped_misc;
 	struct sta_bss_parameters bss_param;
+	struct nl80211_sta_flag_update sta_flags;
 
 	int generation;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index edf655a..48260c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2344,6 +2344,10 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 
 		nla_nest_end(msg, bss_param);
 	}
+	if (sinfo->filled & STATION_INFO_STA_FLAGS)
+		NLA_PUT(msg, NL80211_STA_INFO_STA_FLAGS,
+			sizeof(struct nl80211_sta_flag_update),
+			&sinfo->sta_flags);
 	nla_nest_end(msg, sinfoattr);
 
 	if (sinfo->filled & STATION_INFO_ASSOC_REQ_IES)
-- 
1.7.3.4

