Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.zhaw.ch ([160.85.104.50]:41689 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0ETIiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 04:38:13 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: linville@tuxdriver.com, ilw@linux.intel.com,
	reinette.chatre@intel.com, yi.zhu@intel.com,
	luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 07/11] drivers/net/wireless: Storage class should be before const qualifier
Date: Thu, 20 May 2010 10:38:11 +0200
Message-Id: <1274344691-9095-1-git-send-email-tklauser@distanz.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/iwlwifi/iwl-core.c   |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5a7eca8..5df3f88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2544,7 +2544,7 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 EXPORT_SYMBOL(iwl_update_stats);
 #endif
 
-const static char *get_csr_string(int cmd)
+static const char *get_csr_string(int cmd)
 {
 	switch (cmd) {
 		IWL_CMD(CSR_HW_IF_CONFIG_REG);
@@ -2615,7 +2615,7 @@ void iwl_dump_csr(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_dump_csr);
 
-const static char *get_fh_string(int cmd)
+static const char *get_fh_string(int cmd)
 {
 	switch (cmd) {
 		IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b7d9137..b7a78e2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1991,7 +1991,7 @@ static struct ieee80211_channel wl1271_channels[] = {
 };
 
 /* mapping to indexes for wl1271_rates */
-const static u8 wl1271_rate_to_idx_2ghz[] = {
+static const u8 wl1271_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
 	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
 	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
@@ -2103,7 +2103,7 @@ static struct ieee80211_channel wl1271_channels_5ghz[] = {
 };
 
 /* mapping to indexes for wl1271_rates_5ghz */
-const static u8 wl1271_rate_to_idx_5ghz[] = {
+static const u8 wl1271_rate_to_idx_5ghz[] = {
 	/* MCS rates are used only with 11n */
 	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
 	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
@@ -2139,7 +2139,7 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
 };
 
-const static u8 *wl1271_band_rate_to_idx[] = {
+static const u8 *wl1271_band_rate_to_idx[] = {
 	[IEEE80211_BAND_2GHZ] = wl1271_rate_to_idx_2ghz,
 	[IEEE80211_BAND_5GHZ] = wl1271_rate_to_idx_5ghz
 };
-- 
1.6.3.3

