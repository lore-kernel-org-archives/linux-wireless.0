Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DEB2F99B8
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902980; cv=none; b=gcluAidpncdKjhb1OaadYbDjqV0Ni8bbSg1bHi9lZ9bJWizu5l7Et8uT9oSopHlk2ZywRIHzls95J8V+pJryYOAoZwiWdS0T3eFuAN2E1eYC8bObSnQABd6gvufzvmDs7knY38CJ32dd7FrQ6lBj+3IzJJ3rgy4x5XqkDfP8Gp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902980; c=relaxed/simple;
	bh=lnKlpTlVwDIbRiC5a8uUeP68xhSX3tyPAcjG1Lcef6A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFechqF7To+rAz3nBNxzN0SzNlmyURFv/AYOl8vtt1R53KeI1JrcOnQfIbV0cwCDKRD60Bk6TMumgVzvf6ty3zNPIbSI4oR3s0gwOXrH8zwBfwZ32XMaXyu/GIVw56DkyUE+A/Fm1uFZP7BUYSxpX7xC9l0pYw+o7cb67yByQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ulh7r2G3; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ulh7r2G3"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66OEMuOW21234430, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784902977; bh=LnuQjxGIbeONWP+Mtmoj5CdSteYf+uW7U7QUtaw1n+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ulh7r2G3nt4kV+O1G/XGbOyIlXBN9wLNgFbKxt8KHz7zPVSgA0tiXcn6yEYKK98Mv
	 WlcWvZb4JdXNgLr9VzJMCi62SjTM38Jnag66eMwTuX/mcVFdOLWCmh1e6cG4vv8AZd
	 9H0/P18xnjT7/tI/WhOy2G22Cv6ciabsSuisAYyw6oMfdn+9cVi40TbY37RcDt/EVR
	 pJPIyjYyuOuood+BScI4rwwwUVeyWX3X9hWx9uDlFv4TxyPdG+3TW4Efh20Ri71Yex
	 +9VeugykFP525RFuvWc0S7kEWkyyLLR7OLLMQXtGco099gmAAhbVLGf8sBVicyUrf9
	 leoiC7MZgP7Zw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66OEMuOW21234430
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:22:56 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 22:22:56 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 22:22:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: [PATCH rtw-next 2/3] wifi: rtw89: fix scan offload version check logic
Date: Fri, 24 Jul 2026 22:22:45 +0800
Message-ID: <20260724142246.3195274-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724142246.3195274-1-pkshih@realtek.com>
References: <20260724142246.3195274-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Po-Hao Huang <phhuang@realtek.com>

The version check with less than should check for smallest upper-bound
first, or some branch will be unreachable.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 3b8c144e0e98..7d68ee870ed5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7615,12 +7615,12 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 
 	rtw89_scan_get_6g_disabled_chan(rtwdev, option);
 
-	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw)) {
-		cfg_len = offsetofend(typeof(*h2c), w9);
-		scan_offload_ver = 1;
-	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw)) {
+	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw)) {
 		cfg_len = offsetofend(typeof(*h2c), w8);
 		scan_offload_ver = 0;
+	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw)) {
+		cfg_len = offsetofend(typeof(*h2c), w9);
+		scan_offload_ver = 1;
 	}
 
 	len = cfg_len + macc_role_size + opch_size;
-- 
2.25.1

