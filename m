Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F04A8FC7
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 17:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454890; cv=none; b=GnKtSOUdmeBo+eKxTwdSUqGTUG5T7FE0wnZ1ppZk28iulmM7r4mg1RHlR2+/ocX5DEw+4gnsT9kDYmRukyPxktO+62UN06DLeeyx73SqFaWTmRC5xQcV2x5l87yJ+04nKwDvR1Gwfo4GB4+uaySzSK7z5pEMpqRJQ2Yu2FX2gR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454890; c=relaxed/simple;
	bh=HQ9aH5rvRwQkOUzglPJfIazfP/5jmGrBk6DlWkYkdVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVAFw7M0CqDK2Jxnl5Bh0Rxt34Ol9xdpNG0lfPBwSsg524nPI9+YOs/xsNn5+8NNnSqMuzbPmgBwISghQT5cDVlD2BIeSo4bgxq7SXHOjACt/fHy0eeRa7ZxB6JJjqz3/AyIgTvB4tLoRZk1Hfo7fb+nHC3QiWShF2rWOAmoGig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PaDumkaj; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PaDumkaj"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b4ab40d839so2420322e87.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 10:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788454887; x=1789059687; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OZyw8m6+styphgut7aMHW2Tb5x1l46viCOdrvdrROu0=;
        b=PaDumkajGG/h6sWzOvDh29HTmdAQSuAB9NgnvSPDzy4ebnjuhPIBFMwlpd2s92vTOL
         pjEx5zThQ0lrJiMQU9CCiOyYPvvrl/lZdmAtB2NQ5yNWN3rBRLJXOFGkFMezyOfBHUhi
         sLYMPX1Sk8P3Rkq23uhibyUUXkzMZE1WuB8ZSFz6Bc2adcv8GXZHziIgq+Evd3aRecgc
         LsU9JDmNav/e6W4D/XZI1LFtqzSQ5ZCnwhGRgAza+/6IBdvqQTDooex/OghpEOXpwRnV
         5y5esMaMzWgIEO4uztvy8w10Dn7X7QGcfBiPGG32EOlF5c1gyP3aC+Y48M57bTSbeSS/
         gPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788454887; x=1789059687;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OZyw8m6+styphgut7aMHW2Tb5x1l46viCOdrvdrROu0=;
        b=pyxAp5G7VNBSD2qwD0ezv7GGAWU7FRpsU9Mmo0XTNrVr60ucaIFSNwea0NRIGA/+y/
         GgYKtpnkTxSOZVcKVX/GqL0pnYJRf04TiZbcDC1PrjiGMCI0nWbFA7eOZZ4U1SOClsqQ
         b6dUKWusEYARRVGK/d31OLi1sE6C9PKTI9T5XQrVwtxje8UrKWs1GmD6hvfe+GmdPux6
         0a4DGqTyjzYN7K2JBcRQJvaJxMmM8Td67yuSHJTXLTsslzXqH79Yplt9U6en/fzg+C1g
         raEc8f9AUsPLpQDZgcHG2CML3iIxUnMveJ75NMWLnYU9q21i2B/F6pllL942tnwcYJV1
         nxMQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1Q3ugBjYBHscgPN85JXvL3ktHoRLfFAgszfxh5hN5/6Vr6x6UhPF4CmjhgTOl+gjm5BU4GPrtfVmSf47jZQ==@vger.kernel.org
X-Gm-Message-State: AFuF++my0wKYeC2CkJ1LbdK7WB/XY9wL3rsmn5yWY++82HB2/7hTmocC
	tBMGcahlJEh9Ftwtt/v552W9WmHgaDDF7KJ4M75t/vrH4M3QZH+bDJQ=
X-Gm-Gg: AYBFou0Gtey+DzbFzcAr9yDcQfz+MfUJ8WMogeBo/0hUqubbf9Q31ERQ+F48LXGLNGE
	m1Dilpd7cnm5Ufw+7eFJggq4iX+OM2SsZGUwETEewp1x4dzazxF1HoArqy1zCnUgrWdEF6Qbttq
	fB2HOCyKo5BDwrEa0HBIJoxqGetroZww2xiy9WxTdN5Kx7iac5WCowhseGYtEM2FxI3rlXslbuK
	UQrWogOJArlMd6a+Zp6aNuj5+IcH7yOBrGHeuMJHs4j8EhmDPUU9Kf/s5qyN5EWs/eWrg4MlfRY
	UMLP8BBXAb3RjjytdZD8MuAUuGQg6eCC36LinPp6xL8XlQM+NvEmrlNLZLQaM8SOYE7x9bwToH4
	newDxGZD4xqpW5LYfmzQLyeDc9JHF4BmAaVZLhF+YWfZk1TGfRghCLBHWo2EX8dxW5juXyKnQtx
	gTdt60E9qI8SAFf2nD0lxNF8kL38flsTzucc2Nb6Ljmw2Nr31PeJtB3o2D+SAX5R8LXZi3lDy4X
	u3LIggmcJPueSdXY/lnHFFkT4W0/M+QvqeNYyruLMKqfcPvZ0jXoBExsBDS9QWgWrigb+iGymgL
	E+yAayS5/0jRxZQ=
X-Received: by 2002:a05:6512:3d20:b0:5b5:e53e:5710 with SMTP id 2adb3069b0e04-5b60831e808mr4109616e87.2.1788454886335;
        Thu, 03 Sep 2026 10:01:26 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b61669b215sm5563e87.11.2026.09.03.10.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 10:01:24 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wifi: ath9k_htc: derive the PHY error filter bits from software state
Date: Thu,  3 Sep 2026 20:00:49 +0300
Message-ID: <20260903170050.1089917-2-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903170050.1089917-1-nerijus.bendziunas@gmail.com>
References: <20260903170050.1089917-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_htc_calcrxfilter() reads AR_RX_FILTER back from the device to keep
the PHY error bits the spectral trigger may have set. On USB that read is
a WMI round trip, and when it times out ath9k_regread() returns -1, so
the recalculated filter turns PHY error forwarding on with no scan
running and the device streams every PHY error frame at the host until
the next recalculation. The driver already knows whether a scan is
active, so set the two bits from spec_priv instead, the way ath9k
derives its filter from software state. This drops one round trip from
every filter recalculation, and the bits now go away when the scan is
disabled rather than lingering until the next reset.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..299064a7fa49 100644
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

