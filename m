Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:39471 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752600AbeC3Upx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 16:45:53 -0400
Received: by mail-lf0-f66.google.com with SMTP id p142-v6so13844857lfd.6
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2018 13:45:52 -0700 (PDT)
From: Dmitry Lebed <lebed.dmitry@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH 2/2] iw: add printout of all supported ext_features to phy info
Date: Fri, 30 Mar 2018 23:45:09 +0300
Message-Id: <20180330204509.4395-2-lebed.dmitry@gmail.com> (sfid-20180330_224558_262425_DE9A3781)
In-Reply-To: <20180330204509.4395-1-lebed.dmitry@gmail.com>
References: <20180330204509.4395-1-lebed.dmitry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dmitry Lebed <lebed.dmitry@gmail.com>
---
 info.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 6 deletions(-)

diff --git a/info.c b/info.c
index 1eba5c9..be68571 100644
--- a/info.c
+++ b/info.c
@@ -69,6 +69,14 @@ static int ext_feature_isset(const unsigned char *ext_features, int ext_features
 	return (ft_byte & BIT(ftidx % 8)) != 0;
 }
 
+static void ext_feat_print(const struct nlattr *tb,
+			   enum nl80211_ext_feature_index idx,
+			   const char *feature_name, const char *feature_desc)
+{
+	if (ext_feature_isset(nla_data(tb), nla_len(tb),idx))
+		printf("\t\t* [ %s ]: %s\n", feature_name, feature_desc);
+}
+
 static int print_phy_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
@@ -603,17 +611,83 @@ broken_combination:
 			printf("\tDevice supports TDLS channel switching\n");
 	}
 
+	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
+		printf("\tDevice supports T-DLS.\n");
+
 	if (tb_msg[NL80211_ATTR_EXT_FEATURES]) {
 		struct nlattr *tb = tb_msg[NL80211_ATTR_EXT_FEATURES];
 
-		if (ext_feature_isset(nla_data(tb), nla_len(tb),
-				      NL80211_EXT_FEATURE_VHT_IBSS))
-			printf("\tDevice supports VHT-IBSS.\n");
+		printf("\tSupported extended features:\n");
+
+		ext_feat_print(tb, NL80211_EXT_FEATURE_VHT_IBSS,
+			       "VHT_IBSS", "VHT-IBSS");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_RRM,
+			       "RRM", "RRM");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER,
+			       "MU_MIMO_AIR_SNIFFER", "MU-MIMO sniffer");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_SCAN_START_TIME,
+			       "SCAN_START_TIME", "scan start timestamp");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_BSS_PARENT_TSF,
+			       "BSS_PARENT_TSF", "BSS last beacon/probe TSF");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_SET_SCAN_DWELL,
+			       "SET_SCAN_DWELL", "scan dwell setting");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_BEACON_RATE_LEGACY,
+			       "BEACON_RATE_LEGACY", "legacy beacon rate setting");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_BEACON_RATE_HT,
+			       "BEACON_RATE_HT", "HT beacon rate setting");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_BEACON_RATE_VHT,
+			       "BEACON_RATE_VHT", "VHT beacon rate setting");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_FILS_STA,
+			       "FILS_STA", "STA FILS (Fast Initial Link Setup)");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA,
+			       "MGMT_TX_RANDOM_TA",
+			       "randomized TA while not associated");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
+			       "MGMT_TX_RANDOM_TA_CONNECTED",
+			       "randomized TA while associated");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
+			       "SCHED_SCAN_RELATIVE_RSSI",
+			       "sched_scan for BSS with better RSSI report");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_CQM_RSSI_LIST,
+			       "CQM_RSSI_LIST",
+			       "multiple CQM_RSSI_THOLD records");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_FILS_SK_OFFLOAD,
+			       "FILS_SK_OFFLOAD",
+			       "FILS shared key authentication offload");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK,
+			       "4WAY_HANDSHAKE_STA_PSK",
+			       "4-way handshake with PSK in station mode");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X,
+			       "4WAY_HANDSHAKE_STA_1X",
+			       "4-way handshake with 802.1X in station mode");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_FILS_MAX_CHANNEL_TIME,
+			       "FILS_MAX_CHANNEL_TIME",
+			       "FILS max channel attribute override with dwell time");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_ACCEPT_BCAST_PROBE_RESP,
+			       "ACCEPT_BCAST_PROBE_RESP",
+			       "accepts broadcast probe response");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE,
+			       "OCE_PROBE_REQ_HIGH_TX_RATE",
+			       "probe request TX at high rate (at least 5.5Mbps)");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
+			       "OCE_PROBE_REQ_DEFERRAL_SUPPRESSION",
+			       "probe request tx deferral and suppression");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_MFP_OPTIONAL,
+			       "MFP_OPTIONAL",
+			       "MFP_OPTIONAL value in ATTR_USE_MFP");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
+			       "LOW_SPAN_SCAN", "low span scan");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_LOW_POWER_SCAN,
+			       "LOW_POWER_SCAN", "low power scan");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
+			       "HIGH_ACCURACY_SCAN", "high accuracy scan");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_DFS_OFFLOAD,
+			       "DFS_OFFLOAD", "DFS offload");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
+			       "CONTROL_PORT_OVER_NL80211",
+			       "control port over nl80211");
 	}
 
-	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
-		printf("\tDevice supports T-DLS.\n");
-
 	if (tb_msg[NL80211_ATTR_COALESCE_RULE]) {
 		struct nl80211_coalesce_rule_support *rule;
 		struct nl80211_pattern_support *pat;
-- 
2.16.3
