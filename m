Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8764B364935
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 01:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809505; cv=none; b=SG47awcJaH1z3UxLDNVp4Nk001k+y6v8Vg9V5fYNtVbHqOQ2FxwJYC8jXqZMv49+XkzPxgXIzEu7p44LdiznKeKnn3BCmRoxdeaHgf3qEldmVmxoTPe0kCMCAKTIZervGp0IeDIww9HQkc1uzb8VYRgLFbqm3maU0GRe0jTZ/1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809505; c=relaxed/simple;
	bh=lsLf2zQUdyJ/SUmEMac0mEkPt94Or+RyrPeEfJfMYD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LpxSrWdp3pZEvt5UO8dESheEOIeiXHCABTEtDtOwWe8jra8s7OUyKmUpMAD04pEAb5LZHxA8g4XXvSGJtZRJ2gRsiB/df7/mNrb051sYemPN55jWhzCTgU7mm5JFY1jwzmky4sHLAG9mfKAWsVnf1AdR6AgoPd8XxqUn9u0CbpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=exHS6cuL; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="exHS6cuL"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64F1j2UD12587123, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778809502; bh=aGK5TjQvsQIPopfYe09Fy8/hp+5QybS78Jt8ZQR8NFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=exHS6cuL+Wp05CXrElaFgN/jGG4Po+/oyx+HvvDyuEwMllmaivgop41xZbTc/1VO0
	 465cnXSL0UOlq6us67elL8hTkVDizbx0gQjMrz+IqLNguDCwz0hX1PqQMYqyZ+anwP
	 lxPkGzPbZbxKDfa5uT4IXzN9HqwKXuXw/I8L1TIxkbWCHPN7hIv4fl9jum3y8Og26M
	 QiWFVMYP6om1w3yTAahFaxgSL7D0d1mXiVo2M0bubSfjy6TQtSAyZSN609xpHE3COY
	 Zt8/Kn76EDpC7I94DWP/8oQksqeHyoJWCXAhLTohQpm1/RePQw2MPj8sC77EAKvfT/
	 4hRBZLVwT8MEg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 64F1j2UD12587123
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 09:45:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 May 2026 09:45:02 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 15 May 2026 09:45:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <dian_syuan0116@realtek.com>, <phhuang@realtek.com>,
        <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 04/13] wifi: rtw89: pci: enable LTR based on pcie control register
Date: Fri, 15 May 2026 09:44:24 +0800
Message-ID: <20260515014433.16168-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260515014433.16168-1-pkshih@realtek.com>
References: <20260515014433.16168-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

Originally, driver always transmits LTR (Latency Tolerance Reporting) to
pcie host, but it may cause pcie link down on some platforms because
LTR is not supported. As a result, driver will check the control
register of LTR setting to decide whether to enable LTR feature.

This applies to Wi-Fi 6 chips only. For Wi-Fi 7 chips, although the
driver still issues LTR, the hardware has its own internal logic
to determine whether to actually transmit it to pcie host.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 64554eb35a72..f7107dc05b71 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3039,6 +3039,17 @@ static int rtw89_pci_mode_op(struct rtw89_dev *rtwdev)
 	return 0;
 }
 
+static bool rtw89_pci_dev_ltr_enabled(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+	u16 cap;
+
+	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &cap);
+
+	return !!(cap & PCI_EXP_DEVCTL2_LTR_EN);
+}
+
 static int rtw89_pci_ops_deinit(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
@@ -3143,7 +3154,7 @@ int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
 
-	if (!en)
+	if (!en || !rtw89_pci_dev_ltr_enabled(rtwdev))
 		return 0;
 
 	val = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
@@ -3179,6 +3190,9 @@ int rtw89_pci_ltr_set_v1(struct rtw89_dev *rtwdev, bool en)
 	u32 dec_ctrl;
 	u32 val32;
 
+	if (!rtw89_pci_dev_ltr_enabled(rtwdev))
+		return 0;
+
 	val32 = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
 	if (rtw89_pci_ltr_is_err_reg_val(val32))
 		return -EINVAL;
-- 
2.25.1

