Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC764B4057
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580117; cv=none; b=s4XdawfRZln4ZEkOfz9QbyxGwQuKAJfIVl1f78ux+BPSPQQPdT5mvwJIm4/gU9bMpyzkk5l/maToKLLruUychrIhWVLChqPGp2IvtmQsOWAQo7sk3vg5JYzWxpbfWa1eLCCaec4PqRLVEyLxXg0nFmFacfnKsH3FLbK0w/cB0YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580117; c=relaxed/simple;
	bh=0eploKnMtQbqzOfeqyk5Y9GntqbhvzIpMJaqpsK1jfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0ju87+s3MeufZVP9sRohEOUuk2PvY52s7C95hcjhiBgurU0DhyibIAi+i6NhrPWo/p4lKF/jK2MkEDGu37VC/mPx1g9BtqFLp80owt+i4khrqY0CLPdy8ogXbFOgXBExvUHKc6sWm5VwC4ThcJmpCh1+RUGUK+Rb1NmHdf1L9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KpYaQiMx; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpYaQiMx"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350faaso7741f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580083; x=1790184883; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gJUYHxCo3nb6bY06DouSUmL+wiO8MyUobMdBWXhYgS8=;
        b=KpYaQiMxfn66pN06z2rADzN00QHVnUdzmKq7KHl0b0Fk91NC2H5xhkxzAp0i2j2jUx
         MPwpYFc1CQFHMAKhTNQiA2Z538NneBRkMRIY2PZIj4iANRTISWD7WHcAgHQ+g/pNVoLX
         tIuWiZjhExOok9TVCjnxVQpNJiDapkK17aS7pcGrByv86ZqkLjzBV+3htWf7mdAIXYrs
         Y54Ex0J/sFyI6sFX2PaWC+CtDXq1BB0DzhU/gXM0T0iZ1Ne/YY648WgNg7OBMBt0oLUy
         InFI8aSwI4GXXydt6CLtLHAuR/y+j8k5XZbhgePUXDCn0qYqodHNrY6kyAnKl3S80Ohv
         WDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580083; x=1790184883;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gJUYHxCo3nb6bY06DouSUmL+wiO8MyUobMdBWXhYgS8=;
        b=FoNO+bo0N79KIrOT1h39z/HwDynkzcm0y2Paxt21h83SW0cLXHaFeKLFNqRCxwf5Ex
         AYT/loHUzACgWf95ds8BZ4igxoIOSQnlS1EMH5QDETDSblY0huX07aao8FcYhCAxJER7
         N3rhstP83OjXV6bFWwAPP8g6ZwHtpBua0PZhEDc6dmjcJqIdWj8gsrOYPM/pm6VjVTTg
         hrsGE9cKJFMNcEHHZh6PZcU4TKSqjbacH98j38lleTDaSwWN44WtVzzpFAEqj38wtmqR
         D8WjBZxSuUaBJCNFU3mBkuy5bZAv5Ld4YhBli/7Intr7dc+BPmY6L0os4SpHIvgoysaL
         xl0w==
X-Gm-Message-State: AFuF++k7kyYQcmW26jrXg7PxhL1mXhBSuQOU5GfBSeSQ6yD+LwwACzTm
	wGrHBXjuE2rp+cHnVcf9qZQKBDTm+c37eZP2xAypYpd134m4YjTKZsLFVzZw
X-Gm-Gg: AYBFou2pzWGAh/09J3oLErJt4UyfmPxoGEzDEyES7utCOzW5ScGRZKHugn06BiD26nU
	+j3V62OL3ZkQ8eR75XfmZYUfgMWwJYLXJgbfSxhte2UdbACotsdB3n0klh4L9kOQbzxWA63WG3f
	L1+/Y490g83or22pOS714bIPghqhR6AxEL4BysfGb/lXG0OXscMoamvZhJTuNOBZOfZk1cJIorF
	UaHCIOaqHfaTn13pAsrlGuHclqQ3Hnq9mkJUnkAHoY8unDbGxqmjLLmQjJm2J/2CpClqI6irBAv
	c1M71zb8SZDSn4QlUqAzrsz55+2M89vE35grzXhDzS+dilryfUT23ePUhceLeOuQDAdJz0r4Y/e
	kAv4NASnka4hVQyxge0oWEmpnI0/RoVjVfHte0YsdrKg2x68W4+cTvUVCT7jO7jCOzifOdWUiBZ
	vZCoj1DWoPFNTzQGCWRVEjwbZmUT7ULqJ+FqjFJ2HGLOlXuECRN6YZhRwSGsEwrMUX+N1cOrGyM
	W6F9ccE7vMZBRc6TbeL+KMRSghZ9AsTHEunWs9vMLq7cQ8MZ2XIQADYub4yu28tZY53eP88G4eA
	EGVDwd2b2cGCfJaPLKDso50qAA==
X-Received: by 2002:a05:6000:230f:b0:486:f97b:6412 with SMTP id ffacd0b85a97d-4870d26c82bmr4826879f8f.46.1789580083139;
        Wed, 16 Sep 2026 10:34:43 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:f23c:f0c3:c09d:d6d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm8987544f8f.20.2026.09.16.10.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:34:42 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	stable@vger.kernel.org
Subject: [PATCH ath-next v4 8/8] wifi: ath9k_htc: derive the PHY error filter bits from software state
Date: Wed, 16 Sep 2026 20:34:29 +0300
Message-ID: <20260916173429.403889-9-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_htc_calcrxfilter() reads the RX filter back from the device to
preserve the PHY error bits a spectral scan may have set. When that WMI
read times out it returns all ones, and the recalculated filter forwards
every PHY error to the host with no scan running.

Set the two bits from the spectral mode instead. A mode written to
spectral_scan_ctl now sets them at the next filter update, not only at
the trigger.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 23d1ef2407a4..1a051d23cf2a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -868,14 +868,14 @@ int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv)
  */
 u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 {
-#define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
-
 	struct ath_hw *ah = priv->ah;
 	u32 rfilt;
 
-	rfilt = (ath9k_hw_getrxfilter(ah) & RX_FILTER_PRESERVE)
-		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
-		| ATH9K_RX_FILTER_MCAST;
+	rfilt = ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST |
+		ATH9K_RX_FILTER_MCAST;
+
+	if (priv->spec_priv.spectral_mode != SPECTRAL_DISABLED)
+		rfilt |= ATH9K_RX_FILTER_PHYRADAR | ATH9K_RX_FILTER_PHYERR;
 
 	if (priv->rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
@@ -906,8 +906,6 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 
 	return rfilt;
-
-#undef RX_FILTER_PRESERVE
 }
 
 /*
-- 
2.55.0

