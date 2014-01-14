Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38516 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaANRaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:30:35 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so370156eek.16
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:30:34 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC] iw: handle DFS CAC time param
Date: Tue, 14 Jan 2014 18:30:24 +0100
Message-Id: <1389720624-2497-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_183041_189184_E21FA9D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle DFS CAC time param for
iw list/info, iw reg get

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 info.c |    3 +++
 reg.c  |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/info.c b/info.c
index b2eef15..021b634 100644
--- a/info.c
+++ b/info.c
@@ -199,6 +199,9 @@ next:
 							printf(" (for %lu sec)", time/1000);
 						}
 						printf("\n");
+						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME])
+							printf("\t\t\t  DFS CAC time: %d sec\n",
+							       nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME]));
 					}
 
 				}
diff --git a/reg.c b/reg.c
index f2481fe..4937a66 100644
--- a/reg.c
+++ b/reg.c
@@ -134,6 +134,7 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 		[NL80211_ATTR_FREQ_RANGE_MAX_BW]	= { .type = NLA_U32 },
 		[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]	= { .type = NLA_U32 },
 		[NL80211_ATTR_POWER_RULE_MAX_EIRP]	= { .type = NLA_U32 },
+		[NL80211_ATTR_DFS_CAC_TIME]		= { .type = NLA_U32 },
 	};
 
 	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
@@ -181,6 +182,11 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 
 		printf(", %d)", MBM_TO_DBM(max_eirp_mbm));
 
+		if ((flags & NL80211_RRF_DFS) && tb_rule[NL80211_ATTR_DFS_CAC_TIME])
+			printf(", (%u sec)", nla_get_u32(tb_rule[NL80211_ATTR_DFS_CAC_TIME]));
+		else
+			printf(", (N/A)");
+
 		if (!flags) {
 			printf("\n");
 			continue;
-- 
1.7.9.5

