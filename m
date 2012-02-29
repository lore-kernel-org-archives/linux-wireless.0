Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36689 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab2B2RTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:34 -0500
Subject: [PATCH 07/12] ath6kl: add ath6kl_bmi_read_hi32()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:29 +0200
Message-ID: <20120229171929.24264.39824.stgit@localhost6.localdomain6> (sfid-20120229_181940_305846_7AA9F40C)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are few 32 bit reads from the host interest area. Add
ath6kl_bmi_read_hi32() to make it easier to do that. As code is cleaner
this also fixes few checkpatch warnings.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.h  |    7 +++++++
 drivers/net/wireless/ath/ath6kl/init.c |   20 ++++----------------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index e6a7330..3c5b382 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -231,6 +231,13 @@ struct ath6kl_bmi_target_info {
 		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
 	})
 
+#define ath6kl_bmi_read_hi32(ar, item, val)				\
+	({								\
+		u32 addr, *check_type = val;				\
+		(void) (check_type == val);				\
+		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
+		ath6kl_bmi_read(ar, addr, (u8 *) val, 4);		\
+	})
 
 int ath6kl_bmi_init(struct ath6kl *ar);
 void ath6kl_bmi_cleanup(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index da5900d..d1d121d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -501,10 +501,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	/* set the firmware mode to STA/IBSS/AP */
 	param = 0;
 
-	if (ath6kl_bmi_read(ar,
-			    ath6kl_get_hi_item_addr(ar,
-			    HI_ITEM(hi_option_flag)),
-			    (u8 *)&param, 4) != 0) {
+	if (ath6kl_bmi_read_hi32(ar, hi_option_flag, &param) != 0) {
 		ath6kl_err("bmi_read_memory for setting fwmode failed\n");
 		return -EIO;
 	}
@@ -1074,17 +1071,11 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		ath6kl_bmi_write_hi32(ar, hi_board_data,
 				      ar->hw.board_addr);
 	} else {
-		ath6kl_bmi_read(ar,
-				ath6kl_get_hi_item_addr(ar,
-				HI_ITEM(hi_board_data)),
-				(u8 *) &board_address, 4);
+		ath6kl_bmi_read_hi32(ar, hi_board_data, &board_address);
 	}
 
 	/* determine where in target ram to write extended board data */
-	ath6kl_bmi_read(ar,
-			ath6kl_get_hi_item_addr(ar,
-			HI_ITEM(hi_board_ext_data)),
-			(u8 *) &board_ext_address, 4);
+	ath6kl_bmi_read_hi32(ar, hi_board_ext_data, &board_ext_address);
 
 	if (ar->target_type == TARGET_TYPE_AR6003 &&
 	    board_ext_address == 0) {
@@ -1177,10 +1168,7 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 	}
 
 	/* read firmware start address */
-	ret = ath6kl_bmi_read(ar,
-			      ath6kl_get_hi_item_addr(ar,
-						      HI_ITEM(hi_app_start)),
-			      (u8 *) &address, sizeof(address));
+	ret = ath6kl_bmi_read_hi32(ar, hi_app_start, &address);
 
 	if (ret) {
 		ath6kl_err("Failed to read hi_app_start: %d\n", ret);

