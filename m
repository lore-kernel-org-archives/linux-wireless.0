Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:44438 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbcATHg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 02:36:58 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH v2 2/6] wireless:libertas: check whether bus can do more than polling
Date: Wed, 20 Jan 2016 08:35:35 +0100
Message-Id: <1453275339-25122-3-git-send-email-andreas@kemnade.info> (sfid-20160120_083705_617277_03317A27)
In-Reply-To: <1453275339-25122-1-git-send-email-andreas@kemnade.info>
References: <1453275339-25122-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a sdio host does not support sdio irqs, polling is used
instead. That has an impact on performance. Some functionality
should not be enabled then. This add a variable in
libertas_priv to indicate that.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/net/wireless/libertas/dev.h     | 1 +
 drivers/net/wireless/libertas/if_sdio.c | 2 +-
 drivers/net/wireless/libertas/if_usb.c  | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 6bd1608..edf710b 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -99,6 +99,7 @@ struct lbs_private {
 	/* Hardware access */
 	void *card;
 	bool iface_running;
+	u8 is_polling; /* host has to poll the card irq */
 	u8 fw_ready;
 	u8 surpriseremoved;
 	u8 setup_fw_on_resume;
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index f1f31a2..13db8b5 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1271,7 +1271,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	priv->reset_card = if_sdio_reset_card;
 	priv->power_save = if_sdio_power_save;
 	priv->power_restore = if_sdio_power_restore;
-
+	priv->is_polling = !(func->card->host->caps & MMC_CAP_SDIO_IRQ);
 	ret = if_sdio_power_on(card);
 	if (ret)
 		goto err_activate_card;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index dff08a2..aba0c99 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -267,6 +267,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->enter_deep_sleep = NULL;
 	priv->exit_deep_sleep = NULL;
 	priv->reset_deep_sleep_wakeup = NULL;
+	priv->is_polling = false;
 #ifdef CONFIG_OLPC
 	if (machine_is_olpc())
 		priv->reset_card = if_usb_reset_olpc_card;
-- 
2.1.4

