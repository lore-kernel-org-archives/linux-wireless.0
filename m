Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:37249 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757288Ab0JFJft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:35:49 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0214927748
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 18:35:48 +0900 (JST)
Subject: [PATCH] iw: print station retry counters
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Oct 2010 18:35:50 +0900
Message-ID: <20101006093550.8943.22555.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 station.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/station.c b/station.c
index 8cf038d..7639553 100644
--- a/station.c
+++ b/station.c
@@ -48,6 +48,8 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLINK_STATE] = { .type = NLA_U8 },
+		[NL80211_STA_INFO_TX_RETRIES] = { .type = NLA_U32 },
+		[NL80211_STA_INFO_TX_FAILED] = { .type = NLA_U32 },
 	};
 
 	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] = {
@@ -96,6 +98,12 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_TX_PACKETS])
 		printf("\n\ttx packets:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_PACKETS]));
+	if (sinfo[NL80211_STA_INFO_TX_RETRIES])
+		printf("\n\ttx retries:\t%u",
+			nla_get_u32(sinfo[NL80211_STA_INFO_TX_RETRIES]));
+	if (sinfo[NL80211_STA_INFO_TX_FAILED])
+		printf("\n\ttx failed:\t%u",
+			nla_get_u32(sinfo[NL80211_STA_INFO_TX_FAILED]));
 	if (sinfo[NL80211_STA_INFO_SIGNAL])
 		printf("\n\tsignal:  \t%d dBm",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));

