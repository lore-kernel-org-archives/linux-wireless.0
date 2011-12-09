Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1LIBZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/15] iwlwifi: remove reference to legacy devices
Date: Thu,  8 Dec 2011 16:26:12 -0800
Message-Id: <1323390382-1678-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022532_330551_623A1A9A)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to reference to legacy devices, remove comments

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6f6a647..be26145 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -60,11 +60,10 @@ struct iwl_tx_queue;
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
- *   1)  Not associated (4965, no beacon statistics being sent to driver)
+ *   1)  Not associated  no beacon statistics being sent to driver)
  *   2)  Scanning (noise measurement does not apply to associated channel)
- *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
  * Use default noise value of -127 ... this is below the range of measurable
- *   Rx dBm for either 3945 or 4965, so it can indicate "unmeasurable" to user.
+ *   Rx dBm for all agn devices, so it can indicate "unmeasurable" to user.
  *   Also, -127 works better than 0 when averaging frames with/without
  *   noise info (e.g. averaging might be done in app); measured dBm values are
  *   always negative ... using a negative value as the default keeps all
-- 
1.7.0.4

