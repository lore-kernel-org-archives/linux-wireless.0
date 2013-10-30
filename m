Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3J3UcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/9] iwlwifi: warn if firmware image doesn't exist
Date: Wed, 30 Oct 2013 22:31:35 +0200
Message-Id: <1383165097-4445-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213222_292418_D9407E74)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the firmware image that we attempt to load doesn't
actually exist we have a broken firmware file or other
code not checking things correctly, so warn in such a
case. Also avoid assigning cur_ucode/ucode_loaded then.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/ucode.c | 9 ++++-----
 drivers/net/wireless/iwlwifi/mvm/fw.c    | 8 +++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 86270b6..6363794 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -330,15 +330,14 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	enum iwl_ucode_type old_type;
 	static const u8 alive_cmd[] = { REPLY_ALIVE };
 
-	old_type = priv->cur_ucode;
-	priv->cur_ucode = ucode_type;
 	fw = iwl_get_ucode_image(priv, ucode_type);
+	if (WARN_ON(!fw))
+		return -EINVAL;
 
+	old_type = priv->cur_ucode;
+	priv->cur_ucode = ucode_type;
 	priv->ucode_loaded = false;
 
-	if (!fw)
-		return -EINVAL;
-
 	iwl_init_notification_wait(&priv->notif_wait, &alive_wait,
 				   alive_cmd, ARRAY_SIZE(alive_cmd),
 				   iwl_alive_fn, &alive_data);
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 83fc5ca..70e5297 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -151,13 +151,11 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	enum iwl_ucode_type old_type = mvm->cur_ucode;
 	static const u8 alive_cmd[] = { MVM_ALIVE };
 
-	mvm->cur_ucode = ucode_type;
 	fw = iwl_get_ucode_image(mvm, ucode_type);
-
-	mvm->ucode_loaded = false;
-
-	if (!fw)
+	if (WARN_ON(!fw))
 		return -EINVAL;
+	mvm->cur_ucode = ucode_type;
+	mvm->ucode_loaded = false;
 
 	iwl_init_notification_wait(&mvm->notif_wait, &alive_wait,
 				   alive_cmd, ARRAY_SIZE(alive_cmd),
-- 
1.8.3.2

