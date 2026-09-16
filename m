Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB1444998E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543427; cv=none; b=JKz1XG7MjiEUKoqt9hPkAXYQ3TZNDj7CiYTA3fwVRz0rSg5Dwwxkt1tcPrs0iv8vvUdu7cjSK/iQdpCo5R7sGht7NorElPQA46tuLL85N7bZOhcTiF0oSQ6IQ1rH1W/XCOB1nrMTkFXhHoVzDlbVKzFuNbsDF2cS8/bDU1bPmwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543427; c=relaxed/simple;
	bh=lt0+vlo+xWHYCECQ2hqQDq6aMyJbshg7R6b1gk4Nl9s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jR0oNhU3uzk93cx3/W2ZsVvLrscTQE0ORpw5Q5KDYp6ilPUh0UIcKIsk0N6YC0y3v9AdPRgC57Ukrxr4SeWiS10wnw9+lrLSQMZsp+mVrsR56E4eJzydqfIAWuzBZERs6VD6jFztMLnhwxQoe9I8qLTbQYDxY1R3GN0fcixyx9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=nhgDRean; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="nhgDRean"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NPOZ02168380, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543405; bh=Xada9BH1a15TkojzTRWt07xaSs073QjwlTTWqIbJ/5A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=nhgDReanRrASJ0gJHH8lNQ60g8Vv7x6AYdeI3LpsQ6eoIcuoKYghQoQWRNbtnYPJl
	 st0gtDI3t9axwTbv4GRhliXdgt+0NJIRtVM1BsSL2n4ullh+MoqH55yNR4ne1M/tVS
	 NgTBRuIXHe2xgAxRkBLiCvSMxzlIwD5kfdz5jc0N2BdYh8COjbaykAmJYrvyWFJvgB
	 yxr+w/lflT0+uK1iUSSyBxpCuOBdCMZJfuhvDDe37gsMQOHRMM/NyTdfQEheohBVJ6
	 IiM0fBkilxxKNGrOg6WqZNmNPyZh2jwUwWbJ4gv4jnP9JgKKz7/x/q51jyNL5R5yok
	 fk39gEOZ6frhQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NPOZ02168380
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:25 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 03/15] wifi: rtw89: coex: fix rlink index bound check in _update_wl_info
Date: Wed, 16 Sep 2026 15:22:26 +0800
Message-ID: <20260916072238.62574-4-pkshih@realtek.com>
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

The rlink array is dimensioned [RTW89_BE_BTC_WL_MAX_ROLE_NUMBER]
[RTW89_MAC_NUM], where rlink_id is the HW-band index selecting the
second dimension. The guard rejected rlink_id only when it reached
RTW89_BAND_NUM (3), but the array holds RTW89_MAC_NUM (2) entries, so
rlink_id == 2 passed the check and led to out-of-bounds access when
writing rlink[role_id][rlink_id], when scanning rlink[i][rlink_id] in
the per-role loop, and inside _update_wl_mlo_info() where the same
index reaches arrays sized by HW band.

Reject rlink_id at RTW89_MAC_NUM so it matches the actual array size.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index f86311191171..279b75461fe2 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -7605,7 +7605,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev, struct rtw89_btc_wl_link_i
 	u8 i, link_mode_ori;
 	u32 role_map = 0;
 
-	if (role_id >= RTW89_BE_BTC_WL_MAX_ROLE_NUMBER || rlink_id >= RTW89_BAND_NUM)
+	if (role_id >= RTW89_BE_BTC_WL_MAX_ROLE_NUMBER || rlink_id >= RTW89_MAC_NUM)
 		return;
 
 	/*
-- 
2.25.1

