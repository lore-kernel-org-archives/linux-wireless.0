Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab1A1PsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 10:48:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 7/8] iwlagn: remove CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
Date: Fri, 28 Jan 2011 16:47:50 +0100
Message-Id: <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This option practically do not change object files size, and only add
complication for users wanted to play with experimental firmware.
Someone who want to use or stop to use experimental firmware can
simply add or remove proper ucode files in /lib/firmware

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   |    6 ------
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 --
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index e1e3b1c..4a5c51f 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -43,12 +43,6 @@ config IWLWIFI_DEBUGFS
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
 
-config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
-        bool "Experimental uCode support"
-        depends on IWLWIFI && IWLWIFI_DEBUG
-        ---help---
-	  Enable use of experimental ucode for testing and debugging.
-
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eb16647..23bf006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1610,11 +1610,9 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 	char tag[8];
 
 	if (first) {
-#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
 		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
 		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
 	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
-#endif
 		priv->fw_index = priv->cfg->ucode_api_max;
 		sprintf(tag, "%d", priv->fw_index);
 	} else {
-- 
1.7.1

