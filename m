Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5B72877DE
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937334; cv=none; b=cKakvrILpa9gufmGhad+vFdslH6c8o6AwPEM4P54/TNlOqaT9eNvhcwwFg5YL5RQUkE30GMR7gFxHcVGqiTaiVYR3HaWyNrK3ZvldOwKc9s3QMnXo9Mpan3PFCtSiyKEqGDOb8X397L+Nl4XGhk1lnv3bpXfnBbGbI5V98CL+Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937334; c=relaxed/simple;
	bh=jcVlkOnTdeMwQSzKxDBbqxQk2uESwRKwZ3ToR4nCJy8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSu0FCOkfYZtZ4qbhXSoIjUJYOVkV0xBuUrryDxppPTrE6QfFeJswzXxe4b66H5iNObrsayzmc+XzsBFjcN00hntEjHXF5EYwXc6jsRt4rpnsCn7MXCA+NscsmGqx6xc1e1kvFyld9EkbF354dZx0X0bEyCBOZOQSGbGCmoTL9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=lxcL5250; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="lxcL5250"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 689727Lr8357262, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937328; bh=yP6tOcyXIaYPRkWp3r9SeiITEsw0htPkWUD0eTN75Zs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=lxcL5250vKT0f93Sl54hul7gyoGxLaFV8EEWxXvrE1PDr0AUyL3Xuu1B5G4RiH94o
	 WM9zWG8bhfkPiZrUojUsx/W221Hmqaum+MFn3BKjaYgQWMqmosSRsXcw2ZLkux79WE
	 FVLfmscZqfiBcuChte3c7PVts50wpdChZhDPaPPee+UYhnlKgFglePeDCh/i0eVo6O
	 1lWn2SVPgfvUFzzCx/NCRpYuu+GAAf7luJ2E+b+RND2tTx+y6vsHD63g4VXorFIuej
	 94Oh7EkXHLybtvNQ3NtBc5Ub2zV4QR2WUtm0EMFjoGkAFzFnIs+UNfJkRZ8e13Htac
	 +2LNPNK9fwtLQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 689727Lr8357262
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:02:07 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:02:07 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:02:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:02:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 15/15] wifi: rtw89: phy: correct PHY-1 EDCCA report register access
Date: Wed, 9 Sep 2026 15:00:04 +0800
Message-ID: <20260909070004.35353-16-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Eric Huang <echuang@realtek.com>

RTL8922D fills the PHY-1 rpt_b entry with the address of rpt_a.

The report select of RTL8922A and RTL8922D has a per-PHY instance, but it
was written without the PHY index, so PHY-1 read its report registers
through the select of PHY-0. Write it with rtw89_phy_write32_idx() instead.

Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.c      | 12 ++++++------
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index c33b888bc0e3..074865665b16 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -8712,8 +8712,8 @@ static void rtw89_phy_edcca_log(struct rtw89_dev *rtwdev, struct rtw89_bb_ctx *b
 	rtw89_phy_write32_mask(rtwdev, edcca_p_regs->rpt_sel,
 			       edcca_p_regs->rpt_sel_mask, 0);
 	if (rtwdev->chip->chip_id == RTL8922A || rtwdev->chip->chip_id == RTL8922D) {
-		rtw89_phy_write32_mask(rtwdev, edcca_regs->rpt_sel_be,
-				       edcca_regs->rpt_sel_be_mask, 0);
+		rtw89_phy_write32_idx(rtwdev, edcca_regs->rpt_sel_be,
+				      edcca_regs->rpt_sel_be_mask, 0, bb->phy_idx);
 		per20_bitmap = rtw89_phy_read32_mask(rtwdev, edcca_p_regs->rpt_a,
 						     MASKBYTE0);
 	}
@@ -8738,16 +8738,16 @@ static void rtw89_phy_edcca_log(struct rtw89_dev *rtwdev, struct rtw89_bb_ctx *b
 	pwdb_s40 = u32_get_bits(tmp, MASKBYTE2);
 
 	if (rtwdev->chip->chip_id == RTL8922A || rtwdev->chip->chip_id == RTL8922D) {
-		rtw89_phy_write32_mask(rtwdev, edcca_regs->rpt_sel_be,
-				       edcca_regs->rpt_sel_be_mask, 4);
+		rtw89_phy_write32_idx(rtwdev, edcca_regs->rpt_sel_be,
+				      edcca_regs->rpt_sel_be_mask, 4, bb->phy_idx);
 		tmp = rtw89_phy_read32(rtwdev, edcca_p_regs->rpt_b);
 		pwdb[0] = u32_get_bits(tmp, MASKBYTE3);
 		pwdb[1] = u32_get_bits(tmp, MASKBYTE2);
 		pwdb[2] = u32_get_bits(tmp, MASKBYTE1);
 		pwdb[3] = u32_get_bits(tmp, MASKBYTE0);
 
-		rtw89_phy_write32_mask(rtwdev, edcca_regs->rpt_sel_be,
-				       edcca_regs->rpt_sel_be_mask, 5);
+		rtw89_phy_write32_idx(rtwdev, edcca_regs->rpt_sel_be,
+				      edcca_regs->rpt_sel_be_mask, 5, bb->phy_idx);
 		tmp = rtw89_phy_read32(rtwdev, edcca_p_regs->rpt_b);
 		pwdb[4] = u32_get_bits(tmp, MASKBYTE3);
 		pwdb[5] = u32_get_bits(tmp, MASKBYTE2);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 2325e646c487..41e2aa1c8f78 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -271,7 +271,7 @@ static const struct rtw89_edcca_regs rtw8922d_edcca_regs = {
 		.rpt_sel_mask		= B_EDCCA_RPT_SEL_BE4_MSK,
 	}, {
 		.rpt_a			= R_EDCCA_RPT_A_BE4_C1,
-		.rpt_b			= R_EDCCA_RPT_A_BE4_C1,
+		.rpt_b			= R_EDCCA_RPT_B_BE4_C1,
 		.rpt_sel		= R_EDCCA_RPT_SEL_BE4_C1,
 		.rpt_sel_mask		= B_EDCCA_RPT_SEL_BE4_MSK,
 	}},
-- 
2.25.1

