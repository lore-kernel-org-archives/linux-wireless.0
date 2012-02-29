Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44811 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2B2RUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:20:16 -0500
Subject: [PATCH 12/12] ath6kl: make ath6kl_bmi_[read|write]_hi32() endian safe
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:20:11 +0200
Message-ID: <20120229172011.24264.76618.stgit@localhost6.localdomain6> (sfid-20120229_182028_735897_D79A526B)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl_bmi_[read|write]_hi32() did not have endian support, fix that.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 3c5b382..18fdd69 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -225,18 +225,25 @@ struct ath6kl_bmi_target_info {
 
 #define ath6kl_bmi_write_hi32(ar, item, val)				\
 	({								\
-		u32 addr, v;						\
+		u32 addr;						\
+		__le32 v;						\
+									\
 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
-		v = val;						\
+		v = cpu_to_le32(val);					\
 		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
 	})
 
 #define ath6kl_bmi_read_hi32(ar, item, val)				\
 	({								\
 		u32 addr, *check_type = val;				\
+		__le32 tmp;						\
+		int ret;						\
+									\
 		(void) (check_type == val);				\
 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
-		ath6kl_bmi_read(ar, addr, (u8 *) val, 4);		\
+		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
+		*val = le32_to_cpu(tmp);				\
+		ret;							\
 	})
 
 int ath6kl_bmi_init(struct ath6kl *ar);

