Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C0D3988FA
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271563; cv=none; b=vEI44oy+hK8Yegjk0I5lWyq1iX4f+qPWMBrNvCJiy6bE1DLwYUpRt4SGNJPM8ZQaF/4Ij802TfZ1HfgZoYFQlz7w+EXgWMiOBsMNm+j0hAu7H+moRU1QCAcDYOCdcCH9QYlksoeueS1E3lKroMNs0Jou5hn1wGAC8MzqMIAUYgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271563; c=relaxed/simple;
	bh=2H3Jo28V+9bzWoiHbzAu19slbnxyyJRWyYyET3b0oeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AD+8CnrXIp/1oCABy4UcHnNQWH8a7pUB8BwW9mWsoCfZWoXrc5Yg4lETmhjEwnbbCEao+FV3YsM6UWbKrh+fimF26vWHp7lf6glHQNylRqNyB0HkQIXBTzF+D9Fwy2/mNcAP7Tf1FlrfOj7jn0CGRLTnzmz1ipTxy1XawxudfYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tim8Pmkb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tim8Pmkb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xJtG54176618, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271559; bh=2vyy80u/sigzaDP6g1ztrauxCFxxNDaKgc7xg5SrjUg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=tim8Pmkb8Dh8tIT2RaZ/j6C9yuCDXjO10VwDkzT4bjnWVu459wmd629ufNZxffSAM
	 FuatM6Glo86aJeBPKnBLg0NdGTn6ETnXsqV80gm7Sqig+DHvXYRViMUEY5+2jkzEvI
	 O8bTxxOe17LQ2n2/SIy77XDQn6vhp3kiWIgiEFVqFOU3sOLuFFzETOiTXi3vQjaGLE
	 DalF3MQVtKuUbaeH3ya59mkS5u+2z5cjg+GbjMqDy0uc/AFcEO71V3lO3g4d7h7WXJ
	 BEYRT+yLpdOfAJj4oxW+vyx5s8nwKpzUEGTmJhHy3zqbrD1fYk1uNNsvQXkDscSrhD
	 zquvXT3YuAt2Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xJtG54176618
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:19 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 07/13] wifi: rtw89: coex: Fix Wi-Fi role info H2C command header issue
Date: Fri, 17 Jul 2026 14:57:33 +0800
Message-ID: <20260717065739.64124-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717065739.64124-1-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The function to filled up H2C command data is the last step in the driver,
the next step is going to firmware. So the structure version number should
not included driver local branch number (like firmware is v5, but driver
branch to v105), it should be assigned as a explicit version number which
paired with firmware.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 53ec6efb1cb2..34bc52519ea2 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6255,6 +6255,10 @@ int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type)
 	skb_put(skb, len);
 	h2c = (struct rtw89_h2c_cxrole_v7 *)skb->data;
 
+	h2c->hdr.type = type;
+	h2c->hdr.ver = 7;
+	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
+
 	h2c->r.connect_cnt = r->connect_cnt;
 	h2c->r.link_mode = r->link_mode;
 	h2c->r.link_mode_chg = r->link_mode_chg;
@@ -6323,7 +6327,7 @@ int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type)
 	h2c = (struct rtw89_h2c_cxrole_v8 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = rtwdev->btc.ver->fwlrole;
+	h2c->hdr.ver = 8;
 	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
 	h2c->r.connect_cnt = r->connect_cnt;
 	h2c->r.link_mode = r->link_mode;
@@ -6397,7 +6401,7 @@ int rtw89_fw_h2c_cxdrv_role_v10(struct rtw89_dev *rtwdev, u8 type)
 	h2c = (struct rtw89_h2c_cxrole_v10 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = rtwdev->btc.ver->fwlrole;
+	h2c->hdr.ver = 10;
 	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
 
 	for (j = RTW89_MAC_0; j <= RTW89_MAC_1; j++) {
-- 
2.25.1

