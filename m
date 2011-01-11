Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:45204 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754841Ab1AKAuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:50:14 -0500
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0688387007
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 09:50:12 +0900 (JST)
Subject: [PATCH v2 1/4] iw: survey: Mark frequency in use
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Tue, 11 Jan 2011 09:51:07 +0900
Message-ID: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

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

