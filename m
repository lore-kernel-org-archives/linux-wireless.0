Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:51518 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3IHOzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:55:41 -0400
Subject: [PATCH 2/8] ath10k: rename ATH10K_DBG_CORE to BOOT
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:55:38 +0300
Message-ID: <20130908145538.3136.40193.stgit@localhost6.localdomain6> (sfid-20130908_165543_654745_61878372)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

core.c mostly deals with driver and firmware starting related
actions. And we can use the boot level also in other components,
like PCI and HTT.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |    6 +++---
 drivers/net/wireless/ath/ath10k/debug.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8a68839..0ed60fd 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -53,7 +53,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 
 static void ath10k_send_suspend_complete(struct ath10k *ar)
 {
-	ath10k_dbg(ATH10K_DBG_CORE, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_BOOT, "%s\n", __func__);
 
 	ar->is_target_paused = true;
 	wake_up(&ar->event_queue);
@@ -101,7 +101,7 @@ static int ath10k_init_connect_htc(struct ath10k *ar)
 		goto timeout;
 	}
 
-	ath10k_dbg(ATH10K_DBG_CORE, "core wmi ready\n");
+	ath10k_dbg(ATH10K_DBG_BOOT, "core wmi ready\n");
 	return 0;
 
 timeout:
@@ -203,7 +203,7 @@ static int ath10k_push_board_ext_data(struct ath10k *ar,
 		return ret;
 	}
 
-	ath10k_dbg(ATH10K_DBG_CORE,
+	ath10k_dbg(ATH10K_DBG_BOOT,
 		   "ath10k: Board extended Data download addr: 0x%x\n",
 		   board_ext_data_addr);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index dfa3070..4bef061 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -27,7 +27,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_HTC		= 0x00000004,
 	ATH10K_DBG_HTT		= 0x00000008,
 	ATH10K_DBG_MAC		= 0x00000010,
-	ATH10K_DBG_CORE		= 0x00000020,
+	ATH10K_DBG_BOOT		= 0x00000020,
 	ATH10K_DBG_PCI_DUMP	= 0x00000040,
 	ATH10K_DBG_HTT_DUMP	= 0x00000080,
 	ATH10K_DBG_MGMT		= 0x00000100,

