Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYE2IhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/43] iwlwifi: add RTC data address for iwl5000
Date: Thu, 29 May 2008 16:34:47 +0800
Message-Id: <1212050128-17132-3-git-send-email-yi.zhu@intel.com> (sfid-20080529_103715_746077_0E57EB00)
In-Reply-To: <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fills the valid_rtc_data_addr handler in iwl5000.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 520c7ea..d6ffdee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -768,6 +768,12 @@ static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 {
 }
 
+static int iwl5000_hw_valid_rtc_data_addr(u32 addr)
+{
+	return (addr >= RTC_DATA_LOWER_BOUND) &&
+		(addr < IWL50_RTC_DATA_UPPER_BOUND);
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -788,6 +794,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.disable_tx_fifo = iwl5000_disable_tx_fifo,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
+	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
-- 
1.5.3.6

