Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51971 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab3GKMUq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 08:20:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/3] iw: dump station per-chain signal strength information
Date: Thu, 11 Jul 2013 14:20:38 +0200
Message-Id: <1373545239-78697-2-git-send-email-nbd@openwrt.org> (sfid-20130711_142049_462640_0FA5041A)
In-Reply-To: <1373545239-78697-1-git-send-email-nbd@openwrt.org>
References: <1373545239-78697-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 station.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/station.c b/station.c
index 5a161eb..07acdbc 100644
--- a/station.c
+++ b/station.c
@@ -91,6 +91,33 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
 				" VHT-NSS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_VHT_NSS]));
 }
 
+static char *get_chain_signal(struct nlattr *attr_list)
+{
+	struct nlattr *attr;
+	static char buf[64];
+	char *cur = buf;
+	int i = 0, rem;
+	const char *prefix;
+
+	if (!attr_list)
+		return "";
+
+	nla_for_each_nested(attr, attr_list, rem) {
+		if (i++ > 0)
+			prefix = ", ";
+		else
+			prefix = "[";
+
+		cur += snprintf(cur, sizeof(buf) - (cur - buf), "%s%d", prefix,
+				(int8_t) nla_get_u8(attr));
+	}
+
+	if (i)
+		snprintf(cur, sizeof(buf) - (cur - buf), "] ");
+
+	return buf;
+}
+
 static int print_sta_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
@@ -118,7 +145,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_LOCAL_PM] = { .type = NLA_U32},
 		[NL80211_STA_INFO_PEER_PM] = { .type = NLA_U32},
 		[NL80211_STA_INFO_NONPEER_PM] = { .type = NLA_U32},
+		[NL80211_STA_INFO_CHAIN_SIGNAL] = { .type = NLA_NESTED },
+		[NL80211_STA_INFO_CHAIN_SIGNAL_AVG] = { .type = NLA_NESTED },
 	};
+	char *chain;
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -165,12 +195,19 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_TX_FAILED])
 		printf("\n\ttx failed:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_FAILED]));
+
+	chain = get_chain_signal(sinfo[NL80211_STA_INFO_CHAIN_SIGNAL]);
 	if (sinfo[NL80211_STA_INFO_SIGNAL])
-		printf("\n\tsignal:  \t%d dBm",
-			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
+		printf("\n\tsignal:  \t%d %sdBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]),
+			chain);
+
+	chain = get_chain_signal(sinfo[NL80211_STA_INFO_CHAIN_SIGNAL_AVG]);
 	if (sinfo[NL80211_STA_INFO_SIGNAL_AVG])
-		printf("\n\tsignal avg:\t%d dBm",
-			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL_AVG]));
+		printf("\n\tsignal avg:\t%d %sdBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL_AVG]),
+			chain);
+
 	if (sinfo[NL80211_STA_INFO_T_OFFSET])
 		printf("\n\tToffset:\t%lld us",
 			(unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_T_OFFSET]));
-- 
1.8.0.2

