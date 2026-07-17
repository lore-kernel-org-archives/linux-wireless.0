Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929622E6CA8
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269255; cv=none; b=Xn0G6t2WBwlAA6d6b6h0MxFQvE/qSPYNYkw26w9+sFNyTawhDx1Pj0UX5qvRGeuwZGjg3VfPADgoERZnneJwtWhdJInr7GBtze3v2VPcpv9776e3HlIiDZJiJhs4dbDxLHnSCTtz19Q9SsF9l8CI+PXI5bdb5pAfLejAB71kdrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269255; c=relaxed/simple;
	bh=geVS9fKlhYUPvQMlXmoHgSIRkap2KCpSPOtaJ79hz3E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6Uam4XZvPvrT2r9nWK5NS2IOpPaUwJvRACh8F/X9VGYbUstuxk/xxVvySd/fd7WAEEdQkYU+0r+GwtNEIkPGrsnVLmypc2kI7zjtvw7eejlnbYgeUCkb8EZp3cYT70yYsyR0gyDHY1b5bsR4LmuevVXRWHtAudbVZk5cfhIeKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hMAc/maJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hMAc/maJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KpTJ24163689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269251; bh=3iZh5203Lg8vpPbIlZLsjcc6rpuzMm/hAW1H4mj0i0Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=hMAc/maJMm5C6yps1IjnvDQIG0qcwUU49JoGcGj8TgRDnuN334QrATVqkw3qqeiMJ
	 zoRlT4DIacgfsqVCDPBkzjrno3JhD1OQ3CDzx9Nj6n/bHluVW9PW4LubufQN1kicvm
	 mYo3sOG9J/opBmrtk/K7XxARvhWLMwgqcTxjyAlTbFOLSkjGSfa53sgtlLjmEMnlZY
	 OeWcnOjRfURUEvQR69BUNAGqFPwf+c0Rb/TSlAjyaOEDEPHt8S2Rp5emO0fbbT8Jj3
	 JwajOj7OKb/s0EU3CNtFCQebtzYW3KhnMCuHBcCo1w8baCJFFR0gHlyEmUfJymEf52
	 rnGO/0eGFkcAg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KpTJ24163689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:51 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:51 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:51 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 7/9] wifi: rtw89: pci: set PCIe maximum TS1 for RTL8922DE
Date: Fri, 17 Jul 2026 14:19:08 +0800
Message-ID: <20260717061910.54466-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717061910.54466-1-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Set TS1 (training sequence 1) to 1024 when PCIe enters recovery state to
improve RF interference while entering and leaving L1ss.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.h    |  1 +
 drivers/net/wireless/realtek/rtw89/pci_be.c | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index 339706d99f6c..0e1557cedd20 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1138,6 +1138,7 @@
 #define RTW89_PCIE_GEN1_SPEED		0x01
 #define RTW89_PCIE_GEN2_SPEED		0x02
 #define RTW89_PCIE_PHY_RATE		0x82
+#define RTW89_PCIE_EXTENDED_SYNCH	BIT(7)
 #define RTW89_PCIE_PHY_RATE_MASK	GENMASK(1, 0)
 #define RTW89_PCIE_LINK_CHANGE_SPEED	0xA0
 #define RTW89_PCIE_L1SS_STS_V1		0x0168
diff --git a/drivers/net/wireless/realtek/rtw89/pci_be.c b/drivers/net/wireless/realtek/rtw89/pci_be.c
index 6390980b8ee0..d338bf633272 100644
--- a/drivers/net/wireless/realtek/rtw89/pci_be.c
+++ b/drivers/net/wireless/realtek/rtw89/pci_be.c
@@ -85,13 +85,22 @@ static void _patch_pcie_power_wake_be(struct rtw89_dev *rtwdev, bool power_up)
 
 static void _patch_pre_init_be(struct rtw89_dev *rtwdev)
 {
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
 	struct rtw89_hal *hal = &rtwdev->hal;
+	struct pci_dev *pdev = rtwpci->pdev;
 
-	if (!(rtwdev->chip->chip_id == RTL8922D && hal->cid == RTL8922D_CID7090))
+	if (rtwdev->chip->chip_id != RTL8922D)
 		return;
 
+	if (hal->cid != RTL8922D_CID7090)
+		goto set_ts1;
+
 	rtw89_write16_clr(rtwdev, R_RAC_DIRECT_OFFSET_BE_LANE0_G2 +
 				  RAC_ANA14 * RAC_MULT, EIEOS_L1SS_WAIT_CLKRDY);
+
+set_ts1:
+	pci_clear_and_set_config_dword(pdev, RTW89_PCIE_L1_STS_V1,
+				       0, RTW89_PCIE_EXTENDED_SYNCH);
 }
 
 static void rtw89_pci_set_io_rcy_be(struct rtw89_dev *rtwdev)
-- 
2.25.1

