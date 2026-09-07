Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6EF5221EA
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 19:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788808150; cv=none; b=Y6o6uski6Ubkg2JAKqQ3kvri4yWGiLg1DKk+qtSHzmUTYrtNdmBLSsbCVsXnxBcUY8zdiRcLr8Kv9tRpLGndQgrPv0NHNQe/qVEMaYv+YzaGT5iDe1q2TWuGGZgTDxF7XBntCZkGY6hsQ4quUiZ32cNOCXw0ivPFJfIVLDYyJ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788808150; c=relaxed/simple;
	bh=t4Yjm2DFocmwKXQlXnFjkqXGxphq5+vhcIQY98+Bhy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uzt2tJa6Xzb32bt2jSADW4UfIElUZ1ubvmsFzpqC1V8WlJQ3RuiOu04YZPNM9kWvwCb8xMxZ9TZwAS/R7XZ5hLTRW4+h6/BhpXRfBSEGYbEqi1Df/XaTtNXv4QU6eO4iRei/kVGDizJpoAs4lJf8qFhefI1NRzmeBc8iR4SCkYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrF5MKb4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrF5MKb4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso48406395e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 12:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788808146; x=1789412946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6BtYvbGadikfpl85inOhvk04RG8y78PVhmpNVJAilv8=;
        b=QrF5MKb4IheRkOHTPilCSZisUMIqZNZEkXoZy5+z+gYiIVF9FwRefowkeibtcTpUk3
         F1YqAdwXNdob2C0IKTd06SE2JVN3eH4F0ZIKxpiZPC+H3CRbBjP4G0WAFlChOqKE89rF
         wKtzShBqa4pGrtzl7WUdBNidZli6lcBAUpqbJBt2sGRYftKWqyhIhbGsnvrVDfMDnyt2
         cF8EQXT+A2d2VGHz5a/nJze/R6pxeB5F3dky0wPySpSP4uiOyvXd6a41HhVc9ApeQg8X
         92sKgiKayipMVJruoHqcHFytxDw2O+RbX8zSNn7Go0ZHuApCEY2KKOk4tjCtI5RIfH+2
         PRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788808146; x=1789412946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6BtYvbGadikfpl85inOhvk04RG8y78PVhmpNVJAilv8=;
        b=R7QBV7sw1EL3dA7u6ZQApzMqNb6d6C8WXjYFNTP8nUkLbm2Jq8sgGpRzl30XAFgZ2v
         Z98CapcQjSCimpTzX33xnzmxvYi7BkUW4Lt/gpwTPxxkfaJDeTkVWAP8xjaLryIcuPC2
         Me2T/nerNcXMKAkUbo0P2/gqdVYIidu11egEhfivXw/qBEszniTjl0Z/dHMYwPdfMEfo
         5KerCYyKsg4CrDHRmjkH+RQ3rbscbuZc2SW39w+RDPi6+PwJSDNVhgHKZslrwmPFeHYa
         TSTKvAaX4VRnJCMOD0nD6hDX4qqepEoTE0xGOydLtN5VDhNtJDw0WSeyZSilQHXAW0Pp
         AdaQ==
X-Forwarded-Encrypted: i=1; AKwUvBxmtXCZXRsJK1TNE7TOeXTSYCFf93wbUmHvSe9jdrcQJ3k5MQR+CRWYvlOc674OG/ZYbc0JXMqGU/RKtBV+Dg==@vger.kernel.org
X-Gm-Message-State: AFuF++kFkWpV2sEGL4otUQ4z6X1Yrcaqg21xeKrAY8Q1yC04b6+foT8U
	AX2PTGrHPQ7e/loJMX/ocgqvW9POVIPvovWTqS/9MBHARwYE/HAkklt9
X-Gm-Gg: AYBFou06zcPCEkrJo6KJs+RQwxYF0tZYHf2BumElzRztOlxTIemEl+7112a/RdlK1OO
	Evb8ZJ/oKYffsWXL0wXRFoJwIbibpPY9cpdUus8SZ6xVpmEp1pO5bMCXwlWfL/9OsAwMYgnq1Za
	wJfHOtDoNutI0wVsi9886tIrQezBttV2te/SdTSjD6NYwVzgHDARcwM8L/rZD3qBemjQmLwNSfg
	GiT01rPjHJf6CpBCh2EU6mhcG0BdwwtU4YjY00CnwJdrI4wB1MJGct7Qj1kP26NE6LdRHENcse0
	SUGFtsbNwtYLxbRe1nKUwEXkHBq9rwIEYkPDnRQ+q79060/pGcz8y3GDVIC7U99CgP3aWJMfce9
	/+Qr0j2uYBG3MRdIWX5YC3pvN54WIWALg2SZnYl1RminVASZEJVQItcZfu8NLGkNq/iYnjRhKe0
	VSJbUoFlSHCqjUu4b6PczMenZkxi6Gnc07cDgvUKTQWRcRs3hs4J74d5V2488+WHjNew==
X-Received: by 2002:a05:600c:474a:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-49cf825d722mr223565895e9.10.1788808145861;
        Mon, 07 Sep 2026 12:09:05 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885bf3f0sm33365544f8f.33.2026.09.07.12.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 12:09:05 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v2 3/3] wifi: rtw88: widen the ATIM window while an AP interface is up
Date: Mon,  7 Sep 2026 21:09:01 +0200
Message-ID: <20260907190901.1056945-4-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907190901.1056945-1-mehmet.fide@gmail.com>
References: <20260907190901.1056945-1-mehmet.fide@gmail.com>
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
---
v2:
- new patch, REG_ATIMWND 0xa in AP mode as in the vendor driver, back to
  the 0x2 default on stop_ap since most chips never program it (Ping-Ke)

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

