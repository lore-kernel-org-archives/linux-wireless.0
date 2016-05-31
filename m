Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32911 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbcEaQ2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 12:28:30 -0400
Received: by mail-lf0-f67.google.com with SMTP id w16so15538960lfd.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 09:28:29 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 iw] add "channels" PHY command listing frequencies with more details
Date: Tue, 31 May 2016 18:28:20 +0200
Message-Id: <1464712100-4489-1-git-send-email-zajec5@gmail.com> (sfid-20160531_182846_684993_0820A10C)
In-Reply-To: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channels (frequencies) are getting more details that users may want to
know about. E.g. it's important to know which frequencies allow using
40/80/160 MHz channels to setup AP properly.

We list channels in "info" command output but it's already quite big and
it was agreed to introduce new command rather than expand the old one.

This patch adds "channels" command printing what was already available
in the "info" plus details about supported channel widths. It also
removes DFS info from the "info" output.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Make width_40, width_80 & width_160 variables static. This is needed
    to keep their values across separated handler calls.
---
 info.c |  30 --------------
 phy.c  | 143 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 30 deletions(-)

diff --git a/info.c b/info.c
index 32de0af..b375123 100644
--- a/info.c
+++ b/info.c
@@ -47,20 +47,6 @@ static char *cipher_name(__u32 c)
 	}
 }
 
-static char *dfs_state_name(enum nl80211_dfs_state state)
-{
-	switch (state) {
-	case NL80211_DFS_USABLE:
-		return "usable";
-	case NL80211_DFS_AVAILABLE:
-		return "available";
-	case NL80211_DFS_UNAVAILABLE:
-		return "unavailable";
-	default:
-		return "unknown";
-	}
-}
-
 static int ext_feature_isset(const unsigned char *ext_features, int ext_features_len,
 			     enum nl80211_ext_feature_index ftidx)
 {
@@ -198,22 +184,6 @@ next:
 					if (open)
 						printf(")");
 					printf("\n");
-
-					if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED] && tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]) {
-						enum nl80211_dfs_state state = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]);
-						unsigned long time;
-
-						printf("\t\t\t  DFS state: %s", dfs_state_name(state));
-						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]) {
-							time = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]);
-							printf(" (for %lu sec)", time/1000);
-						}
-						printf("\n");
-						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME])
-							printf("\t\t\t  DFS CAC time: %u ms\n",
-							       nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME]));
-					}
-
 				}
 			}
 
diff --git a/phy.c b/phy.c
index 13e8260..7e7abb5 100644
--- a/phy.c
+++ b/phy.c
@@ -14,6 +14,149 @@
 #include "nl80211.h"
 #include "iw.h"
 
+static char *dfs_state_name(enum nl80211_dfs_state state)
+{
+	switch (state) {
+	case NL80211_DFS_USABLE:
+		return "usable";
+	case NL80211_DFS_AVAILABLE:
+		return "available";
+	case NL80211_DFS_UNAVAILABLE:
+		return "unavailable";
+	default:
+		return "unknown";
+	}
+}
+
+static int print_channels_handler(struct nl_msg *msg, void *arg)
+{
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+
+	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
+	struct nlattr *tb_band[NL80211_BAND_ATTR_MAX + 1];
+	struct nlattr *tb_freq[NL80211_FREQUENCY_ATTR_MAX + 1];
+	struct nlattr *nl_band;
+	struct nlattr *nl_freq;
+	int rem_band, rem_freq;
+	static int last_band = -1;
+	static bool width_40, width_80, width_160;
+
+	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0), genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (tb_msg[NL80211_ATTR_WIPHY_BANDS]) {
+		nla_for_each_nested(nl_band, tb_msg[NL80211_ATTR_WIPHY_BANDS], rem_band) {
+			if (last_band != nl_band->nla_type) {
+				printf("Band %d:\n", nl_band->nla_type + 1);
+				width_40 = false;
+				width_80 = false;
+				width_160 = false;
+				last_band = nl_band->nla_type;
+			}
+
+			nla_parse(tb_band, NL80211_BAND_ATTR_MAX, nla_data(nl_band), nla_len(nl_band), NULL);
+
+			if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
+				__u16 cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
+
+				if (cap & BIT(1))
+					width_40 = true;
+			}
+
+			if (tb_band[NL80211_BAND_ATTR_VHT_CAPA]) {
+				__u32 capa;
+
+				width_80 = true;
+
+				capa = nla_get_u32(tb_band[NL80211_BAND_ATTR_VHT_CAPA]);
+				switch ((capa >> 2) & 3) {
+				case 2:
+					/* width_80p80 = true; */
+					/* fall through */
+				case 1:
+					width_160 = true;
+				break;
+				}
+			}
+
+			if (tb_band[NL80211_BAND_ATTR_FREQS]) {
+				nla_for_each_nested(nl_freq, tb_band[NL80211_BAND_ATTR_FREQS], rem_freq) {
+					uint32_t freq;
+
+					nla_parse(tb_freq, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_freq), nla_len(nl_freq), NULL);
+
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_FREQ])
+						continue;
+					freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
+					printf("\t* %d MHz [%d] ", freq, ieee80211_frequency_to_channel(freq));
+
+					if (tb_freq[NL80211_FREQUENCY_ATTR_DISABLED]) {
+						printf("(disabled)\n");
+						continue;
+					}
+					printf("\n");
+
+					if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER])
+						printf("\t  Maximum TX power: %.1f dBm\n", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]));
+
+					/* If both flags are set assume an new kernel */
+					if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IR] && tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS]) {
+						printf("\t  No IR\n");
+					} else if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN]) {
+						printf("\t  Passive scan\n");
+					} else if (tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS]){
+						printf("\t  No IBSS\n");
+					}
+
+					if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR])
+						printf("\t  Radar detection\n");
+
+					printf("\t  Channel widths:");
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_20MHZ])
+						printf(" 20MHz");
+					if (width_40 && !tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40_MINUS])
+						printf(" HT40-");
+					if (width_40 && !tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40_PLUS])
+						printf(" HT40+");
+					if (width_80 && !tb_freq[NL80211_FREQUENCY_ATTR_NO_80MHZ])
+						printf(" VHT80");
+					if (width_160 && !tb_freq[NL80211_FREQUENCY_ATTR_NO_160MHZ])
+						printf(" VHT160");
+					printf("\n");
+
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED] && tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]) {
+						enum nl80211_dfs_state state = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]);
+						unsigned long time;
+
+						printf("\t  DFS state: %s", dfs_state_name(state));
+						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]) {
+							time = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]);
+							printf(" (for %lu sec)", time / 1000);
+						}
+						printf("\n");
+						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME])
+							printf("\t  DFS CAC time: %u ms\n",
+							       nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_CAC_TIME]));
+					}
+				}
+			}
+		}
+	}
+
+	return NL_SKIP;
+}
+
+static int handle_channels(struct nl80211_state *state, struct nl_msg *msg,
+			   int argc, char **argv, enum id_input id)
+{
+	nla_put_flag(msg, NL80211_ATTR_SPLIT_WIPHY_DUMP);
+	nlmsg_hdr(msg)->nlmsg_flags |= NLM_F_DUMP;
+
+	register_handler(print_channels_handler, NULL);
+
+	return 0;
+}
+TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_PHY, handle_channels, "Show available channels.");
+
 static int handle_name(struct nl80211_state *state,
 		       struct nl_msg *msg,
 		       int argc, char **argv,
-- 
1.8.4.5

