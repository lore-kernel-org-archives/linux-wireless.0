Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CC54D955C
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 17:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580088; cv=none; b=lTogtGU745UZ+nC5/f97tZCmrz3NJDaSR9abcLTUg1N9U189oa349LTkmqhm/0BWbJ7ThOLQiMh6ADcjVD5+69i7FzNYhpLBa+FRytrpNASoUW7d7wQeCs38R/1gAe49OUVxXGIzVQdJBy3DNBetIDMDLQu5XpTaOhcWk5c8zho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580088; c=relaxed/simple;
	bh=ghaLQhsjErRuw7z0EbmTWSMQtRPaLPRGjjmIhiMeksM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTsnHY/cBN4QX+4AK1v4+0yCGIF1GSwRzeLpAbLMv8EDjDQo2OJSAij0LSs24u4gqdpZbS2Reah3n88DTw6v7CExU0w9XKY8WWCAMSnu7+NwRt2hVocfHa60Q8CN6yMB/8AHEn/jxDCBYUW2KOWIe/+XZAbDXLBpXEgBKviGYGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YvGRz5r4; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YvGRz5r4"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c5so864491f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580080; x=1790184880; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=w65kxI0NVO+6JXj4YPaYmqJGny/IamxZxDoeb93T3ro=;
        b=YvGRz5r4skKFjGn+VPbLzIIJHKluXbJn8oeVovguT6l160/YI+S372+BL1ZWluNCsF
         Dl8Jn0Z/NQV/Fd7hMnuoGfy7rNi2ueoZWk67NTGajFxa/ZuPBzKysCuavDA6jANDdy9g
         YzfflkCnIKQ8FW0byjMQCHTRW/BoVXv8/7npmyEyeSxM1nidHa//ploxa3U2Y4hJmkno
         TCK+B1r9sxmFvhjvuQwtH3vGTQPDdyet0ClQlTZjEbMcli+XmRdy+rs1PVXRMl8/7MSl
         hkIo0saWuTfLWejxjAgWRV5PakFPQ10Im3CxPJSZ3/ILN/GkXFIjhnJzwP8telP6V4Ke
         5HBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580080; x=1790184880;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w65kxI0NVO+6JXj4YPaYmqJGny/IamxZxDoeb93T3ro=;
        b=0Pd4saBISgfCm3c02yltLToMNmLf3Zg3FDcueTtnPuC1lA4RFVviht3wUX0JK6K0iq
         nqxwgiB8YxX+N52PHpFOfur4EPebvAt2smcp5Jkt7q5bmhykn7DCmHCRMuDV+hVnHgSk
         Z4isSSt27lAegoi3eeBVKtr9wVEbUWeJAUi7EtpNyGxf8MNqvHBXS69KEHuQEKjaxahr
         U57lX0uyMN11kX8ysJcKxEter/32xMD49HMHnTGN689bVMlZ9G4tU2GPmtktYnshhKxe
         bZfITBu+mMpudC9/K2rhx4T4gmRxwgk2qbbBg8xo5MyN7PRpu0te1zWWfkLcZf/P70cZ
         IIYw==
X-Gm-Message-State: AFuF++kfa1/4pJZszj68yYwNxUpraEVwYc/agul8ay72N+8vFUz5/9DA
	eNZP0Ut1y/gkayOQ1qLWWE0PXGmumprhcv3JDtysCVljMSDnTS42Xy8VElOW
X-Gm-Gg: AYBFou2Bt7KD0AdMwKT7r0Wqyi2vMUc7uL4h8La7ZtdbeIAaVJy3TY4pbNJF7+6zSFS
	criGNRfQW2TUaYAw/AeuJ5FARTcneLp5kPVmWMKO5ENayiKyYmLkhwlwisUnKAX1Uatarnl1kTW
	wmGsbCzxyHKe68D/IqyrIgO1jkGp/s+tHum9wiOIxqlhtOD5KiVuZLnKqGulzNXrNQq45yHQZiN
	NuhA0UesEKORnWKLqr0nlaz23hl+h42W9NMUaN8G4SDAHB+cfHlsdmaBNoDGepDn1n2JQYhF8Wy
	i5ykeiB8dyGbwxh4lqWljJsmR1N4FdypsD78ozGsBmma09wQnb2JX8+LE4m8BFkWp8Y2WdjXDUz
	nbAQEdeK8SAGWAHH7OOVwjDQzWeNrFJMYSyVoErYCiFsK/mdSPcnQi2N8KpEu5K10jEq3YHUozU
	GacGWrLkauTQGhp7KS54JWKSH+Sco5vTyf5ayxqpz1+8OzqQUoT0TW5+CfmHgPJVyi11IeLA6hm
	MXj7E+vT1okz0kku2ZYTKvm8UydX5/fA0zTUUmK9Kse495p372iod/PPs9dN73VscV1FL7y6cU3
	NvhWVhyhfWgl1QpB
X-Received: by 2002:a05:6000:4b1c:b0:487:c99:8bec with SMTP id ffacd0b85a97d-4870cf0a430mr4310836f8f.3.1789580079562;
        Wed, 16 Sep 2026 10:34:39 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:f23c:f0c3:c09d:d6d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm8987544f8f.20.2026.09.16.10.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:34:39 -0700 (PDT)
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
Subject: [PATCH ath-next v4 5/8] wifi: ath9k: clear the PHY error filter when a spectral scan is disabled
Date: Wed, 16 Sep 2026 20:34:26 +0300
Message-ID: <20260916173429.403889-6-nerijus.bendziunas@gmail.com>
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

Triggering a spectral scan sets the PHY error bits in AR_RX_FILTER and
AR_PHY_ERR and sets AR_RXCFG_ZLFDMA; disabling it clears none of them.
ath9k_htc carries the hardware bits into every later filter update, so
an idle device keeps forwarding every PHY error as a zero-length frame.

Clear all three when the scan is disabled, unless radar detection is
enabled and needs the same bits. AR_RXCFG_ZLFDMA must go too, or the
frames keep coming.

Fixes: e93d083f42a1 ("ath9k: add spectral scan feature")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 .../net/wireless/ath/ath9k/common-spectral.c  |  5 ++++
 drivers/net/wireless/ath/ath9k/hw.c           | 23 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 73c1eb4ebe0e..24000d5b2a6f 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -776,6 +776,11 @@ int ath9k_cmn_spectral_scan_config(struct ath_common *common,
 
 	ath_ps_ops(common)->wakeup(common);
 	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
+
+	if (spectral_mode == SPECTRAL_DISABLED &&
+	    !common->hw->conf.radar_enabled)
+		ath9k_hw_disable_rxfilter(ah, ATH9K_RX_FILTER_PHYRADAR |
+					      ATH9K_RX_FILTER_PHYERR);
 	ath_ps_ops(common)->restore(common);
 
 	spec_priv->spectral_mode = spectral_mode;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7cafd6c5870f..b8f3a8afaeb3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2928,6 +2928,29 @@ void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits)
 }
 EXPORT_SYMBOL(ath9k_hw_enable_rxfilter);
 
+/**
+ * ath9k_hw_disable_rxfilter() - clear RX filter bits without a driver-side read
+ * @ah: the atheros hardware data structure
+ * @bits: ATH9K_RX_FILTER_* bits to clear
+ */
+void ath9k_hw_disable_rxfilter(struct ath_hw *ah, u32 bits)
+{
+	u32 phybits = 0;
+
+	if (bits & ATH9K_RX_FILTER_PHYRADAR)
+		phybits |= AR_PHY_ERR_RADAR;
+	if (bits & ATH9K_RX_FILTER_PHYERR)
+		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
+
+	REG_CLR_BIT(ah, AR_RX_FILTER, bits);
+
+	if (phybits) {
+		REG_CLR_BIT(ah, AR_PHY_ERR, phybits);
+		REG_CLR_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_disable_rxfilter);
+
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
 	if (ath9k_hw_mci_is_enabled(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f102f73a0114..983146208f26 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1056,6 +1056,7 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
 void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits);
+void ath9k_hw_disable_rxfilter(struct ath_hw *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hw *ah);
 bool ath9k_hw_disable(struct ath_hw *ah);
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
-- 
2.55.0

