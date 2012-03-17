Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34722 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030745Ab2CQNKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 09:10:09 -0400
Received: by wibhq7 with SMTP id hq7so2023307wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2012 06:10:07 -0700 (PDT)
Subject: [PATCH] p54: only unregister ieee80211_hw when it has been registered
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com
To: linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 17 Mar 2012 14:10:02 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201203171410.02412.chunkeey@googlemail.com> (sfid-20120317_141025_666928_BCE966EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54_unregister_common may now be called by the backend
driver's remove routine, even if the ieee80211_hw device
struct was never successfully registered.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/main.c |   13 ++++++++++---
 drivers/net/wireless/p54/p54.h  |    1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 40f4eb7..9c2d3d1 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -793,16 +793,19 @@ int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		dev_err(pdev, "Cannot register device (%d).\n", err);
		return err;
 	}
+	priv->registered = true;
 
 #ifdef CONFIG_P54_LEDS
 	err = p54_init_leds(priv);
-	if (err)
+	if (err) {
+		p54_unregister_common(dev);
 		return err;
+	}
 #endif /* CONFIG_P54_LEDS */
 
 	dev_info(pdev, "is registered as '%s'\n", wiphy_name(dev->wiphy));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(p54_register_common);
@@ -839,7 +843,11 @@ void p54_unregister_common(struct ieee80211_hw *dev)
 	p54_unregister_leds(priv);
 #endif /* CONFIG_P54_LEDS */
 
-	ieee80211_unregister_hw(dev);
+	if (priv->registered) {
+		priv->registered = false;
+		ieee80211_unregister_hw(dev);
+	}
+
 	mutex_destroy(&priv->conf_mutex);
 	mutex_destroy(&priv->eeprom_mutex);
 }
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 452fa3a..40b401e 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -173,6 +173,7 @@ struct p54_common {
 	struct sk_buff_head tx_pending;
 	struct sk_buff_head tx_queue;
 	struct mutex conf_mutex;
+	bool registered;
 
 	/* memory management (as seen by the firmware) */
 	u32 rx_start;
-- 
1.7.9.1

