Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F2225782D
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901472; cv=none; b=Q+u9006NxemkU73IB/weZ4z10zBT9OMPPYjDhYyQTqChz0DnmryNZVP9OoR/rt7q3udo98VwmJJPvTmFntASqlqmwn2aGhka7Nu4mXxwfMJiKK9hNRnBd3QEZV0iWKh6+sX8h0eT0MGuBtG5P5cpK7So35gVphi89rgxR2iQ49M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901472; c=relaxed/simple;
	bh=Au9zjQLctjSQnknyJ7h618bha/6TpDgR30IjH6dgqqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GuZI0qLdy0BP1gcAtJafpLLQd3PPiEwyRnyGqpr3BNX/blLjWgFjyrrF2VCkYTm1TMyWObDmShaQ0RpiLY9whcDGTcDe/uRRE+GGgMr7At+NCuFG0TOJfamC9nXCLcGMskD4kKdy0VjZ+owRSXeuazjTkU9hFK5Z2NzWh1PQw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YntjzG+W; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YntjzG+W"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvmEeB1179839, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901468; bh=vRYkLFkSC2XG3Ie6WETFAhp/Ygc9CPCG5Wl4UAKNlRg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=YntjzG+WQoJp95ggzyE3fXIwA4iYilxxK9F+i0BHmg3O1tUjMzamT7wS1nmXmBpeC
	 It1pK9gPQcGk2s3iqtAv9unuiO4DaHR/CEepwzB/g35Vjjpfq+1E47ZIGdZHhlNVuX
	 aupve99QBEz2qPDXKqjmBjKqHkAP6LgQRwzPS17sMNqYhLXVEJlKqLt07jkIIAacZr
	 RYtouMVq4eYRXM2iTwj1nMvOeo3YVZWyW+IEyHPUQ7g5AUMWGNnLbErux4rulmoBE3
	 lcFFKdlf7kyKaC1TFwiyRTneqxMsE+JptjlSsIIqMIH6G7N15A2BsbUdNrFFCRyEat
	 h95002HtTXq0w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvmEeB1179839
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:48 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:48 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 13/14] wifi: rtw89: coex: Fix H2C command redundant send & version fall through
Date: Fri, 24 Jul 2026 21:56:39 +0800
Message-ID: <20260724135640.3195044-14-pkshih@realtek.com>
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

I/O offload higher priority sending event didn't return after H2C command
was sent, add a return to prevent send twice in the same time. Update
driver info entry which is handling module control info didn't handle the
version 9 command format, add if condition to handle it. TX power update
H2C command result checker logic was reversed, it will lead to the TX
power value never update again after first update, fix the issue.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 7ab22c60a420..6b3e199398cf 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1073,6 +1073,7 @@ static int _send_fw_cmd(struct rtw89_dev *rtwdev, u8 h2c_class, u8 h2c_func,
 		}
 
 		btc->fwinfo.cnt_h2c++;
+		return 0;
 	} else { /* Fill H2C MACRO buffer(TLV format) temporarily */
 		if (btc->hbuf_cnt == 0)
 			_reset_h2c_macro(btc);
@@ -3500,6 +3501,8 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 
 		if (ver->fcxctrl == 7)
 			rtw89_fw_h2c_cxdrv_ctrl_v7(rtwdev, index);
+		else if (ver->fcxctrl == 9)
+			rtw89_fw_h2c_cxdrv_ctrl_v9(rtwdev, index);
 		else
 			rtw89_fw_h2c_cxdrv_ctrl(rtwdev, index);
 		break;
@@ -3893,7 +3896,7 @@ static void _set_bt_tx_power(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
 		if (rtwdev->chip->chip_gen == RTW89_CHIP_AX)
 			len = SET_RF_PARA_AX_LEN;
 
-		if (_send_fw_cmd(rtwdev, BTFC_SET, h2c_func, buf, len)) {
+		if (!_send_fw_cmd(rtwdev, BTFC_SET, h2c_func, buf, len)) {
 			btc->dm.rf_trx_para.bt_tx_power[i] = level;
 			if (rf_band == RTW89_BAND_2G)
 				bt->tx_power_now = level;
-- 
2.25.1

