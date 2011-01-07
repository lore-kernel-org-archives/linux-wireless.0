Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:12861 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753888Ab1AGF7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 00:59:34 -0500
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0815499971
	for <linux-wireless@vger.kernel.org>; Fri,  7 Jan 2011 14:59:33 +0900 (JST)
Subject: [PATCH 2/4] iw: Add channel busy time to survey
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Fri, 07 Jan 2011 15:00:31 +0900
Message-ID: <20110107060031.21507.10327.stgit@localhost6.localdomain6>
In-Reply-To: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
References: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 

