Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab1AaWId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:08:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH  wireless-2.6.38] iwlagn: overwrite EEPROM chain setting for 6250 devices
Date: Mon, 31 Jan 2011 13:56:03 -0800
Message-Id: <1296510963-11266-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

6250 2x2 devices have 2 tx chain and 2 rx chain. For some reason,
the EEPROM contain incorrect information and indicate it only has single
tx chain. overwrite it with .cfg parameter to make sure both chain 'A' and
chain 'B' can be used for transmit and receive

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index af505bc..ef36aff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -681,6 +681,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,				\
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
+	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.ops = &iwl6050_ops,					\
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
-- 
1.7.0.4

