Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:51272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYKVKh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 05:37:57 -0500
Received: by nf-out-0910.google.com with SMTP id d3so650327nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 02:37:56 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 4/4] orinoco: Provide option to avoid unnecessary fw caching
Date: Sat, 22 Nov 2008 10:37:28 +0000
Message-Id: <1227350248-8917-5-git-send-email-kilroyd@googlemail.com> (sfid-20081122_113759_803737_60E5DAC8)
In-Reply-To: <1227350248-8917-4-git-send-email-kilroyd@googlemail.com>
References: <1227350248-8917-1-git-send-email-kilroyd@googlemail.com>
 <1227350248-8917-2-git-send-email-kilroyd@googlemail.com>
 <1227350248-8917-3-git-send-email-kilroyd@googlemail.com>
 <1227350248-8917-4-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make firmware caching on startup optional, and make it default.

When the option is not selected and PM_SLEEP is configured, then
cache firmware in the suspend pm_notifier. This configuration saves
about 64k RAM in normal use, but can lead to a situation where the
driver is configured to use a different firmware.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/Kconfig           |   15 ++++++++
 drivers/net/wireless/orinoco/orinoco.c |   57 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/orinoco.h |    3 ++
 3 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 7ea916b..ea543fc 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -214,6 +214,21 @@ config HERMES
 	  configure your card and that /etc/pcmcia/wireless.opts works :
 	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>
 
+config HERMES_CACHE_FW_ON_INIT
+	bool "Cache Hermes firmware on driver initialisation"
+	depends on HERMES
+	default y
+	---help---
+	  Say Y to cache any firmware required by the Hermes drivers
+	  on startup.  The firmware will remain cached until the
+	  driver is unloaded.  The cache uses 64K of RAM.
+
+	  Otherwise load the firmware from userspace as required.  In
+	  this case the driver should be unloaded and restarted
+	  whenever the firmware is changed.
+
+	  If you are not sure, say Y.
+
 config APPLE_AIRPORT
 	tristate "Apple Airport support (built-in)"
 	depends on PPC_PMAC && HERMES
diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 4c8f4c2..40f662e 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -84,6 +84,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/firmware.h>
+#include <linux/suspend.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
@@ -712,6 +713,7 @@ static int orinoco_download(struct orinoco_private *priv)
 	return err;
 }
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 static void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 {
 	const struct firmware *fw_entry = NULL;
@@ -745,6 +747,10 @@ static void orinoco_uncache_fw(struct orinoco_private *priv)
 	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
 }
+#else
+#define orinoco_cache_fw(priv, ap)
+#define orinoco_uncache_fw(priv)
+#endif
 
 /********************************************************************/
 /* Device methods                                                   */
@@ -3103,6 +3109,50 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 }
 
 /********************************************************************/
+/* Power management                                                 */
+/********************************************************************/
+#if defined(CONFIG_PM_SLEEP) && !defined(CONFIG_HERMES_CACHE_FW_ON_INIT)
+static int orinoco_pm_notifier(struct notifier_block *notifier,
+			       unsigned long pm_event,
+			       void *unused)
+{
+	struct orinoco_private *priv = container_of(notifier,
+						    struct orinoco_private,
+						    pm_notifier);
+
+	/* All we need to do is cache the firmware before suspend, and
+	 * release it when we come out.
+	 *
+	 * Only need to do this if we're downloading firmware. */
+	if (!priv->do_fw_download)
+		return NOTIFY_DONE;
+
+	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		orinoco_cache_fw(priv, 0);
+		break;
+
+	case PM_POST_RESTORE:
+		/* Restore from hibernation failed. We need to clean
+		 * up in exactly the same way, so fall through. */
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		orinoco_uncache_fw(priv);
+		break;
+
+	case PM_RESTORE_PREPARE:
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+#else /* !PM_SLEEP || HERMES_CACHE_FW_ON_INIT */
+#define orinoco_pm_notifier NULL
+#endif
+
+/********************************************************************/
 /* Initialization                                                   */
 /********************************************************************/
 
@@ -3346,7 +3396,9 @@ static int orinoco_init(struct net_device *dev)
 	}
 
 	if (priv->do_fw_download) {
+#ifdef CONFIG_HERMES_CACHE_FW_ON_INIT
 		orinoco_cache_fw(priv, 0);
+#endif
 
 		err = orinoco_download(priv);
 		if (err)
@@ -3587,6 +3639,10 @@ struct net_device
 	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
 
+	/* Register PM notifiers */
+	priv->pm_notifier.notifier_call = orinoco_pm_notifier;
+	register_pm_notifier(&priv->pm_notifier);
+
 	return dev;
 }
 
@@ -3599,6 +3655,7 @@ void free_orinocodev(struct net_device *dev)
 	 * emptying the list */
 	tasklet_kill(&priv->rx_tasklet);
 
+	unregister_pm_notifier(&priv->pm_notifier);
 	orinoco_uncache_fw(priv);
 
 	priv->wpa_ie_len = 0;
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index f6eaea9..00750c8 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -10,6 +10,7 @@
 #define DRIVER_VERSION "0.15"
 
 #include <linux/interrupt.h>
+#include <linux/suspend.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
@@ -170,6 +171,8 @@ struct orinoco_private {
 	/* Cached in memory firmware to use during ->resume. */
 	const struct firmware *cached_pri_fw;
 	const struct firmware *cached_fw;
+
+	struct notifier_block pm_notifier;
 };
 
 #ifdef ORINOCO_DEBUG
-- 
1.5.6.4

