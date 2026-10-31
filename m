Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430637;
	b=U6+DOQvW1L+lJsGnbhnDMwrZ9RlXx8CooSVL+X32rOwR8dTq9BP9VZHYBtoxBRj3vxc6
	 MV2E8MvXt7zjlejTM05qOwSoIDtjnLIzFrii7m5k6WZXQSY/Wrb7JDYh34iHZvwNyNJyD
	 DC55UVuxVOJC9XuxvIG7llbtg71M1lRuwtCuJmoANPaolmSBJo+0M0mdWFfa69bAsOGBT
	 aVI4Jl+FtHYN9lQvizIQCHT0RB+bHDZs+y+DBP8nodDfxIGwFVlUNbF+yrkTCZxddhLLV
	 e9l8pZnsqC5/osLCYuXSykqV84aLPqYiLHz+OaQrpxrjhpUG07Rj/3FRvDXXw6KGZ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430637;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=y8xZwpAPIkj52QCkHw47OM7dH0DdqJgMz048F4gTYBk=;
	b=5XX0F7Ptcd6eFhSCHz6i+TVGPCqBSzsGgD18yOBbM4KYSK2jtgCOO4pcvbrRdcq+NDaE
	 1z2iac/CprlLSZZOFi5WftYVk7ww4qlpX/yp5I8qjOS1VkPsZ4kFtgmUG1+RK+Uiry6GG
	 UajvBZJqjitCscEA7sgjwS8Piloag5eEzrkhZg3aNxXJvKnvHHQh7LsbgVqOFlNMaqZcl
	 iuM36OLL26o1snrSweH4dsiA7XCOv7OPmccMdRxV4EHacV5WxxtsooEWMcdAhYjUsdxIb
	 hZRaTyvktkJMcRobcZ6TDdo8y5NOoZFFxmI6lNyTNJiOIoYyuoTKG7MXYCnjSiwAhKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QtfYv6GW;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FDF606A31E
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60FDF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QtfYv6GW
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso744188a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430637; x=1794035437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y8xZwpAPIkj52QCkHw47OM7dH0DdqJgMz048F4gTYBk=;
        b=QtfYv6GWXYdUe6LNRpXxuOsxAhGSyGk+PogkdC62+ZbVH9+Jqp/PTOsU9jeaiVBGtE
         b4a2b86DFjuV+WglyEBanCwhvoBzQjNPWNn0IdPGLvBWOULMyhA77sYr0PvorJ338aY+
         tkFDAlf7AeYij3WfFT/dAwg3ImEIydckWWqZ14kQJ6NLzw6YNgXQt7B24otQ6lkesTwu
         sY3YzDInJ84wd5+52tvtbznPFKiPJWAG7ScjwTBCqQZ0PaLpwjGBSaR3xbrCCBxftPJQ
         +ZEGV1/GzcYPsZMfj3ORVKMjgYNtaJ+wbJWzI32/kD9R0QzsaLlY9HPo151r+n3JA5VW
         ABUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430637; x=1794035437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y8xZwpAPIkj52QCkHw47OM7dH0DdqJgMz048F4gTYBk=;
        b=IOUjpItss61J9Vac18B4YmYNBh1r3V22z4XngHjUAgRDC3ozn57Lkbyxt0aZRH8+5z
         TyMMXIe2fjKwpRaNzIZkxqGkXh+ko65crRRFgpCnEHnh4P4+ZBvYLCrWQHl9kMdCRRnE
         XA8cMWOUkPSVnnJvGzVzagMnzQUBwWd710+CP/amdLU91DVYNmhPC0ShtEd+EABqmQTW
         9lc9tHPd9mVe8vBrJaco9gqq4SVjBCNJGUMIQb2Fg2y34CdY7ZxGwBb3wc0gQ5lIQT8j
         AuiWtpCZbDGCA6dPx3OL+uH/nPpcrGSuUN8ROz/fg19RW+P85kItXq9hhK0Jx+g+ioWR
         Rg8w==
X-Gm-Message-State: AFq9FYKq2WCK0H7jwYV1q59Z4wYOX4EW+Y7eVzaQkrQ3OagSxqmmI+S2
	G9eeLJZP+fF3p5lT4tzMnminDgjnof7Z+ugppgpKICL6RRbar/3HNP8n
X-Gm-Gg: AYBFou1oWF5sth6vu+y82kpkiT347eLa9KdIpBGlHJK6674joTSTLEsbMY9kvUqH36o
	lGDqmHBHLAbVkOz6ZNN9ZcrsAiE2wi6fLuSBn5ciNT3tWO6mijw9aZdgPGFB6qGx7MnJQtSxKKq
	N8jNDjD4yLzxtChlU040H3FVe51QNmoO8a8HsgzhnYTNjUueYH2F79sV4xU4oxtYciuTVzm8TUr
	A362B+gFbJPDuoF9xWtI4+YBcmeAm296nGWEjRrEee6wTEfKCDpRF2xscCyYUUUke3SeWTyZoCx
	GPFtREYyUJkJg4wqPDUckfUzikAUMDCWl0ngIb6sKF0cYUkc2E4MJVO0hZt/xMK4OIjnuyNR2az
	9QChtZArnWGu8TBc7mUCrsHks+fJjSAWTna0Osl5u8kklkoyxgaRFpwWsz6nBqEMFhtLRtLUzC1
	P4y6ljLYS0K1sA9BmbOOAP4rMGccwb6H7DM87PUBqCZnnrZ/KOO9zBNmJyrN5AqJ+htlCIfphKZ
	BUv85C1tzmmco5iFkuWB95/FLxKi4ocq5XsVeSImON2LJ4g9Dz6CrUAoz3leQX2BlY9M9v8sdSY
	gK+QyVABjllvfbOhpoujSAKnYbz3v2PxFkGN7dC61f/t9UMdSmA6HP6ei9aHsoV/aMOMHh0uDyN
	X5+DkQpAS5ki8AeZDTD8bf82G0A==
X-Received: by 2002:a17:90b:2e51:b0:3a0:4668:4cb0 with SMTP id 98e67ed59e1d1-3ae8983f049mr3818814a91.47.1793430636804;
        Sat, 31 Oct 2026 00:10:36 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:36 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2 7/7] wifi: rtw88: 8812a, 8821a: respect peer A-MPDU size limits
Date: Sat, 31 Oct 2026 15:09:47 +0800
Message-ID: <20261031070950.425176-8-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261031070950.425176-1-hjf3108@gmail.com>
References: <20261031070950.425176-1-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Honor the peer-advertised receive limit for transmitted A-MPDUs.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8812a.c | 9 ++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index d93c4776e0303f52273d92eaa75341ebbcfcb066..a3b5fae5608e0637b1badb7aff7986160c9668a1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -78,6 +78,13 @@ static void rtw8812a_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
 {
 }
 
+static void rtw8812a_set_ampdu_factor(struct rtw_dev *rtwdev, u8 factor)
+{
+	factor = min_t(u8, factor, IEEE80211_VHT_MAX_AMPDU_128K);
+
+	rtw_write32(rtwdev, REG_AMPDU_MAX_LENGTH, (8192 << factor) - 1);
+}
+
 static void rtw8812a_do_lck(struct rtw_dev *rtwdev)
 {
 	u32 cont_tx, lc_cal, i;
@@ -926,7 +933,7 @@ static const struct rtw_chip_ops rtw8812a_ops = {
 	.set_tx_power_index	= rtw88xxa_set_tx_power_index,
 	.cfg_ldo25		= rtw8812a_cfg_ldo25,
 	.efuse_grant		= rtw88xxa_efuse_grant,
-	.set_ampdu_factor	= NULL,
+	.set_ampdu_factor	= rtw8812a_set_ampdu_factor,
 	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
 	.phy_calibration	= rtw8812a_phy_calibration,
 	.cck_pd_set		= rtw_phy_cck_pd_set,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index f7391f6aa3039c7ba4d88249d968a5f1763ea866..f597edec290f64fda1c457812b240515360dc387 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -49,6 +49,13 @@ static void rtw8821a_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
 {
 }
 
+static void rtw8821a_set_ampdu_factor(struct rtw_dev *rtwdev, u8 factor)
+{
+	factor = min_t(u8, factor, IEEE80211_HT_MAX_AMPDU_64K);
+
+	rtw_write32(rtwdev, REG_AMPDU_MAX_LENGTH, (8192 << factor) - 1);
+}
+
 #define CAL_NUM_8821A 3
 #define MACBB_REG_NUM_8821A 8
 #define AFE_REG_NUM_8821A 4
@@ -872,7 +879,7 @@ static const struct rtw_chip_ops rtw8821a_ops = {
 	.set_tx_power_index	= rtw88xxa_set_tx_power_index,
 	.cfg_ldo25		= rtw8821a_cfg_ldo25,
 	.efuse_grant		= rtw88xxa_efuse_grant,
-	.set_ampdu_factor	= NULL,
+	.set_ampdu_factor	= rtw8821a_set_ampdu_factor,
 	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
 	.phy_calibration	= rtw8821a_phy_calibration,
 	.cck_pd_set		= rtw_phy_cck_pd_set,
-- 
2.55.0

