Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40447 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaBLSyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 13:54:45 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so4574432eek.13
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 10:54:44 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] iw: handle DFS CAC time param
Date: Wed, 12 Feb 2014 19:54:26 +0100
Message-Id: <1392231266-28479-7-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195456_637488_9B541A73)
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
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
index a696503..073f3a3 100644
--- a/info.c
+++ b/info.c
@@ -199,6 +199,9 @@ next:
 							printf(" (for %lu sec)", time/1000);
 						}
 						printf("\n");
+						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME])
+							printf("\t\t\t  DFS CAC time: %u ms\n",
+							       nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME]));
 					}
 
 				}
diff --git a/reg.c b/reg.c
index f2481fe..e1bb0d2 100644
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
+			printf(", (%u ms)", nla_get_u32(tb_rule[NL80211_ATTR_DFS_CAC_TIME]));
+		else
+			printf(", (N/A)");
+
 		if (!flags) {
 			printf("\n");
 			continue;
-- 
1.7.9.5

