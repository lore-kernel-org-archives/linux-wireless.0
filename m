Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD5315D58;
	Wed, 12 Aug 2026 06:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514892; cv=none; b=SKkn9TJhdVXNd4ADkwlmWdy4M8HP/z9jzLPD67k6I9ypFWuTiAYK1b2p0luAo1QeUG4vZQxGQTaBN8NVMCDRgYMxLhOnIpUlwuMs6E9mBH0t6tBt+Hg8BPSJ76yAqk3nsZvqBUrpYQxIgn4ihAZ7y/eKYWw3LxyoODr3n3D4cT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514892; c=relaxed/simple;
	bh=1Zgoh7KwYe19jPX28ywjpTtR7fob6aZecEE4CDysbag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U132ZhI+neWUf/sS1CYqJ4nHdQC2M7Avqjtmq1xNn/UkwpjzPjzV0ftYk0suC9Jp3M9w2MKsyqDaeHiYO96L8pO/QRJEIZQnM4rWg8Rq2DJjkSiP8ffagxU3wSWncpwaPXc2XOMKrg4PubDGUjO3oFhHPeYDPaDmNksHZLRQoII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2d767f76961411f1aa26b74ffac11d73-20260812
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:358db522-993e-451c-8923-f7160c3eb2a1,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:222384f615f6213ad7a20a2ec4404eb4,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2d767f76961411f1aa26b74ffac11d73-20260812
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2103006533; Wed, 12 Aug 2026 14:08:03 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 4/4] wifi: mm81x: bound the extended host table walk
Date: Wed, 12 Aug 2026 14:07:40 +0800
Message-Id: <20260812060740.1275280-5-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260812060740.1275280-1-lilinmao@kylinos.cn>
References: <20260812060740.1275280-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extended host table is read from the chip into a buffer sized from
the length register, then walked without any of its contents being
checked:

 - the length the table declares in its own header is used to compute
   the end pointer, but is never compared against the length that was
   read, so a larger value moves the end pointer past the buffer;
 - the walk only requires a TLV header to start before that end, so a
   header straddling it is read anyway;
 - every recognised tag is cast to a structure larger than the TLV
   header and read in full without checking that the TLV is that long,
   so a short S1G capabilities, checksum or YAPS TLV at the end of the
   table reads past the allocation.

Firmware that reports a table the driver does not agree with is enough
to reach these; it does not take a malicious device.

Reject a self-declared length that does not fit what was read, and walk
the TLVs by remaining length, skipping any TLV too short for the
structure its tag selects.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 47 +++++++++++++++-------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d2fba42e53627..50fa9e4b5f803 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -503,6 +503,13 @@ static int mm81x_fw_read_ext_host_table(struct mm81x *mors,
 	if (ret)
 		goto exit;
 
+	/* The table describes its own length; it must fit what was read */
+	if (le32_to_cpu(host_tbl->ext_host_tbl_length) < sizeof(*host_tbl) ||
+	    le32_to_cpu(host_tbl->ext_host_tbl_length) > ext_host_tbl_len) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	mm81x_release_bus(mors);
 	*ext_host_table = host_tbl;
 	return ret;
@@ -570,34 +577,44 @@ int mm81x_fw_parse_ext_host_tbl(struct mm81x *mors)
 	end = ((u8 *)ext_host_table) +
 	      le32_to_cpu(ext_host_table->ext_host_tbl_length);
 
-	while (head < end) {
+	while (end - head >= (ptrdiff_t)sizeof(struct ext_host_tbl_tlv_hdr)) {
 		struct ext_host_tbl_tlv_hdr *hdr =
 			(struct ext_host_tbl_tlv_hdr *)head;
+		u16 tlv_len = le16_to_cpu(hdr->length);
+
+		if (tlv_len < sizeof(*hdr) || tlv_len > end - head)
+			break;
 
 		switch (le16_to_cpu(hdr->tag)) {
-		case MM81X_FW_HOST_TABLE_TAG_S1G_CAPABILITIES:
-			mm81x_fw_update_capabilities(
-				mors, (struct ext_host_tbl_s1g_caps *)hdr);
+		case MM81X_FW_HOST_TABLE_TAG_S1G_CAPABILITIES: {
+			struct ext_host_tbl_s1g_caps *caps = (void *)hdr;
+
+			if (tlv_len >= sizeof(*caps))
+				mm81x_fw_update_capabilities(mors, caps);
 			break;
+		}
+		case MM81X_FW_HOST_TABLE_TAG_INSERT_SKB_CHECKSUM: {
+			struct ext_host_tbl_insert_skb_checksum *csum =
+				(void *)hdr;
 
-		case MM81X_FW_HOST_TABLE_TAG_INSERT_SKB_CHECKSUM:
-			mm81x_fw_update_validate_skb_checksum(
-				mors,
-				(struct ext_host_tbl_insert_skb_checksum *)hdr);
+			if (tlv_len >= sizeof(*csum))
+				mm81x_fw_update_validate_skb_checksum(mors,
+								      csum);
 			break;
+		}
+		case MM81X_FW_HOST_TABLE_TAG_YAPS_TABLE: {
+			struct ext_host_tbl_yaps_table *yaps = (void *)hdr;
 
-		case MM81X_FW_HOST_TABLE_TAG_YAPS_TABLE:
-			mm81x_yaps_hw_read_table(
-				mors, &((struct ext_host_tbl_yaps_table *)hdr)
-					       ->yaps_table);
+			if (tlv_len >= sizeof(*yaps))
+				mm81x_yaps_hw_read_table(mors,
+							 &yaps->yaps_table);
 			break;
+		}
 		default:
 			break;
 		}
 
-		head += le16_to_cpu(hdr->length);
-		if (!hdr->length)
-			break;
+		head += tlv_len;
 	}
 
 	kfree(ext_host_table);
-- 
2.25.1

