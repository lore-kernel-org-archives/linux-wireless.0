Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43408 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2DRSBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 14:01:12 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so10201276dak.11
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 11:01:11 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH v2 2/2] iw: Show Toffset on station dump
Date: Wed, 18 Apr 2012 11:00:45 -0700
Message-Id: <1334772045-12802-2-git-send-email-ashok@cozybit.com> (sfid-20120418_200115_367372_C1535453)
In-Reply-To: <1334772045-12802-1-git-send-email-ashok@cozybit.com>
References: <1334772045-12802-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 v2:
 	Fix compiler warning (Johannes)
 station.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/station.c b/station.c
index ef69ea5..3c5fc38 100644
--- a/station.c
+++ b/station.c
@@ -45,6 +45,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_RX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
+		[NL80211_STA_INFO_T_OFFSET] = { .type = NLA_U64 },
 		[NL80211_STA_INFO_TX_BITRATE] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
@@ -113,6 +114,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_SIGNAL_AVG])
 		printf("\n\tsignal avg:\t%d dBm",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL_AVG]));
+	if (sinfo[NL80211_STA_INFO_T_OFFSET])
+		printf("\n\tToffset:\t%ld us",
+			(int64_t)nla_get_u64(sinfo[NL80211_STA_INFO_T_OFFSET]));
 
 	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
 		if (nla_parse_nested(rinfo, NL80211_RATE_INFO_MAX,
-- 
1.7.5.4

