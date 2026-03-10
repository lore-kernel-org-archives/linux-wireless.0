Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135928640C
	for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2026 08:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773129733; cv=none; b=deeevwEi+qWrUHUD0bVwQc8odq6SQW5gUoJ9JQHmn5NpR24Cvi1xvjpOw0Ix7ou6O+Wd2otR4ZnbhhJl93n4Ovkoukf4sYm8UZHhcno9cx8P01VlpN7fey11n9ZrKN8j54ed2Fio683VBKm+wqL4YbcQTM2E3d6Kx0hyPvmKlgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773129733; c=relaxed/simple;
	bh=yNyzoGDZophc/sB0PIlg2ED0Xmu2y5fO0wTocw2f41o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3iM5qNGxxkM8rmaVuEAIDSfgWy23Cv4NKafpqwhDXVPyYhsA44iv/77l96ZMbOKcTeH94AWcSxRFUn6azvcdcHQA3IoPpaVFZ4Nr1y+8F4HJeCdZ4Iq3rlVssfla6u8gk0mLSbUF5LLWunUKq9mZr/rxaoHTu/ygK5OoeIk+Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rYwgDc6O; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rYwgDc6O"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62A82AhbC2208469, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1773129730; bh=thVjQNhgV8qOrAtops3Sxln/Te+iPd7y0kj1kQGJ9I0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=rYwgDc6OX5NzdWDc0qrybouxo0LM9nvG/I38Z+XYhIXZjTujLlqg4yWAFvjW4Vy7u
	 MTgIsNUXNYsV2tNgNkMkbTkegUfFuSZNcuhgp9kGuANiuVCJZNgrr0YiLMZ9TVxXFs
	 h3YCqPONMRHlGZo97sTp4EL9NLjSIzaK2nRF1K33hW3ES94jzlGo7xTy5vrKf+hnbC
	 X9ZhGtcieZ6xQmGUkzIIt8MNLzZyv61CkKV2lIPrA5a49TleiPFIyHwB6+qYIg6l2d
	 0LZ1ldemAZDwQf8gLb49OLePw4mOplhAUyWID6aBS6yttFWRnx7uTjyH4HBgRooerb
	 Z6bc54N6+eE2w==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62A82AhbC2208469
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2026 16:02:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 10 Mar 2026 16:02:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 10 Mar 2026 16:02:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 10 Mar 2026 16:02:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 03/13] wifi: rtw89: mac: remove A-die off setting for RTL8852C and RTL8922A
Date: Tue, 10 Mar 2026 16:01:36 +0800
Message-ID: <20260310080146.31113-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260310080146.31113-1-pkshih@realtek.com>
References: <20260310080146.31113-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Fix timing issue of A-die off followed by XTAL off. Otherwise, device might
get lost potentially.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852c.c | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index e62a7288c8aa..7ea0a8905282 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -463,7 +463,7 @@ static int rtw8852c_pwr_off_func(struct rtw89_dev *rtwdev)
 	else if (rtwdev->hci.type == RTW89_HCI_TYPE_USB)
 		rtw89_write32_clr(rtwdev, R_AX_SYS_PW_CTRL, B_AX_SOP_EDSWR);
 
-	rtw89_write32_set(rtwdev, R_AX_SYS_PW_CTRL, B_AX_XTAL_OFF_A_DIE);
+	rtw89_write32_clr(rtwdev, R_AX_SYS_PW_CTRL, B_AX_XTAL_OFF_A_DIE);
 	rtw89_write32_set(rtwdev, R_AX_SYS_SWR_CTRL1, B_AX_SYM_CTRL_SPS_PWMFREQ);
 	rtw89_write32_mask(rtwdev, R_AX_SPS_DIG_ON_CTRL0,
 			   B_AX_REG_ZCDC_H_MASK, 0x3);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 36ef36110602..a489aaf90f23 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -492,7 +492,7 @@ static int rtw8922a_pwr_off_func(struct rtw89_dev *rtwdev)
 		return ret;
 
 	rtw89_write32(rtwdev, R_BE_WLLPS_CTRL, 0x0000A1B2);
-	rtw89_write32_set(rtwdev, R_BE_SYS_PW_CTRL, B_BE_XTAL_OFF_A_DIE);
+	rtw89_write32_clr(rtwdev, R_BE_SYS_PW_CTRL, B_BE_XTAL_OFF_A_DIE);
 	rtw89_write32_set(rtwdev, R_BE_SYS_PW_CTRL, B_BE_APFM_SWLPS);
 	rtw89_write32(rtwdev, R_BE_UDM1, 0);
 
-- 
2.25.1

