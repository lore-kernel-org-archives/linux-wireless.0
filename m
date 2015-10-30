Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56746 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030341AbbJ3Jpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:45:31 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 11/17] staging: wilc1000: wilc_wlan_firmware_download: add argument net_device
Date: Fri, 30 Oct 2015 18:47:17 +0900
Message-ID: <1446198443-6623-11-git-send-email-glen.lee@atmel.com> (sfid-20151030_104654_570889_3701D844)
In-Reply-To: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new argument struct net_device and pass dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c  | 3 ++-
 drivers/staging/wilc1000/wilc_wlan.h  | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1019a19..bb37f5b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -624,7 +624,7 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(wilc->firmware->data,
+	ret = wilc_wlan_firmware_download(dev, wilc->firmware->data,
 					  wilc->firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c464cd7..e8afa6b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1415,7 +1415,8 @@ void wilc_handle_isr(void *wilc)
  *      Firmware download
  *
  ********************************************/
-int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
+int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
+				u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index fa66783..194c24c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -295,7 +295,8 @@ typedef struct {
 	u32 seq_no;
 } wilc_cfg_rsp_t;
 
-int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
+int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
+				u32 buffer_size);
 int wilc_wlan_start(void);
 int wilc_wlan_stop(struct net_device *dev);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
-- 
1.9.1

