Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B33D47A0
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789028247; cv=none; b=fmEF0TfTRMGkl8t2dhyulAPoBp7aT/vJM83uzzj+8VDcRBvvaCXSgvqXOSfNiK/WVM1vE2la4fcWFtSGwYedHWWL2RqRjmmgG1Av/ApqLdnT6SQIGkwq0qmybBFRRNZTBNPzsPUGL0idFR7/E8jGaninMUTzpuHP4Q52D+iPY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789028247; c=relaxed/simple;
	bh=A9QmHRxhcnlFEMXPsheklMbj5r20vpaPgP2nE5PMD2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFpa7h9vMe2kOEpk2P7/8wI3WIzh9h/niv8J0MsWYR0e1qn7ZTOdAbwoXYa0VKNDFEpR1bdaXMZPOJUwzn27BAAUuWwPbjVvhON2nOE4gaipPlq6TdabGBJnxyaO83DQcjjYgyoakBPyxI7IRY5EvKmGiIHExNjv0DYoH1JFrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mX2vNhOI; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mX2vNhOI"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e85499ffbso543623885a.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 01:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789028244; x=1789633044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8w29+FNmbA7LWNO6WgdUJylIFrA2rKKIMGzm7xHnRZg=;
        b=mX2vNhOIAOwa76+OqBd9FCSTAiBmq06wRjyx55dI4Y2rEtiIx2hooyuQwbkadi41YR
         k5ldR5XWyOYsh3JrVS329wcN1sD7qzQgh14grLWkPU0LzBtoWDr7tYR7FycOjA9rjxmM
         XU1Nr3H6p6bpaIlNNiKhGjtnJlqGTe2Qr0T1YurtF/UVD9+v1N1im/ypTrnFbrlovsJY
         Q7XepRHTsKv2KeBlWJX2P0WgBPY4N5zovxd7JQwkBds6nF0pfeSDeuEzUa9Z9QZud6UQ
         Ho2b6CS56m29id4lKVlHEfphl4HOOYrkD/EQPEFvIu4IbHmCo/qnpiKjYu5XRsAkZ7Hc
         7PAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789028244; x=1789633044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8w29+FNmbA7LWNO6WgdUJylIFrA2rKKIMGzm7xHnRZg=;
        b=pUZoIGcHQ4IDt4OzYVMhSkYT/K6l3fDD6JlDlh/+HVBRSdauP9QmncJNUKiEO5Ky+A
         nClO48Tvp0DzrAvIpwrU3pYLL3mqXs9ms/WPXg0pTpVZ1IEGLRJjX6cC5M7TR2XR0LZr
         RfIehgW8a8kKmxUKfGb4B3ebTuQB8jJfIEyZmO+U1+64OH0LjqRkwJPPQNQL2qh9cA+A
         aGN6TCGJ3Ls0k9ovjDlaUCbOIiocUBTTglsTswlQgo1wNCAM82VM/h3zGWdaCvg3sHKZ
         CwwfdnQXe3oWz7FVZaR+r0Qug138e2ZccCPediifXe1mMLzEY8hVydi3D3z8qqI+30hm
         IPZQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4LUI1wbNaU4KXyndKayQhEJ9uo29Ub+9xm+2Wv6Gr3PBa85kHG/2RvK7AB5f0a2oq6UFWQBMtaLBgNGhXxQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nUaYxYdyxszpN/CO7dto+4GB0wlgXuRC154KGTpE9AswkbqRco
	WYSxOp6FHI1VyGNp98YiKJuOBIsNs0eW6pNolcwD81QkCeS6yd24DSwu
X-Gm-Gg: AYBFou03GE8Fi5iosiwQpcA/fJplPbRAo6/rs4uAaXhGImUOvuN1iue7+hjgy/96W/R
	tBIav6O0EGiMqyCRYDFsrzCjz0jdQKIJXdPYGzEkQm6zDb2pOVh4Cpbiouwf2sA3R5dTXOTjc21
	8tmxI2ELJC1Ve3bP5Xj1e9Wss9OazLoN0SfIqINYrvZnmHhCwH3TP+6AbHjYhfv4wVuiV6LPeNw
	hjOfaF59Tdh7fJKwfcH5BcV0zS7DdIIj5lmyQr/Cb7NgOivr6r0FASetKx2fOn92AJH2ilR9Zmv
	agVjqdBlNGp8e5PNnkafaCmNNmO8PxEN67QXbtTlsERR47rkq8rJFkwGe/xpPOxPvjrqfPtf666
	nONuFCPOvBrAv4FtuqG1rpCtrIH9AvRK2odB8zY517gpBsmaVBeEVrK6KSQXrLJ3Pk+hqwZoS9I
	AueqSIurJusGoHtHbuuflJSqrzEq3CZK+D690cy3RtyYiaz6a+zfZpUd2XWk4EoXfJItmDHcN7b
	bap
X-Received: by 2002:a05:620a:8388:b0:939:9c21:8ece with SMTP id af79cd13be357-9399c21b43fmr3256938285a.42.1789028243645;
        Thu, 10 Sep 2026 01:17:23 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939a57535a1sm1087723885a.0.2026.09.10.01.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:17:23 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v3 3/3] wifi: rtw88: widen the ATIM window while an AP interface is up
Date: Thu, 10 Sep 2026 10:17:16 +0200
Message-ID: <20260910081716.769081-4-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910081716.769081-1-mehmet.fide@gmail.com>
References: <20260910081716.769081-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

The frames held for dozing stations go out right after the DTIM beacon
and only for the duration of the ATIM window. The chips come up with a
2 TU window (the two that program it set 0x2 at init), which drains
about three frames per DTIM; the vendor driver sets 0xa or 0xc in AP
mode instead. With the 2 TU window the measured page pool exhaustion
takes ~100 s of ordinary multicast chatter; at 0x4 the same storm
already drains, so 0xa leaves comfortable headroom.

Program 0xa when an AP interface starts and put the default back when
it stops, since most chips never initialize the register themselves.
The bound and the filter of the previous patches still apply: the
window adds drain capacity, the budget protects the pool when that is
not enough, the filter keeps chatter off the beacon-paced path.

Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 2 ++
 drivers/net/wireless/realtek/rtw88/reg.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 0b622d7663b6..2a9b09fa76e7 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -474,6 +474,7 @@ static int rtw_ops_start_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_AP);
 	rtwdev->ap_active = true;
 	rtw_store_op_chan(rtwdev, true);
 	chip->ops->phy_calibration(rtwdev);
@@ -490,6 +491,7 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
 	rtwdev->ap_active = false;
 	if (!rtw_core_check_sta_active(rtwdev))
 		rtw_clear_op_chan(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 08e9494977e0..0b9ba6f37680 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -483,6 +483,8 @@
 #define REG_DRVERLYINT		0x0558
 #define REG_BCNDMATIM		0x0559
 #define REG_ATIMWND		0x055A
+#define ATIMWND_DEFAULT		0x2
+#define ATIMWND_AP		0xa
 #define REG_USTIME_TSF		0x055C
 #define REG_BCN_MAX_ERR		0x055D
 #define REG_RXTSF_OFFSET_CCK	0x055E
-- 
2.55.0

