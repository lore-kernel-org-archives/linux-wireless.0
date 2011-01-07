Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:15653 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751808Ab1AGF72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 00:59:28 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0436099966
	for <linux-wireless@vger.kernel.org>; Fri,  7 Jan 2011 14:59:27 +0900 (JST)
Subject: [PATCH 1/4] iw: survey: Mark frequency in use
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Fri, 07 Jan 2011 15:00:25 +0900
Message-ID: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Survey: Mark frequency in use according to NL80211_SURVEY_INFO_IN_USE.

This patch comes from OpenWRT. Original author: Felix Fietkau

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 survey.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/survey.c b/survey.c
index f9f2508..83c54b3 100644
--- a/survey.c
+++ b/survey.c
@@ -44,8 +44,9 @@ static int print_survey_handler(struct nl_msg *msg, void *arg)
 	}
 
 	if (sinfo[NL80211_SURVEY_INFO_FREQUENCY])
-		printf("\tfrequency:\t%u MHz\n",
-			nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]));
+		printf("\tfrequency:\t%u MHz%s\n",
+			nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]),
+			sinfo[NL80211_SURVEY_INFO_IN_USE] ? " [in use]" : "");
 	if (sinfo[NL80211_SURVEY_INFO_NOISE])
 		printf("\tnoise:\t\t%d dBm\n",
 			(int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_NOISE]));

