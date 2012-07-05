Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26137 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2GELgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:36:38 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1 2/4] Prefer 32-bit bitrate
Date: Thu, 5 Jul 2012 14:36:19 +0300
Message-ID: <1341488181-12542-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120705_133725_986845_49A937BB)
In-Reply-To: <1341488181-12542-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341488181-12542-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If 32-bit bitrate reported, use it. Otherwise, use 16-bit one.

    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 link.c    |   10 +++++++---
 station.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/link.c b/link.c
index 11ee0aa..eb27de2 100644
--- a/link.c
+++ b/link.c
@@ -131,6 +131,7 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 
 	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] = {
 		[NL80211_RATE_INFO_BITRATE] = { .type = NLA_U16 },
+		[NL80211_RATE_INFO_BITRATE32] = { .type = NLA_U32 },
 		[NL80211_RATE_INFO_MCS] = { .type = NLA_U8 },
 		[NL80211_RATE_INFO_40_MHZ_WIDTH] = { .type = NLA_FLAG },
 		[NL80211_RATE_INFO_SHORT_GI] = { .type = NLA_FLAG },
@@ -174,11 +175,14 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 				     sinfo[NL80211_STA_INFO_TX_BITRATE], rate_policy)) {
 			fprintf(stderr, "failed to parse nested rate attributes!\n");
 		} else {
+			int rate = 0;
 			printf("\ttx bitrate: ");
-			if (rinfo[NL80211_RATE_INFO_BITRATE]) {
-				int rate = nla_get_u16(rinfo[NL80211_RATE_INFO_BITRATE]);
+			if (rinfo[NL80211_RATE_INFO_BITRATE32])
+				rate = nla_get_u32(rinfo[NL80211_RATE_INFO_BITRATE32]);
+			else if (rinfo[NL80211_RATE_INFO_BITRATE])
+				rate = nla_get_u16(rinfo[NL80211_RATE_INFO_BITRATE]);
+			if (rate > 0)
 				printf("%d.%d MBit/s", rate / 10, rate % 10);
-			}
 
 			if (rinfo[NL80211_RATE_INFO_MCS])
 				printf(" MCS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_MCS]));
diff --git a/station.c b/station.c
index ac73e48..45e84ad 100644
--- a/station.c
+++ b/station.c
@@ -58,6 +58,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 
 	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] = {
 		[NL80211_RATE_INFO_BITRATE] = { .type = NLA_U16 },
+		[NL80211_RATE_INFO_BITRATE32] = { .type = NLA_U32 },
 		[NL80211_RATE_INFO_MCS] = { .type = NLA_U8 },
 		[NL80211_RATE_INFO_40_MHZ_WIDTH] = { .type = NLA_FLAG },
 		[NL80211_RATE_INFO_SHORT_GI] = { .type = NLA_FLAG },
@@ -123,11 +124,14 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 				     sinfo[NL80211_STA_INFO_TX_BITRATE], rate_policy)) {
 			fprintf(stderr, "failed to parse nested rate attributes!\n");
 		} else {
+			int rate = 0;
 			printf("\n\ttx bitrate:\t");
-			if (rinfo[NL80211_RATE_INFO_BITRATE]) {
-				int rate = nla_get_u16(rinfo[NL80211_RATE_INFO_BITRATE]);
+			if (rinfo[NL80211_RATE_INFO_BITRATE32])
+				rate = nla_get_u32(rinfo[NL80211_RATE_INFO_BITRATE32]);
+			else if (rinfo[NL80211_RATE_INFO_BITRATE])
+				rate = nla_get_u16(rinfo[NL80211_RATE_INFO_BITRATE]);
+			if (rate > 0)
 				printf("%d.%d MBit/s", rate / 10, rate % 10);
-			}
 
 			if (rinfo[NL80211_RATE_INFO_MCS])
 				printf(" MCS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_MCS]));
-- 
1.7.9.5

