Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0873BD25E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580100; cv=none; b=S7GbBCLixJ5b97/sWJuc3Yv2U0Vl0XI8rwMGG8gV1MBzAf80KHi1fI0jq/aPCN/ZXJ5dZfI7Zn7NiSOS2BpWFOh8CYt3FKBB4Y3GrGnxtB+D3akGsfQO2DpF7NTC10XIUqn++puYgBk3I9VT9eEJFmWZACb1iHAw2F5yFkWLLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580100; c=relaxed/simple;
	bh=DbTuwqjf85854fenTtyIPM+vsibM6VyN2XhXfAJ4Lkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BddUrHCh1gfVYhvZyLhFBm7mQLpto4GxXihoDAhnoLJSeSHBfhqC/PIuoOKTsqGXAHr6Dta55aU/vy2WmzCLEzCO7hkHTZA2Who3fFbireXtx1EMt497x5a0+n0gzn99EJRVP6kkMBGLKOiYGKgQzdLxhbsZd69+4LUWxcDik1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4aWH/B5; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4aWH/B5"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so6625f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580078; x=1790184878; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ROTRY7hKYrz3TsSfE8T23LGWXQ6PydcyjAIm+qUiZis=;
        b=L4aWH/B5/Ed1NWRE+Ijt3SKX0qX+rkQA5qMTLm3zhIaM+UtHEpSe5lZUzHghelX+p+
         sJHEU7FC5jxkmn2p5fsLLDIi31RPKT1BS5nx42KMvT9eWxNOnCVJY9roeAHr0snr4yk1
         8WnWsaRw6ITCIHTiPvwQr6+sdSi5e1/S3m24FOx6KjuNEoBNeCadAEefvHsRvfK8p6Ho
         8NQLqjco0oWL8GwpKQwNvjzpSIwv9y4VHDSlzvj0jVOLH10AA5MuQOxQTREkkIxYB0W2
         MTR47RUQBwNKPs+36nZ53HFDsLkRKJHbL28pTq/gu6TPI02rRaOXqQ/q9nYHYIZ7X5LB
         bXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580078; x=1790184878;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ROTRY7hKYrz3TsSfE8T23LGWXQ6PydcyjAIm+qUiZis=;
        b=yHqeSYWybNT6DxmzHfKDUk5JdkA8MjdBaQcCdRdhRpVqajxUI0+4Rl3nG86vfehcbX
         cKqvWkulcpeZdVwkonJRMDwE3O8lJ6RdG/5fdzpHCmee1NjZ75ssb/fmBde1yo5dWC8b
         rRDQmWGFQ/8w0t8SUFwF2/rajDomutKybD6a5bvpg85cRaoG5+U4mcdKYZIP/xQud3RA
         eYsoDFBCKxRNUbjZ5en8QlX3T5XcRTUaJd8RPEqg+Imwkp+pJIGfVCJSyyzGHPRwklz+
         hJnOBS31yClS9abw2D6Sxq8xTuU3RkJUTu+XkuGKAN08lXoAg9wvW+yznJhMHEBtA0LL
         ry8w==
X-Gm-Message-State: AFuF++mSxAZSt4CFAdxZAzbpZiI/1mSRxd/LUx3qPPEtGkazClui4tYV
	SKtOv+JwsjXuuaKP0Qetlk5bXSbmWnuaqVD1WG/8O5V5nbXwmePmXeU=
X-Gm-Gg: AYBFou2ivEorXFy/5wf5AhFSkR0h9vcRbkjuxGUkSFLyTulL9nvz7X0KBGqXh9/Fscr
	9GdlZIBl/cqOdrAAJB0D/OCQHBmrt7cTpLtaC8kHU28PmwToBBnaQvhb9Vorc04m3VidLjCs2Rd
	kAnMy3Yt3IJf+/Fqy5DM6tRp3aml7s5kbA8x3es/MwofpzqIXFEhdKemNtA/H6iVBq/gZF9QXsJ
	9vEI4LcnRYzc6w5klyO2MFCP/3v/6zhDoXqoAelsRf9xLfU2vh/TD/KuzMtOyQ1pZNweld/mlib
	G4u3QlGoBCRdy8Pl40ujzri8IIizyl++eTHgQhv4qYRZdarQ+cTCJyoPMqz85pD7FiqebS42rJi
	Wc7Mj4m2zewXzqaNC3otZbOzrsiZS9L3/x8tmUmorD/Xy8guuN1SBd6POpvYCW6kZUIH16c757+
	MUwVOWAfbVWMHHvNzDIsxOtQnBczFrR+Rl+SAcSmWFZYhgfvoIJ5ZVsLchC5Cl9oYk41DxAhtlA
	qf3KYPuYqdls4DJ94Aczn5Cp1conFnuSpsim1fzXZRe4Z180m4UV/7nR8i7QxA2OOFIsrrJrOM6
	vfvVAxro/DAPDvXl
X-Received: by 2002:a05:6000:41cd:b0:487:72f:fbe0 with SMTP id ffacd0b85a97d-4870d0666c3mr4743641f8f.35.1789580078373;
        Wed, 16 Sep 2026 10:34:38 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:f23c:f0c3:c09d:d6d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm8987544f8f.20.2026.09.16.10.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:34:37 -0700 (PDT)
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
Subject: [PATCH ath-next v4 4/8] wifi: ath9k: stop a failed register read from opening the RX filter
Date: Wed, 16 Sep 2026 20:34:25 +0300
Message-ID: <20260916173429.403889-5-nerijus.bendziunas@gmail.com>
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

On USB a register read is a WMI round trip and a timeout returns -1.
The spectral trigger reads AR_RX_FILTER back, ORs in the PHY error
bits and writes it, so a timed-out read stores 0xffffffff and the
device forwards every frame and PHY error to the host.

Add ath9k_hw_enable_rxfilter(), which sets the requested bits with
REG_SET_BIT() instead of reading the register from the driver, and
use it in the trigger. With firmware 1.4 and later the
read-modify-write is done by the firmware; older firmware still reads
from the host.

Fixes: e93d083f42a1 ("ath9k: add spectral scan feature")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 .../net/wireless/ath/ath9k/common-spectral.c  |  7 ++----
 drivers/net/wireless/ath/ath9k/hw.c           | 23 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index ca01a07f6630..73c1eb4ebe0e 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -716,7 +716,6 @@ void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
 				 struct ath_spec_scan_priv *spec_priv)
 {
 	struct ath_hw *ah = spec_priv->ah;
-	u32 rxfilter;
 
 	if (IS_ENABLED(CONFIG_ATH9K_TX99))
 		return;
@@ -730,10 +729,8 @@ void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
 		return;
 
 	ath_ps_ops(common)->wakeup(common);
-	rxfilter = ath9k_hw_getrxfilter(ah);
-	ath9k_hw_setrxfilter(ah, rxfilter |
-				 ATH9K_RX_FILTER_PHYRADAR |
-				 ATH9K_RX_FILTER_PHYERR);
+	ath9k_hw_enable_rxfilter(ah, ATH9K_RX_FILTER_PHYRADAR |
+				     ATH9K_RX_FILTER_PHYERR);
 
 	/* TODO: usually this should not be necessary, but for some reason
 	 * (or in some mode?) the trigger must be called after the
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e08ab73fcacb..7cafd6c5870f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2905,6 +2905,29 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 }
 EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
+/**
+ * ath9k_hw_enable_rxfilter() - set RX filter bits without a driver-side read
+ * @ah: the atheros hardware data structure
+ * @bits: ATH9K_RX_FILTER_* bits to set
+ */
+void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits)
+{
+	u32 phybits = 0;
+
+	if (bits & ATH9K_RX_FILTER_PHYRADAR)
+		phybits |= AR_PHY_ERR_RADAR;
+	if (bits & ATH9K_RX_FILTER_PHYERR)
+		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
+
+	REG_SET_BIT(ah, AR_RX_FILTER, bits);
+
+	if (phybits) {
+		REG_SET_BIT(ah, AR_PHY_ERR, phybits);
+		REG_SET_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_enable_rxfilter);
+
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
 	if (ath9k_hw_mci_is_enabled(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b942b8303d8f..f102f73a0114 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1055,6 +1055,7 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 				  struct chan_centers *centers);
 u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
+void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hw *ah);
 bool ath9k_hw_disable(struct ath_hw *ah);
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
-- 
2.55.0

