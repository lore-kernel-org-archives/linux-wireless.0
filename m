Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx28.mail.ru ([94.100.176.42]:22019 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZBOKJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 05:09:50 -0500
Received: from mx7.mail.ru (mx7.mail.ru [94.100.176.21])
	by mx28.mail.ru (mPOP.Fallback_MX) with ESMTP id 0A475784C03
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 12:51:51 +0300 (MSK)
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: [PATCH] orinoco: do not resgister NULL pm_notifier function
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Date: Sun, 15 Feb 2009 12:51:18 +0300
Message-ID: <20090215094753.31795.19546.stgit@cooker.net> (sfid-20090215_110956_181878_02756325)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With DEBUG_NOTIFIERS it results in

[11330.890966] WARNING: at /home/bor/src/linux-git/kernel/notifier.c:88
notifier_call_chain+0x91/0xa0()
[11330.890977] Hardware name: PORTEGE 4000
[11330.890983] Invalid notifier called! ...

Without DEBUG_NOTIFIERS it most likely crashes on NULL pointer.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

---

This condition is triggered by default config options so it is 2.6.29
material. Patch is intentionally against 2.6.29 base and not against
wireless-next.

 drivers/net/wireless/orinoco/orinoco.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 6514e46..728fd3f 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -3158,8 +3158,20 @@ static int orinoco_pm_notifier(struct notifier_block *notifier,
 
 	return NOTIFY_DONE;
 }
+
+static void orinoco_register_pm_notifier(struct orinoco_private *priv)
+{
+	priv->pm_notifier.notifier_call = orinoco_pm_notifier;
+	register_pm_notifier(&priv->pm_notifier);
+}
+
+static void orinoco_unregister_pm_notifier(struct orinoco_private *priv)
+{
+	unregister_pm_notifier(&priv->pm_notifier);
+}
 #else /* !PM_SLEEP || HERMES_CACHE_FW_ON_INIT */
-#define orinoco_pm_notifier NULL
+#define orinoco_register_pm_notifier(priv) do { } while(0)
+#define orinoco_unregister_pm_notifier(priv) do { } while(0)
 #endif
 
 /********************************************************************/
@@ -3653,8 +3665,7 @@ struct net_device
 	priv->cached_fw = NULL;
 
 	/* Register PM notifiers */
-	priv->pm_notifier.notifier_call = orinoco_pm_notifier;
-	register_pm_notifier(&priv->pm_notifier);
+	orinoco_register_pm_notifier(priv);
 
 	return dev;
 }
@@ -3678,7 +3689,7 @@ void free_orinocodev(struct net_device *dev)
 		kfree(rx_data);
 	}
 
-	unregister_pm_notifier(&priv->pm_notifier);
+	orinoco_unregister_pm_notifier(priv);
 	orinoco_uncache_fw(priv);
 
 	priv->wpa_ie_len = 0;

