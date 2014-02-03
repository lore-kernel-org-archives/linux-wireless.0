Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46733 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaBCU7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:37 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so3967850eaj.26
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 50/62] iwlwifi: fix potential buffer overrun in fw name
Date: Mon,  3 Feb 2014 22:57:56 +0200
Message-Id: <1391461088-8082-50-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_385390_74F66A7E)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Fix a potential buffer overrun when creating the fw name
in drv->firmware_name by setting a maximal length to the
char array copied to it.
The maximal length is also updated to 32 rather than 25 to
keep both 32bit and 64bit alignment without requiring
padding to the struct it is in.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index c372816..b3bc30b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -128,7 +128,7 @@ struct iwl_drv {
 	const struct iwl_cfg *cfg;
 
 	int fw_index;                   /* firmware we're trying to load */
-	char firmware_name[25];         /* name of firmware file to load */
+	char firmware_name[32];         /* name of firmware file to load */
 
 	struct completion request_firmware_complete;
 
@@ -237,7 +237,8 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		return -ENOENT;
 	}
 
-	sprintf(drv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
+	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
+		 name_pre, tag);
 
 	IWL_DEBUG_INFO(drv, "attempting to load firmware %s'%s'\n",
 		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
-- 
1.7.9.5

