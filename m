Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B158D3612EF
	for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2026 08:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773129792; cv=none; b=O3SOGy0e3FR1TxVRqYQCtSxAuhX2BpTtbWCZtBo9trRS2YC6sNTrTwSFmQCf/Z51HZsIjKYU3idJLVarf+0b3ZlEOGQe/8XCmBpQpeehOH6Zh6EjOVhfaATi8tB4E5J1vwthr+Sc17dKTCGpwJllsu/tWifkS3OOwjc8M0Yxfhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773129792; c=relaxed/simple;
	bh=5rZXfiGVWsmYjxQTk1QCIXNwqge+QAGStg/6PFudc8s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rz02CGNvWPvVvZsOKwUgyH389KPhtKM0iA3JvClKOg7NL14Wtv0Uw8mjl0+1LzWzbyUOJO3ufcbpR7d2pkvJ8AI9RZngXF+5ysGgpWC9JY8jfViPacwanLySG4oZ69EZMdAxJcjs2j6JnT1uKyTQfIyMZxAkXWQdhYtwlXDRrCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LIiifxKj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LIiifxKj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62A83AbC42211495, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1773129790; bh=zZZIjIYhX7L9DnW50j8WzT/P7A1QRPAFjSu4kGlpNWA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=LIiifxKjmXnPHZEbm+ePNsubOJMWb8LoXVfR26s759GV0ojrxsLEwqbDwTLBhFVwD
	 wAWN2/QrJ3u9q9L7Qb8lYTfE27EWaFm0wdV6zfjL1PPD5u+f3OVgLi9KKHVXN0Ky4V
	 HparUfdhPpAnUQZQQTktSayFUWfFAlbUu8nwyFYlPsyWaDUukIva3XLBEpWwy4PjYh
	 CkWKyUzmdiUIXM/fkwBbRteMoPNSaNzhq/z4HnQuDib56h952BRSp1ZFDzi1SkDDRK
	 OFz34Iw+w5DxvxUjQAxiq4lmW2l9ck172PxRPrsVb8skitqGuJ1JP+0Q+P4HMFKOsb
	 aGaPxmr2+EnCw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62A83AbC42211495
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2026 16:03:10 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 10 Mar 2026 16:03:09 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 10 Mar 2026 16:03:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 13/13] wifi: rtw89: debug: simulate Wi-Fi 7 SER L0/L1 without PS mode
Date: Tue, 10 Mar 2026 16:01:46 +0800
Message-ID: <20260310080146.31113-14-pkshih@realtek.com>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Current triggers of Wi-Fi 7 SER (system error recovery) L0/L1 simulation
don't yet guarantee working with PS mode. So, leave PS mode first before
triggering them for now.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index d461ffc6dc9e..82849d109cc3 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -3552,6 +3552,8 @@ static int rtw89_dbg_trigger_l1_error_by_halt_h2c_be(struct rtw89_dev *rtwdev)
 	if (!test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags))
 		return -EBUSY;
 
+	rtw89_leave_ps_mode(rtwdev);
+
 	rtw89_write32_set(rtwdev, R_BE_FW_TRIGGER_IDCT_ISR,
 			  B_BE_DMAC_FW_TRIG_IDCT | B_BE_DMAC_FW_ERR_IDCT_IMR);
 
@@ -3654,6 +3656,8 @@ static int rtw89_dbg_trigger_l0_error_by_halt_h2c_be(struct rtw89_dev *rtwdev)
 	if (!test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags))
 		return -EBUSY;
 
+	rtw89_leave_ps_mode(rtwdev);
+
 	rtw89_write32_set(rtwdev, R_BE_CMAC_FW_TRIGGER_IDCT_ISR,
 			  B_BE_CMAC_FW_TRIG_IDCT | B_BE_CMAC_FW_ERR_IDCT_IMR);
 
-- 
2.25.1

