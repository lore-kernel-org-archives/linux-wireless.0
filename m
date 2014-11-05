Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37229 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbaKEIi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 03:38:56 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <cluo@marvell.com>,
	<yangyang@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: module load parameter for interface creation
Date: Wed, 5 Nov 2014 19:38:11 +0530
Message-ID: <1415196491-25391-1-git-send-email-patila@marvell.com> (sfid-20141105_093859_779701_4AEAB3EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds module load parameter driver_mode for mwifiex
which would enable driver to create AP or P2P client interface while loading
module. driver_mode is bitmap of interface modes for station, AP and
P2P client.

Station interface is created by default and is unaffected by driver_mode
parameter.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 32 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h |  5 +++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2a5a59b..2de8a6a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -28,6 +28,11 @@ const char driver_version[] = "mwifiex " VERSION " (%s) ";
 static char *cal_data_cfg;
 module_param(cal_data_cfg, charp, 0);
 
+static unsigned short driver_mode;
+module_param(driver_mode, ushort, 0);
+MODULE_PARM_DESC(driver_mode,
+		 "station=0x1(default), ap-sta=0x3, station-p2p=0x5, ap-sta-p2p=0x7");
+
 /*
  * This function registers the device and performs all the necessary
  * initializations.
@@ -449,6 +454,11 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		goto err_init_fw;
 	}
 
+	if (driver_mode) {
+		driver_mode &= MWIFIEX_DRIVER_MODE_BITMASK;
+		driver_mode |= MWIFIEX_DRIVER_MODE_STA;
+	}
+
 	rtnl_lock();
 	/* Create station interface by default */
 	wdev = mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d",
@@ -458,6 +468,28 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		rtnl_unlock();
 		goto err_add_intf;
 	}
+
+	if (driver_mode & MWIFIEX_DRIVER_MODE_UAP) {
+		wdev = mwifiex_add_virtual_intf(adapter->wiphy, "uap%d",
+						NL80211_IFTYPE_AP, NULL, NULL);
+		if (IS_ERR(wdev)) {
+			dev_err(adapter->dev, "cannot create AP interface\n");
+			rtnl_unlock();
+			goto err_add_intf;
+		}
+	}
+
+	if (driver_mode & MWIFIEX_DRIVER_MODE_P2P) {
+		wdev = mwifiex_add_virtual_intf(adapter->wiphy, "p2p%d",
+						NL80211_IFTYPE_P2P_CLIENT, NULL,
+						NULL);
+		if (IS_ERR(wdev)) {
+			dev_err(adapter->dev,
+				"cannot create p2p client interface\n");
+			rtnl_unlock();
+			goto err_add_intf;
+		}
+	}
 	rtnl_unlock();
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5feaffb..1038cf8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -48,6 +48,11 @@ enum {
 	MWIFIEX_SYNC_CMD
 };
 
+#define MWIFIEX_DRIVER_MODE_STA			BIT(0)
+#define MWIFIEX_DRIVER_MODE_UAP			BIT(1)
+#define MWIFIEX_DRIVER_MODE_P2P			BIT(2)
+#define MWIFIEX_DRIVER_MODE_BITMASK		(BIT(0) | BIT(1) | BIT(2))
+
 #define MWIFIEX_MAX_AP				64
 
 #define MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT	(5 * HZ)
-- 
1.8.1.4

