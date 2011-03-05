Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46136 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1CEEYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 23:24:19 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: make a shorter name of hotplug_device
Date: Fri,  4 Mar 2011 20:27:06 -0800
Message-Id: <1299299227-8849-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change "struct device *hotplug_device;" to "struct device *dev;"

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |    5 ++---
 drivers/net/wireless/mwifiex/main.h |    2 +-
 drivers/net/wireless/mwifiex/sdio.c |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index e08b7a0..df97e79 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -433,8 +433,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	default:
 		break;
 	}
-	err = request_firmware(&adapter->firmware, fw_name,
-			       adapter->hotplug_device);
+	err = request_firmware(&adapter->firmware, fw_name, adapter->dev);
 
 	if (err < 0) {
 		PRINTM(MFATAL, "request_firmware() failed, error code =%#x\n",
@@ -759,7 +758,7 @@ static struct mwifiex_private *mwifiex_add_interface(
 
 	mwifiex_init_priv_params(priv, dev);
 
-	SET_NETDEV_DEV(dev, adapter->hotplug_device);
+	SET_NETDEV_DEV(dev, adapter->dev);
 
 	/* Register network device */
 	if (register_netdev(dev)) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0211942..41aeebd 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -515,7 +515,7 @@ struct mwifiex_adapter {
 	u8 priv_num;
 	struct mwifiex_drv_mode *drv_mode;
 	const struct firmware *firmware;
-	struct device *hotplug_device;
+	struct device *dev;
 	bool surprise_removed;
 	u32 fw_release_number;
 	u32 revision_id;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 0144ecf..4df8186 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1584,7 +1584,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	sdio_release_host(func);
 	sdio_set_drvdata(func, card);
 
-	adapter->hotplug_device = &func->dev;
+	adapter->dev = &func->dev;
 
 	return 0;
 
@@ -1907,7 +1907,7 @@ mwifiex_sdio_cleanup_module(void)
 		goto exit;
 
 	if (adapter->is_suspended)
-		mwifiex_sdio_resume(adapter->hotplug_device);
+		mwifiex_sdio_resume(adapter->dev);
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		if ((GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_STA) &&
-- 
1.7.0.2

