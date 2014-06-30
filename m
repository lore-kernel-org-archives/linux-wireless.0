Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60281 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaF3JkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 05:40:22 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so5691431wiv.15
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 02:40:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix unregister deadlock when fw probe fails
Date: Mon, 30 Jun 2014 11:32:00 +0200
Message-Id: <1404120720-14649-1-git-send-email-michal.kazior@tieto.com> (sfid-20140630_114025_709935_2D0E99C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If firmware probing worker failed it called
device_release_driver() which synchronously called
remove() pci callback. The callback in turn waited
for the worker that called it to finish resulting
in a deadlock.

Waiting for a completion instead of a worker, like
some other drivers do, doesn't seem like the best
idea either:

  Syscall                 Worker

                          probe_fw()
  rmmod
  dev_lock()
  pci->remove()
  wait_for_completion()
                          complete_all()
                          device_release_driver()
                          dev_lock()
                          [sleep]
  free(ar)
  dev_unlock()
                          [resume]

There's no guarantee that Worker upon resuming can
still access any data/code of the module.

Leaving device bound to a driver is not as harmful
as deadlocking so remove the call to
device_release_driver() while a proper solution is
figured out.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 82017f5..b70e443 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -984,7 +984,9 @@ err_unregister_mac:
 err_release_fw:
 	ath10k_core_free_firmware_files(ar);
 err:
-	device_release_driver(ar->dev);
+	/* TODO: It's probably a good idea to release device from the driver
+	 * but calling device_release_driver() here will cause a deadlock.
+	 */
 	return;
 }
 
-- 
1.8.5.3

