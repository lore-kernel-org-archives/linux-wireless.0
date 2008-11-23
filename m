Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39445 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYKWLSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 06:18:25 -0500
Date: Sun, 23 Nov 2008 19:18:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: fix build warning
Message-ID: <20081123111812.GA15611@localhost> (sfid-20081123_121840_934709_B7C73186)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_escape_essid() is only used in debugging code for now.
So define it only with CONFIG_IWL3945_DEBUG enabled.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c89365e..412f5d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -70,6 +70,7 @@ static int scan_tx_ant[3] = {
 
 
 
+#ifdef CONFIG_IWL3945_DEBUG
 static int iwl_is_empty_essid(const char *essid, int essid_len)
 {
 	/* Single white space is for Linksys APs */
@@ -111,6 +112,7 @@ static const char *iwl_escape_essid(const char *essid, u8 essid_len)
 	*d = '\0';
 	return escaped;
 }
+#endif
 
 /**
  * iwl_scan_cancel - Cancel any currently executing HW scan
