Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:43949 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3CHK1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 05:27:14 -0500
Subject: [PATCH 3/3] ath6kl: cold reset target after host warm boot
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Fri, 08 Mar 2013 12:27:11 +0200
Message-ID: <20130308102711.23245.98569.stgit@localhost6.localdomain6> (sfid-20130308_112716_777007_D5B74662)
In-Reply-To: <20130308102539.23245.55176.stgit@localhost6.localdomain6>
References: <20130308102539.23245.55176.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julien reported that ar6004 usb device fails to initialise after host has been rebooted and
power is still on for the ar6004 device. He found out that doing a cold reset fixes the issue.

I wasn't sure what would be the best way to detect if target needs a reset so I settled on
checking a timeout from htc_wait_recv_ctrl_message().

Reported-by: Julien Massot <jmassot@aldebaran-robotics.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   19 ++++++++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index c02d9d3..67aa924 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -1168,7 +1168,7 @@ static int htc_wait_recv_ctrl_message(struct htc_target *target)
 
 	if (count <= 0) {
 		ath6kl_warn("htc pipe control receive timeout!\n");
-		return -ECOMM;
+		return -ETIMEDOUT;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 8b01ec3..ecf196f 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1658,7 +1658,18 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 	 * size.
 	 */
 	ret = ath6kl_htc_wait_target(ar->htc_target);
-	if (ret) {
+
+	if (ret == -ETIMEDOUT) {
+		/*
+		 * Most likely USB target is in odd state after reboot and
+		 * needs a reset. A cold reset makes the whole device
+		 * disappear from USB bus and initialisation starts from
+		 * beginning.
+		 */
+		ath6kl_warn("htc wait target timed out, resetting device\n");
+		ath6kl_init_hw_reset(ar);
+		goto err_power_off;
+	} else if (ret) {
 		ath6kl_err("htc wait target failed: %d\n", ret);
 		goto err_power_off;
 	}
@@ -1842,12 +1853,6 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		ath6kl_htc_stop(ar->htc_target);
 	}
 
-	/*
-	 * Try to reset the device if we can. The driver may have been
-	 * configure NOT to reset the target during a debug session.
-	 */
-	ath6kl_init_hw_reset(ar);
-
 	up(&ar->sem);
 }
 EXPORT_SYMBOL(ath6kl_stop_txrx);

