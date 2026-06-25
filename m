Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BB827707
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 06:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368206; cv=none; b=EZd67V1clVg+GXbfZXXpVbCkXcDwI0aN4mgCjJOwfK8UOP02xkQzHs0x7qvFyTEzAuUuEqk/4pXhQ9oUmli9Tuf1gFCqrVapIKKZ94/UtySwm+cGXud2HgHPvA7B3VpOkWyguua8t8+lwcpasQQDPTc8/q9uz7zyujul86+r6VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368206; c=relaxed/simple;
	bh=rRbkOAKTmPkrsOYSmp/SVicWaTyhZyNLa8zy4sR63Ho=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o61eukEbvEV3lA0iB9s5EPkZ6tY6izFvLY607jFJSbhPFqy7A+WCAOK/CCoSaes6h0/UDIggmIAPuQLJpDXb0SFcnIhpiw5ku/7xrW54cqYKAGWMrd7I5Ol4Vd/rD57U+HAJ/T64eHhJgrIaT+nfxB8/VDV6mobQFMSTQy7NojE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tklo0I6I; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tklo0I6I"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65P6GgcT6584296, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782368202; bh=du2O1vxWXpmB5QAOsMh8hTcciYSMZW8ffWFtm7u20uM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=tklo0I6ILt30uaNAOhq0Md9VxeX71UBMN27odB/SdhKos0Db91d3YtqP6LC4nU3zS
	 4KyC89phzFzf0xeQtwRYffNqWov3YmgkJtZq1EDlhF0VN9sf76+wocnJD/yEIBc+Eq
	 LC+aH5S50wzmQWEv5ZBfO1vxVxQ2gdjOXGDpOVgxaxGjePumkhYx51OZnz+eVnV467
	 Yykvfp3oPPAlwqELWCMiKD7hDPYCmECR6MfPwbKdlqppWv4S+zqqUOk9wYkuwmaVPF
	 x5I+GOHeSXRq9sBJ/1WO/aRWZZte7QuDYpkvue3UzpNIPKR4EXGzP/huoeuLXIN2SA
	 7az9P2HxpMaMA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65P6GgcT6584296
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 14:16:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 25 Jun 2026 14:16:42 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 25 Jun 2026 14:16:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <timlee@realtek.com>,
	<dian_syuan0116@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 02/10] wifi: rtw89: mac: pass chip version to firmware
Date: Thu, 25 Jun 2026 14:15:37 +0800
Message-ID: <20260625061545.44808-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260625061545.44808-1-pkshih@realtek.com>
References: <20260625061545.44808-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Set chip version to register shared with firmware before downloading
firmware, so firmware can run proper flow according to the version.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac_be.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index 70e6c9d21986..4cb48cf9415a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -641,6 +641,7 @@ static void set_cpu_en(struct rtw89_dev *rtwdev, bool include_bb)
 static int wcpu_on(struct rtw89_dev *rtwdev, u8 boot_reason, bool dlfw)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_hal *hal = &rtwdev->hal;
 	u32 val32;
 	int ret;
 
@@ -683,6 +684,8 @@ static int wcpu_on(struct rtw89_dev *rtwdev, u8 boot_reason, bool dlfw)
 	if (chip->chip_id != RTL8922A)
 		rtw89_write32_set(rtwdev, R_BE_WCPU_FW_CTRL, B_BE_HOST_EXIST);
 
+	rtw89_write32_mask(rtwdev, R_BE_WCPU_FW_CTRL,
+			   B_BE_WCPU_ROM_CUT_VAL_MASK, hal->cv + 1);
 	rtw89_write16_mask(rtwdev, R_BE_BOOT_REASON, B_BE_BOOT_REASON_MASK, boot_reason);
 	rtw89_write32_clr(rtwdev, R_BE_PLATFORM_ENABLE, B_BE_WCPU_EN);
 	rtw89_write32_clr(rtwdev, R_BE_PLATFORM_ENABLE, B_BE_HOLD_AFTER_RESET);
-- 
2.25.1

