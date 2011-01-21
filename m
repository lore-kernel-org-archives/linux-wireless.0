Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46839 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1AUUrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 15:47:23 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so1170225ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 12:47:22 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>,
	Marek Vasut <marek.vasut@gmail.com>, anarsoul@gmail.com
Subject: [PATCH 2/3] libertas: Prepare stuff for if_spi.c pm support
Date: Fri, 21 Jan 2011 22:44:49 +0200
Message-Id: <1295642690-16646-3-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support suspend/resume in if_spi we need two things:
- re-setup fw in lbs_resume(), because if_spi powercycles card;
- don't touch hwaddr on second lbs_update_hw_spec() call for same
  reason;

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/net/wireless/libertas/cmd.c  |   10 +++-
 drivers/net/wireless/libertas/dev.h  |    2 +
 drivers/net/wireless/libertas/main.c |   77 +++++++++++++++++----------------
 3 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 78c4da1..7e8a658 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -145,9 +145,13 @@ int lbs_update_hw_spec(struct lbs_private *priv)
 	if (priv->current_addr[0] == 0xff)
 		memmove(priv->current_addr, cmd.permanentaddr, ETH_ALEN);
 
-	memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
-	if (priv->mesh_dev)
-		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
+	if (!priv->copied_hwaddr) {
+		memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
+		if (priv->mesh_dev)
+			memcpy(priv->mesh_dev->dev_addr,
+				priv->current_addr, ETH_ALEN);
+		priv->copied_hwaddr = 1;
+	}
 
 out:
 	lbs_deb_leave(LBS_DEB_CMD);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 18dd9a0..bc461eb 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -90,6 +90,7 @@ struct lbs_private {
 	void *card;
 	u8 fw_ready;
 	u8 surpriseremoved;
+	u8 setup_fw_on_resume;
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
 	void (*reset_card) (struct lbs_private *priv);
 	int (*enter_deep_sleep) (struct lbs_private *priv);
@@ -101,6 +102,7 @@ struct lbs_private {
 	u32 fwcapinfo;
 	u16 regioncode;
 	u8 current_addr[ETH_ALEN];
+	u8 copied_hwaddr;
 
 	/* Command download */
 	u8 dnld_sent;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 6836a6d..ca8149c 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -539,6 +539,43 @@ static int lbs_thread(void *data)
 	return 0;
 }
 
+/**
+ * @brief This function gets the HW spec from the firmware and sets
+ *        some basic parameters.
+ *
+ *  @param priv    A pointer to struct lbs_private structure
+ *  @return        0 or -1
+ */
+static int lbs_setup_firmware(struct lbs_private *priv)
+{
+	int ret = -1;
+	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
+
+	lbs_deb_enter(LBS_DEB_FW);
+
+	/* Read MAC address from firmware */
+	memset(priv->current_addr, 0xff, ETH_ALEN);
+	ret = lbs_update_hw_spec(priv);
+	if (ret)
+		goto done;
+
+	/* Read power levels if available */
+	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
+	if (ret == 0) {
+		priv->txpower_cur = curlevel;
+		priv->txpower_min = minlevel;
+		priv->txpower_max = maxlevel;
+	}
+
+	/* Send cmd to FW to enable 11D function */
+	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
+
+	lbs_set_mac_control(priv);
+done:
+	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
+	return ret;
+}
+
 int lbs_suspend(struct lbs_private *priv)
 {
 	int ret;
@@ -584,47 +621,13 @@ int lbs_resume(struct lbs_private *priv)
 			lbs_pr_err("deep sleep activation failed: %d\n", ret);
 	}
 
-	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(lbs_resume);
-
-/**
- * @brief This function gets the HW spec from the firmware and sets
- *        some basic parameters.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   0 or -1
- */
-static int lbs_setup_firmware(struct lbs_private *priv)
-{
-	int ret = -1;
-	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
-
-	lbs_deb_enter(LBS_DEB_FW);
-
-	/* Read MAC address from firmware */
-	memset(priv->current_addr, 0xff, ETH_ALEN);
-	ret = lbs_update_hw_spec(priv);
-	if (ret)
-		goto done;
-
-	/* Read power levels if available */
-	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
-	if (ret == 0) {
-		priv->txpower_cur = curlevel;
-		priv->txpower_min = minlevel;
-		priv->txpower_max = maxlevel;
-	}
+	if (priv->setup_fw_on_resume)
+		ret = lbs_setup_firmware(priv);
 
-	/* Send cmd to FW to enable 11D function */
-	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
-
-	lbs_set_mac_control(priv);
-done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(lbs_resume);
 
 /**
  *  This function handles the timeout of command sending.
-- 
1.7.4.rc1

