Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37512 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1KAGos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 02:44:48 -0400
Subject: [PATCH v2 7/7] ath6kl: cut power during suspend
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Nov 2011 08:44:44 +0200
Message-ID: <20111101064444.6798.60888.stgit@localhost6.localdomain6> (sfid-20111101_074451_759661_646A9995)
In-Reply-To: <20111101064140.6798.7006.stgit@localhost6.localdomain6>
References: <20111101064140.6798.7006.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If sdio controller doesn't support keep power, cut power from hardware
during suspend and restart firmware during resume. If we are connected
during suspend, send a disconnected event to user space.

Earlier suspend failed with an error if sdio didn't support keep power.
Now suspend will happen succesfully even with that case.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   31 ++++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    1 
 drivers/net/wireless/ath/ath6kl/core.h     |    1 
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 
 drivers/net/wireless/ath/ath6kl/sdio.c     |   64 +++++++++++++++++++++++++---
 5 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b618119..a942475 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1674,6 +1674,28 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		ar->state = ATH6KL_STATE_DEEPSLEEP;
 
 		break;
+
+	case ATH6KL_CFG_SUSPEND_CUTPOWER:
+		if (ar->state == ATH6KL_STATE_OFF) {
+			ath6kl_dbg(ATH6KL_DBG_SUSPEND,
+				   "suspend hw off, no action for cutpower\n");
+			break;
+		}
+
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "suspend cutting power\n");
+
+		ret = ath6kl_init_hw_stop(ar);
+		if (ret) {
+			ath6kl_warn("failed to stop hw during suspend: %d\n",
+				    ret);
+		}
+
+		ar->state = ATH6KL_STATE_CUTPOWER;
+
+		break;
+
+	default:
+		break;
 	}
 
 	return 0;
@@ -1698,6 +1720,15 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 
 		break;
 
+	case ATH6KL_STATE_CUTPOWER:
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "resume restoring power\n");
+
+		ret = ath6kl_init_hw_start(ar);
+		if (ret) {
+			ath6kl_warn("Failed to boot hw in resume: %d\n", ret);
+			return ret;
+		}
+
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 3630c5e..72eadf8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -19,6 +19,7 @@
 
 enum ath6kl_cfg_suspend_mode {
 	ATH6KL_CFG_SUSPEND_DEEPSLEEP,
+	ATH6KL_CFG_SUSPEND_CUTPOWER,
 };
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6613248..f301c32 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -454,6 +454,7 @@ enum ath6kl_state {
 	ATH6KL_STATE_OFF,
 	ATH6KL_STATE_ON,
 	ATH6KL_STATE_DEEPSLEEP,
+	ATH6KL_STATE_CUTPOWER,
 };
 
 struct ath6kl {
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 491485e..c24d120 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -40,6 +40,7 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_SDIO_DUMP	= BIT(17),
 	ATH6KL_DBG_BOOT		= BIT(18),    /* driver init and fw boot */
 	ATH6KL_DBG_WMI_DUMP	= BIT(19),
+	ATH6KL_DBG_SUSPEND	= BIT(20),
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index b02ecea..ccb888b 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -782,12 +782,11 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 
 	flags = sdio_get_host_pm_caps(func);
 
+	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio suspend pm_caps 0x%x\n", flags);
+
 	if (!(flags & MMC_PM_KEEP_POWER)) {
-		/* as host doesn't support keep power we need to bail out */
-		ath6kl_dbg(ATH6KL_DBG_SDIO,
-			   "func %d doesn't support MMC_PM_KEEP_POWER\n",
-			   func->num);
-		return -EINVAL;
+		/* as host doesn't support keep power we need to cut power */
+		return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER);
 	}
 
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
@@ -797,13 +796,30 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 		return ret;
 	}
 
-	ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP);
-
-	return 0;
+	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP);
 }
 
 static int ath6kl_sdio_resume(struct ath6kl *ar)
 {
+	switch (ar->state) {
+	case ATH6KL_STATE_OFF:
+	case ATH6KL_STATE_CUTPOWER:
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND,
+			   "sdio resume configuring sdio\n");
+
+		/* need to set sdio settings after power is cut from sdio */
+		ath6kl_sdio_config(ar);
+		break;
+
+	case ATH6KL_STATE_ON:
+		/* we shouldn't be on this state during resume */
+		WARN_ON(1);
+		break;
+
+	case ATH6KL_STATE_DEEPSLEEP:
+		break;
+	}
+
 	ath6kl_cfg80211_resume(ar);
 
 	return 0;
@@ -858,6 +874,37 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.stop = ath6kl_sdio_stop,
 };
 
+#ifdef CONFIG_PM_SLEEP
+
+/*
+ * Empty handlers so that mmc subsystem doesn't remove us entirely during
+ * suspend. We instead follow cfg80211 suspend/resume handlers.
+ */
+static int ath6kl_sdio_pm_suspend(struct device *device)
+{
+	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio pm suspend\n");
+
+	return 0;
+}
+
+static int ath6kl_sdio_pm_resume(struct device *device)
+{
+	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio pm resume\n");
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ath6kl_sdio_pm_ops, ath6kl_sdio_pm_suspend,
+			 ath6kl_sdio_pm_resume);
+
+#define ATH6KL_SDIO_PM_OPS (&ath6kl_sdio_pm_ops)
+
+#else
+
+#define ATH6KL_SDIO_PM_OPS NULL
+
+#endif /* CONFIG_PM_SLEEP */
+
 static int ath6kl_sdio_probe(struct sdio_func *func,
 			     const struct sdio_device_id *id)
 {
@@ -969,6 +1016,7 @@ static struct sdio_driver ath6kl_sdio_driver = {
 	.id_table = ath6kl_sdio_devices,
 	.probe = ath6kl_sdio_probe,
 	.remove = ath6kl_sdio_remove,
+	.drv.pm = ATH6KL_SDIO_PM_OPS,
 };
 
 static int __init ath6kl_sdio_init(void)

