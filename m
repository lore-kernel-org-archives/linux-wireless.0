Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53042 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaICT4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:35 -0400
Received: by mail-wg0-f42.google.com with SMTP id b13so8930789wgh.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:34 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/36] iwlwifi: mvm: add use_ps-poll debugfs power option
Date: Wed,  3 Sep 2014 22:55:52 +0300
Message-Id: <1409774184-24665-4-git-send-email-egrumbach@gmail.com> (sfid-20140903_215639_919376_660FDC36)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

By default, when uapsd is not used, the ucode uses
null data packet to exit power-save and get then
pending frames.

However, some tests require the explicit usage of ps-poll.
Allow setting use_ps_poll power option (through debugfs)
to configure the ucode to use ps-poll instead.

The ucode configuration is done by setting the advanced-pm
flag while setting all the ACs to non-upasd mode.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 8 ++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 2 ++
 drivers/net/wireless/iwlwifi/mvm/power.c       | 9 ++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 2e90ff7..5f5a94b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -119,6 +119,10 @@ static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
 		IWL_DEBUG_POWER(mvm, "uapsd_misbehaving_enable=%d\n", val);
 		dbgfs_pm->uapsd_misbehaving = val;
 		break;
+	case MVM_DEBUGFS_PM_USE_PS_POLL:
+		IWL_DEBUG_POWER(mvm, "use_ps_poll=%d\n", val);
+		dbgfs_pm->use_ps_poll = val;
+		break;
 	}
 }
 
@@ -169,6 +173,10 @@ static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
 		if (sscanf(buf + 18, "%d", &val) != 1)
 			return -EINVAL;
 		param = MVM_DEBUGFS_PM_UAPSD_MISBEHAVING;
+	} else if (!strncmp("use_ps_poll=", buf, 12)) {
+		if (sscanf(buf + 12, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_USE_PS_POLL;
 	} else {
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 771cf46..83a00ab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -203,6 +203,7 @@ enum iwl_dbgfs_pm_mask {
 	MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD = BIT(7),
 	MVM_DEBUGFS_PM_SNOOZE_ENABLE = BIT(8),
 	MVM_DEBUGFS_PM_UAPSD_MISBEHAVING = BIT(9),
+	MVM_DEBUGFS_PM_USE_PS_POLL = BIT(10),
 };
 
 struct iwl_dbgfs_pm {
@@ -215,6 +216,7 @@ struct iwl_dbgfs_pm {
 	u32 lprx_rssi_threshold;
 	bool snooze_ena;
 	bool uapsd_misbehaving;
+	bool use_ps_poll;
 	int mask;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 2b2d108..8cbe7ea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -198,8 +198,15 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 		}
 	}
 
-	if (!(cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)))
+	if (!(cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK))) {
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		/* set advanced pm flag with no uapsd ACs to enable ps-poll */
+		if (mvmvif->dbgfs_pm.use_ps_poll)
+			cmd->flags |=
+				cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
+#endif
 		return;
+	}
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK);
 
-- 
1.9.1

