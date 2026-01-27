Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE529D289
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 08:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769503911; cv=none; b=X+0/a9JKRGWtH9tpNw8uLZt8U0+MhoXK0VqSB92TXGDsRNZvLEFwPVrUmOOqQs8Bxh9qPOEk/FJG3L2zIeqrz2QITtWNKaV0Go2Dy2Kdf2zQCpao6Yl9wNu17nKR9pqO5DzgNFPcuIlCCAt6l/gSDSBQXuSjs5wCdQuOfaWcEPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769503911; c=relaxed/simple;
	bh=n1k3KsG+drMv5ykDvt2AaqoaU4sF3tfu+C+bcly2ZXw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gpohk5GxGjirOjckyLb5hLyKbBi+2zO0MumzqVUTlZOsFQGuEWz55eHT7yaQD2egbF+zS0/l9C13exwG/4T4oJIVQhzSrltxUb9ycUlXna6tTM2GUwr6Zgf50f3oKbHaAU42vjfAWCn+FrDXd2wTp4zMqdd/WVkAZcmTWnHXnhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DtwjGxnF; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DtwjGxnF"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 60R8pmMvB2655529, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769503908; bh=D5ZiFDgjucGtUOtlm10/3yibt3CXOI7+1e45cGnUmTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=DtwjGxnFYNZl4mI+yEXrjLx4ugt0DkspH5ggNVxYFqATDjrv08EEOOrlx6jHvIik6
	 NTX8IFSfFypNtRa9ieeN0cIXaFzW2G98NZXYCSyRCCO/Ci8nHH3qmGkOWCNF6fh+/a
	 88A9si5/KUK3ZeHUaONUv/OgPlH99OOG0lFbxUKfwyHS46gvuVo9ZC2wpoOBN1mR0l
	 ft86lzoUCVpGeneW8fVdp7GlsV7WQyeNnYQICAJzgboH5m7joJwQWeITmyJ0yVeM7u
	 B/UeM+pQ36AD+FT9ZsRNwqWB9pULidNuNX9I8jxC+wxJNeE1sfmDOy/8FNK49G2UcP
	 fPv54GF8RjP0g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 60R8pmMvB2655529
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 16:51:48 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 27 Jan 2026 16:51:48 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 27 Jan 2026 16:51:47 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 27 Jan 2026 16:51:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <dian_syuan0116@realtek.com>,
        <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 5/6] wifi: rtw89: pci: restore LDO setting after device resume
Date: Tue, 27 Jan 2026 16:50:35 +0800
Message-ID: <20260127085036.44060-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260127085036.44060-1-pkshih@realtek.com>
References: <20260127085036.44060-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

The LDO (Low Dropout Regulator) setting is missing after suspend/resume
in some platforms, and it will cause card loss. Therefore, reconfigure
this setting to avoid it.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 093960d7279f..9f3445fa55a9 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4603,6 +4603,7 @@ static int __maybe_unused rtw89_pci_resume(struct device *dev)
 		rtw89_write32_clr(rtwdev, R_AX_PCIE_PS_CTRL_V1,
 				  B_AX_SEL_REQ_ENTR_L1);
 	}
+	rtw89_pci_hci_ldo(rtwdev);
 	rtw89_pci_l2_hci_ldo(rtwdev);
 
 	rtw89_pci_basic_cfg(rtwdev, true);
-- 
2.25.1

