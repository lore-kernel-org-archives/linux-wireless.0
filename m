Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F131C3148D0;
	Wed, 12 Aug 2026 06:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514891; cv=none; b=vEdOocP0t4Y3x6UYo7FnC6bf6DY9kwnQ+ng6s0hxdKGCamUXb7GhQu1vfydaw5z65phkjHdKVoHoinoLVfza38Alg35cweLWzrtjZGbbnYYJO66DM34DrXyluJlXk9otWxAq9dwyJQd9pFkUs+EkvOlYn/HHlg6sllvnODeFXlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514891; c=relaxed/simple;
	bh=tQ1k/tIcckyMmnS8tsT6Z0X0s5QMb+r4aEyOZYtZ6h8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uAcyHRgmLLtD68g4r7DSJp/CPND1uDVcE0Lvot09ZzUcvjvPeexkjnYfiHgWyFvTxKk2obw+VU2VXrjUR+/SN/jENHJ9621qp0eAP+tEBwzSaYB4VYn0UWvdcsqealOKxoDhBYOLxk+DFsyArs9YbpcMXM5PqfQwIYbCgjk3duo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2c74e5c2961411f1aa26b74ffac11d73-20260812
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d4c173ca-74d7-49b1-bb5f-57630f49bfb0,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:cb7aab0023b1ac9047cc38007e75f7e9,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2c74e5c2961411f1aa26b74ffac11d73-20260812
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 422827498; Wed, 12 Aug 2026 14:08:01 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 3/4] wifi: mm81x: bound the .fw_info TLV walk
Date: Wed, 12 Aug 2026 14:07:39 +0800
Message-Id: <20260812060740.1275280-4-lilinmao@kylinos.cn>
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

mm81x_fw_parse_info() only checks that a TLV header starts before the
end of the section, so a header that straddles the end is read anyway,
and MM81X_FW_INFO_TLV_BCF_ADDR reads its four-byte value without looking
at the TLV length at all.  The BCF address can come from whatever
follows the section.

Walk by remaining length, and only take the address when the value is
really there.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 24 ++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index a2cb97cefc4e9..d2fba42e53627 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -54,21 +54,29 @@ static int mm81x_fw_get_header(const u8 *data, Elf32_Ehdr *ehdr)
 
 static void mm81x_fw_parse_info(struct mm81x *mors, const u8 *data, int length)
 {
-	const struct mm81x_fw_info_tlv *tlv =
-		(const struct mm81x_fw_info_tlv *)data;
+	const u8 *end = data + length;
+	const u8 *pos = data;
+
+	while (end - pos >= (ptrdiff_t)sizeof(struct mm81x_fw_info_tlv)) {
+		const struct mm81x_fw_info_tlv *tlv =
+			(const struct mm81x_fw_info_tlv *)pos;
+		u16 tlv_len = le16_to_cpu(tlv->length);
+
+		pos = tlv->val;
+		if (tlv_len > end - pos)
+			break;
 
-	while ((u8 *)tlv < (data + length)) {
 		switch (le16_to_cpu(tlv->type)) {
 		case MM81X_FW_INFO_TLV_BCF_ADDR:
-			mors->bcf_address = get_unaligned_le32(tlv->val);
+			if (tlv_len >= sizeof(__le32))
+				mors->bcf_address =
+					get_unaligned_le32(tlv->val);
 			break;
 		default:
 			break;
 		}
-		tlv = (const struct mm81x_fw_info_tlv *)((u8 *)tlv +
-							 le16_to_cpu(
-								 tlv->length) +
-							 sizeof(*tlv));
+
+		pos += tlv_len;
 	}
 }
 
-- 
2.25.1

