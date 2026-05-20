Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E67F3E5572
	for <linux-wireless@vger.kernel.org>; Wed, 20 May 2026 12:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280713; cv=none; b=cNglG3UJqRlJGXvcnZKTX7ZxmTxyszB3Ue7XPOVY/2y5R7Kw6TjxpEbuOG2G5JVAUJHH6cEaN3iBLSm15Q+RTB18EEByCqrRbc+3XmTUB35DMQSAxvsr4+wq/TD8+xpwHilW+EzotKbMaDQEqjfM6MtAJ2JsUyZN8S+UDdmLnuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280713; c=relaxed/simple;
	bh=D5iyPEPlFHiP+cChp+hhF+naSafUaAlKb4RXTeu8QoQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lGPtFxajSgxjIZCs6hsSmC8WGfHZ/8cXwjUD+yQ3K8AXl+qz+cdNIUoCt8ATHemoieNOtQbsKprYxHyBjjYGb23YjWOz24RwAw7jJ90bNeO9N36LLLEaAVxO9SWFs59KFPhw0h/HfMoDhQBmW/0JzkdAcSA5pjvqEI+e36z3Vq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=udlc6uFR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="udlc6uFR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64KCcS601095450, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1779280708; bh=qI+p2m4wcA1q2OQHDBY8ziYDVx9Bv7ZY7AyMRl9sPk0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=udlc6uFRINazpbFdTLsvU5NbUPIctqfZpiq4Zwkr3M9gomMH2+kBntXN/58g3R+i7
	 oylR8N1yA1sPu9YVoKDzNxcwNY9nFfuCwRiyCyGOIXNbRZTpnkrjshvu903Jvl4Lgx
	 pCGKQfaLWfJNANZaJYxqBc30rsAf+q3bN4Ne4cPf0omvPOufxZaTyEXvNfI3Jkg4lg
	 IhnXKZwmyrT3B2USQYuwCZWtLRBYQ53crrd9fPETrxakaRcXcEzWRXQZKYaqBSaQPH
	 w7xszuvi7gCM4sQrka2KMf7oOAkW7CCyzjc65kutjQaRBIXi6C1+BF/Y09h1nNVt8S
	 phu7tddflasvg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 64KCcS601095450
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 20 May 2026 20:38:28 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 May 2026 20:38:28 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 20 May 2026 20:38:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 1/7] wifi: rtw89: fw: load TX power track element according to AID
Date: Wed, 20 May 2026 20:38:17 +0800
Message-ID: <20260520123823.1792954-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260520123823.1792954-1-pkshih@realtek.com>
References: <20260520123823.1792954-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

RF parameters has different TX power track table for different AID.
FW elements may include multiple TX power track tables for different
AID. So, load the corresponding one.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index ff3914a16b81..5d0b3ba9a358 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -1209,12 +1209,17 @@ int rtw89_build_txpwr_trk_tbl_from_elm(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_hal *hal = &rtwdev->hal;
+	u16 aid = le16_to_cpu(elm->aid);
 	u32 needed_bitmap = 0;
 	u32 offset = 0;
 	int subband;
 	u32 bitmap;
 	int type;
 
+	if (aid && aid != hal->aid)
+		return 1;
+
 	if (chip->support_bands & BIT(NL80211_BAND_6GHZ))
 		needed_bitmap |= RTW89_DEFAULT_NEEDED_FW_TXPWR_TRK_6GHZ;
 	if (chip->support_bands & BIT(NL80211_BAND_5GHZ))
-- 
2.25.1

