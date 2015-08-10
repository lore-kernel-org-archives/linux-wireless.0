Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36822 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbHJIBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 04:01:04 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Benjamin Romer <benjamin.romer@unisys.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, HPDD-discuss@lists.01.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 3/3] Staging: unisys: Remove useless cast on void pointer
Date: Mon, 10 Aug 2015 13:30:35 +0530
Message-Id: <1439193635-6063-3-git-send-email-shraddha.6596@gmail.com> (sfid-20150810_100205_976418_38DFCB79)
In-Reply-To: <1439193635-6063-1-git-send-email-shraddha.6596@gmail.com>
References: <1439193635-6063-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

void pointers do not need to be cast to other pointer types.

The semantic patch used to find this:

@r@
expression x;
void* e;
type T;
identifier f;
@@
(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T *)x)->f
|
- (T *)
  e
)

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/unisys/visorbus/visorbus_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/unisys/visorbus/visorbus_main.c b/drivers/staging/unisys/visorbus/visorbus_main.c
index 403c13b..db4282f 100644
--- a/drivers/staging/unisys/visorbus/visorbus_main.c
+++ b/drivers/staging/unisys/visorbus/visorbus_main.c
@@ -677,7 +677,7 @@ unregister_driver_attributes(struct visor_driver *drv)
 static void
 dev_periodic_work(void *xdev)
 {
-	struct visor_device *dev = (struct visor_device *)xdev;
+	struct visor_device *dev = xdev;
 	struct visor_driver *drv = to_visor_driver(dev->device.driver);
 
 	down(&dev->visordriver_callback_lock);
-- 
2.1.0

