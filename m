Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038554;
	b=urGeTYDKziPUoMrcPs+fMdzcpkycn/cFvc6A+AvF9GAj5VG0GfqanfZZqImMefBo6r0t
	 CKOBoDGUDeLAUDGZmNzYQOZsufybkuTqXSK2l96gUcvyYWIgfXWOSj+qWINVnSXIP+H9m
	 1kDsfoVYoncSuwfQE+Mh2Ef8LDLwXegBuYb8KkYF7ToaVQRxynDLRoKOTpiXgl+j2MsYC
	 xJdrvZ7okxik/qxVQoLlKJRsECVsT+mLdscO26ODSgLAxJH2wsu5OG7zkVjdy5zWae7hy
	 gpXxopT28KYL6rOzW3UjKkkk9gidWw+36cPACKlXNciKs67PqDvZntfdpq2ktxrCxnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038554;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oA2KSCCZdPSPR7+/ASoZPmv+ibMiLNh4p2Cq1FVXsDM=;
	b=KvO8fjqx6OudD/xasMzpWUJt5pQqT7W+hBQudR/o4XUt7K0AyB9eHh085eyXQqkSQleA
	 2qFe9XZQrfxCsse2TDs5scnt7kg4x591ern7Kfw8Pyw1mlrRvcequsauh6MLFBPiWvoCe
	 D1lXG65xCcxASzXSLvZ25GAGuOX8CD1zqHAswTGilb5b2H8F7cZlF46YbkjZhPxrM7ga0
	 Tno0aZc/mdD7RxKou47arun6WRKsbJddvnr6S1BNPoTC73Y93eBnxT6gGl9ZBt/Ezjdv8
	 z3OsR0qCkaZOsci+6QXGlSN8p31TLazDhFwFxgxKaZlSuwZv+J76ygpqqGCnPXe+Y2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZltljWek;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7D4606A339
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E7D4606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZltljWek
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e10a70540so1897953f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038553; x=1793643353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oA2KSCCZdPSPR7+/ASoZPmv+ibMiLNh4p2Cq1FVXsDM=;
        b=ZltljWekt9VRbbM3i9DkjeTC7lAx9hLD8rDQQCdtcceujBVnzVUD+6X7PTQ+QKxcWg
         N0xC5D6gCIhXsdCVYcbjyDbwee5LPYVWtSSvXJWWmMnZF45/v9sBTW6CNqN5UUdqldOj
         z6Je9EEkNh5+r3H2sEgjEKt67B6B/c594/qW8vrNDruiNhR7m+KdI9EuvU4RC62IM/uj
         4T0m/Gf/cfJpTCPg5aCL5yNRg0I6O2YuIToWBvb8ksNd++mKX4uHagpXBYlVyT6p+yKd
         /RHFC4wVmpzpP9Vd7CrZ+GADxOhZDgUqIzQt4FNvNsx9xjZvLoZBO7oMqTBuGS04HS6W
         9K3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038553; x=1793643353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oA2KSCCZdPSPR7+/ASoZPmv+ibMiLNh4p2Cq1FVXsDM=;
        b=iwXaWMzQlQBqk6miYkH0hClf2BmbGg16uycXtVvDO5qk/XEy1caF9PWLn5C09rBOJ+
         PTbycDaDEhGjg2ZvdPUxhFYcMbCyF6+dGfIHruuzE1D/FSZnDuEj1m7qCTWC/8jj6TAK
         ZUCSPVmQeh6lQlm/QuhL9Twnn3keE8m+klHaibVuTPaTeMPitQYo8+fV3M3OkH9MFaL7
         f2dOOZa0vsUeay4A44nuwW8cqrJ5MEl6t2wk4+ia+msdWWe44RAc7SWrft2sFehUdZ4h
         YJ6JTWEGm/GZ4Qqve7YCeGxqdfqwFC0XKukbW1QfeW/4e7MykkpvZulLNHoIQHvUrNGG
         X7wg==
X-Gm-Message-State: AFq9FYK7gsu27VTvSK20/CFZN8d8DJqSHirg0umNuAf01pmQRoZhVAz5
	Euty8mlYjRp7BVLMS5MOLiVfhFVuvZW56VMT6rVuQK/uZGNNYt6tN5f5ApIKXxZM
X-Gm-Gg: AYBFou09Ctypa+8/x6PVkMFX/uSxYPsMNPJ9hwP5N6YJrV6YquGpi3r+Kq+/W3wAQZv
	UR9ER+k5ox/MHR+rcEmlWA4GH86RO9KcinKGN9kGWDuEAVWIibD/Q3AIs5ElbAF6+DjqqZxJv/K
	l2vIAUcfZluq7ObV3YFT8IPRB7zW8ANM5LiC7X4X9HDTpl5yYOKMxj04LBG5d1GvrU0cG7hQ1wr
	O/WPj9ajYroRWG24NCOSwiW5E19+VYnhwyZCm0MkTI1IfyWuPfysqfJgd+5UJ5ZzRCJF4mSBAxW
	MfS92tszzpg2dgCe0W0aEHsEpmSZcgD7rPlIO7cK6XQDYGQq1b1l9yenX74tCLe1MnKoTuRo6wd
	vmf/2OFPSSN3WnsUPZ7rncjJCoPfyoNR4o4L7Umk8jDwBRbz/6tvEnwzTj8V5/1ZKCNrgUwMEu9
	n4g+I1PzCA86w7IYYFZCegdd3uqb55/GBygB6kAe0z2GuLGNHZwgrBXwkgoHB5zg5sHTcaQ3u7L
	xqGMhpRUzD1JuCx0ORHwt5VUiMdWeQp6tEJRwQF+Wvz2qRI0qsndGsMoqD1Y1k0P4OriKrdBgh9
	FEwZ
X-Received: by 2002:a05:6000:188e:b0:48e:3085:7cf0 with SMTP id ffacd0b85a97d-48e3eb989d2mr14700024f8f.51.1793038552780;
        Mon, 26 Oct 2026 11:15:52 -0700 (PDT)
Received: from luca-HP-ProBook-650-G1.lan ([2001:b07:6454:c33e:6c42:b004:d90b:d191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20967847f8f.45.2026.10.26.11.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:15:52 -0700 (PDT)
From: Luca Casati <luk00casati@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com,
	b43-dev@lists.infradead.org,
	Luca Casati <luk00casati@gmail.com>
Subject: [PATCH wireless-next 4/5] b43: N-PHY: wait for the first 2057 RC calibration run
Date: Mon, 26 Oct 2026 19:15:42 +0100
Message-ID: <20261026181543.77763-5-luk00casati@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
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

RCCAL_DONE_OSCCAP still shows the previous run's done bit for a few us
after a start, and the first (SCAP) run polled it immediately, so the
run was stopped before it happened. RCCAL_SCAP_VAL then read 0 (wl
gets 8 on a BCM43228), which detunes the TX low-pass filter set up in
the rev7+ workarounds. Sleep before polling, as the other two runs do.

Found and fixed with the help of an AI coding assistant (Claude Opus 5.5),
by comparing mmiotraces of b43 and wl on the same card.

Signed-off-by: Luca Casati <luk00casati@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 44769dbb7..cd50614ff 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -938,8 +938,15 @@ static u16 b43_radio_2057_rccal(struct b43_wldev *dev)
 	}
 	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
 
-	/* Start, wait, stop */
+	/*
+	 * Start, wait, stop. DONE still holds the previous run's done bit
+	 * for a few us after the start, so give the cal time to clear it
+	 * before polling, as for the other two runs. Polling right away
+	 * stopped this (SCAP) cal before it ran and left RCCAL_SCAP_VAL at
+	 * 0, which detunes the TX LPF on radio rev 9.
+	 */
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
+	usleep_range(70, 140);
 	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 2, 2, 500,
 				  5000000))
 		b43dbg(dev->wl, "Radio 0x2057 rccal timeout\n");
-- 
2.43.0

