Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18227 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbcCGLEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 06:04:33 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
	<kvalo@codeaurora.org>, <mohammed@codeaurora.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH v1] iw: Add support for NL80211_STA_INFO_RX_DURATION netlink attribute
Date: Mon, 7 Mar 2016 16:34:00 +0530
Message-ID: <1457348640-10628-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160307_120435_829826_BA601944)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable support for parsing per station rx-duration (usecs)
via adding support for new netlink attribute NL80211_STA_INFO_RX_DURATION

rx_duration is vendor specific total air time(usecs) for data/management
frames from the connected client. This will get dumped as
part of 'iw dev wlan#N station dump'

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[v1]

changed the doc for rx_duration as 'vendor specific implementation'

 nl80211.h |    3 +++
 station.c |    5 +++++
 2 files changed, 8 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index 5b7b5eb..3aeb2c6 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2464,6 +2464,8 @@ enum nl80211_sta_bss_param {
  *	TID+1 and the special TID 16 (i.e. value 17) is used for non-QoS frames;
  *	each one of those is again nested with &enum nl80211_tid_stats
  *	attributes carrying the actual values.
+ * @NL80210_STA_INFO_RX_DURATION: vendor specific total airtime(usecs) for
+ *	data/management frames from the connected client
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2500,6 +2502,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_BEACON_RX,
 	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
 	NL80211_STA_INFO_TID_STATS,
+	NL80211_STA_INFO_RX_DURATION,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/station.c b/station.c
index b5ccf4a..a730db1 100644
--- a/station.c
+++ b/station.c
@@ -147,6 +147,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_NONPEER_PM] = { .type = NLA_U32},
 		[NL80211_STA_INFO_CHAIN_SIGNAL] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_CHAIN_SIGNAL_AVG] = { .type = NLA_NESTED },
+		[NL80211_STA_INFO_RX_DURATION] = { .type = NLA_U64 },
 	};
 	char *chain;
 
@@ -226,6 +227,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\trx bitrate:\t%s", buf);
 	}
 
+	if (sinfo[NL80211_STA_INFO_RX_DURATION])
+		printf("\n\trx duration:\t%lld us",
+		       (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_RX_DURATION]));
+
 	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
 		uint32_t thr;
 
-- 
1.7.9.5

