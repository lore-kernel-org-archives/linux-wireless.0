Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031487Ab2CFWnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 22/33] iwlwifi: fix notification wait bug
Date: Tue,  6 Mar 2012 13:30:57 -0800
Message-Id: <1331069468-11074-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234410_159064_214164A7)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In "iwlwifi: consolidate the start_device flow"
Emmanuel added the return if the fw isn't there
but forgot to take into account that the struct
for notification wait needs to be added only
after the check -- fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-ucode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index c1c5e1f..686d456 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -533,9 +533,6 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	int ret;
 	enum iwl_ucode_type old_type;
 
-	iwl_init_notification_wait(priv->shrd, &alive_wait, REPLY_ALIVE,
-				      iwl_alive_fn, &alive_data);
-
 	old_type = priv->shrd->ucode_type;
 	priv->shrd->ucode_type = ucode_type;
 	fw = iwl_get_ucode_image(priv, ucode_type);
@@ -543,6 +540,9 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (!fw)
 		return -EINVAL;
 
+	iwl_init_notification_wait(priv->shrd, &alive_wait, REPLY_ALIVE,
+				      iwl_alive_fn, &alive_data);
+
 	ret = iwl_trans_start_fw(trans(priv), fw);
 	if (ret) {
 		priv->shrd->ucode_type = old_type;
-- 
1.7.0.4

