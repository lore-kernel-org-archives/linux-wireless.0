Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542266;
	b=AXfVhpxrzLSO9G+BayhnW5vORufZwgyGFuG5lQ1EAsackFgwSiNSOuIiX1zLN9zA2A/i
	 EehameczSyKrSxkC3xn4KT6eAs55g5qoODaC4idWomSrdfxMEe5LWG2tv/BhE8HYmy26S
	 qksueVDEmWB17oBV89x2Y4tnm9zb54IkaoMFhrOvZz7YfpAOeKwwo/VXYWDVtFowN/pgh
	 XbaXeZUSdroUjNlEpvp/pKAdVYB1f5RpZnaTpslR7CU9+Msb+aejHoIKHU6a7rwKJPqIs
	 SAbwE5hCE3Xwor3r2SKY572CaPFs1vZl5/M1cuBizVR42uzsqcszKn5ZTGtt2EnYFYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542266;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=OpuSXTvUGb9inJ3VTguE55fRGrCNrDzuw/3a5E0Z6tQ=;
	b=IkYtWNLr8jmJbrpkIHH/MQ/newiHw+n9+M3kKjbsB+ld1x3gSu/eSkMcHRrBm/Qxggc9
	 RdymNyQGlRJXe7pZyyuwH5lceJX0g85LydKtSB8vOGIdma/Ciimq7RhdkE1Av6ELGBzrH
	 1Go36mxIUEPxc/RSjdkbWH5dLWCu5cE5qUpa7GEYxV5/w+hA5K4YbjyMANN6rmDY1bVZe
	 2pZtvibE/bKW4OyQJ+bzCraUnkhQNthtyyRCBg2hKBSEMcYqSNDSmJbvak49ocBRyg5S3
	 ElK+J4O4lpS2ZNeEuFinmGfgHm8+RjtqlhtcnOLDwB4YGfiCv69kvBm/3V8gVokc1ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=a2oPrnZP;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF62606A324;
	Sun,  1 Nov 2026 14:11:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBF62606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=a2oPrnZP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Op
	uSXTvUGb9inJ3VTguE55fRGrCNrDzuw/3a5E0Z6tQ=; b=a2oPrnZP6fkCRNHl6x
	qefc9q1V0anl3a/FtI03S/D4VZoqip6TT82ZYizXIveZS/zXmk5qAV93JSPCEak6
	7je92pxsvQMFNEHE6g/1MSLAHnsZg/xyfd37A4c43LZouEoemy8JXVsStbsRjNSB
	Z2VFcKniSBf1yo5Si+meJBCWc=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDHTuZVSOdqvnsDDA--.65244S2;
	Sun, 01 Nov 2026 22:10:32 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org,
	lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com,
	arien.judge@morsemicro.com
Cc: johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mm81x: validate external host table TLV lengths
Date: Sun,  1 Nov 2026 22:10:25 +0800
Message-ID: <20261101141025.694-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDHTuZVSOdqvnsDDA--.65244S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JFWkAr4DAFykZw4UKr1rJFb_yoW7Xry7pF
	4Ygry29rs8WryUWr1SvF42yr1ftan7ArWUG34kJ34Ykw1ayry8Ga98WFyjgFn8Aa95Cr13
	WFn8tFW7GFnrAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jehFxUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-h29Z2rnSF0LSQAA3j

mm81x_fw_parse_ext_host_tbl() uses the length stored in the external host
table payload as the TLV walk boundary.  The buffer is allocated using a
different length read from a device register, and the two values are not
cross-checked.  A device can report a small register length so that the
driver allocates a small buffer, while the payload length field claims a
larger size and makes the walk read beyond the allocation.

Each branch also dereferences a complete fixed-size structure while only
the start of the TLV header has been bounds-checked.  A truncated trailing
TLV can therefore make the capabilities, checksum, or YAPS parser read
past the allocated buffer.

Pass the allocation length out of mm81x_fw_read_ext_host_table() and clamp
the payload length to it.  Require a complete TLV header before reading it
and verify that the full structure is present before dispatching it.

A KASAN reproducer mirroring the TLV walk reports a slab-out-of-bounds
with a small allocation and an oversized payload length.  The same input
does not report after these checks are applied.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 84 +++++++++++++++++-----
 1 file changed, 65 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d6d2ad086..b5d6f87df 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -445,7 +445,8 @@ static int mm81x_fw_get_host_table_ptr(struct mm81x *mors)
 }
 
 static int mm81x_fw_read_ext_host_table(struct mm81x *mors,
-					struct ext_host_tbl **ext_host_table)
+					struct ext_host_tbl **ext_host_table,
+					u32 *alloc_len)
 {
 	int ret = 0;
 	u32 host_tbl_ptr = mors->host_table_ptr;
@@ -494,6 +495,7 @@ static int mm81x_fw_read_ext_host_table(struct mm81x *mors,
 
 	mm81x_release_bus(mors);
 	*ext_host_table = host_tbl;
+	*alloc_len = ext_host_tbl_len;
 	return ret;
 
 exit:
@@ -548,47 +550,91 @@ int mm81x_fw_parse_ext_host_tbl(struct mm81x *mors)
 	int ret;
 	u8 *head;
 	u8 *end;
+	u32 alloc_len = 0;
+	u32 tbl_len;
+	size_t tlv_offset = offsetof(struct ext_host_tbl,
+				       ext_host_table_data_tlvs);
 	struct ext_host_tbl *ext_host_table = NULL;
 
-	ret = mm81x_fw_read_ext_host_table(mors, &ext_host_table);
+	ret = mm81x_fw_read_ext_host_table(mors, &ext_host_table, &alloc_len);
 	if (ret || !ext_host_table)
 		goto exit;
 
-	/* Parse the TLVs */
+	if (alloc_len < tlv_offset) {
+		ret = -EINVAL;
+		goto exit_free;
+	}
+
 	head = ext_host_table->ext_host_table_data_tlvs;
-	end = ((u8 *)ext_host_table) +
-	      le32_to_cpu(ext_host_table->ext_host_tbl_length);
 
-	while (head < end) {
+	/*
+	 * The length stored inside the table is device supplied and is not
+	 * guaranteed to match the size allocated from the length register.
+	 * Clamp it to the allocation so the walk stays inside the buffer.
+	 */
+	tbl_len = le32_to_cpu(ext_host_table->ext_host_tbl_length);
+	if (tbl_len < tlv_offset) {
+		ret = -EINVAL;
+		goto exit_free;
+	}
+	if (tbl_len > alloc_len)
+		tbl_len = alloc_len;
+	end = ((u8 *)ext_host_table) + tbl_len;
+
+	while (end - head >= sizeof(struct ext_host_tbl_tlv_hdr)) {
 		struct ext_host_tbl_tlv_hdr *hdr =
 			(struct ext_host_tbl_tlv_hdr *)head;
+		size_t left = end - head;
+		u16 tlv_len = le16_to_cpu(hdr->length);
 
 		switch (le16_to_cpu(hdr->tag)) {
-		case MM81X_FW_HOST_TABLE_TAG_S1G_CAPABILITIES:
-			mm81x_fw_update_capabilities(
-				mors, (struct ext_host_tbl_s1g_caps *)hdr);
+		case MM81X_FW_HOST_TABLE_TAG_S1G_CAPABILITIES: {
+			struct ext_host_tbl_s1g_caps *caps;
+
+			if (left < sizeof(*caps) || tlv_len < sizeof(*caps)) {
+				ret = -EINVAL;
+				goto exit_free;
+			}
+			caps = (struct ext_host_tbl_s1g_caps *)hdr;
+			mm81x_fw_update_capabilities(mors, caps);
 			break;
+		}
+		case MM81X_FW_HOST_TABLE_TAG_INSERT_SKB_CHECKSUM: {
+			struct ext_host_tbl_insert_skb_checksum *cks;
 
-		case MM81X_FW_HOST_TABLE_TAG_INSERT_SKB_CHECKSUM:
-			mm81x_fw_update_validate_skb_checksum(
-				mors,
-				(struct ext_host_tbl_insert_skb_checksum *)hdr);
+			if (left < sizeof(*cks) || tlv_len < sizeof(*cks)) {
+				ret = -EINVAL;
+				goto exit_free;
+			}
+			cks = (struct ext_host_tbl_insert_skb_checksum *)hdr;
+			mm81x_fw_update_validate_skb_checksum(mors, cks);
 			break;
+		}
+		case MM81X_FW_HOST_TABLE_TAG_YAPS_TABLE: {
+			struct ext_host_tbl_yaps_table *yt;
 
-		case MM81X_FW_HOST_TABLE_TAG_YAPS_TABLE:
-			mm81x_yaps_hw_read_table(
-				mors, &((struct ext_host_tbl_yaps_table *)hdr)
-					       ->yaps_table);
+			if (left < sizeof(*yt) || tlv_len < sizeof(*yt)) {
+				ret = -EINVAL;
+				goto exit_free;
+			}
+			yt = (struct ext_host_tbl_yaps_table *)hdr;
+			mm81x_yaps_hw_read_table(mors, &yt->yaps_table);
 			break;
+		}
 		default:
 			break;
 		}
 
-		head += le16_to_cpu(hdr->length);
-		if (!hdr->length)
+		if (!tlv_len)
 			break;
+		if (tlv_len > left) {
+			ret = -EINVAL;
+			goto exit_free;
+		}
+		head += tlv_len;
 	}
 
+exit_free:
 	kfree(ext_host_table);
 	return ret;
 exit:

