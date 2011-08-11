Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46176 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1HKBA4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 21:00:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	jouni@qca.qualcomm.com
Subject: [PATCH] cfg80211: fix a crash in nl80211_send_station
Date: Wed, 10 Aug 2011 19:00:33 -0600
Message-Id: <1313024433-35053-1-git-send-email-nbd@openwrt.org> (sfid-20110811_030113_656755_E43F427D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 leaves sinfo->assoc_req_ies uninitialized, causing a random
pointer memory access in nl80211_send_station.
Instead of checking if the pointer is null, use sinfo->filled, like
the rest of the fields.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h |    4 +++-
 net/wireless/nl80211.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 779e300..96876d3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -421,6 +421,7 @@ struct station_parameters {
  * @STATION_INFO_RX_BITRATE: @rxrate fields are filled
  * @STATION_INFO_BSS_PARAM: @bss_param filled
  * @STATION_INFO_CONNECTED_TIME: @connected_time filled
+ * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -439,7 +440,8 @@ enum station_info_flags {
 	STATION_INFO_SIGNAL_AVG		= 1<<13,
 	STATION_INFO_RX_BITRATE		= 1<<14,
 	STATION_INFO_BSS_PARAM          = 1<<15,
-	STATION_INFO_CONNECTED_TIME	= 1<<16
+	STATION_INFO_CONNECTED_TIME	= 1<<16,
+	STATION_INFO_ASSOC_REQ_IES	= 1<<17
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ca76977..253e563 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2236,7 +2236,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	}
 	nla_nest_end(msg, sinfoattr);
 
-	if (sinfo->assoc_req_ies)
+	if (sinfo->filled & STATION_INFO_ASSOC_REQ_IES)
 		NLA_PUT(msg, NL80211_ATTR_IE, sinfo->assoc_req_ies_len,
 			sinfo->assoc_req_ies);
 
-- 
1.7.3.2

