Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6397369D75
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142365; cv=none; b=iz01McXN+23clxUi8GuB8xDpzW4NEaBbx05GBHr1xn3NL3Jf6XGYF9QSP9rYe5Mqdyxz9alrnSShNCn7GggqQpAyIszZx/su2M0S38vkLcMQrpNAtOTyuSnR15StM0vS3ONUSRwM9WyJ0/Par+TqQgGjZWsawjGHiS95tLhI5l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142365; c=relaxed/simple;
	bh=RvCi/azPGbB0H1RoTWPkKLzx9f1RbSsU9Vx2Pjmxex4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXoFYozz78If2ENuAEIPEAeHo57NrtqfH4fPLRFL9Y9I2VpxnY+9YELRteTqoNkCpVoQ1th9aiE1IflIMkn3Ww8h3iDMjNWvOkMBk4GIvaR+GCNBU6K31KzpOMzeey6pncKih/6yx8mRo1dRGYax+xOXmGYj1zq2LvbJh1uwxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=J7aVxvtf; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="J7aVxvtf"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5jxxS7097477, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142361; bh=vt0d7h/gcktymn+qksyBeH1DgPXO1zRLllKRFz+QJ0U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=J7aVxvtfYQ05WWDkS4DQ+LPosgFVwuucHZ0zQIsd6T+78OfPxl1gG8mGP14KXjfs0
	 DTpaau+AUVMG/NNveibkmvreQ5J4oSlQlmo8nlqQ8+teZ6/li9us9orz/unEqn2nMw
	 vAsEtBHQr0IsWHpPzIaQ8PPOX1aLcsWI45mlzrsgYjuR88Wvl4ugfuc2lygnWfL6T1
	 KN1m71rhX7MUJcQab48mCaLDxcsS2LkzkVG4sefx9wEP8hdMl2pr/TyEh60XIGurDn
	 Aghxi8tVsRJQvDhb6uqI7DP29oj0teQ4NY0XQ8uneVyODcu7EZPUa9cjaZiaEtSyCu
	 sYq47IWdxJ1WA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5jxxS7097477
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:46:00 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:45:59 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:45:59 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:45:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 3/6] wifi: rtw89: fw: duplicate firmware suit data by vmalloc to reduce memory fragment
Date: Wed, 23 Sep 2026 13:45:02 +0800
Message-ID: <20260923054505.43329-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923054505.43329-1-pkshih@realtek.com>
References: <20260923054505.43329-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The firmware suit data might be just over 512kB (e.g. 540kB) and actual
allocation size of devm_kmemdup() can be 1MB, which is a big internal
fragment. Use vmalooc() instead to reduce fragment.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c |  1 +
 drivers/net/wireless/realtek/rtw89/core.h |  3 ++
 drivers/net/wireless/realtek/rtw89/fw.c   | 52 ++++++++++++++++++-----
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 5ca0c401c43a..e61d7e89882f 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -6986,6 +6986,7 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
 	}
 	INIT_LIST_HEAD(&rtwdev->scan_info.chan_list);
 	INIT_LIST_HEAD(&rtwdev->tx_waits);
+	INIT_LIST_HEAD(&rtwdev->fw.dup_data_list);
 	INIT_WORK(&rtwdev->ba_work, rtw89_core_ba_work);
 	INIT_WORK(&rtwdev->txq_work, rtw89_core_txq_work);
 	INIT_DELAYED_WORK(&rtwdev->txq_reinvoke_work, rtw89_core_txq_reinvoke_work);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 4b4500a7a068..d8adf7425a3a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6059,6 +6059,7 @@ enum rtw89_fw_feature {
 struct rtw89_fw_suit {
 	enum rtw89_fw_type type;
 	const u8 *data;
+	struct list_head list;
 	u32 size;
 	u8 major_ver;
 	u8 minor_ver;
@@ -6150,6 +6151,8 @@ struct rtw89_fw_info {
 	struct rtw89_fw_elm_info elm_info;
 	struct rtw89_fw_secure sec;
 
+	struct list_head dup_data_list;
+
 	DECLARE_BITMAP(feature_map, NUM_OF_RTW89_FW_FEATURES);
 };
 
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index e4b59690622d..7c7c0a4f703e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/if_arp.h>
+#include <linux/vmalloc.h>
 #include "cam.h"
 #include "chan.h"
 #include "coex.h"
@@ -138,15 +139,23 @@ int rtw89_fw_check_rdy(struct rtw89_dev *rtwdev, enum rtw89_fwdl_check_type type
 }
 
 static const void *__rtw89_fw_elem_dup_if_needed(struct rtw89_dev *rtwdev,
-						 const void *src, size_t len)
+						 const void *src, size_t len,
+						 bool is_fw_suit)
 {
 	struct rtw89_fw_req_info *fw_req = &rtwdev->fw.req;
-	const void *dup;
+	void *dup;
 
 	if (!fw_req->free_after_probe)
 		return src;
 
-	dup = devm_kmemdup(rtwdev->dev, src, len, GFP_KERNEL);
+	if (is_fw_suit) {
+		dup = vmalloc(len);
+		if (dup)
+			memcpy(dup, src, len);
+	} else {
+		dup = devm_kmemdup(rtwdev->dev, src, len, GFP_KERNEL);
+	}
+
 	if (!dup) {
 		/* If failed to memdup, fallback to point to firmware->data. */
 		fw_req->free_after_probe = false;
@@ -161,7 +170,22 @@ static const void *rtw89_fw_elem_dup_if_needed(struct rtw89_dev *rtwdev,
 {
 	size_t len = sizeof(*elm) + le32_to_cpu(elm->size);
 
-	return __rtw89_fw_elem_dup_if_needed(rtwdev, elm, len);
+	return __rtw89_fw_elem_dup_if_needed(rtwdev, elm, len, false);
+}
+
+static const void *rtw89_fw_suit_data_dup_if_needed(struct rtw89_dev *rtwdev,
+						    struct rtw89_fw_suit *fw_suit,
+						    const void *src)
+{
+	struct rtw89_fw_info *fw = &rtwdev->fw;
+	const void *dup;
+
+	dup = __rtw89_fw_elem_dup_if_needed(rtwdev, src, fw_suit->size, true);
+
+	if (dup != src)
+		list_add_tail(&fw_suit->list, &fw->dup_data_list);
+
+	return dup;
 }
 
 static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 len,
@@ -680,8 +704,7 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 		if (type != RTW89_FW_NORMAL)
 			return -EINVAL;
 		fw_suit->size = mfw_len;
-		fw_suit->data = __rtw89_fw_elem_dup_if_needed(rtwdev, mfw,
-							      fw_suit->size);
+		fw_suit->data = rtw89_fw_suit_data_dup_if_needed(rtwdev, fw_suit, mfw);
 		return 0;
 	}
 
@@ -725,8 +748,7 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 	}
 
 	fw_suit->size = mfw_info_size;
-	fw_suit->data = __rtw89_fw_elem_dup_if_needed(rtwdev, mfw_info_ptr,
-						      fw_suit->size);
+	fw_suit->data = rtw89_fw_suit_data_dup_if_needed(rtwdev, fw_suit, mfw_info_ptr);
 
 	return 0;
 }
@@ -866,8 +888,8 @@ int __rtw89_fw_recognize_from_elm(struct rtw89_dev *rtwdev,
 		return 1; /* ignore this element (a firmware is taken already) */
 
 	fw_suit->size = le32_to_cpu(elm->size);
-	fw_suit->data = __rtw89_fw_elem_dup_if_needed(rtwdev, elm->u.bbmcu.contents,
-						      fw_suit->size);
+	fw_suit->data =
+		rtw89_fw_suit_data_dup_if_needed(rtwdev, fw_suit, elm->u.bbmcu.contents);
 
 	return rtw89_fw_update_ver(rtwdev, type, fw_suit);
 }
@@ -2206,6 +2228,15 @@ static void rtw89_unload_firmware_elements(struct rtw89_dev *rtwdev)
 	kfree(elm_info->rfk_log_fmt);
 }
 
+static void rtw89_unload_firmware_dup_data(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_fw_info *fw = &rtwdev->fw;
+	struct rtw89_fw_suit *fw_suit;
+
+	list_for_each_entry(fw_suit, &fw->dup_data_list, list)
+		vfree(fw_suit->data);
+}
+
 void __rtw89_unload_firmware(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_fw_info *fw = &rtwdev->fw;
@@ -2229,6 +2260,7 @@ void rtw89_unload_firmware(struct rtw89_dev *rtwdev)
 
 	kfree(fw->log.fmts);
 	rtw89_unload_firmware_elements(rtwdev);
+	rtw89_unload_firmware_dup_data(rtwdev);
 }
 
 static u32 rtw89_fw_log_get_fmt_idx(struct rtw89_dev *rtwdev, u32 fmt_id)
-- 
2.25.1

