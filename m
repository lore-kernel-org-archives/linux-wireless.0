Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45315 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1HBK2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 06:28:06 -0400
Received: by fxh19 with SMTP id 19so5482579fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 03:28:05 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: libertas-dev@lists.infradead.org, Daniel Drake <dsd@laptop.org>,
	linville@tuxdriver.com, dcbw@redhat.com,
	linux-wireless@vger.kernel.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 1/2] libertas: add ability to power off card on suspend
Date: Tue,  2 Aug 2011 13:27:11 +0300
Message-Id: <1312280832-27675-1-git-send-email-anarsoul@gmail.com> (sfid-20110802_122811_331587_451A934D)
In-Reply-To: <201108021312.23153.anarsoul@gmail.com>
References: <201108021312.23153.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could be usefull if it's not possible to keep power on the card
when host goes into suspend.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/net/wireless/libertas/dev.h  |    3 ++-
 drivers/net/wireless/libertas/main.c |   22 +++++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index f526633..563a8b0 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -86,9 +86,10 @@ struct lbs_private {
 	/* Hardware access */
 	void *card;
 	bool iface_running;
+	bool suspend_iface_status;
 	u8 fw_ready;
 	u8 surpriseremoved;
-	u8 setup_fw_on_resume;
+	u8 disable_on_suspend;
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
 	void (*reset_card) (struct lbs_private *priv);
 	int (*power_save) (struct lbs_private *priv);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 208e4d9..5522202 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -644,7 +644,7 @@ done:
 
 int lbs_suspend(struct lbs_private *priv)
 {
-	int ret;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
@@ -658,7 +658,13 @@ int lbs_suspend(struct lbs_private *priv)
 		priv->deep_sleep_required = 1;
 	}
 
-	ret = lbs_set_host_sleep(priv, 1);
+	if (priv->disable_on_suspend) {
+		/* Disable card */
+		priv->suspend_iface_status = priv->iface_running;
+		if (priv->iface_running)
+			lbs_stop_iface(priv);
+	} else
+		ret = lbs_set_host_sleep(priv, 1);
 
 	netif_device_detach(priv->dev);
 	if (priv->mesh_dev)
@@ -671,11 +677,16 @@ EXPORT_SYMBOL_GPL(lbs_suspend);
 
 int lbs_resume(struct lbs_private *priv)
 {
-	int ret;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
-	ret = lbs_set_host_sleep(priv, 0);
+	if (priv->disable_on_suspend) {
+		/* Enable card */
+		if (priv->suspend_iface_status)
+			lbs_start_iface(priv);
+	} else
+		ret = lbs_set_host_sleep(priv, 0);
 
 	netif_device_attach(priv->dev);
 	if (priv->mesh_dev)
@@ -689,9 +700,6 @@ int lbs_resume(struct lbs_private *priv)
 				   "deep sleep activation failed: %d\n", ret);
 	}
 
-	if (priv->setup_fw_on_resume)
-		ret = lbs_setup_firmware(priv);
-
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
 }
-- 
1.7.5.rc3

