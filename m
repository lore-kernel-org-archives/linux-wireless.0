Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:38184 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3CIKBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 05:01:39 -0500
Subject: [PATCH v2 1/3] ath6kl: cleanup ath6kl_reset_device()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 12:01:35 +0200
Message-ID: <20130309100135.432.44516.stgit@localhost6.localdomain6> (sfid-20130309_110142_268163_AE96BFED)
In-Reply-To: <20130309100031.432.94974.stgit@localhost6.localdomain6>
References: <20130309100031.432.94974.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move it to init.c, make it static, remove all useless checks and force it to
always do cold reset.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h   |    2 --
 drivers/net/wireless/ath/ath6kl/init.c   |   12 ++++++++---
 drivers/net/wireless/ath/ath6kl/main.c   |   33 ------------------------------
 drivers/net/wireless/ath/ath6kl/target.h |    2 +-
 4 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1c9ed40..26b0f92 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -935,8 +935,6 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 			     u8 win_sz);
 void ath6kl_wakeup_event(void *dev);
 
-void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
-			 bool wait_fot_compltn, bool cold_reset);
 void ath6kl_init_control_info(struct ath6kl_vif *vif);
 struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
 void ath6kl_cfg80211_vif_stop(struct ath6kl_vif *vif, bool wmi_ready);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 3e45adc..ae1e477 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1619,6 +1619,14 @@ static void ath6kl_init_get_fwcaps(struct ath6kl *ar, char *buf, size_t buf_len)
 	buf[len] = '\0';
 }
 
+static int ath6kl_init_hw_reset(struct ath6kl *ar)
+{
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "cold resetting the device");
+
+	return ath6kl_diag_write32(ar, RESET_CONTROL_ADDRESS,
+				   cpu_to_le32(RESET_CONTROL_COLD_RST));
+}
+
 static int __ath6kl_init_hw_start(struct ath6kl *ar)
 {
 	long timeleft;
@@ -1836,9 +1844,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 	 * Try to reset the device if we can. The driver may have been
 	 * configure NOT to reset the target during a debug session.
 	 */
-	ath6kl_dbg(ATH6KL_DBG_TRC,
-		   "attempting to reset target on instance destroy\n");
-	ath6kl_reset_device(ar, ar->target_type, true, true);
+	ath6kl_init_hw_reset(ar);
 
 	up(&ar->sem);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index bd50b6b..bad62b3 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -345,39 +345,6 @@ out:
 	return ret;
 }
 
-/* FIXME: move to a better place, target.h? */
-#define AR6003_RESET_CONTROL_ADDRESS 0x00004000
-#define AR6004_RESET_CONTROL_ADDRESS 0x00004000
-
-void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
-			 bool wait_fot_compltn, bool cold_reset)
-{
-	int status = 0;
-	u32 address;
-	__le32 data;
-
-	if (target_type != TARGET_TYPE_AR6003 &&
-	    target_type != TARGET_TYPE_AR6004)
-		return;
-
-	data = cold_reset ? cpu_to_le32(RESET_CONTROL_COLD_RST) :
-			    cpu_to_le32(RESET_CONTROL_MBOX_RST);
-
-	switch (target_type) {
-	case TARGET_TYPE_AR6003:
-		address = AR6003_RESET_CONTROL_ADDRESS;
-		break;
-	case TARGET_TYPE_AR6004:
-		address = AR6004_RESET_CONTROL_ADDRESS;
-		break;
-	}
-
-	status = ath6kl_diag_write32(ar, address, data);
-
-	if (status)
-		ath6kl_err("failed to reset target\n");
-}
-
 static void ath6kl_install_static_wep_keys(struct ath6kl_vif *vif)
 {
 	u8 index;
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index a98c12b..a580a62 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -25,7 +25,7 @@
 #define AR6004_BOARD_DATA_SZ     6144
 #define AR6004_BOARD_EXT_DATA_SZ 0
 
-#define RESET_CONTROL_ADDRESS		0x00000000
+#define RESET_CONTROL_ADDRESS		0x00004000
 #define RESET_CONTROL_COLD_RST		0x00000100
 #define RESET_CONTROL_MBOX_RST		0x00000004
 

