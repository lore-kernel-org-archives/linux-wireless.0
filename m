Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9A39A4D6
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784882925; cv=none; b=oJuDSeybO0LQu8KSefiH5lf3T9CoFkipfG5wSbFiKXI9x4wdWHZRdHysJAAz/eZg436xnVxzObjuiiIBlRvnKraOfQMpETD6t8DOrO6pNssa/ZmVDWGIukje6fSOqCH3FYmFn5ik5UswQ8zZ4rYurCvmpx1OtzWBzVxF8nKsQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784882925; c=relaxed/simple;
	bh=LJdeqYihm9f7ZhZgDOk7Jj61TXihrNmsZ37/U8hbtM4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B/J4IJAGFVB5dphmIXdgXEE+HhzMy4CPFLy3t4/vUbTyEPwZU0IhYG0Rjz2ulfX7S25To7fWWNF1vItFszIRiqAGBDWI57gqoaFVJ7N77CBk9q86OkF8pByl8R0GScQuSoaAcMafA5pMdvsZtGNBBFkG/FzG9hXDjd7WOy6qrS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rPG3qLht; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rPG3qLht"
X-UUID: 727808c4873c11f1b1788b6acf885367-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=nyWiYmrY82lGfKhVlYkrW3OPfzhavRcnPcOFfJYwljI=;
	b=rPG3qLhtxp48dUKxa1MQEV059nqkG3dRb8lNjtSn1Fnj6GulZcVXgrLqjcRaBPO01oibLmD0rekceltbBZSAnr5hXc+Xm2AWgpZTwnIeJ80XU/QmcEmaf0K7qstPp1B0At8CK+aKkR5hL0Cdxn53jOU844CFQGrxT91etwFo8ns=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:abe21fbb-9974-445a-93e1-c9123d03b99c,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:8a735a6,CLOUDID:de805f98-d7dc-4717-b0e4-6dc2a9a44c15,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 727808c4873c11f1b1788b6acf885367-20260724
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 225498191; Fri, 24 Jul 2026 16:48:31 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:48:30 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:48:30 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt792x: skip MTCL country list lookup for default BE mode
Date: Fri, 24 Jul 2026 16:48:29 +0800
Message-ID: <20260724084829.3154190-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

In the v3 MTCL country list parsing, a mode_be value of 0x02 indicates
that 11BE enablement should follow the driver default instead of being
gated by the per-country BE bitmap.

Handle this case explicitly: when cl->mode_be == 0x02, skip the BE/EU
country list matching and return the driver default configuration
directly, avoiding an unnecessary lookup.

Fixes: 7cebc2300de2 ("wifi: mt76: mt792x: extend MTCL of APCI to version3 for EHT control")
Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 11 +++++++----
 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h |  7 +++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..868feadbff61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -388,7 +388,7 @@ mt792x_acpi_get_mtcl_map_v3(int row, int column, struct mt792x_asar_cl_v3 *cl)
 	u32 config = 0;
 	u8 mode_be = 0;
 
-	mode_be = (cl->mode_be > 0x02) ? 0 : cl->mode_be;
+	mode_be = (cl->mode_be > MT792X_ACPI_MTCL_MODE_DEFAULT) ? 0 : cl->mode_be;
 
 	if (cl->version > 2 && cl->clbe[row] & BIT(column))
 		config |= (mode_be & 0x3) << 4;
@@ -402,10 +402,10 @@ mt792x_acpi_get_mtcl_map(int row, int column, struct mt792x_asar_cl *cl)
 	u32 config = 0;
 	u8 mode_6g, mode_5g9;
 
-	mode_6g = (cl->mode_6g > 0x02) ? 0 : cl->mode_6g;
-	mode_5g9 = (cl->mode_5g9 > 0x01) ? 0 : cl->mode_5g9;
+	mode_6g = (cl->mode_6g > MT792X_ACPI_MTCL_MODE_DEFAULT) ? 0 : cl->mode_6g;
+	mode_5g9 = (cl->mode_5g9 > MT792X_ACPI_MTCL_MODE_ENABLE) ? 0 : cl->mode_5g9;
 
-	if ((cl->cl6g[row] & BIT(column)) || cl->mode_6g == 0x02)
+	if ((cl->cl6g[row] & BIT(column)) || cl->mode_6g == MT792X_ACPI_MTCL_MODE_DEFAULT)
 		config |= (mode_6g & 0x3) << 2;
 	if (cl->version > 1 && cl->cl5g9[row] & BIT(column))
 		config |= (mode_5g9 & 0x3);
@@ -426,6 +426,9 @@ mt792x_acpi_parse_mtcl_tbl_v3(struct mt792x_phy *phy, char *alpha2)
 	if (!cl)
 		return MT792X_ACPI_MTCL_INVALID;
 
+	if (cl->mode_be == MT792X_ACPI_MTCL_MODE_DEFAULT)
+		goto out;
+
 	for (i = 0; i < ARRAY_SIZE(cc_list_be); i++) {
 		col = 7 - i % 8;
 		row = i / 8;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
index 474033073831..110f68438d90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
@@ -17,6 +17,13 @@
 
 #define MT792X_ACPI_MTCL_INVALID	0xffffffff
 
+/* MTCL per-band control mode (mode_6g/mode_5g9/mode_be) */
+enum {
+	MT792X_ACPI_MTCL_MODE_DISABLE	= 0x00,	/* force disable */
+	MT792X_ACPI_MTCL_MODE_ENABLE	= 0x01,	/* enable if driver & BIOS support */
+	MT792X_ACPI_MTCL_MODE_DEFAULT	= 0x02,	/* supporting depends on driver setting */
+};
+
 struct mt792x_asar_dyn_limit {
 	u8 idx;
 	u8 frp[5];
-- 
2.18.0

