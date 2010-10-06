Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:21474 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758561Ab0JFDak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 23:30:40 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0644215837
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 12:30:38 +0900 (JST)
Subject: [PATCH] iw: add survey busy ratios
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Oct 2010 12:30:39 +0900
Message-ID: <20101006033039.17342.55809.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print survey busy information, if present.

This does not include the neccessay update to nl80211.h.

Signed-off-by: Bruno Randolf <br1@einfach.org>

--
the iw part of the survey series, in case it gets accepted :)
---
 survey.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/survey.c b/survey.c
index f9f2508..3257e9f 100644
--- a/survey.c
+++ b/survey.c
@@ -23,6 +23,9 @@ static int print_survey_handler(struct nl_msg *msg, void *arg)
 	static struct nla_policy survey_policy[NL80211_SURVEY_INFO_MAX + 1] = {
 		[NL80211_SURVEY_INFO_FREQUENCY] = { .type = NLA_U32 },
 		[NL80211_SURVEY_INFO_NOISE] = { .type = NLA_U8 },
+		[NL80211_SURVEY_INFO_BUSY] = { .type = NLA_U8 },
+		[NL80211_SURVEY_INFO_BUSY_TX] = { .type = NLA_U8 },
+		[NL80211_SURVEY_INFO_BUSY_RX] = { .type = NLA_U8 },
 	};
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
@@ -49,6 +52,18 @@ static int print_survey_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_SURVEY_INFO_NOISE])
 		printf("\tnoise:\t\t%d dBm\n",
 			(int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_NOISE]));
+	if (sinfo[NL80211_SURVEY_INFO_BUSY])
+		printf("\tbusy:\t\t%d%%\n",
+			((int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_BUSY])
+			* 100) / 255);
+	if (sinfo[NL80211_SURVEY_INFO_BUSY_RX])
+		printf("\tbusy rx:\t%d%%\n",
+			((int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_BUSY_RX])
+			* 100) / 255);
+	if (sinfo[NL80211_SURVEY_INFO_BUSY_TX])
+		printf("\tbusy tx:\t%d%%\n",
+			((int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_BUSY_TX])
+			* 100) / 255);
 	return NL_SKIP;
 }
 

