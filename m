Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSOKB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 10:10:01 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 1/3] cfg80211: Extend avg ack rssi support for mgmt frames
Date: Thu, 19 Jul 2018 18:56:27 +0530
Message-Id: <1532006789-32454-2-git-send-email-bpothuno@codeaurora.org> (sfid-20180719_152653_050004_CE454A9F)
In-Reply-To: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
References: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Defining APIs to update avg ack rssi irrespective of data or
mgmt tx ack packet; this patch keeps the original behavior
intact without breaking the existing API.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2: Addressed Johannes comments
    Modified subject and commit log

 include/uapi/linux/nl80211.h | 7 +++++++
 net/wireless/nl80211.c       | 7 ++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f82ce3c..06f23db 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -52,6 +52,13 @@
 #define NL80211_MULTICAST_GROUP_NAN		"nan"
 #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
 
+/*
+ * These APIs are defined to maintain average ack signal for both data and
+ * mgmt tx ack packets
+ */
+#define NL80211_STA_INFO_ACK_SIGNAL_AVG NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG
+#define NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT
+
 /**
  * DOC: Station handling
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0ccce33..a0ad39e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4723,10 +4723,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO_U64(RX_DROP_MISC, rx_dropped_misc);
 	PUT_SINFO_U64(BEACON_RX, rx_beacon);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
-	PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
 	if (wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT))
-		PUT_SINFO(DATA_ACK_SIGNAL_AVG, avg_ack_signal, s8);
+	    NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT)) {
+		PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
+		PUT_SINFO(ACK_SIGNAL_AVG, avg_ack_signal, s8);
+	}
 
 #undef PUT_SINFO
 #undef PUT_SINFO_U64
-- 
2.7.4
