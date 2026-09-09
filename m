Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96823BFE33
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937300; cv=none; b=puxSwyortVdJ1NXwXSgQpNV/GRelYrTf+CYjcrg2hJOHqXBraiy85nI3wiv27C608o18V3IwHmszqbo9d9sTvjPx+P6OzlUOTdPBr5DUyz/G7NBzXzi+AbMg+6bJRIlHqb/oFzpX+Pvati8zEHSccnImgDbK0Ap5d7IsE7x1J00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937300; c=relaxed/simple;
	bh=z0/+TfgV7n2fOCl80R03xO8oc0+BN53rE0UQOpSS0Io=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j1w9tSt2RTyhpAvmpKt2GyIGHEXqslh9fgqj9goFHmDyMeumWDpN2tFmXxJpRVLkQyCvZXsxhqohM58C9wI/jYkXYamDsV0m2Rt5TxeOvJ9Zq/134TchjoOxFQ4Nc8WPc5WOo7XpfNKH4gL3CpRSmR6TRUvgr8ST50yua71UXNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=WgggYboc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="WgggYboc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971X5c8356915, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937294; bh=NQWgFN+9ih7Y9ZJ4rFVXGl9CzEk6gfLt8VYtpHh058E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=WgggYbocDcK2PaBmNvvcMFBTkZlmQUYk6gRiib5GBEKHUH9iQlfJpxWuyJBBv9tR4
	 xrisXPTIC2E407AwWARoTNDwbuHA5ALu9n+d/VLTFg+JYCI1a0AXGOdmpCpG90jFTx
	 OIb2YDrHCXs9L3y+NBPI69zBZ6BXbPgcUiF45BA+pbtJIiIe4a3JR+eQtKjaeCHUXY
	 dp2m64ymOVbNTniTcMNig1D5msU8MvHRboqe6e+Drw7YRQ8FIIo0mCwDTBMfC1GWIW
	 TjdM/aFo4FQW1TYC0ROqoiFtTqyAQbn7uAf75CfkcQWXFl4KME0PxlADaJZR+UvlGM
	 mU98TwM3c1UFA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971X5c8356915
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:34 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:33 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 10/15] wifi: rtw89: mac: change beamformee CSI direct forward to CMAC_TXDMA
Date: Wed, 9 Sep 2026 14:59:59 +0800
Message-ID: <20260909070004.35353-11-pkshih@realtek.com>
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

Set R_BE_RESP_MODE register when initializing beamformee to makes CSI
RX state machine enter initial state, and enables received beamformee CSI
to be directly forwarded to CMAC_TXDMA via hardware shortcut path.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac_be.c |  3 +++
 drivers/net/wireless/realtek/rtw89/reg.h    | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index c8f343c8d545..fa35cafd7074 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -2786,6 +2786,9 @@ static int rtw89_mac_init_bfee_be(struct rtw89_dev *rtwdev, u8 mac_idx)
 				       B_BE_CSIPRT_HESU_AID_EN |
 				       B_BE_CSIPRT_EHTSU_AID_EN);
 
+	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_RESP_MODE, mac_idx);
+	rtw89_write32_set(rtwdev, reg, B_BE_INIT_CLEAR_RX_STATE | B_BE_SHORT_CUT_MODE);
+
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_TRXPTCL_RESP_CSI_RRSC, mac_idx);
 	rtw89_write32(rtwdev, reg, CSI_RRSC_BMAP_BE);
 
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 4291e8115f10..e85af8713777 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -8373,6 +8373,26 @@
 #define B_BE_CSI_RESERVED_PAGE_NUM_MASK GENMASK(27, 16)
 #define B_BE_CSI_RESERVED_START_PAGE_MASK GENMASK(11, 0)
 
+#define R_BE_RESP_MODE 0x11814
+#define R_BE_RESP_MODE_C1 0x15814
+#define B_BE_LMR_MASK_PRE_ENQ BIT(27)
+#define B_BE_LMR_INIT_CLEAR_RX_STATE BIT(26)
+#define B_BE_LMR_SHORT_CUT_MODE BIT(25)
+#define B_BE_LMR_IMMED_ENQ_MODE BIT(24)
+#define B_BE_CLEAR_SMR_SEG_TBL BIT(19)
+#define B_BE_CLEAR_FTM_SEG_TBL BIT(18)
+#define B_BE_CLEAR_CSI_SEG_TBL BIT(17)
+#define B_BE_CLEAR_CSI_RESP_TBL BIT(16)
+#define B_BE_SMR_MASK_PRE_ENQ BIT(12)
+#define B_BE_SMR_DELAY_IMMED_ENQ_MODE BIT(11)
+#define B_BE_SMR_INIT_CLEAR_RX_STATE BIT(10)
+#define B_BE_SMR_SHORT_CUT_MODE BIT(9)
+#define B_BE_SMR_IMMED_ENQ_MODE BIT(8)
+#define B_BE_CSI_MASK_PRE_ENQ BIT(3)
+#define B_BE_INIT_CLEAR_RX_STATE BIT(2)
+#define B_BE_SHORT_CUT_MODE BIT(1)
+#define B_BE_IMMED_ENQ_MODE BIT(0)
+
 #define R_BE_RESP_IMR1 0x11878
 #define R_BE_RESP_IMR1_C1 0x15878
 #define B_BE_RESP_IMR_1_MASK GENMASK(31, 9)
-- 
2.25.1

