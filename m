Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31414 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaEPONb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 10:13:31 -0400
From: Frederic Danis <frederic.danis@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	ath10k@lists.infradead.org,
	Frederic Danis <frederic.danis@linux.intel.com>
Subject: [PATCH] ath10k: Fix ath10k_bmi_read32 macro
Date: Fri, 16 May 2014 16:13:21 +0200
Message-Id: <1400249601-24899-1-git-send-email-frederic.danis@linux.intel.com> (sfid-20140516_161334_305001_8537F44C)
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tmp may be used uninitialized if ath10k_bmi_read_memory() returns
an error.

Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>
---
 drivers/net/wireless/ath/ath10k/bmi.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 3a9bdf51..111ab70 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -201,7 +201,8 @@ int ath10k_bmi_write_memory(struct ath10k *ar, u32 address,
 									\
 		addr = host_interest_item_address(HI_ITEM(item));	\
 		ret = ath10k_bmi_read_memory(ar, addr, (u8 *)&tmp, 4); \
-		*val = __le32_to_cpu(tmp);				\
+		if (!ret)						\
+			*val = __le32_to_cpu(tmp);			\
 		ret;							\
 	 })
 
-- 
1.7.9.5

