Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BBB3264F4;
	Wed, 12 Aug 2026 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514885; cv=none; b=dNCsUO5FgcDYsom9S9t5hqLZMpo7Vx3H79RNNp7ikgDdYqpWLRecerrWS+ArMs3x4euSNLQFDO616NQ6XmU610pgQa9J2pB1Ha/PttsAs9TiQ3s6jLdCoaQJEwZnIdxZZGm6nMHqb9sI7LzRww9MkiDyAo1+4SDTcR1whNpMv2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514885; c=relaxed/simple;
	bh=7K0F3pNxMJxMUv8nrmHJgg+DdGJ5S+hgkuvjQayL5lU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YrrDKFEoDcoMP2FUjCzcJqH3O6Ye8MYvaKSxR+1ydNCF05ZfEZvopSdW/n4L5LipQxcCRDoh2jao2FvdI+Q9Kud5Q/G3X8sGzFifWPLLunYk5L8hhdBbnUlyrCIm4whLJc76Wiicw2o/FUNtdAU2oTTZJ6WWnWZq4swH/Xl4geE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 27836566961411f1aa26b74ffac11d73-20260812
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b7b2b4b5-a492-49f2-aafc-ca39b1af9aa9,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:4f6115090072d14b10440498c34e5d58,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 27836566961411f1aa26b74ffac11d73-20260812
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1170945384; Wed, 12 Aug 2026 14:07:53 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 1/4] wifi: mm81x: free the firmware scratch buffer on parse failures
Date: Wed, 12 Aug 2026 14:07:37 +0800
Message-Id: <20260812060740.1275280-2-lilinmao@kylinos.cn>
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

mm81x_fw_load_fw() allocates fw_buf before it inspects the image, but
releases it only on the success path.  The two early returns taken for a
malformed image leave one firmware-sized allocation attached to the
device, and mm81x_fw_flash() retries the load three times.

Release it on those paths too, the way mm81x_fw_load_bcf() already does.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d6d2ad086c328..d407b57f4c9cb 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -117,13 +117,15 @@ static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 
 	if (mm81x_fw_get_header(fw->data, &ehdr)) {
 		dev_err(mors->dev, "Wrong file format");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free;
 	}
 
 	if (mm81x_fw_get_section_header(fw->data, &ehdr, &sh_strtab,
 					ehdr.e_shstrndx)) {
 		dev_err(mors->dev, "Invalid firmware. Missing string table");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out_free;
 	}
 
 	sh_strs = (const char *)fw->data + sh_strtab.sh_offset;
@@ -179,6 +181,7 @@ static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 	if (ehdr.e_entry)
 		ret = mm81x_fw_set_boot_addr(mors, ehdr.e_entry);
 
+out_free:
 	devm_kfree(mors->dev, fw_buf);
 	return ret;
 }
-- 
2.25.1

