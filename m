Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28170 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaLDLCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 06:02:51 -0500
Date: Thu, 4 Dec 2014 14:02:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] iwlwifi: use a format string for an snprintf()
Message-ID: <20141204110220.GE22643@mwanda> (sfid-20141204_120256_172346_207B7F52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make Kees Cook happy if we specify a format string and, who
knows, maybe someday there will be a firmware version with a percent
character and we'll be glad for this.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 38de151..68efe97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1296,7 +1296,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		iwl_dealloc_ucode(drv);
 
 		/* Build name of correct-step FW */
-		snprintf(firmware_name, sizeof(firmware_name),
+		snprintf(firmware_name, sizeof(firmware_name), "%s",
 			 strrchr(drv->firmware_name, '-'));
 		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
 			 "%s%s", drv->cfg->fw_name_pre, firmware_name);
