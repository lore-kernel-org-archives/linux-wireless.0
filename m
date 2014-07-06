Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:40637 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaGFJgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:48 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so3090081wes.41
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:47 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/40] iwlwifi: mvm: warn about empty OTP
Date: Sun,  6 Jul 2014 12:35:53 +0300
Message-Id: <1404639376-3792-17-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_640875_9B5884F7)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 1f1a550..b04805c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -530,6 +530,8 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 			}
 #endif
 		}
+		if (!size_read)
+			IWL_ERR(mvm, "OTP is blank\n");
 		kfree(nvm_buffer);
 	}
 
-- 
1.8.3.2

