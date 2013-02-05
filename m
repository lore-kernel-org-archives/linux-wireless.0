Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42178 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3BEPmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 10:42:08 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] iw: prefer 64-bit byte counters for sta_info
Date: Tue, 5 Feb 2013 17:41:44 +0200
Message-ID: <1360078904-13056-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130205_164224_446271_86AFEA6E)
In-Reply-To: <1360078904-13056-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1360078904-13056-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 link.c    |   14 ++++++++++++--
 station.c |   12 ++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/link.c b/link.c
index 3470c4d..3a6b15a 100644
--- a/link.c
+++ b/link.c
@@ -121,6 +121,8 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_RX_BYTES] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_BYTES] = { .type = NLA_U32 },
+		[NL80211_STA_INFO_RX_BYTES64] = { .type = NLA_U64 },
+		[NL80211_STA_INFO_TX_BYTES64] = { .type = NLA_U64 },
 		[NL80211_STA_INFO_RX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
@@ -159,11 +161,19 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 		return NL_SKIP;
 	}
 
-	if (sinfo[NL80211_STA_INFO_RX_BYTES] && sinfo[NL80211_STA_INFO_RX_PACKETS])
+	if (sinfo[NL80211_STA_INFO_RX_BYTES64] && sinfo[NL80211_STA_INFO_RX_PACKETS])
+		printf("\tRX: %llu bytes (%u packets)\n",
+			(unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_RX_BYTES64]),
+			nla_get_u32(sinfo[NL80211_STA_INFO_RX_PACKETS]));
+	else if (sinfo[NL80211_STA_INFO_RX_BYTES] && sinfo[NL80211_STA_INFO_RX_PACKETS])
 		printf("\tRX: %u bytes (%u packets)\n",
 			nla_get_u32(sinfo[NL80211_STA_INFO_RX_BYTES]),
 			nla_get_u32(sinfo[NL80211_STA_INFO_RX_PACKETS]));
-	if (sinfo[NL80211_STA_INFO_TX_BYTES] && sinfo[NL80211_STA_INFO_TX_PACKETS])
+	if (sinfo[NL80211_STA_INFO_TX_BYTES64] && sinfo[NL80211_STA_INFO_TX_PACKETS])
+		printf("\tTX: %llu bytes (%u packets)\n",
+			(unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_TX_BYTES64]),
+			nla_get_u32(sinfo[NL80211_STA_INFO_TX_PACKETS]));
+	else if (sinfo[NL80211_STA_INFO_TX_BYTES] && sinfo[NL80211_STA_INFO_TX_PACKETS])
 		printf("\tTX: %u bytes (%u packets)\n",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_BYTES]),
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_PACKETS]));
diff --git a/station.c b/station.c
index 247f445..5b132d9 100644
--- a/station.c
+++ b/station.c
@@ -42,6 +42,8 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_RX_BYTES] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_BYTES] = { .type = NLA_U32 },
+		[NL80211_STA_INFO_RX_BYTES64] = { .type = NLA_U64 },
+		[NL80211_STA_INFO_TX_BYTES64] = { .type = NLA_U64 },
 		[NL80211_STA_INFO_RX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
@@ -91,13 +93,19 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_INACTIVE_TIME])
 		printf("\n\tinactive time:\t%u ms",
 			nla_get_u32(sinfo[NL80211_STA_INFO_INACTIVE_TIME]));
-	if (sinfo[NL80211_STA_INFO_RX_BYTES])
+	if (sinfo[NL80211_STA_INFO_RX_BYTES64])
+		printf("\n\trx bytes:\t%llu", (unsigned long long)
+			nla_get_u64(sinfo[NL80211_STA_INFO_RX_BYTES64]));
+	else if (sinfo[NL80211_STA_INFO_RX_BYTES])
 		printf("\n\trx bytes:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_RX_BYTES]));
 	if (sinfo[NL80211_STA_INFO_RX_PACKETS])
 		printf("\n\trx packets:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_RX_PACKETS]));
-	if (sinfo[NL80211_STA_INFO_TX_BYTES])
+	if (sinfo[NL80211_STA_INFO_TX_BYTES64])
+		printf("\n\ttx bytes:\t%llu", (unsigned long long)
+			nla_get_u64(sinfo[NL80211_STA_INFO_TX_BYTES64]));
+	else if (sinfo[NL80211_STA_INFO_TX_BYTES])
 		printf("\n\ttx bytes:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_BYTES]));
 	if (sinfo[NL80211_STA_INFO_TX_PACKETS])
-- 
1.7.10.4

