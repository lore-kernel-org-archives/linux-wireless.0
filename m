Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38768 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1HCBgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 21:36:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: print driver version information
Date: Tue,  2 Aug 2011 18:42:23 -0700
Message-Id: <1312335743-4738-1-git-send-email-bzhao@marvell.com> (sfid-20110803_033653_323808_28F35041)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Add code to display driver version information in dmesg after
loading the driver successfully.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index e5fc53d..53579ad 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -849,6 +849,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 {
 	int i;
 	struct mwifiex_adapter *adapter;
+	char fmt[64];
 
 	if (down_interruptible(sem))
 		goto exit_sem_err;
@@ -897,6 +898,9 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 
 	up(sem);
 
+	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
+	dev_notice(adapter->dev, "driver_version = %s\n", fmt);
+
 	return 0;
 
 err_add_intf:
-- 
1.7.0.2

