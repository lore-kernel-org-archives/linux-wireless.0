Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51967 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab3GKMUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 08:20:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/3] iw: dump station rx bit rate information
Date: Thu, 11 Jul 2013 14:20:37 +0200
Message-Id: <1373545239-78697-1-git-send-email-nbd@openwrt.org> (sfid-20130711_142046_255648_E10F7681)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 iw.h      |  2 +-
 link.c    |  2 +-
 station.c | 12 ++++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/iw.h b/iw.h
index 8816e88..854d356 100644
--- a/iw.h
+++ b/iw.h
@@ -170,7 +170,7 @@ enum print_ie_type {
 void print_ies(unsigned char *ie, int ielen, bool unknown,
 	       enum print_ie_type ptype);
 
-void parse_tx_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen);
+void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen);
 
 DECLARE_SECTION(set);
 DECLARE_SECTION(get);
diff --git a/link.c b/link.c
index b8acd5c..f7818f5 100644
--- a/link.c
+++ b/link.c
@@ -165,7 +165,7 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
 		char buf[100];
 
-		parse_tx_bitrate(sinfo[NL80211_STA_INFO_TX_BITRATE], buf, sizeof(buf));
+		parse_bitrate(sinfo[NL80211_STA_INFO_TX_BITRATE], buf, sizeof(buf));
 		printf("\ttx bitrate: %s\n", buf);
 	}
 
diff --git a/station.c b/station.c
index dde552f..5a161eb 100644
--- a/station.c
+++ b/station.c
@@ -43,7 +43,7 @@ static void print_power_mode(struct nlattr *a)
 	}
 }
 
-void parse_tx_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
+void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
 {
 	int rate = 0;
 	char *pos = buf;
@@ -107,6 +107,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
 		[NL80211_STA_INFO_T_OFFSET] = { .type = NLA_U64 },
 		[NL80211_STA_INFO_TX_BITRATE] = { .type = NLA_NESTED },
+		[NL80211_STA_INFO_RX_BITRATE] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLINK_STATE] = { .type = NLA_U8 },
@@ -177,10 +178,17 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
 		char buf[100];
 
-		parse_tx_bitrate(sinfo[NL80211_STA_INFO_TX_BITRATE], buf, sizeof(buf));
+		parse_bitrate(sinfo[NL80211_STA_INFO_TX_BITRATE], buf, sizeof(buf));
 		printf("\n\ttx bitrate:\t%s", buf);
 	}
 
+	if (sinfo[NL80211_STA_INFO_RX_BITRATE]) {
+		char buf[100];
+
+		parse_bitrate(sinfo[NL80211_STA_INFO_RX_BITRATE], buf, sizeof(buf));
+		printf("\n\trx bitrate:\t%s", buf);
+	}
+
 	if (sinfo[NL80211_STA_INFO_LLID])
 		printf("\n\tmesh llid:\t%d",
 			nla_get_u16(sinfo[NL80211_STA_INFO_LLID]));
-- 
1.8.0.2

