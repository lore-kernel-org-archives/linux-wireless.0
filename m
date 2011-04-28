Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643Ab1D1JxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:53:01 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/10] iwlegacy: remove sync_cmd_mutex
Date: Thu, 28 Apr 2011 11:51:33 +0200
Message-Id: <1303984293-6601-10-git-send-email-sgruszka@redhat.com> (sfid-20110428_115306_824355_B2096BA3)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We now use priv->mutex to serialize sync command, remove old
priv->sync_cmd_mutex and add assertion that priv->mutex must be locked.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlegacy/iwl-hcmd.c     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    1 -
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    1 -
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index df19d5c..2d87dba 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -1077,7 +1077,6 @@ struct iwl_priv {
 	spinlock_t hcmd_lock;	/* protect hcmd */
 	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
-	struct mutex sync_cmd_mutex; /* enable serialization of sync commands */
 
 	/* basic pci-network driver stuff */
 	struct pci_dev *pci_dev;
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 9d721cb..62b4b09 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -145,6 +145,8 @@ int iwl_legacy_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int cmd_idx;
 	int ret;
 
+	lockdep_assert_held(&priv->mutex);
+
 	BUG_ON(cmd->flags & CMD_ASYNC);
 
 	 /* A synchronous command can not have a callback set. */
@@ -152,7 +154,6 @@ int iwl_legacy_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
 			iwl_legacy_get_cmd_string(cmd->id));
-	mutex_lock(&priv->sync_cmd_mutex);
 
 	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
 	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
@@ -224,7 +225,6 @@ fail:
 		cmd->reply_page = 0;
 	}
 out:
-	mutex_unlock(&priv->sync_cmd_mutex);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_legacy_send_cmd_sync);
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 0460d3b..dc9e8ca 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -3815,7 +3815,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);
-	mutex_init(&priv->sync_cmd_mutex);
 
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 8650970..af2ae22 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -3124,7 +3124,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);
-	mutex_init(&priv->sync_cmd_mutex);
 
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
-- 
1.7.1

