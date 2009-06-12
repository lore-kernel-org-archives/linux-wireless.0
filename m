Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38971 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZFLLPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:15:39 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 11/33] wl12xx: moved firmware version reading routine to
	chip-specific functions
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:27 +0300
Message-ID: <20090612111527.8877.69871.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

With WL1271, the firmware version can only be read right after booting the
chip.  To keep WL1251 aligned with this procedure, the code that reads the
firmware version initially has been moved to a common place where it can be
read from both chipsets.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/boot.c   |    2 ++
 drivers/net/wireless/wl12xx/wl1251.c |    9 ++++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 48ac08c..a6a2649 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -269,6 +269,8 @@ int wl12xx_boot_run_firmware(struct wl12xx *wl)
 	wl12xx_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
 		     wl->cmd_box_addr, wl->event_box_addr);
 
+	wl->chip.op_fw_version(wl);
+
 	/*
 	 * in case of full asynchronous mode the firmware event must be
 	 * ready to receive event from the command mailbox
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index e484a23..b793325 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -288,9 +288,6 @@ static int wl1251_boot(struct wl12xx *wl)
 	if (ret < 0)
 		goto out;
 
-	/* Get and save the firmware version */
-	wl12xx_acx_fw_version(wl, wl->chip.fw_ver, sizeof(wl->chip.fw_ver));
-
 out:
 	return ret;
 }
@@ -394,6 +391,11 @@ static void wl1251_target_enable_interrupts(struct wl12xx *wl)
 	wl12xx_boot_target_enable_interrupts(wl);
 }
 
+static void wl1251_fw_version(struct wl12xx *wl)
+{
+	wl12xx_acx_fw_version(wl, wl->chip.fw_ver, sizeof(wl->chip.fw_ver));
+}
+
 static void wl1251_irq_work(struct work_struct *work)
 {
 	u32 intr;
@@ -709,6 +711,7 @@ void wl1251_setup(struct wl12xx *wl)
 	wl->chip.op_target_enable_interrupts = wl1251_target_enable_interrupts;
 	wl->chip.op_hw_init = wl1251_hw_init;
 	wl->chip.op_plt_init = wl1251_plt_init;
+	wl->chip.op_fw_version = wl1251_fw_version;
 
 	wl->chip.p_table = wl1251_part_table;
 	wl->chip.acx_reg_table = wl1251_acx_reg_table;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b874214..32f62a6 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -163,6 +163,7 @@ struct wl12xx_chip {
 	void (*op_target_enable_interrupts)(struct wl12xx *wl);
 	int (*op_hw_init)(struct wl12xx *wl);
 	int (*op_plt_init)(struct wl12xx *wl);
+	void (*op_fw_version)(struct wl12xx *wl);
 
 	struct wl12xx_partition_set *p_table;
 	enum wl12xx_acx_int_reg *acx_reg_table;

