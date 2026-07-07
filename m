Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3F2882C5
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415569; cv=none; b=hifZUtX9klj8GirS9YLeDwWLKmthf1ax2Kot59EnBVCQE4QaApD7WeklYpbZQh7uNLqH/qWtA88KVLO5bloH8nBIQ0LJh6Vou7PpawVa1NYsYAQIdjQOAkbYzHiNQiwfHuKDzxDIVjMR8mqIuRwRGL3yxMhiNlnxz3zvl7PMBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415569; c=relaxed/simple;
	bh=XRrKDc107D3tnxuRuSlOR3zifchg3nmSj4I6jM88NEI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGqAiiLczFFhgJqy84oNZDoeaIo3eHfWUW9QjDXvCzEX98bczdns7d28LScKze1CkvwiuyWT+g1cXIZT/i/Qt5VJt62hiVzJ8lGw///h0865XOPXtzzoXnSpUBkULu0jCitnK4k5tQlhE0il+bB6hNIPcMdj3/2XNLjrEjIEa4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NEnnnQkX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NEnnnQkX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6679CjaT61359640, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783415565; bh=rR7KT9WdhO85422kmmgpKN4YX2GHCuAWJyp9+IBQUAY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=NEnnnQkX01VrW07/+pMD+6TGvWcD2MQw5UbOD15lmXsNvW7cn4aQ8EBHocZV1krmH
	 O/NfbLjUXVufpgg9bNwZTHZu44pPzucXUlZ3J62Wqs77zIX7sNQH7z3LBgfnmKrPNR
	 xLymabmlZq2AF5p5Bybt4Xzk8QBI0CulyXOC4zBkrT5B7S0S8VzNap8mgR17nmQfEQ
	 aH1Hg6XDbPb7z7UQQEMs4bheX6h0UIGRPb/s3UsVh4KAmPj7aIcemF7chX2wjpbSNg
	 a0/NfCN8GQT+zvFgDcuDWLDCl5OqAzRE+igdJNKyxcCh0qmz15NDD6wqNlJr9J1KxM
	 xlj4BOZOdeuxQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6679CjaT61359640
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Jul 2026 17:12:45 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:45 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 7 Jul 2026 17:12:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: [PATCH rtw-next 10/15] wifi: rtw89: 8922d: set ANA CLK enter to 500KHz
Date: Tue, 7 Jul 2026 17:10:51 +0800
Message-ID: <20260707091056.42771-11-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707091056.42771-1-pkshih@realtek.com>
References: <20260707091056.42771-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

To power save, change the clock of ANA hardware from 12MHz to 500KHz.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac.h      |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index f85c14ca0f35..a5f1694af91a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1680,6 +1680,7 @@ enum rtw89_mac_xtal_si_offset {
 	XTAL_SI_PWR_CUT = 0x10,
 #define XTAL_SI_SMALL_PWR_CUT	BIT(0)
 #define XTAL_SI_BIG_PWR_CUT	BIT(1)
+	XTAL_SI_AONLDO_CTRL = 0x10,
 	XTAL_SI_XTAL_DRV = 0x15,
 #define XTAL_SI_DRV_LATCH	BIT(4)
 	XTAL_SI_XTAL_PLL = 0x16,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 36b9b529195d..8ca07aeb377a 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -535,6 +535,19 @@ static int rtw8922d_pwr_on_func(struct rtw89_dev *rtwdev)
 	rtw89_write32_set(rtwdev, R_BE_SYS_PW_CTRL, B_BE_EN_WLON);
 	rtw89_write32_set(rtwdev, R_BE_WLRESUME_CTRL, B_BE_LPSROP_CMAC0 |
 						      B_BE_LPSROP_CMAC1);
+
+	if (hal->aid == RTL8922D_AID7102) {
+		ret = rtw89_mac_write_xtal_si(rtwdev, XTAL_SI_AONLDO_CTRL, 0, 0x20);
+		if (ret)
+			return ret;
+
+		udelay(1);
+
+		ret = rtw89_mac_write_xtal_si(rtwdev, XTAL_SI_AONLDO_CTRL, 0, 0x40);
+		if (ret)
+			return ret;
+	}
+
 	rtw89_write32_set(rtwdev, R_BE_SYS_PW_CTRL, B_BE_APFN_ONMAC);
 
 	ret = read_poll_timeout(rtw89_read32, val32, !(val32 & B_BE_APFN_ONMAC),
-- 
2.25.1

