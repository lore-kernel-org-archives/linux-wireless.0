Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:62943 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710Ab0JaNkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 09:40:37 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: pgf@laptop.org
Subject: [PATCH] libertas: EHS_REMOVE_WAKEUP is not always supported
Message-Id: <20101031134033.C97169D401B@zog.reactivated.net>
Date: Sun, 31 Oct 2010 13:40:33 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Deepak Saxena <dsaxena@laptop.org>

Certain firmware versions, particularly the 8388 found on the XO-1,
do not support the EHS_REMOVE_WAKEUP command that is used to disable
WOL. Sending this command to the card will return a failure that
would get propagated up the stack and cause suspend to fail.

Instead, fall back to an all-zero wakeup mask.

This fixes http://dev.laptop.org/ticket/9967

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
[includes fixups by Paul Fox]
---
 drivers/net/wireless/libertas/cmd.c    |    8 ++++++++
 drivers/net/wireless/libertas/dev.h    |    1 +
 drivers/net/wireless/libertas/if_usb.c |    7 +++++++
 drivers/net/wireless/libertas/main.c   |    3 ++-
 4 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 7074592..78c4da1 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -177,6 +177,14 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
 	struct cmd_ds_host_sleep cmd_config;
 	int ret;
 
+	/*
+	 * Certain firmware versions do not support EHS_REMOVE_WAKEUP command
+	 * and the card will return a failure.  Since we need to be
+	 * able to reset the mask, in those cases we set a 0 mask instead.
+	 */
+	if (criteria == EHS_REMOVE_WAKEUP && !priv->ehs_remove_supported)
+		criteria = 0;
+
 	cmd_config.hdr.size = cpu_to_le16(sizeof(cmd_config));
 	cmd_config.criteria = cpu_to_le32(criteria);
 	cmd_config.gpio = priv->wol_gpio;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index f062ed5..f5a9851 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -137,6 +137,7 @@ struct lbs_private {
 	uint32_t wol_criteria;
 	uint8_t wol_gpio;
 	uint8_t wol_gap;
+	bool ehs_remove_supported;
 
 	/* Transmitting */
 	int tx_pending_len;		/* -1 while building packet */
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 35931cf..6524c70 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -345,6 +345,13 @@ static int if_usb_probe(struct usb_interface *intf,
 	if (device_create_file(&priv->dev->dev, &dev_attr_lbs_flash_boot2))
 		lbs_pr_err("cannot register lbs_flash_boot2 attribute\n");
 
+	/*
+	 * EHS_REMOVE_WAKEUP is not supported on all versions of the firmware.
+	 */
+	priv->wol_criteria = EHS_REMOVE_WAKEUP;
+	if (lbs_host_sleep_cfg(priv, priv->wol_criteria, NULL))
+		priv->ehs_remove_supported = false;
+
 	return 0;
 
 err_start_card:
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 47ce5a6..6d7af91 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -844,9 +844,10 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 
-	priv->wol_criteria = 0xffffffff;
+	priv->wol_criteria = EHS_REMOVE_WAKEUP;
 	priv->wol_gpio = 0xff;
 	priv->wol_gap = 20;
+	priv->ehs_remove_supported = true;
 
 	goto done;
 
-- 
1.7.2.3

