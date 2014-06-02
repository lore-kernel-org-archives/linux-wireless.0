Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23319 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbaFBMSP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 08:18:15 -0400
From: Frederic Danis <frederic.danis@linux.intel.com>
To: kvalo@qca.qualcomm.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath6kl@lists.infradead.org,
	Frederic Danis <frederic.danis@linux.intel.com>
Subject: [PATCH v2] ath6kl: Fix ath6kl_bmi_read_hi32 macro
Date: Mon,  2 Jun 2014 14:17:50 +0200
Message-Id: <1401711470-31267-1-git-send-email-frederic.danis@linux.intel.com> (sfid-20140602_141824_614422_FD11C159)
In-Reply-To: <87oayi6mei.fsf@kamboji.qca.qualcomm.com>
References: <87oayi6mei.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tmp may be used uninitialized if ath6kl_bmi_read() returns an error.

Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.h  |    3 ++-
 drivers/net/wireless/ath/ath6kl/init.c |   12 ++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 18fdd69..397a52f 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -242,7 +242,8 @@ struct ath6kl_bmi_target_info {
 		(void) (check_type == val);				\
 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
 		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
-		*val = le32_to_cpu(tmp);				\
+		if (!ret)						\
+			*val = le32_to_cpu(tmp);			\
 		ret;							\
 	})
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d5ef211..6e1e699 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1161,11 +1161,19 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		ath6kl_bmi_write_hi32(ar, hi_board_data,
 				      board_address);
 	} else {
-		ath6kl_bmi_read_hi32(ar, hi_board_data, &board_address);
+		ret = ath6kl_bmi_read_hi32(ar, hi_board_data, &board_address);
+		if (ret) {
+			ath6kl_err("Failed to get board file target address.\n");
+			return ret;
+		}
 	}
 
 	/* determine where in target ram to write extended board data */
-	ath6kl_bmi_read_hi32(ar, hi_board_ext_data, &board_ext_address);
+	ret = ath6kl_bmi_read_hi32(ar, hi_board_ext_data, &board_ext_address);
+	if (ret) {
+		ath6kl_err("Failed to get extended board file target address.\n");
+		return ret;
+	}
 
 	if (ar->target_type == TARGET_TYPE_AR6003 &&
 	    board_ext_address == 0) {
-- 
1.7.9.5

