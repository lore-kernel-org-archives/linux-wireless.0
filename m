Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F3274670
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783827973; cv=none; b=iQuO/xLuFC/TikXI1X9N93NeN6GYiJ9d8XMgQXbFOUjdbmjH24kSH0WV2hKGljnnOwy5wnc7RBFRbJoar2AOJx3qxrD95KdioDjE79qLiayavIgTc7V79y+FwdbSxW7aeK085kTFHITMA5m6pcDr/GI61ctVR/mBDXRGsJlNQsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783827973; c=relaxed/simple;
	bh=nalz0IXpjGiDyFuEDg1T5k0T293UW1tsxFl4eBfOCTY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdGP/I3VuPAqwzlzmzMeFDIII5taL8xtyOxibWvlVVDfz1TTk07yamrU6C5/8R5Wv88plOLGOpHPs0hwJtWstAllPHKdXy3p13A1nh2bZbsA/PuplDK5iIxQpvPPTtylGvPa9xgzTLuinhvI98Er0Wecg6xGE/y5EBtaQ0etCg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Blof6r8Q; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Blof6r8Q"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66C3k9IN1535594, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783827969; bh=5jQNboHWqRsza6mOqKB3AbEwUBRiXIVclw5tYsV2ofw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Blof6r8QmgiCSSvtJjQ+b9P67ZlKufbrWxL13sHoDPV6ghK1ZT9FWddy/eVFlZ1kf
	 nMgXXUUV2PvKbEbAGpra4vGrFO5vgYzCbbPHegEeOfeUY0VUnvPvOkk0sQzIHDS0Hn
	 P4Goktw4S9tSBphxNLdkDpcSblJgLjeYrQ13TpBMZ6jv9gP29Nu7iwhXiMx7cSvG1R
	 S8ZMvbvOrbedPzBi6z8ItKPaSWesfRHzsqUWVxyKHIWEm3JnJS62uKc2hrltH3yLqf
	 EyQNpbGrV8Vv7RAeyxG/SoJgMnoejRiqvHcmbNGmPbOLGW8ikDDjgbsQfKssy5fdPN
	 xtxnwhXPEL9ow==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66C3k9IN1535594
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 11:46:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 12 Jul 2026 11:46:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Jul 2026 11:46:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <echuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 1/8] wifi: rtw89: pack I/O during bb_sethw to reduce API execution time
Date: Sun, 12 Jul 2026 11:44:59 +0800
Message-ID: <20260712034506.53209-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260712034506.53209-1-pkshih@realtek.com>
References: <20260712034506.53209-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Eric Huang <echuang@realtek.com>

Wrap rtw89_chip_bb_sethw() with rtw89_io_pack/unpack so all register
writes during baseband hardware initialization are batched into a single
bus transaction. This reduces API execution time from ~11000 us to
~4000 us on affected platforms.

Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 174349c6bc58..0f6d4ad66fe2 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -7810,8 +7810,12 @@ static inline void rtw89_chip_bb_sethw(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 
+	rtw89_io_pack(rtwdev);
+
 	if (chip->ops->bb_sethw)
 		chip->ops->bb_sethw(rtwdev);
+
+	rtw89_io_unpack(rtwdev);
 }
 
 static inline void rtw89_chip_rfk_init(struct rtw89_dev *rtwdev)
-- 
2.25.1

