Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BF745198C
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543478; cv=none; b=AuDrcSysHSE3GzG6ETMcnu2emyMPRqRJL1cQMe/qlDTnpuE/KOTXvxGpCatjdS0OdkuDaF0fqLIMhJcOGiXl0D9eR2xAfsaW2Urln0zZN4YbJPKuVdNhKgEFr7RCdo8DvJy7cAkx5An2+LqOFvJgGRfY59cBLnXBbNM7A9y9qiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543478; c=relaxed/simple;
	bh=jsC4a8Hk8ol6c593tpQRP4kecLkvNuEnXaDc8bwXfmk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ddv9Cw3+JgReyJDGIgjh5ghfziw+WpNVKlsjBMvE+96l3RBgj8/DdHiDWDqoukjrtPYJcH3vY1fy/eqCjehKWUjy3mbxfqW9JK/TzRbaiycy3MmXC/UsD9SQlH1WaLQ8MXCEVaR8tM5ze+zyLk7Nn0H6GRa8OCbuH9Y34R1ayd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jYg0Pm+d; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jYg0Pm+d"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7OGuE42168579, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543457; bh=cq917hU/0wJknc0kySz1I+zEsCB/2cZJd7YwQo8M6eo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=jYg0Pm+dDKBLNsLLPCmyK4TMYmK5/wPh3hmXOlkvpJj9YAe203UbfvUFtyE4xKCdI
	 /dfI95/nIltSQhZO8eJowLBIlhhsW/MDm3Uj2vjDZJw5DEB+VjEdduBcVVcbO2UPCh
	 kRLWI05OxN70Q3tKkiuV6jJjtbbjeUGFad9+231XOx73H89+8UK9ArfHrPo5riuTsU
	 WOk2bPvrmEeoEN0qJ3z1iYoXh1r+RjT8E24D7FE9uoq8D6DD3N499voIOJR57/liPz
	 Y71plwygIlOkinVcN6kdtcka92x4EP44QWvZUsrHyWoKIGTp1VYKXlw4Xgp95zN3nI
	 kHFQNkE6otZ8g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7OGuE42168579
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:24:16 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:16 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:16 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:24:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 12/15] wifi: rtw89: coex: detect BT HID activity from scoreboard
Date: Wed, 16 Sep 2026 15:22:35 +0800
Message-ID: <20260916072238.62574-13-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The BT scoreboard reports HID activity on a dedicated bit, but the
driver only mirrored the A2DP, PAN and HFP activity bits into the BT
link info. HID was therefore never marked present, so coexistence
decisions that depend on an active HID device treated it as absent.

Read the HID activity bit alongside the other profile bits so that an
active HID link is reflected in the BT link state.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index f2cf5bdf65c7..2392883df528 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -517,6 +517,7 @@ enum btc_b2w_scoreboard {
 	BTC_BSCB_BT_CONNECT_56G = BIT(17),
 	BTC_BSCB_BT_LNAB0_56G = BIT(18),
 	BTC_BSCB_BT_LNAB1_56G = BIT(19),
+	BTC_BSCB_HID_ACT = BIT(23),
 	BTC_BSCB_BT_15DOT4 = BIT(24),
 	BTC_BSCB_BT_PROTECT = BIT(27),
 	BTC_BSCB_PAN_ACT = BIT(28),
@@ -7955,6 +7956,7 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 		bt_2g->a2dp_desc.exist = !!(val & BTC_BSCB_A2DP_ACT);
 		bt_2g->pan_desc.exist = !!(val & BTC_BSCB_PAN_ACT);
 		bt_2g->hfp_desc.exist = !!(val & BTC_BSCB_HFP_ACT);
+		bt_2g->hid_desc.exist = !!(val & BTC_BSCB_HID_ACT);
 
 		bt->lna_constrain = 4 + !!(val & BTC_BSCB_BT_LNAB0) +
 				    !!(val & BTC_BSCB_BT_LNAB1) * 2;
-- 
2.25.1

