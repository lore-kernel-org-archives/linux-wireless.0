Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36061 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbcDNPTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 11:19:09 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: fix double unlock
Date: Thu, 14 Apr 2016 20:48:48 +0530
Message-Id: <1460647129-22740-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160414_172008_412859_C950B3F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore was being released twice, once at the beginning of the
thread and then again when the thread is about to close.
The semaphore is acquired immediately after creating the thread so we
should be releasing it when the thread ends.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/staging/wilc1000/linux_wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a858552..5643a3d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -313,7 +313,6 @@ static int linux_wlan_txq_task(void *vp)
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
 
-	up(&wl->txq_thread_started);
 	while (1) {
 		down(&wl->txq_event);
 
-- 
1.9.1

