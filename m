Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F702481FC5
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329060; cv=none; b=cFmYMv8T1Fi1m+p4MiYTE2vpENQur8XT5+REo6xNKmS6n0v+rxZiz6y01aAWzzwTzCz4jYYSqSXWlnDisVzonfHj0UbMwWOJWd7jS2T63S0/3wvAPHCBsQ2LZL53DR0hZcVFzzC2D8ItVoThSr7/QQbksPsJHnkwuX4d6Kjdctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329060; c=relaxed/simple;
	bh=7UTW1CBulxuHuzHr3owHP3WI4ORQLEYlrKDKLsH5bAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2+9T76mF6XdD0p5oYhZSRbJDiWl/FgeuoQ7Fg2RDjbdNLFgDySvGI4ZVHGTYeFRO2Ydho1wfm4JTzy5kmoXpjxTeVLizK9qqJuqNPSbd89CqbmMXcDolV2eGoweW8zig/RodOgthO3cOKF0BOhfUNCfjqWrEi1D0oBS2d8Ov7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ToR3F/AN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ToR3F/AN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66TCi4gG5421724, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785329044; bh=N+OwpWAGOgetD6SKjEXwjmbT5/7Ow5/VrMfCO1/Kd84=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ToR3F/ANxy+sgifZTAYM7jhFLy5n6uGy5v3OKpcxVyBrWz+hwVItnQacUCs4P288C
	 501oXn8nIeuOQvrGD2YwwiQJFnMtTNQJ0uRvppzzJ0ffu/Hz0C9KluT4E4iNYgF52o
	 PSSo5sg2eQdKO5zfD87czG4yhIbImrF4hlNQdgBQTVTFcKtEaxm99l7VQU5eRLHsm9
	 79+mjrddkFyqGAwXC223oAHjreLjflrO12ti2WOFYR+4Y61QR6AcqIcM8vYvfbA8i8
	 LWlzn3a0not53+0W/9q0y9qmmKJrxa1yiZprSphaJDblRxsqkNAHAtbEdEG/gwjflj
	 2qmHrVpeyfaPw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66TCi4gG5421724
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:44:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 20:44:05 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 20:44:04 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Jul 2026 20:44:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: [PATCH rtw-next v2 2/3] wifi: rtw89: fix scan offload version check logic
Date: Wed, 29 Jul 2026 20:43:53 +0800
Message-ID: <20260729124354.3231368-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260729124354.3231368-1-pkshih@realtek.com>
References: <20260729124354.3231368-1-pkshih@realtek.com>
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
v2: no change
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

