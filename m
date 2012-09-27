Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:41127 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2I0Kio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:44 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Yair Shapira <yair.shapira@ti.com>
Subject: [PATCH 21/31] wlcore/wl18xx: add phy_fw_version_str to debugfs driver_state
Date: Thu, 27 Sep 2012 13:37:59 +0300
Message-Id: <1348742289-6587-22-git-send-email-luca@coelho.fi> (sfid-20120927_123859_124310_524DE753)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

add phy_fw_version_str to debugfs driver_state file.
information is taken during boot and stored in wl->chip.phy_fw_ver_str.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/main.c     |    6 ++++++
 drivers/net/wireless/ti/wlcore/debugfs.c  |    1 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ae6920b..fa7e6ef 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1201,6 +1201,12 @@ static int wl18xx_handle_static_data(struct wl1271 *wl,
 	struct wl18xx_static_data_priv *static_data_priv =
 		(struct wl18xx_static_data_priv *) static_data->priv;
 
+	strncpy(wl->chip.phy_fw_ver_str, static_data_priv->phy_version,
+		sizeof(wl->chip.phy_fw_ver_str));
+
+	/* make sure the string is NULL-terminated */
+	wl->chip.phy_fw_ver_str[sizeof(wl->chip.phy_fw_ver_str) - 1] = '\0';
+
 	wl1271_info("PHY firmware version: %s", static_data_priv->phy_version);
 
 	return 0;
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 3b7e0e8..3d39784d 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -489,6 +489,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(platform_quirks);
 	DRIVER_STATE_PRINT_HEX(chip.id);
 	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);
+	DRIVER_STATE_PRINT_STR(chip.phy_fw_ver_str);
 	DRIVER_STATE_PRINT_INT(sched_scanning);
 
 #undef DRIVER_STATE_PRINT_INT
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index a7472bf..496e7c6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -123,6 +123,7 @@ struct wl1271_chip {
 	u32 id;
 	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
 	unsigned int fw_ver[NUM_FW_VER];
+	char phy_fw_ver_str[ETHTOOL_BUSINFO_LEN];
 };
 
 #define NUM_TX_QUEUES              4
-- 
1.7.10.4

