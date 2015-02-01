Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25275 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbBAIzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 03:55:39 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 5/6] wil6210: print ciphers in debug info
Date: Sun,  1 Feb 2015 10:55:15 +0200
Message-Id: <1422780916-8577-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150201_095548_649854_1680AB64)
In-Reply-To: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print (at debug level) all cipher and AKM suites

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 37 +++++++++++++++++++----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e758f43..2d5ea21 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -334,6 +334,30 @@ out:
 	return rc;
 }
 
+static void wil_print_crypto(struct wil6210_priv *wil,
+			     struct cfg80211_crypto_settings *c)
+{
+	int i, n;
+
+	wil_dbg_misc(wil, "WPA versions: 0x%08x cipher group 0x%08x\n",
+		     c->wpa_versions, c->cipher_group);
+	wil_dbg_misc(wil, "Pairwise ciphers [%d] {\n", c->n_ciphers_pairwise);
+	n = min_t(int, c->n_ciphers_pairwise, ARRAY_SIZE(c->ciphers_pairwise));
+	for (i = 0; i < n; i++)
+		wil_dbg_misc(wil, "  [%d] = 0x%08x\n", i,
+			     c->ciphers_pairwise[i]);
+	wil_dbg_misc(wil, "}\n");
+	wil_dbg_misc(wil, "AKM suites [%d] {\n", c->n_akm_suites);
+	n = min_t(int, c->n_akm_suites, ARRAY_SIZE(c->akm_suites));
+	for (i = 0; i < n; i++)
+		wil_dbg_misc(wil, "  [%d] = 0x%08x\n", i,
+			     c->akm_suites[i]);
+	wil_dbg_misc(wil, "}\n");
+	wil_dbg_misc(wil, "Control port : %d, eth_type 0x%04x no_encrypt %d\n",
+		     c->control_port, be16_to_cpu(c->control_port_ethertype),
+		     c->control_port_no_encrypt);
+}
+
 static void wil_print_connect_params(struct wil6210_priv *wil,
 				     struct cfg80211_connect_params *sme)
 {
@@ -348,6 +372,7 @@ static void wil_print_connect_params(struct wil6210_priv *wil,
 		print_hex_dump(KERN_INFO, "  SSID: ", DUMP_PREFIX_OFFSET,
 			       16, 1, sme->ssid, sme->ssid_len, true);
 	wil_info(wil, "  Privacy: %s\n", sme->privacy ? "secure" : "open");
+	wil_print_crypto(wil, &sme->crypto);
 }
 
 static int wil_cfg80211_connect(struct wiphy *wiphy,
@@ -619,18 +644,6 @@ static void wil_print_bcon_data(struct cfg80211_beacon_data *b)
 			     b->assocresp_ies, b->assocresp_ies_len);
 }
 
-static void wil_print_crypto(struct wil6210_priv *wil,
-			     struct cfg80211_crypto_settings *c)
-{
-	wil_dbg_misc(wil, "WPA versions: 0x%08x cipher group 0x%08x\n",
-		     c->wpa_versions, c->cipher_group);
-	wil_dbg_misc(wil, "Pairwise ciphers [%d]\n", c->n_ciphers_pairwise);
-	wil_dbg_misc(wil, "AKM suites [%d]\n", c->n_akm_suites);
-	wil_dbg_misc(wil, "Control port : %d, eth_type 0x%04x no_encrypt %d\n",
-		     c->control_port, be16_to_cpu(c->control_port_ethertype),
-		     c->control_port_no_encrypt);
-}
-
 static int wil_fix_bcon(struct wil6210_priv *wil,
 			struct cfg80211_beacon_data *bcon)
 {
-- 
2.1.0

