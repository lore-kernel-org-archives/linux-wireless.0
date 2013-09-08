Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:33693 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3IHOzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:55:46 -0400
Subject: [PATCH 3/8] ath10k: cleanup debug messages in core.c
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:55:44 +0300
Message-ID: <20130908145544.3136.77144.stgit@localhost6.localdomain6> (sfid-20130908_165549_232616_1DA453D6)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix them to follow the general logging style in ath10k.

While at it, add print id chip_id to the debug log.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0ed60fd..76906d5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -53,7 +53,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 
 static void ath10k_send_suspend_complete(struct ath10k *ar)
 {
-	ath10k_dbg(ATH10K_DBG_BOOT, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot suspend complete\n");
 
 	ar->is_target_paused = true;
 	wake_up(&ar->event_queue);
@@ -101,7 +101,7 @@ static int ath10k_init_connect_htc(struct ath10k *ar)
 		goto timeout;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "core wmi ready\n");
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot wmi ready\n");
 	return 0;
 
 timeout:
@@ -204,7 +204,7 @@ static int ath10k_push_board_ext_data(struct ath10k *ar,
 	}
 
 	ath10k_dbg(ATH10K_DBG_BOOT,
-		   "ath10k: Board extended Data download addr: 0x%x\n",
+		   "boot push board extended data addr 0x%x\n",
 		   board_ext_data_addr);
 
 	if (board_ext_data_addr == 0)
@@ -722,6 +722,9 @@ static int ath10k_core_check_chip_id(struct ath10k *ar)
 {
 	u32 hw_revision = MS(ar->chip_id, SOC_CHIP_ID_REV);
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot chip_id 0x%08x hw_revision 0x%x\n",
+		   ar->chip_id, hw_revision);
+
 	/* Check that we are not using hw1.0 (some of them have same pci id
 	 * as hw2.0) before doing anything else as ath10k crashes horribly
 	 * due to missing hw1.0 workarounds. */

