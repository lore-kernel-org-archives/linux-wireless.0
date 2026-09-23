Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C31D38737A
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142376; cv=none; b=WiBBi+//qtyLuBcEGjmYhVJI3Gt53PEC08RzN/vnLyINfaN6tiT4xA24xqfQJlzO9mYO7IGRrtzE+bvwi4QT97LF872p317UZZBS8wxPahARciwcoWIlW0RivpRXR9hDY6t1EDWoLRL23YAd543g6gcvBbtZHRgHC+gcKXOP0HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142376; c=relaxed/simple;
	bh=/jCfJzoveZrJKmhySFqReDUeweqjKJddier5YslIswE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Szj6NYTYUqsMWIBnLEsFMbJxzI2CvqtFyMRJayLb7eppFHZHF6fU9LVFP8CKl/iIm3PSWIOcTydGQoyFY7782f4UxDiTUjfkGvlaYNs4FCqKgDfnLGqQMQggMP/lPXmIfcXzBQ9g65T5veqiU2QRrUllsARnIQoLatSITDkvVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Ln1n8Un5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Ln1n8Un5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5kChO5097514, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142372; bh=Q/NgsXVioqCHYShIH1saeAF8BmO6UU0BAd7BawSK8q8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Ln1n8Un5XCh+UD593qkoVq5um7zzjxk6qqGtWSh4vHlM4H4USuluVxec1HUOXVxcV
	 KRyR/IeomK3uJUoC00j1l5jjaE5U7FlDhFHuTccjKoWCuvmQLBm+XYDPcV00qJXtOS
	 RiYxGOkTvuz8SpqD+7DsadjFaYg+CFsprhp4y/vj/hDtNTmCrogfbpYAtw1zYslnMr
	 D4CDTvarP49ZDd8whSki7TGi7OcMPs9zCnZUEmUccWG81y2zMbsgpsdgA97paPja+o
	 cDTcZaTisVuK3x3cap2DUojhjkf9fI4l+lyOZL4fFhi2ue705HcpuvOFfhPWd/vnoB
	 dVdTZtLXCBTMw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5kChO5097514
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:46:12 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:46:11 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:46:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 5/6] wifi: rtw89: support variants of FW elements
Date: Wed, 23 Sep 2026 13:45:04 +0800
Message-ID: <20260923054505.43329-6-pkshih@realtek.com>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Although there is a set of general FW elements parameters for each
chip, some chipsets depending on products may need variants of FW
elements for some specific adjustments.

Each of these chipsets will be defined with a specific VID/PID that
mapping to a specific board ID for FW elements. When probing these
chipsets, try to load rtw89/board_elm.bin and seek the given variant
ID. If found, apply the variant of FW elements. Otherwise, fallback
to the general FW elements.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c |   1 +
 drivers/net/wireless/realtek/rtw89/core.h |  14 +++
 drivers/net/wireless/realtek/rtw89/fw.c   | 124 ++++++++++++++++++----
 drivers/net/wireless/realtek/rtw89/fw.h   |  14 +++
 4 files changed, 135 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index e61d7e89882f..2a1f54e9664a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -7745,6 +7745,7 @@ void rtw89_free_ieee80211_hw(struct rtw89_dev *rtwdev)
 }
 EXPORT_SYMBOL(rtw89_free_ieee80211_hw);
 
+MODULE_FIRMWARE(RTW89_FWNAME_BOARD_ELM);
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek 802.11ax wireless core module");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d8adf7425a3a..bcb58a9392cc 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5302,6 +5302,8 @@ struct rtw89_reg_imr {
 #define RTW89_GEN_MODULE_FWNAME(basename, maxformat) \
 	basename RTW89_GEN_MODULE_FWNAME_FMT(maxformat) ".bin"
 
+#define RTW89_FWNAME_BOARD_ELM "rtw89/board_elm.bin"
+
 struct rtw89_fw_def {
 	const char *fw_basename;
 	u8 fw_format_max;
@@ -5893,7 +5895,18 @@ struct rtw89_chip_variant {
 	const struct rtw89_qta_def *qta_def_override;
 };
 
+/* @pid can have extra suffix to describe the variant if necessary */
+#define RTW89_BOARD_ID(vid, pid) \
+	RTW89_BOARD_ID_##vid##_##pid
+
+enum rtw89_board_id {
+	RTW89_BOARD_ID(0000, 0000) = 0, /* reserve 0 for non-variant */
+
+	NUM_OF_RTW89_BOARD_IDS,
+};
+
 struct rtw89_board_variant {
+	enum rtw89_board_id id;
 	const struct rtw89_led_desc *led_desc;
 };
 
@@ -6094,6 +6107,7 @@ struct rtw89_fw_suit {
 
 struct rtw89_fw_req_info {
 	const struct firmware *firmware;
+	const struct firmware *board_elm;
 	struct completion completion;
 	bool free_after_probe;
 };
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 7c7c0a4f703e..d53e670a29cf 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -1658,30 +1658,17 @@ static const struct rtw89_fw_element_handler __fw_element_handlers[] = {
 	},
 };
 
-int rtw89_fw_recognize_elements(struct rtw89_dev *rtwdev)
+static int __rtw89_fw_recognize_elements(struct rtw89_dev *rtwdev,
+					 const struct firmware *firmware,
+					 u32 offset, u32 skipped_elements,
+					 u32 *unrecognized_elements)
 {
-	struct rtw89_fw_info *fw_info = &rtwdev->fw;
-	const struct firmware *firmware = fw_info->req.firmware;
-	const struct rtw89_chip_info *chip = rtwdev->chip;
-	u32 unrecognized_elements = chip->needed_fw_elms;
 	const struct rtw89_fw_element_handler *handler;
 	const struct rtw89_fw_element_hdr *hdr;
-	bool transition;
 	u32 elm_size;
 	u32 elem_id;
-	u32 offset;
 	int ret;
 
-	BUILD_BUG_ON(sizeof(chip->needed_fw_elms) * 8 < RTW89_FW_ELEMENT_ID_NUM);
-
-	transition = !!((chip->needed_fw_elms & BIT(__RTW89_FW_ELEMENT_ID_INTL_TRANSITION)));
-	unrecognized_elements &= ~BIT(__RTW89_FW_ELEMENT_ID_INTL_TRANSITION);
-
-	offset = rtw89_mfw_get_size(rtwdev);
-	offset = ALIGN(offset, RTW89_FW_ELEMENT_ALIGN);
-	if (offset == 0)
-		return -EINVAL;
-
 	while (offset + sizeof(*hdr) < firmware->size) {
 		hdr = (const struct rtw89_fw_element_hdr *)(firmware->data + offset);
 
@@ -1694,6 +1681,8 @@ int rtw89_fw_recognize_elements(struct rtw89_dev *rtwdev)
 		elem_id = le32_to_cpu(hdr->id);
 		if (elem_id >= ARRAY_SIZE(__fw_element_handlers))
 			goto next;
+		if (skipped_elements & BIT(elem_id))
+			goto next;
 
 		handler = &__fw_element_handlers[elem_id];
 		if (!handler->fn)
@@ -1709,12 +1698,105 @@ int rtw89_fw_recognize_elements(struct rtw89_dev *rtwdev)
 			rtw89_info(rtwdev, "Firmware element %s version: %4ph\n",
 				   handler->name, hdr->ver);
 
-		unrecognized_elements &= ~BIT(elem_id);
+		*unrecognized_elements &= ~BIT(elem_id);
 next:
 		offset += sizeof(*hdr) + elm_size;
 		offset = ALIGN(offset, RTW89_FW_ELEMENT_ALIGN);
 	}
 
+	return 0;
+}
+
+static int rtw89_board_elm_seek(const struct firmware *board_elm,
+				enum rtw89_board_id board_id,
+				struct firmware *pseudo_fw)
+{
+	const struct rtw89_board_elm_hdr *hdr;
+	const struct rtw89_board_elm_ent *ent;
+	u32 ofst;
+	u32 size;
+	u16 num;
+
+	if (board_elm->size < sizeof(*hdr))
+		return -EINVAL;
+
+	hdr = (const struct rtw89_board_elm_hdr *)board_elm->data;
+	if (hdr->sig != RTW89_BOARD_ELM_SIG)
+		return -EINVAL;
+
+	BUILD_BUG_ON(U16_MAX < NUM_OF_RTW89_BOARD_IDS);
+
+	num = le16_to_cpu(hdr->num);
+	if (unlikely(board_elm->size < struct_size(hdr, ents, num)))
+		return -EFAULT;
+	if (num <= board_id)
+		return -ENOENT;
+
+	ent = &hdr->ents[board_id];
+
+	ofst = le32_to_cpu(ent->ofst);
+	size = le32_to_cpu(ent->size);
+
+	if (unlikely(board_elm->size < ofst + size))
+		return -EFAULT;
+
+	memset(pseudo_fw, 0, sizeof(*pseudo_fw));
+
+	pseudo_fw->data = (const void *)board_elm->data + ofst;
+	pseudo_fw->size = size;
+
+	return 0;
+}
+
+int rtw89_fw_recognize_elements(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_board_variant *board = rtwdev->board;
+	struct rtw89_fw_req_info *fw_req = &rtwdev->fw.req;
+	const struct firmware *firmware = fw_req->firmware;
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	u32 unrecognized_elements = chip->needed_fw_elms;
+	u32 skipped_elements = 0;
+	bool transition;
+	u32 offset;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(chip->needed_fw_elms) * 8 < RTW89_FW_ELEMENT_ID_NUM);
+	BUILD_BUG_ON(!__same_type(unrecognized_elements, chip->needed_fw_elms));
+	BUILD_BUG_ON(!__same_type(skipped_elements, chip->needed_fw_elms));
+
+	transition = !!((chip->needed_fw_elms & BIT(__RTW89_FW_ELEMENT_ID_INTL_TRANSITION)));
+	unrecognized_elements &= ~BIT(__RTW89_FW_ELEMENT_ID_INTL_TRANSITION);
+
+	if (fw_req->board_elm) {
+		struct firmware pseudo_fw;
+
+		ret = rtw89_board_elm_seek(fw_req->board_elm, board->id, &pseudo_fw);
+		if (ret)
+			goto mfw;
+
+		ret = __rtw89_fw_recognize_elements(rtwdev, &pseudo_fw, 0, 0,
+						    &unrecognized_elements);
+		if (ret)
+			goto mfw;
+
+		skipped_elements = chip->needed_fw_elms & ~unrecognized_elements;
+
+		rtw89_debug(rtwdev, RTW89_DBG_FW, "apply elements 0x08%x from %s\n",
+			    skipped_elements, RTW89_FWNAME_BOARD_ELM);
+	}
+
+mfw:
+	offset = rtw89_mfw_get_size(rtwdev);
+	offset = ALIGN(offset, RTW89_FW_ELEMENT_ALIGN);
+	if (offset == 0)
+		return -EINVAL;
+
+	ret = __rtw89_fw_recognize_elements(rtwdev, firmware, offset,
+					    skipped_elements,
+					    &unrecognized_elements);
+	if (ret)
+		return ret;
+
 	if (unrecognized_elements) {
 		if (transition) {
 			rtw89_info(rtwdev, "NOTE: This firmware is going to be obsolete!\n"
@@ -2171,6 +2253,7 @@ static int rtw89_load_firmware_req(struct rtw89_dev *rtwdev,
 				   struct rtw89_fw_req_info *req,
 				   const char *fw_name, bool nowarn)
 {
+	const struct rtw89_board_variant *board = rtwdev->board;
 	int ret = 0;
 
 	if (req->firmware) {
@@ -2185,6 +2268,9 @@ static int rtw89_load_firmware_req(struct rtw89_dev *rtwdev,
 		ret = request_firmware(&req->firmware, fw_name, rtwdev->dev);
 
 out:
+	if (board && board->id)
+		firmware_request_nowarn(&req->board_elm, RTW89_FWNAME_BOARD_ELM, rtwdev->dev);
+
 	req->free_after_probe = req->firmware && req->firmware->size > 0x200000;
 	complete_all(&req->completion);
 
@@ -2242,6 +2328,7 @@ void __rtw89_unload_firmware(struct rtw89_dev *rtwdev)
 	struct rtw89_fw_info *fw = &rtwdev->fw;
 
 	release_firmware(fw->req.firmware);
+	release_firmware(fw->req.board_elm);
 
 	/*
 	 * Directly call this to free firmware early in normal flow. Assign
@@ -2249,6 +2336,7 @@ void __rtw89_unload_firmware(struct rtw89_dev *rtwdev)
 	 * try to release the same one again in error handling paths.
 	 */
 	fw->req.firmware = NULL;
+	fw->req.board_elm = NULL;
 }
 
 void rtw89_unload_firmware(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index cb4209df5843..23adf12f132e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -4394,6 +4394,7 @@ struct rtw89_h2c_ofld {
 #define RTW89_H2C_OFLD_W0_RX_TP GENMASK(27, 18)
 
 #define RTW89_MFW_SIG	0xFF
+#define RTW89_BOARD_ELM_SIG 0xFE
 
 struct rtw89_mfw_info {
 	u8 cv;
@@ -4419,6 +4420,19 @@ struct rtw89_mfw_hdr {
 	struct rtw89_mfw_info info[];
 } __packed;
 
+struct rtw89_board_elm_ent {
+	u8 rsvd[8];
+	__le32 ofst; /* offset from beginning of rtw89_board_elm_hdr */
+	__le32 size;
+} __packed;
+
+struct rtw89_board_elm_hdr {
+	u8 sig; /* RTW89_BOARD_ELM_SIG */
+	u8 rsvd[13];
+	__le16 num;
+	struct rtw89_board_elm_ent ents[] __counted_by_le(num);
+} __packed;
+
 struct rtw89_fw_logsuit_hdr {
 	__le32 rsvd;
 	__le32 count;
-- 
2.25.1

