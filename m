Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390DF2D739B
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142352; cv=none; b=NjExSXxs12m8PRn1VJndNHKoY7ekIi1XsSNWdtPUsRPIWvhxkL4mreUKXJQA2A8DmwG3RtN7GgdDQpN2m91f0F+w7db7NmtSSeoGX+7VmqEgRkt8IJn1oT3eVb/cQfxoZlhFy9OdaZgRhZZfjrczRQXFKwrPeE1vxVykeovDUlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142352; c=relaxed/simple;
	bh=rEfRpqiWuXGmwCgLYEg2pz+C3Xr1Wnq3dIuQeUQAf5s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBbMuEz+bACJejI7BjD2nTU3PqWeI2i3VfiDCWeV6f7KI03moYvDTCFbibz/6qICA590tPtUrOGCf5k4TRaUi80OUydSojuwnHdbvZWbyABeakf228d6FWI0owg2MboeHkKyIjpCPRElps7jrzXGuHG3PRG4nhtXqEgHxmMUG3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Zf+FmB+V; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Zf+FmB+V"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5jlkbF097421, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142348; bh=3Z66sNhON3Uyy0gBxW8nBKDwwCOF2p/sImsYehxBK4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Zf+FmB+VaFltJ54Tihvg3cexJOSuhszhfpp3P1HPLcHgDDsVvoRKpEz1IXw0RXpJj
	 TqmMliQ3ttV6iPSj4Rq2Ht4DkFIPh8BARxalqtkCL+KoW4NaXItsx/NHhjOAwQeZag
	 84yYmY2MnfCsIncYl/Djz/4HHc5LajByVL4SJ2qBk+dK17EKYc990Y/03DiQ5FLPcd
	 0kOloKCW/MtXZSrMNxa+1GXLPI2/PODQuDGfItbvuejysnnDg2cbgH6Q0xhsUsHCCo
	 P6wV5qBoQwMl5SXtNe+nWg4vdVS+AxVeZw6dCFWi/V87rDjW0ZdpHNvdoMWy5YghlJ
	 pmZdSRUgP47LA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5jlkbF097421
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:45:48 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:45:47 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:45:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 1/6] wifi: rtw89: fw: duplicate recognized firmware elements
Date: Wed, 23 Sep 2026 13:45:00 +0800
Message-ID: <20260923054505.43329-2-pkshih@realtek.com>
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

The firmware file contains variant elements for variant hardware, and
currently whole firmware content is persistent. However, RTL8922DE has many
variants and firmware file become grown to over 4MB, but actually size of
necessary duplicate elements are about 1.0MB.

To reduce memory usage, duplicate recognized firmware elements as
persistent memory, and will release firmware by next coming patch.

However, firmware for early chips doesn't have many variant elements, and
no need to duplicate memory for the purpose, so do it only if firmware
size is over 2MB.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 72 ++++++++++++++++++-----
 2 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 3a6099386b09..4b4500a7a068 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6094,6 +6094,7 @@ struct rtw89_fw_suit {
 struct rtw89_fw_req_info {
 	const struct firmware *firmware;
 	struct completion completion;
+	bool free_after_probe;
 };
 
 struct rtw89_fw_log {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 535cc2ad8611..3cdfb141f075 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -137,6 +137,33 @@ int rtw89_fw_check_rdy(struct rtw89_dev *rtwdev, enum rtw89_fwdl_check_type type
 	return 0;
 }
 
+static const void *__rtw89_fw_elem_dup_if_needed(struct rtw89_dev *rtwdev,
+						 const void *src, size_t len)
+{
+	struct rtw89_fw_req_info *fw_req = &rtwdev->fw.req;
+	const void *dup;
+
+	if (!fw_req->free_after_probe)
+		return src;
+
+	dup = devm_kmemdup(rtwdev->dev, src, len, GFP_KERNEL);
+	if (!dup) {
+		/* If failed to memdup, fallback to point to firmware->data. */
+		fw_req->free_after_probe = false;
+		return src;
+	}
+
+	return dup;
+}
+
+static const void *rtw89_fw_elem_dup_if_needed(struct rtw89_dev *rtwdev,
+					       const struct rtw89_fw_element_hdr *elm)
+{
+	size_t len = sizeof(*elm) + le32_to_cpu(elm->size);
+
+	return __rtw89_fw_elem_dup_if_needed(rtwdev, elm, len);
+}
+
 static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 len,
 				  struct rtw89_fw_bin_info *info)
 {
@@ -641,6 +668,8 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 	const struct rtw89_mfw_hdr *mfw_hdr;
 	const u8 *mfw = firmware->data;
 	u32 mfw_len = firmware->size;
+	const u8 *mfw_info_ptr;
+	u32 mfw_info_size;
 	int ret;
 	int i;
 
@@ -650,8 +679,9 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 		/* legacy firmware support normal type only */
 		if (type != RTW89_FW_NORMAL)
 			return -EINVAL;
-		fw_suit->data = mfw;
 		fw_suit->size = mfw_len;
+		fw_suit->data = __rtw89_fw_elem_dup_if_needed(rtwdev, mfw,
+							      fw_suit->size);
 		return 0;
 	}
 
@@ -686,14 +716,18 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 	return -ENOENT;
 
 found:
-	fw_suit->data = mfw + le32_to_cpu(mfw_info->shift);
-	fw_suit->size = le32_to_cpu(mfw_info->size);
+	mfw_info_ptr = mfw + le32_to_cpu(mfw_info->shift);
+	mfw_info_size = le32_to_cpu(mfw_info->size);
 
-	if (fw_suit->data + fw_suit->size > mfw + mfw_len) {
+	if (mfw_info_ptr + mfw_info_size > mfw + mfw_len) {
 		rtw89_err(rtwdev, "fw_suit %d out of address\n", type);
 		return -EFAULT;
 	}
 
+	fw_suit->size = mfw_info_size;
+	fw_suit->data = __rtw89_fw_elem_dup_if_needed(rtwdev, mfw_info_ptr,
+						      fw_suit->size);
+
 	return 0;
 }
 
@@ -831,8 +865,9 @@ int __rtw89_fw_recognize_from_elm(struct rtw89_dev *rtwdev,
 	if (fw_suit->data)
 		return 1; /* ignore this element (a firmware is taken already) */
 
-	fw_suit->data = elm->u.bbmcu.contents;
 	fw_suit->size = le32_to_cpu(elm->size);
+	fw_suit->data = __rtw89_fw_elem_dup_if_needed(rtwdev, elm->u.bbmcu.contents,
+						      fw_suit->size);
 
 	return rtw89_fw_update_ver(rtwdev, type, fw_suit);
 }
@@ -1252,7 +1287,12 @@ int rtw89_fw_recognize_txpwr_from_elm(struct rtw89_dev *rtwdev,
 	conf->rfe_type = txpwr_elm->rfe_type;
 	conf->ent_sz = txpwr_elm->ent_sz;
 	conf->num_ents = le32_to_cpu(txpwr_elm->num_ents);
+	/*
+	 * The conf->data is used by rtw89_core_setup_rfe_parms() to do format
+	 * conversion before releasing firmware. No need to duplicate.
+	 */
 	conf->data = txpwr_elm->content;
+
 	return 0;
 }
 
@@ -1263,6 +1303,7 @@ int rtw89_build_txpwr_trk_tbl_from_elm(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
+	const struct rtw89_fw_element_hdr *elm_dup;
 	struct rtw89_hal *hal = &rtwdev->hal;
 	u16 aid = le16_to_cpu(elm->aid);
 	u32 needed_bitmap = 0;
@@ -1293,6 +1334,8 @@ int rtw89_build_txpwr_trk_tbl_from_elm(struct rtw89_dev *rtwdev,
 	if (!elm_info->txpwr_trk)
 		return -ENOMEM;
 
+	elm_dup = rtw89_fw_elem_dup_if_needed(rtwdev, elm);
+
 	for (type = 0; bitmap; type++, bitmap >>= 1) {
 		if (!(bitmap & BIT(0)))
 			continue;
@@ -1309,10 +1352,10 @@ int rtw89_build_txpwr_trk_tbl_from_elm(struct rtw89_dev *rtwdev,
 		else
 			break;
 
-		elm_info->txpwr_trk->delta[type] = &elm->u.txpwr_trk.contents[offset];
+		elm_info->txpwr_trk->delta[type] = &elm_dup->u.txpwr_trk.contents[offset];
 
 		offset += subband;
-		if (offset * DELTA_SWINGIDX_SIZE > le32_to_cpu(elm->size))
+		if (offset * DELTA_SWINGIDX_SIZE > le32_to_cpu(elm_dup->size))
 			goto err;
 	}
 
@@ -1347,7 +1390,7 @@ int rtw89_build_rfk_log_fmt_from_elm(struct rtw89_dev *rtwdev,
 	if (rfk_id >= RTW89_PHY_C2H_RFK_LOG_FUNC_NUM)
 		return 1;
 
-	elm_info->rfk_log_fmt->elm[rfk_id] = elm;
+	elm_info->rfk_log_fmt->elm[rfk_id] = rtw89_fw_elem_dup_if_needed(rtwdev, elm);
 
 	return 0;
 }
@@ -1454,7 +1497,7 @@ int rtw89_build_afe_pwr_seq_from_elm(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
 
-	elm_info->afe = elm;
+	elm_info->afe = rtw89_fw_elem_dup_if_needed(rtwdev, elm);
 
 	return 0;
 }
@@ -1466,7 +1509,7 @@ int rtw89_recognize_diag_mac_from_elm(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
 
-	elm_info->diag_mac = elm;
+	elm_info->diag_mac = rtw89_fw_elem_dup_if_needed(rtwdev, elm);
 
 	return 0;
 }
@@ -1492,7 +1535,7 @@ int rtw89_build_tx_comp_from_elm(struct rtw89_dev *rtwdev,
 	else if (elm_info->tx_comp)
 		return 1; /* ignore if an element is existing */
 
-	elm_info->tx_comp = elm;
+	elm_info->tx_comp = rtw89_fw_elem_dup_if_needed(rtwdev, elm);
 
 	return 0;
 }
@@ -2106,13 +2149,12 @@ static int rtw89_load_firmware_req(struct rtw89_dev *rtwdev,
 				   struct rtw89_fw_req_info *req,
 				   const char *fw_name, bool nowarn)
 {
-	int ret;
+	int ret = 0;
 
 	if (req->firmware) {
 		rtw89_debug(rtwdev, RTW89_DBG_FW,
 			    "full firmware has been early requested\n");
-		complete_all(&req->completion);
-		return 0;
+		goto out;
 	}
 
 	if (nowarn)
@@ -2120,6 +2162,8 @@ static int rtw89_load_firmware_req(struct rtw89_dev *rtwdev,
 	else
 		ret = request_firmware(&req->firmware, fw_name, rtwdev->dev);
 
+out:
+	req->free_after_probe = req->firmware && req->firmware->size > 0x200000;
 	complete_all(&req->completion);
 
 	return ret;
-- 
2.25.1

