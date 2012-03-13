Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43022 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2CMTrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 15:47:40 -0400
Received: by mail-pz0-f52.google.com with SMTP id p12so1456332dad.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 12:47:40 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH v2 3/3] nl80211: Read Toffset for each station
Date: Tue, 13 Mar 2012 12:47:25 -0700
Message-Id: <1331668045-16384-3-git-send-email-ashok@cozybit.com> (sfid-20120313_204749_974578_847FED01)
In-Reply-To: <1331668045-16384-1-git-send-email-ashok@cozybit.com>
References: <1331668045-16384-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h |    2 ++
 net/wireless/nl80211.c  |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e474f6e..94211ff 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1685,6 +1685,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
  * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
+ * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1708,6 +1709,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CONNECTED_TIME,
 	NL80211_STA_INFO_STA_FLAGS,
 	NL80211_STA_INFO_BEACON_LOSS,
+	NL80211_STA_INFO_T_OFFSET,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4c1eb94..d7b85e1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2479,6 +2479,9 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 		NLA_PUT(msg, NL80211_STA_INFO_STA_FLAGS,
 			sizeof(struct nl80211_sta_flag_update),
 			&sinfo->sta_flags);
+	if (sinfo->filled & STATION_INFO_T_OFFSET)
+		NLA_PUT_U64(msg, NL80211_STA_INFO_T_OFFSET,
+			    sinfo->t_offset);
 	nla_nest_end(msg, sinfoattr);
 
 	if (sinfo->filled & STATION_INFO_ASSOC_REQ_IES)
-- 
1.7.5.4

