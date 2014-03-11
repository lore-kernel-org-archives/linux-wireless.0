Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:35274 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaCKLxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 07:53:41 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] iwlwifi: dvm: take mutex when sending SYNC BT config command
Date: Tue, 11 Mar 2014 13:53:36 +0200
Message-Id: <1394538816-21460-1-git-send-email-egrumbach@gmail.com> (sfid-20140311_125345_493991_88B9CD4C)
In-Reply-To: <531EF845.2050609@gmail.com>
References: <531EF845.2050609@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There is a flow in which we send the host command in SYNC
mode, but we don't take priv->mutex.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1046495

Cc: <stable@vger.kernel.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index ba1b1ea..ea7e70c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -252,13 +252,17 @@ static void iwl_bg_bt_runtime_config(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_runtime_config);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
 	/* dont send host command if rf-kill is on */
 	if (!iwl_is_ready_rf(priv))
-		return;
+		goto out;
+
 	iwlagn_send_advance_bt_config(priv);
+out:
+	mutex_unlock(&priv->mutex);
 }
 
 static void iwl_bg_bt_full_concurrency(struct work_struct *work)
-- 
1.8.3.2

