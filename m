Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E7E446BE2
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543420; cv=none; b=qLiM52fM+KKcaXQYPdy7nk0DlUKTFmDmYc6Iw95RaS+qJao/OFK/QxV8Hm0gZ1DgUPmBVwMBhD4sGwuadOnSf1ViLIzBRn4CJIi48cm/OVcAvuR4htbZ7CH62DaqZStnJaeaYKSbCIqh7lG9cXemK3iabL5BkAnNAhk70W6hsmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543420; c=relaxed/simple;
	bh=xmXczHt+/AR8ebgGXa59PKufxg+gJg8yYQLJXHC6sYM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5+KmL517MG3dqmZptTVCLSytYmgNqwuo9tXidnI8PbD/hoL1sAZjZTHvNthCgl/bmon5FRdHar26xhD6WvrfC1dA4gw20b+K0j6GxzPisxLD4FXD4t1mhI6nzvpNEI1/9ZmllvKgBlc3j8b/pmeza29BqslhEaHxb5fN3Y1WPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VpTqT7Pv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VpTqT7Pv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NJBx82168356, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543399; bh=FTt4iR2QbtYeSwHyPbKNAPckgTdzmRp0I3zhTfssgiM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=VpTqT7PvHnZJ+w8e+pLXPX4ZuHSaBQxITZeHfrqM+8xiYpqnUkDOChLmXs+ubWUg8
	 TP2xhZQEyp99N2t1zSL1275PJTxPSjV92Elk5A1e/8aRQuczUW8cjbuQE5t1qUPJY5
	 4bU4pD1hJfKr6IB9I0Lzcie50EGOX+JnBl2OdJxTZBbT1wKpP4lo37WGS25mWhqHFp
	 L6VrlczzHCa/t9G1/lnaqyFaxh/tq0JFyDlOdb8Wc1a8PJJthStW8KlfzZOx3RdyzI
	 jlIiIQAL4zyRxNLa5eiRb0p48GIX+wEXJCTX7dQ1Mx1LsMhGg++T4sn/P0eixD1jiP
	 p+VPviEctNHHA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NJBx82168356
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:19 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:18 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 02/15] wifi: rtw89: coex: fix out-of-bounds read of report gnt_val
Date: Wed, 16 Sep 2026 15:22:25 +0800
Message-ID: <20260916072238.62574-3-pkshih@realtek.com>
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

The firmware report control structures store gnt_val as either
struct rtw89_mac_ax_gnt or a u8[4] array, so each element is four
bytes wide. The destination dm->gnt_val[] uses struct
rtw89_btc_gnt_ctrl, which is eight bytes. Copying
sizeof(dm->gnt_val[i]) therefore read four bytes past the end of
every source element on each loop iteration, across all affected
report versions.

Bound the copy by the size of the source element instead, so the
memcpy never reads beyond the report field.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 3ef30bd962d9..f86311191171 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -2050,7 +2050,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
 				memcpy(&dm->gnt_val[i], &prpt->v4.gnt_val[i],
-				       sizeof(dm->gnt_val[i]));
+				       sizeof(prpt->v4.gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le32_to_cpu(prpt->v4.bt_cnt[BTC_BCNT_HI_TX]);
@@ -2082,7 +2082,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
 				memcpy(&dm->gnt_val[i], &prpt->v5.gnt_val[i],
-				       sizeof(dm->gnt_val[i]));
+				       sizeof(prpt->v5.gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v5.bt_cnt[BTC_BCNT_HI_TX]);
@@ -2109,7 +2109,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
 				memcpy(&dm->gnt_val[i], &prpt->v105.gnt_val[i],
-				       sizeof(dm->gnt_val[i]));
+				       sizeof(prpt->v105.gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v105.bt_cnt[BTC_BCNT_HI_TX_V105]);
@@ -2135,7 +2135,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
 				memcpy(&dm->gnt_val[i], &prpt->v7.gnt_val[i],
-				       sizeof(dm->gnt_val[i]));
+				       sizeof(prpt->v7.gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v7.bt_cnt[BTC_BCNT_HI_TX_V105]);
@@ -2167,7 +2167,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
 				memcpy(&dm->gnt_val[i], &prpt->v8.gnt_val[i],
-				       sizeof(dm->gnt_val[i]));
+				       sizeof(prpt->v8.gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v8.bt_cnt[BTC_BCNT_HI_TX_V105]);
@@ -2212,7 +2212,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
 				memcpy(&dm->gnt_val[i], &prpt->v9.gnt_val[i],
-				       sizeof(dm->gnt_val[i]));
+				       sizeof(prpt->v9.gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v9.bt_cnt[BTC_BCNT_HI_TX_V105]);
-- 
2.25.1

