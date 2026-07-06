Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE8E351C22
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 02:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783306556; cv=none; b=e8uVQ5MfO9coH4FzIxjEzaMs54+wJ17BvK89AT4dyOjfhI9Euj7eLrrQ0moY/wjDHqjkjptIbKrLKIjViTvI9o80uOWcVNZOIhfHUv0x8GVYfk/PjxxaQ+YpEGnPXTDHdHI6udkPb8Pm4IbRNV7kVprATuyUDbwmc18XU2jDHdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783306556; c=relaxed/simple;
	bh=f/AH01BLk+khu5lzcRjlTDmIS4KZ0QlTHfNiA2lrtck=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bi6AlMmXqN/VNJWyVEl+HgvVeS/1btCCY1Mhs+rMlGWyKdcOUcxqvF27Eenp+tS/6g4gv1f18CqRYu7UZX27n+mQDTBGtiKHYx9zgZIAcTaN6xFiI5UyQ1XYPv/H1uAA/FIpwNd+unjHcdVeGotDz8zBuc+ro2sg3SZIXd3qtb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iks1ZE0M; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iks1ZE0M"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6662tp3cB120471, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783306552; bh=fKyCMZEJ/iVBbRUuGXLt+JLhpg7jj4pFQIQAPCkCeY4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=iks1ZE0M6GbRD6qob2FkyAgDPS7YIgDV+ksphj4kLkDzZr3HI88ynyfpntfBZrtVs
	 eCNRzPrrEJ7KSevwmIDLqqMJNkMZjSbNpV3pLgt5N9zkErIyN3WHTunM6NAaOHeKbT
	 nEKKOqB2yEB7nHTQs49al+nxzSOfqkSc56iwFWdnDQ+nzlazYr7m2934Wh3v+LnbQa
	 MZUajf2FPxEKFdxKI5FQbiYmIrOLRw7dkE4fgpnhgjkKW0xrsxkGin/CJfklWW80Mn
	 Kr78S8awjf/7IxDMo0Si/X3n2+RMSfouscSkPIDKSo58Uea9BKoFlFqaRW3XxnAtbu
	 7FcYZ547hm2cg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6662tp3cB120471
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Mon, 6 Jul 2026 10:55:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 6 Jul 2026 10:55:51 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 6 Jul 2026 10:55:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next v2 2/9] wifi: rtw89: coex: add rtw89_btc_init() entry for initialization once
Date: Mon, 6 Jul 2026 10:54:38 +0800
Message-ID: <20260706025445.18428-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706025445.18428-1-pkshih@realtek.com>
References: <20260706025445.18428-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Separate these two type of initialize entry. Because Wi-Fi power save
leaving will also call the initializing, but don't have to reset all the
stored variables.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 35 ++++++++++++++---------
 drivers/net/wireless/realtek/rtw89/coex.h |  1 +
 drivers/net/wireless/realtek/rtw89/core.c |  1 +
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 43de238c18f8..196bec751070 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -7858,6 +7858,28 @@ void _run_coex(struct rtw89_dev *rtwdev, enum btc_reason_and_action reason)
 	_action_common(rtwdev);
 }
 
+void rtw89_btc_init(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
+	const struct rtw89_btc_ver *ver = btc->ver;
+
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s(): Init %s !!\n", __func__,
+		    chip_id_str(chip->chip_id));
+
+	_reset_btc_var(rtwdev, BTC_RESET_ALL);
+
+	btc->dm.run_reason = BTC_RSN_NONE;
+	btc->dm.run_action = BTC_ACT_NONE;
+	if (ver->fcxctrl >= 7)
+		btc->ctrl.ctrl_v7.igno_bt = true;
+	else
+		btc->ctrl.ctrl.igno_bt = true;
+	wl->status.map.init_ok = true;
+}
+
 void rtw89_btc_ntfy_poweron(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -7941,19 +7963,6 @@ void rtw89_btc_ntfy_init(struct rtw89_dev *rtwdev, u8 mode)
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	const struct rtw89_btc_ver *ver = btc->ver;
 
-	rtw89_debug(rtwdev, RTW89_DBG_BTC,
-		    "[BTC], %s(): Init %s !!\n", __func__,
-		    chip_id_str(chip->chip_id));
-
-	_reset_btc_var(rtwdev, BTC_RESET_ALL);
-	btc->dm.run_reason = BTC_RSN_NONE;
-	btc->dm.run_action = BTC_ACT_NONE;
-	if (ver->fcxctrl >= 7)
-		btc->ctrl.ctrl_v7.igno_bt = true;
-	else
-		btc->ctrl.ctrl.igno_bt = true;
-	wl->status.map.init_ok = true;
-
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], %s(): mode=%d\n", __func__, mode);
 
diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index 259c6e2c0e3c..fb151f68eb64 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -272,6 +272,7 @@ enum btc_wl_gpio_debug {
 	BTC_DBG_USER_DEF = 31,
 };
 
+void rtw89_btc_init(struct rtw89_dev *rtwdev);
 void rtw89_btc_ntfy_poweron(struct rtw89_dev *rtwdev);
 void rtw89_btc_ntfy_poweroff(struct rtw89_dev *rtwdev);
 void rtw89_btc_ntfy_init(struct rtw89_dev *rtwdev, u8 mode);
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 26b744dfbcf8..85aeb9e90812 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -7488,6 +7488,7 @@ static int rtw89_core_register_hw(struct rtw89_dev *rtwdev)
 	}
 
 	rtw89_rfkill_polling_init(rtwdev);
+	rtw89_btc_init(rtwdev);
 
 	return 0;
 
-- 
2.25.1

