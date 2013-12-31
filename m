Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43372 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3LaRQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:28 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so5633769eaj.4
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:27 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/28] iwlwifi: mvm: fix harmless smatch / coccinelle warnings
Date: Tue, 31 Dec 2013 19:15:47 +0200
Message-Id: <1388510157-23345-18-git-send-email-egrumbach@gmail.com> (sfid-20131231_183436_593280_55AD9791)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Don't check if mvm->fw->cs is NULL since it can't be.
cs is an array member of iwl_fw, it can't be NULL.

Use memset(ptr, 0, sizeof(*ptr)); instead of
memset(ptr, 0, sizeof(struct ptr_type));

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b61d5a2..e9eff30 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -262,7 +262,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 	/* currently FW API supports only one optional cipher scheme */
-	if (mvm->fw->cs && mvm->fw->cs->cipher) {
+	if (mvm->fw->cs->cipher) {
 		mvm->hw->n_cipher_schemes = 1;
 		mvm->hw->cipher_schemes = mvm->fw->cs;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index d6d28d7..269fa0a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -700,7 +700,7 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 	u8 num_of_ant = get_num_of_ant_from_rate(ucode_rate);
 	u8 nss;
 
-	memset(rate, 0, sizeof(struct rs_rate));
+	memset(rate, 0, sizeof(*rate));
 	rate->index = iwl_hwrate_to_plcp_idx(ucode_rate);
 
 	if (rate->index == IWL_RATE_INVALID) {
@@ -2446,7 +2446,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
 	bool toggle_ant = false;
 
-	memcpy(&rate, initial_rate, sizeof(struct rs_rate));
+	memcpy(&rate, initial_rate, sizeof(rate));
 
 	if (mvm)
 		valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
-- 
1.7.9.5

