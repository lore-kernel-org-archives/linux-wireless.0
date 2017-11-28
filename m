Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:9742 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdK1ICN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 03:02:13 -0500
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] wlcore: allow elp during wowlan suspend
Date: Tue, 28 Nov 2017 08:02:07 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B364A3796@DFRE01.ent.ti.com> (sfid-20171128_090235_564740_20A5A38B)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when enabling wowlan and entering suspend the last write to the firmware
allowing it to go into elp mode was not completing before suspend, leaving
the firmware running in full active mode consuming high power.
Use an immediate call instead of a work queue for this last access
allowing the firmware to go into power save during wowlan uspend.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/t=
i/wlcore/main.c
index 792cb91..1c31555 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -42,6 +42,7 @@
 #include "sysfs.h"
=20
 #define WL1271_BOOT_RETRIES 3
+#define WL1271_SUSPEND_SLEEP 100
=20
 static char *fwlog_param;
 static int fwlog_mem_blocks =3D -1;
@@ -979,6 +980,24 @@ static int wlcore_fw_wakeup(struct wl1271 *wl)
 	return wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
 }
=20
+static int wlcore_fw_sleep(struct wl1271 *wl)
+{
+	int ret;
+
+	mutex_lock(&wl->mutex);
+	ret =3D wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
+	if (ret < 0) {
+		wl12xx_queue_recovery_work(wl);
+		goto out;
+	}
+	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
+out:
+	mutex_unlock(&wl->mutex);
+	mdelay(WL1271_SUSPEND_SLEEP);
+
+	return 0;
+}
+
 static int wl1271_setup(struct wl1271 *wl)
 {
 	wl->raw_fw_status =3D kzalloc(wl->fw_status_len, GFP_KERNEL);
@@ -1750,7 +1769,6 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 		goto out_sleep;
=20
 out_sleep:
-	wl1271_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
=20
 	if (ret < 0) {
@@ -1783,6 +1801,15 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw=
,
 	 */
 	cancel_delayed_work(&wl->tx_watchdog_work);
=20
+	/*
+	 * Use an immediate call for allowing the firmware to go into power
+	 * save during suspend.
+	 * Using a workque for this last write was only hapenning on resume
+	 * leaving the firmware with power save disabled during suspend,
+	 * while consuming full power during wowlan suspend.
+	 */
+	wlcore_fw_sleep(wl);
+
 	return 0;
 }
=20
--=20
2.7.4
