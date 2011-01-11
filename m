Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:47482 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755091Ab1AKAuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:50:14 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0689937013
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 09:50:13 +0900 (JST)
Subject: [PATCH v2 2/4] iw: Add channel busy time to survey
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Tue, 11 Jan 2011 09:51:12 +0900
Message-ID: <20110111005112.10231.46375.stgit@localhost6.localdomain6>
In-Reply-To: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
References: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Print channel busy time in survey dump.

This patch comes from OpenWRT. Original author: Felix Fietkau.
Fixed up for unsigned values.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 survey.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/survey.c b/survey.c
index 83c54b3..e71d21b 100644
--- a/survey.c
+++ b/survey.c
@@ -44,12 +44,27 @@ static int print_survey_handler(struct nl_msg *msg, void *arg)
 	}
 
 	if (sinfo[NL80211_SURVEY_INFO_FREQUENCY])
-		printf("\tfrequency:\t%u MHz%s\n",
+		printf("\tfrequency:\t\t\t%u MHz%s\n",
 			nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]),
 			sinfo[NL80211_SURVEY_INFO_IN_USE] ? " [in use]" : "");
 	if (sinfo[NL80211_SURVEY_INFO_NOISE])
-		printf("\tnoise:\t\t%d dBm\n",
+		printf("\tnoise:\t\t\t\t%d dBm\n",
 			(int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_NOISE]));
+	if (sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME])
+		printf("\tchannel active time:\t\t%llu ms\n",
+			(uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME]));
+	if (sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY])
+		printf("\tchannel busy time:\t\t%llu ms\n",
+			(uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY]));
+	if (sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY])
+		printf("\textension channel busy time:\t%llu ms\n",
+			(uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY]));
+	if (sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX])
+		printf("\tchannel receive time:\t\t%llu ms\n",
+			(uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX]));
+	if (sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX])
+		printf("\tchannel transmit time:\t\t%llu ms\n",
+			(uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX]));
 	return NL_SKIP;
 }
 

