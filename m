Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56AB41687C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901436; cv=none; b=erCdjcQ/h47vrOecE+bT9qtCexdp1F+WaJzOim0n+Ys1tUZQno+sSdq3Wb7InJ/qBSpMQ7V2B8zMLhJZgoYW9SkyPwoP+ql8qTHDj6aZi2K13LR3QjfaSgXi6sPn/6xwCutx5+mZwYULaqmQzW2gRKSLM1sGIiN9I+uhWlky3y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901436; c=relaxed/simple;
	bh=SXWM8pYGqBzjUw0X/fADlgcDOvwcdsBCUVGls74ExOM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GeDj+9tW+GQorDAaRcd08zRDA3457y4xt4qO/2ja/B4QkejCoEaQhQZqZmurNBlndCB8gMtBJOKZjKUVCNDFpz8e60BRUX5biML7r9c+jn1viZZSAZJyzgdO4mjQnXvZwDa0OEtDLToFe9Iw3MQSyT3V/eiTXXsP3Hw/tXMBx/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BbNz/SPa; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BbNz/SPa"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvC4111179730, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901432; bh=25zHxSLQDcsMSh7F3/rAFzcBzfQO5pBsC/EB8HdWlPs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=BbNz/SPa5koWJFCPZIeaPWMyKgdThhq0g3it/ThRVmUKlP+GESY5Jcuqt6hk9W8pL
	 kYLAtvW4Nkr9hHyloBuB3hEnIZL3NQY3EuITKzeEtguR9PaCzadcps41d6aGcVmCHq
	 CCG7bbxdvdoTejNZEQ+DI664yvrFHW0iJYMDBEOqT/Jxxa51lv0/qprc+HTY8samcE
	 39jc+4rk49V6QYn9cqpe/1Qt1SdGzuG9JPeMCYCnPG2r0TK2Fc00hGQn2SSDkURHTd
	 npd8hn4W6c+dmqs9gDQMzg7WA6J+OYv0x8fi9EVj+yJBSiiqc/vETe2vHotKrDjmzW
	 hg6Sp1m/0raOg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvC4111179730
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:12 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:12 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:12 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 06/14] wifi: rtw89: coex: Decrease Wi-Fi special packet protect time
Date: Fri, 24 Jul 2026 21:56:32 +0800
Message-ID: <20260724135640.3195044-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724135640.3195044-1-pkshih@realtek.com>
References: <20260724135640.3195044-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

While Wi-Fi is doing special packet handshake, or going into some
transient state, BT-Coexistence will held timer to fix control logic
to protect the segment. Set the protection duration to 1 second,
it is enough to cover the situation.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index 41a68ab21d80..355784941edd 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -69,7 +69,7 @@ enum btc_wl_rfk_type {
 #define NM_EXEC false
 #define FC_EXEC true
 
-#define RTW89_COEX_ACT1_WORK_PERIOD	round_jiffies_relative(HZ * 4)
+#define RTW89_COEX_ACT1_WORK_PERIOD	round_jiffies_relative(HZ)
 #define RTW89_COEX_BT_DEVINFO_WORK_PERIOD	round_jiffies_relative(HZ * 16)
 #define RTW89_COEX_RFK_CHK_WORK_PERIOD	msecs_to_jiffies(300)
 #define BTC_RFK_PATH_MAP GENMASK(3, 0)
-- 
2.25.1

