Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab2B0XTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/24] iwlwifi: move eeprom defines to iwl-eeprom.c
Date: Mon, 27 Feb 2012 14:07:39 -0800
Message-Id: <1330380468-17674-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001912_807338_F2962113)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

They don't need to be in iwl-dev.h

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    3 ---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 479d328..a670c82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -443,9 +443,6 @@ struct iwl_chain_noise_data {
 	u8 state;
 };
 
-#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
-#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
-
 enum {
 	MEASUREMENT_READY = (1 << 0),
 	MEASUREMENT_ACTIVE = (1 << 1),
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index d1fd1cd..5936833 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -149,6 +149,10 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
  * EEPROM chip, not a single event, so even reads could conflict if they
  * weren't arbitrated by the semaphore.
  */
+
+#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
+#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
+
 static int iwl_eeprom_acquire_semaphore(struct iwl_bus *bus)
 {
 	u16 count;
-- 
1.7.0.4

