Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57098 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaLRILY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 03:11:24 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so895940wgh.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 00:11:22 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/5] iwlwifi: don't double free a pointer if no FW was found
Date: Thu, 18 Dec 2014 10:09:59 +0200
Message-Id: <1418890201-15177-3-git-send-email-egrumbach@gmail.com> (sfid-20141218_091128_328982_B180741A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the very unlikely case in which no firmware could be,
found. the same pointer was freed twice. Fix that.

Fixes: 490fefebb6db ("iwlwifi: define the .ucode file format for debug")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 38de151..850b85a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1323,10 +1323,10 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 
  try_again:
 	/* try next, if any */
-	kfree(pieces);
 	release_firmware(ucode_raw);
 	if (iwl_request_firmware(drv, false))
 		goto out_unbind;
+	kfree(pieces);
 	return;
 
  out_free_fw:
-- 
1.9.1

