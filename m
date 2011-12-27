Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33152 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1L0UMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 15:12:38 -0500
Received: by eekc4 with SMTP id c4so11883321eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Dec 2011 12:12:37 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 27 Dec 2011 21:01:55 +0100
Subject: [PATCH] carl9170: move checksum and txseq into subfunctions
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1RfdNx-0000Tk-Mu@debian64.daheim> (sfid-20111227_211256_144315_E2FD0C08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fw.c |   97 ++++++++++++++++++++------------
 1 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index cba9d04..3de61ad 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -146,13 +146,15 @@ static bool valid_cpu_addr(const u32 address)
 	return false;
 }
 
-static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
+static int carl9170_fw_checksum(struct ar9170 *ar, const __u8 *data,
+				size_t len)
 {
 	const struct carl9170fw_otus_desc *otus_desc;
-	const struct carl9170fw_chk_desc *chk_desc;
 	const struct carl9170fw_last_desc *last_desc;
-	const struct carl9170fw_txsq_desc *txsq_desc;
-	u16 if_comb_types;
+	const struct carl9170fw_chk_desc *chk_desc;
+	unsigned long fin, diff;
+	unsigned int dsc_len;
+	u32 crc32;
 
 	last_desc = carl9170_fw_find_desc(ar, LAST_MAGIC,
 		sizeof(*last_desc), CARL9170FW_LAST_DESC_CUR_VER);
@@ -170,36 +172,68 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	chk_desc = carl9170_fw_find_desc(ar, CHK_MAGIC,
 		sizeof(*chk_desc), CARL9170FW_CHK_DESC_CUR_VER);
 
-	if (chk_desc) {
-		unsigned long fin, diff;
-		unsigned int dsc_len;
-		u32 crc32;
+	if (!chk_desc) {
+		dev_warn(&ar->udev->dev, "Unprotected firmware image.\n");
+		return 0;
+	}
 
-		dsc_len = min_t(unsigned int, len,
+	dsc_len = min_t(unsigned int, len,
 			(unsigned long)chk_desc - (unsigned long)otus_desc);
 
-		fin = (unsigned long) last_desc + sizeof(*last_desc);
-		diff = fin - (unsigned long) otus_desc;
+	fin = (unsigned long) last_desc + sizeof(*last_desc);
+	diff = fin - (unsigned long) otus_desc;
 
-		if (diff < len)
-			len -= diff;
+	if (diff < len)
+		len -= diff;
 
-		if (len < 256)
-			return -EIO;
+	if (len < 256)
+		return -EIO;
 
-		crc32 = crc32_le(~0, data, len);
-		if (cpu_to_le32(crc32) != chk_desc->fw_crc32) {
-			dev_err(&ar->udev->dev, "fw checksum test failed.\n");
-			return -ENOEXEC;
-		}
+	crc32 = crc32_le(~0, data, len);
+	if (cpu_to_le32(crc32) != chk_desc->fw_crc32) {
+		dev_err(&ar->udev->dev, "fw checksum test failed.\n");
+		return -ENOEXEC;
+	}
+
+	crc32 = crc32_le(crc32, (void *)otus_desc, dsc_len);
+	if (cpu_to_le32(crc32) != chk_desc->hdr_crc32) {
+		dev_err(&ar->udev->dev, "descriptor check failed.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
 
-		crc32 = crc32_le(crc32, (void *)otus_desc, dsc_len);
-		if (cpu_to_le32(crc32) != chk_desc->hdr_crc32) {
-			dev_err(&ar->udev->dev, "descriptor check failed.\n");
+static int carl9170_fw_tx_sequence(struct ar9170 *ar)
+{
+	const struct carl9170fw_txsq_desc *txsq_desc;
+
+	txsq_desc = carl9170_fw_find_desc(ar, TXSQ_MAGIC, sizeof(*txsq_desc),
+					  CARL9170FW_TXSQ_DESC_CUR_VER);
+	if (txsq_desc) {
+		ar->fw.tx_seq_table = le32_to_cpu(txsq_desc->seq_table_addr);
+		if (!valid_cpu_addr(ar->fw.tx_seq_table))
 			return -EINVAL;
-		}
 	} else {
-		dev_warn(&ar->udev->dev, "Unprotected firmware image.\n");
+		ar->fw.tx_seq_table = 0;
+	}
+
+	return 0;
+}
+
+static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
+{
+	const struct carl9170fw_otus_desc *otus_desc;
+	int err;
+	u16 if_comb_types;
+
+	err = carl9170_fw_checksum(ar, data, len);
+	if (err)
+		return err;
+
+	otus_desc = carl9170_fw_find_desc(ar, OTUS_MAGIC,
+		sizeof(*otus_desc), CARL9170FW_OTUS_DESC_CUR_VER);
+	if (!otus_desc) {
+		return -ENODATA;
 	}
 
 #define SUPP(feat)						\
@@ -321,19 +355,8 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 
 	ar->hw->wiphy->interface_modes |= if_comb_types;
 
-	txsq_desc = carl9170_fw_find_desc(ar, TXSQ_MAGIC,
-		sizeof(*txsq_desc), CARL9170FW_TXSQ_DESC_CUR_VER);
-
-	if (txsq_desc) {
-		ar->fw.tx_seq_table = le32_to_cpu(txsq_desc->seq_table_addr);
-		if (!valid_cpu_addr(ar->fw.tx_seq_table))
-			return -EINVAL;
-	} else {
-		ar->fw.tx_seq_table = 0;
-	}
-
 #undef SUPPORTED
-	return 0;
+	return carl9170_fw_tx_sequence(ar);
 }
 
 static struct carl9170fw_desc_head *
-- 
1.7.7.3

