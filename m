Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaFPQiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:16 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 03/25] wil6210: print debug info when starting AP
Date: Mon, 16 Jun 2014 19:37:01 +0300
Message-ID: <1402936643-31819-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183825_134481_B619C26F)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the wil_cfg80211_start_ap(), debug print selected data:
- beacon (before and after fix-up)
- crypto parameters
- mark start/stop AP invocation

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 43 ++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index cfdf1a2..a3042cd 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -566,6 +566,34 @@ static int wil_cancel_remain_on_channel(struct wiphy *wiphy,
 	return rc;
 }
 
+static void wil_print_bcon_data(struct cfg80211_beacon_data *b)
+{
+	print_hex_dump_bytes("head     ", DUMP_PREFIX_OFFSET,
+			     b->head, b->head_len);
+	print_hex_dump_bytes("tail     ", DUMP_PREFIX_OFFSET,
+			     b->tail, b->tail_len);
+	print_hex_dump_bytes("BCON IE  ", DUMP_PREFIX_OFFSET,
+			     b->beacon_ies, b->beacon_ies_len);
+	print_hex_dump_bytes("PROBE    ", DUMP_PREFIX_OFFSET,
+			     b->probe_resp, b->probe_resp_len);
+	print_hex_dump_bytes("PROBE IE ", DUMP_PREFIX_OFFSET,
+			     b->proberesp_ies, b->proberesp_ies_len);
+	print_hex_dump_bytes("ASSOC IE ", DUMP_PREFIX_OFFSET,
+			     b->assocresp_ies, b->assocresp_ies_len);
+}
+
+static void wil_print_crypto(struct wil6210_priv *wil,
+			     struct cfg80211_crypto_settings *c)
+{
+	wil_dbg_misc(wil, "WPA versions: 0x%08x cipher group 0x%08x\n",
+		     c->wpa_versions, c->cipher_group);
+	wil_dbg_misc(wil, "Pairwise ciphers [%d]\n", c->n_ciphers_pairwise);
+	wil_dbg_misc(wil, "AKM suites [%d]\n", c->n_akm_suites);
+	wil_dbg_misc(wil, "Control port : %d, eth_type 0x%04x no_encrypt %d\n",
+		     c->control_port, be16_to_cpu(c->control_port_ethertype),
+		     c->control_port_no_encrypt);
+}
+
 static int wil_fix_bcon(struct wil6210_priv *wil,
 			struct cfg80211_beacon_data *bcon)
 {
@@ -599,8 +627,11 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	struct ieee80211_channel *channel = info->chandef.chan;
 	struct cfg80211_beacon_data *bcon = &info->beacon;
+	struct cfg80211_crypto_settings *crypto = &info->crypto;
 	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	if (!channel) {
 		wil_err(wil, "AP: No channel???\n");
 		return -EINVAL;
@@ -608,11 +639,19 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "AP on Channel %d %d MHz, %s\n", channel->hw_value,
 		     channel->center_freq, info->privacy ? "secure" : "open");
+	wil_dbg_misc(wil, "Privacy: %d auth_type %d\n",
+		     info->privacy, info->auth_type);
+	wil_dbg_misc(wil, "BI %d DTIM %d\n", info->beacon_interval,
+		     info->dtim_period);
 	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
 			     info->ssid, info->ssid_len);
+	wil_print_bcon_data(bcon);
+	wil_print_crypto(wil, crypto);
 
-	if (wil_fix_bcon(wil, bcon))
+	if (wil_fix_bcon(wil, bcon)) {
 		wil_dbg_misc(wil, "Fixed bcon\n");
+		wil_print_bcon_data(bcon);
+	}
 
 	mutex_lock(&wil->mutex);
 
@@ -667,6 +706,8 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	int rc = 0;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	mutex_lock(&wil->mutex);
 
 	rc = wmi_pcp_stop(wil);
-- 
1.9.1

