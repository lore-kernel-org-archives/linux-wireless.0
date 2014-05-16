Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbaEPOLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 10:11:47 -0400
From: Frederic Danis <frederic.danis@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Frederic Danis <frederic.danis@linux.intel.com>
Subject: [PATCH] ath6kl: Fix ath6kl_bmi_read_hi32 macro
Date: Fri, 16 May 2014 16:11:44 +0200
Message-Id: <1400249504-23739-1-git-send-email-frederic.danis@linux.intel.com> (sfid-20140516_161150_871533_C5031768)
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tmp may be used uninitialized if ath6kl_bmi_read() returns an error.

Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
 
-- 
1.7.9.5

