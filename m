Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab3BNPeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 10:34:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: dennis.h.jensen@siemens.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] iw: support split wiphy dump
Date: Thu, 14 Feb 2013 16:34:09 +0100
Message-Id: <1360856049-2546-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_163418_636491_ECBFFDA6)
In-Reply-To: <1360855759-2377-1-git-send-email-johannes@sipsolutions.net>
References: <1360855759-2377-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds support for the new split wiphy dump,
it only uses it for "iw list", not for "info"
though, so far. Using it for "info" would mean
querying the kernel capability first and then
using get/dump (with filter) depending on that.
---
 info.c | 206 +++++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 131 insertions(+), 75 deletions(-)

diff --git a/info.c b/info.c
index 08dbfc0..5f0d535 100644
--- a/info.c
+++ b/info.c
@@ -78,92 +78,116 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *nl_mode;
 	struct nlattr *nl_cmd;
 	struct nlattr *nl_if, *nl_ftype;
-	int bandidx = 1;
 	int rem_band, rem_freq, rem_rate, rem_mode, rem_cmd, rem_ftype, rem_if;
 	int open;
+	/*
+	 * static variables only work here, other applications need to use the
+	 * callback pointer and store them there so they can be multithreaded
+	 * and/or have multiple netlink sockets, etc.
+	 */
+	static int64_t phy_id = -1;
+	static int last_band = -1;
+	static bool band_had_freq = false;
+	bool print_name = true;
 
 	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
 
-	if (!tb_msg[NL80211_ATTR_WIPHY_BANDS])
-		return NL_SKIP;
-
-	if (tb_msg[NL80211_ATTR_WIPHY_NAME])
+	if (tb_msg[NL80211_ATTR_WIPHY]) {
+		if (nla_get_u32(tb_msg[NL80211_ATTR_WIPHY]) == phy_id)
+			print_name = false;
+		else
+			last_band = -1;
+		phy_id = nla_get_u32(tb_msg[NL80211_ATTR_WIPHY]);
+	}
+	if (print_name && tb_msg[NL80211_ATTR_WIPHY_NAME])
 		printf("Wiphy %s\n", nla_get_string(tb_msg[NL80211_ATTR_WIPHY_NAME]));
 
-	nla_for_each_nested(nl_band, tb_msg[NL80211_ATTR_WIPHY_BANDS], rem_band) {
-		printf("\tBand %d:\n", bandidx);
-		bandidx++;
+	/* needed for split dump */
+	if (tb_msg[NL80211_ATTR_WIPHY_BANDS]) {
+		nla_for_each_nested(nl_band, tb_msg[NL80211_ATTR_WIPHY_BANDS], rem_band) {
+			if (last_band != nl_band->nla_type) {
+				printf("\tBand %d:\n", nl_band->nla_type + 1);
+				band_had_freq = false;
+			}
+			last_band = nl_band->nla_type;
 
-		nla_parse(tb_band, NL80211_BAND_ATTR_MAX, nla_data(nl_band),
-			  nla_len(nl_band), NULL);
+			nla_parse(tb_band, NL80211_BAND_ATTR_MAX, nla_data(nl_band),
+				  nla_len(nl_band), NULL);
 
-		if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
-			__u16 cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
-			print_ht_capability(cap);
-		}
-		if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]) {
-			__u8 exponent = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]);
-			print_ampdu_length(exponent);
-		}
-		if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]) {
-			__u8 spacing = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]);
-			print_ampdu_spacing(spacing);
-		}
-		if (tb_band[NL80211_BAND_ATTR_HT_MCS_SET] &&
-		    nla_len(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]) == 16)
-			print_ht_mcs(nla_data(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]));
-		if (tb_band[NL80211_BAND_ATTR_VHT_CAPA] &&
-		    tb_band[NL80211_BAND_ATTR_VHT_MCS_SET])
-			print_vht_info(nla_get_u32(tb_band[NL80211_BAND_ATTR_VHT_CAPA]),
-				       nla_data(tb_band[NL80211_BAND_ATTR_VHT_MCS_SET]));
-
-		printf("\t\tFrequencies:\n");
-
-		nla_for_each_nested(nl_freq, tb_band[NL80211_BAND_ATTR_FREQS], rem_freq) {
-			uint32_t freq;
-			nla_parse(tb_freq, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_freq),
-				  nla_len(nl_freq), freq_policy);
-			if (!tb_freq[NL80211_FREQUENCY_ATTR_FREQ])
-				continue;
-			freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
-			printf("\t\t\t* %d MHz [%d]", freq, ieee80211_frequency_to_channel(freq));
-
-			if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] &&
-			    !tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
-				printf(" (%.1f dBm)", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]));
-
-			open = 0;
-			if (tb_freq[NL80211_FREQUENCY_ATTR_DISABLED]) {
-				print_flag("disabled", &open);
-				goto next;
+			if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
+				__u16 cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
+				print_ht_capability(cap);
+			}
+			if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]) {
+				__u8 exponent = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]);
+				print_ampdu_length(exponent);
+			}
+			if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]) {
+				__u8 spacing = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]);
+				print_ampdu_spacing(spacing);
+			}
+			if (tb_band[NL80211_BAND_ATTR_HT_MCS_SET] &&
+			    nla_len(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]) == 16)
+				print_ht_mcs(nla_data(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]));
+			if (tb_band[NL80211_BAND_ATTR_VHT_CAPA] &&
+			    tb_band[NL80211_BAND_ATTR_VHT_MCS_SET])
+				print_vht_info(nla_get_u32(tb_band[NL80211_BAND_ATTR_VHT_CAPA]),
+					       nla_data(tb_band[NL80211_BAND_ATTR_VHT_MCS_SET]));
+
+			if (tb_band[NL80211_BAND_ATTR_FREQS]) {
+				if (!band_had_freq) {
+					printf("\t\tFrequencies:\n");
+					band_had_freq = true;
+				}
+				nla_for_each_nested(nl_freq, tb_band[NL80211_BAND_ATTR_FREQS], rem_freq) {
+					uint32_t freq;
+					nla_parse(tb_freq, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_freq),
+						  nla_len(nl_freq), freq_policy);
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_FREQ])
+						continue;
+					freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
+					printf("\t\t\t* %d MHz [%d]", freq, ieee80211_frequency_to_channel(freq));
+
+					if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] &&
+					    !tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
+						printf(" (%.1f dBm)", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]));
+
+					open = 0;
+					if (tb_freq[NL80211_FREQUENCY_ATTR_DISABLED]) {
+						print_flag("disabled", &open);
+						goto next;
+					}
+					if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN])
+						print_flag("passive scanning", &open);
+					if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IBSS])
+						print_flag("no IBSS", &open);
+					if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR])
+						print_flag("radar detection", &open);
+next:
+					if (open)
+						printf(")");
+					printf("\n");
+				}
 			}
-			if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN])
-				print_flag("passive scanning", &open);
-			if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IBSS])
-				print_flag("no IBSS", &open);
-			if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR])
-				print_flag("radar detection", &open);
- next:
-			if (open)
-				printf(")");
-			printf("\n");
-		}
 
-		printf("\t\tBitrates (non-HT):\n");
-
-		nla_for_each_nested(nl_rate, tb_band[NL80211_BAND_ATTR_RATES], rem_rate) {
-			nla_parse(tb_rate, NL80211_BITRATE_ATTR_MAX, nla_data(nl_rate),
-				  nla_len(nl_rate), rate_policy);
-			if (!tb_rate[NL80211_BITRATE_ATTR_RATE])
-				continue;
-			printf("\t\t\t* %2.1f Mbps", 0.1 * nla_get_u32(tb_rate[NL80211_BITRATE_ATTR_RATE]));
-			open = 0;
-			if (tb_rate[NL80211_BITRATE_ATTR_2GHZ_SHORTPREAMBLE])
-				print_flag("short preamble supported", &open);
-			if (open)
-				printf(")");
-			printf("\n");
+
+			if (tb_band[NL80211_BAND_ATTR_RATES]) {
+			printf("\t\tBitrates (non-HT):\n");
+			nla_for_each_nested(nl_rate, tb_band[NL80211_BAND_ATTR_RATES], rem_rate) {
+				nla_parse(tb_rate, NL80211_BITRATE_ATTR_MAX, nla_data(nl_rate),
+					  nla_len(nl_rate), rate_policy);
+				if (!tb_rate[NL80211_BITRATE_ATTR_RATE])
+					continue;
+				printf("\t\t\t* %2.1f Mbps", 0.1 * nla_get_u32(tb_rate[NL80211_BITRATE_ATTR_RATE]));
+				open = 0;
+				if (tb_rate[NL80211_BITRATE_ATTR_2GHZ_SHORTPREAMBLE])
+					print_flag("short preamble supported", &open);
+				if (open)
+					printf(")");
+				printf("\n");
+			}
+			}
 		}
 	}
 
@@ -464,10 +488,12 @@ static int handle_info(struct nl80211_state *state,
 		       enum id_input id)
 {
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_phy_handler, NULL);
+	/* kernels not supporting it will ignore this */
+	nla_put_flag(msg, NL80211_ATTR_SPLIT_WIPHY_DUMP);
 
 	return 0;
 }
-__COMMAND(NULL, info, "info", NULL, NL80211_CMD_GET_WIPHY, 0, 0, CIB_PHY, handle_info,
+__COMMAND(NULL, info, "info", NULL, NL80211_CMD_GET_WIPHY, NLM_F_DUMP, 0, CIB_PHY, handle_info,
 	 "Show capabilities for the specified wireless device.", NULL);
 TOPLEVEL(list, NULL, NL80211_CMD_GET_WIPHY, NLM_F_DUMP, CIB_NONE, handle_info,
 	 "List all wireless devices and their capabilities.");
@@ -485,3 +511,33 @@ static int handle_commands(struct nl80211_state *state,
 }
 TOPLEVEL(commands, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_NONE, handle_commands,
 	 "list all known commands and their decimal & hex value");
+
+static int print_feature_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+
+	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (tb_msg[NL80211_ATTR_PROTOCOL_FEATURES]) {
+		uint32_t feat = nla_get_u32(tb_msg[NL80211_ATTR_PROTOCOL_FEATURES]);
+
+		printf("nl80211 features: 0x%x\n", feat);
+		if (feat & NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP)
+			printf("\t* split wiphy dump\n");
+	}
+
+	return NL_SKIP;
+}
+
+static int handle_features(struct nl80211_state *state,
+			   struct nl_cb *cb, struct nl_msg *msg,
+			   int argc, char **argv, enum id_input id)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_feature_handler, NULL);
+	return 0;
+}
+
+TOPLEVEL(features, NULL, NL80211_CMD_GET_PROTOCOL_FEATURES, 0, CIB_NONE,
+	 handle_features, "");
-- 
1.8.0

