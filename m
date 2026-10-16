Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AC03BB12D
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 21:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792187028; cv=none; b=cTzeEPn4v+cPLYvy0Pi+0UutXZNAokWvz36ZqLJmvZVNS1TbA9lO8C1d11zTi+WckgzHL2b3zB9vO7QY4DikJPdCs3+q2CbcqKlMvv6eJXW5vuiZorFlkaxDBK6vQXmswI+S/UqiHh5LPeKumUwmxno2HFPyOpRsru2qW+tygO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792187028; c=relaxed/simple;
	bh=0RGKq1R9eRsSUEYrNith3NyIKZmCEyZV5+m6BlofS1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SneyPX7XtV3X9Xvo1m19vXso02daSXbTx91WYeILDjCyCyHm/Q3478wllANSYdjQsgoJy/nXblidR5Z+pn4D9c3/Wt8oSscfvXG62/uwxzVuha/miU57hFYc47mVgYK+ZhexSWTFxyAov+jxfmv3KQXSsJDmtJQOlnHdmOXw05c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GsiMYCZI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsiMYCZI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4956869750eso2283895e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 14:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792187025; x=1792791825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=27gs7dlyGrdmSFMZuaPiLusWTuM6jffQi1p6X2KKuH8=;
        b=GsiMYCZIMyEgpaP6JUnu22B1ilHTX4wsFPiPAaR1Pn3AU9p52cE/fsW0fRFRSOer7j
         mvQerKRQCrUmvwCH8G2LVu43DEjLepSkLl5XANBZ5y8XANollJsUKWFSMU231Qfkl00t
         LgXNJSK4tLjWUO60FVmXZmnHSae/cUoH+n+gM5c3pqhqCbjM4fA29lozQ51A3hypQEoG
         /XHRAl2pHvZf2H1xuNnRoKBzQHttYxornyZKKQLqEXFrznfoLAm033ZoWM+HQfR/Q53Q
         VUYtGrl5U02rhcQjaPe6x+ayOwlUL8OjjL8HfyTv4wCk9ZcKASuX61Y+u+mJEuDNLGED
         qHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792187025; x=1792791825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=27gs7dlyGrdmSFMZuaPiLusWTuM6jffQi1p6X2KKuH8=;
        b=McTKbI+OMfZLdQ7bq5AaCMx0AaBl+uwGb48ToKGO+KazY1XLBaiGf/F+c9OIpLOuQM
         kNwcfCym2AypmBFIixqYJ9jGu+7Qcg1YUib5KVmS9Lr2C8Q5sR5WTiDENp3dIiwjNTHc
         VqSWzd35LwGnBI1RzFOSRfAsMHsf9imooMc+92yvRB6YkU6cyAOWuBmp7Kz272V69aBT
         ew08EpRbkpBX3nvx6FkLoERBQUZ2q17jJQTmKQrtkLlq11fSyER5JqZ4re6IY0tlQhQg
         7L7EargtEWYWno1qTi2Ddqk0/l9ncsrmetzpoR051y4y90hF6GWnuyAfMPI6OsJeO/Rx
         jTsg==
X-Gm-Message-State: AFq9FYJiIhZtiojKGHnC57ib6DtEpgQrXwWZHlK69lbL42pRPV+FL3H4
	EBU3RpbWQE1Rc7L/VWFPb1M3O3ZfEHfCnhr3jAtb5hOc5bNJEhe0Ru/C5DzYA0MPJIV2aQ==
X-Gm-Gg: AYBFou0nSgm8gIw9GnNfYuN40A1EVm2o7MDcBJnrZ7yVLpu6zd6w4KpYnkTf+i6/t/H
	NH8ymwoP7sue501WBCxR+Vo7pdU84K9TcNb50meI0Cc+T78dY2RwrEn/v3O+88NL9Et6c9pA6XN
	QVO5zd/gXEN3dHHL5OexNwARieNSjAq/GGWuSN8H3U8CMwCjK4//QYfr4HvNHOzi6VTUavM5mg4
	fYKXEhxFrunXv+zE49G8WSZXZIJuuk+LN1NQWGDgznKo17gS70sEjuychgErLmLiBToTV29FPrr
	F27ZeC3QwtqG2vW70bOKfTM/GeZYCXZa3s/zVTXim6ngTcjCaXxVNCU/7Fikm8UE/tsXOMuElE4
	XORM2VACP2z3sBX/n+Cj07hUDkYnJQZ2jjTJTlFmasVPkpgnRNCAMNkOljp3OV0V9eC2tbYVPn9
	XMCvrOLP7I4cM3ETUnODW6vRTl/B5UbZtuNs+9f3DeWZhPSOVfeBILWoG+TCIy25OQfl+2JkrO0
	wV0f9UWjfVA67H1gL0PqA==
X-Received: by 2002:a05:600c:8709:b0:49f:ff73:9971 with SMTP id 5b1f17b1804b1-4a1d75f8f28mr21917295e9.18.1792187025297;
        Fri, 16 Oct 2026 14:43:45 -0700 (PDT)
Received: from omarchy.tailf282f0.ts.net ([102.208.20.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d30d778bsm55151525e9.9.2026.10.16.14.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:43:44 -0700 (PDT)
From: Carl Quist <equalizerjr@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Carl Quist <equalizerjr@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Date: Fri, 16 Oct 2026 21:41:05 +0000
Message-ID: <20261016214105.255517-1-equalizerjr@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow 8723d to operate a station and an AP interface concurrently, using
the combination already enabled for 8822c: one station plus one AP on the
same channel.

Without it, the AP interface cannot be brought up while the station is
active (hostapd: "Could not set interface ap0 flags (UP): Device or
resource busy"), so an RTL8723DE laptop cannot share its Wi-Fi
connection.

Tested on RTL8723DE [10ec:d723], firmware 48.0.0, kernel 7.2.5, with
hostapd 2.12 on a second (AP) interface with its own MAC address:

- the AP ran beside the associated station on 2.4 GHz channel 1 (HT20)
  for about four hours and served a smartphone client;
- the AP was started and stopped repeatedly without affecting the
  station;
- with the AP running, the station was disconnected and reconnected
  four times; it re-associated within one second each time and the AP
  stayed up.

Assisted-by: LLM
Signed-off-by: Carl Quist <equalizerjr@gmail.com>
---

Notes:
    An AI coding assistant (Claude Opus 5.5) helped investigate this, write the
    change and run the tests above; I reviewed the change and tested it on my
    own RTL8723DE laptop.

 drivers/net/wireless/realtek/rtw88/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498..c64a3ba 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2299,7 +2299,8 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->wiphy->max_scan_ssids = RTW_SCAN_MAX_SSIDS;
 	hw->wiphy->max_scan_ie_len = rtw_get_max_scan_ie_len(rtwdev);
 
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8822C) {
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8822C ||
+	    rtwdev->chip->id == RTW_CHIP_TYPE_8723D) {
 		hw->wiphy->iface_combinations = rtw_iface_combs;
 		hw->wiphy->n_iface_combinations = ARRAY_SIZE(rtw_iface_combs);
 	}
-- 
2.55.0

