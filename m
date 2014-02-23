Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35634 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaBWT53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:29 -0500
Received: by mail-wi0-f177.google.com with SMTP id e4so2355820wiv.4
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/17] iwlwifi: mvm: fix possible memory leak
Date: Sun, 23 Feb 2014 21:57:01 +0200
Message-Id: <1393185428-8524-10-git-send-email-egrumbach@gmail.com> (sfid-20140223_205733_980127_1D16E61A)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

iwl_parse_nvm_data() doesn't free allocated memory if it is
fed with invalid parameter. Fix this.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index df3ea60..80c4096 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -516,6 +516,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		if (!nvm_calib) {
 			IWL_ERR_DEV(dev,
 				    "Can't parse empty Calib NVM sections\n");
+			kfree(data);
 			return NULL;
 		}
 		/* in family 8000 Xtal calibration values moved to OTP */
-- 
1.7.9.5

