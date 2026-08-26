Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D1839DBD4
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726544; cv=none; b=rZHFNyvhvfvsIWcg8mEWM/nAu2Idun/96KIH7T1Xxz76qyuCWNXiOT06tSiAtEubZPoN0IiDlI/uPjtAtq2e9olqLnANJvWJQ464ddM75TRnrLqxhh7mp1H/6MAFyLxuHmbbi5UwOpXirqsON2KjuQLt2ldAQA8BCCCPZVJ0/+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726544; c=relaxed/simple;
	bh=SxKY5PWx2B9SwMwX2P6y8ClMpkrs0xtwy7ZMiSVRRhw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jI8tGQXZGWynQt9g2T5GV6+UNUKIe0sNyeAB9wKUYYqhNmDMvsH+H6hElScYmcukE2a1LKYBdzq2bi2I6M5h7IHUARq68njyb+TRCfqxHOY7OV2A9HXOSJs6e6+XVIMV5ykUthJmd7PpT3gmqDO5k/Ey3zu13XOXOC2s2URtKQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uxfQSyTF; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uxfQSyTF"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6gKeE5353538, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726540; bh=79jvwb/j0/oGbJYeUDe0pGZR/iCPiLckGB66nf1H+Ck=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=uxfQSyTFSmmjARxt5sP0H5uYjIydvToYFPRlfq0tVeX1kceNtKcKuf/0uDcK/+ZZW
	 zIAK7PQjF07TAYQtQR0cVPj/oCQDJ0uttXOP40Pu4MCYHD4YmjVikYy2DvCe9hPNLp
	 VnIx97y81MTXpUyElNxsGAvBxA+IX7/rDgV1NW4aMRMNAj0G3ejML+YGIF4C8C+w/H
	 W96dEvmlwDdr3m0EescbG3B4yYlZ3xxfAbRd4GejhgWqPhmy9e6NG1b5tPCZAZIXLQ
	 e/rLQuBe6uHNUnYn9fNdODu4f5G6d4J7QEbk7p9ZeMo/D1fiuRZ/1wQ8jx97VRjmPB
	 XjwB5U5hwb4YQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6gKeE5353538
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:42:20 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:42:20 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:42:18 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:42:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 12/14] wifi: rtw89: regd: check only active vifs when recalculating 6 GHz power type
Date: Wed, 26 Aug 2026 14:40:59 +0800
Message-ID: <20260826064101.58892-13-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Originally, recalculating 6 GHz power type iterates all vifs including
idle ones and takes an intersection. However, driver chanctx management
will treat idle vifs as ones who also use the first chanctx which might
be 6 GHz. Since idle vifs have no 6 GHz power type, default power type
will be taken for them. Then, intersection result would be the default
one. It means the strictest 6 GHz power type. So, fix it by iterating
only active vifs.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 14fab6b1a74a..942f55633942 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -1091,7 +1091,7 @@ static bool __rtw89_reg_6ghz_power_recalc(struct rtw89_dev *rtwdev)
 	int count = 0;
 	u8 index;
 
-	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif) {
 		rtw89_vif_for_each_link(rtwvif, rtwvif_link, link_id) {
 			chan = rtw89_chan_get(rtwdev, rtwvif_link->chanctx_idx);
 			if (chan->band_type != RTW89_BAND_6G)
-- 
2.25.1

