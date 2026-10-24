Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792820322;
	b=U9Pym4sMOEPGlPMqLKqOuKkUpJm1/IXlqPyO28YowyuritULBTgnuy8Y2SUaa5QGSzFR
	 qI8bmZo4JRXXqsY9bx/98hzB7+JNUwEpTjJ3EDd2i644EGi/jHgkCznDAHM/LtmNZfKDR
	 2rHeGQgzDyrjXhWZzyFR28LFO6K/NZ1yr5yRVPE5xhp/TiSMoSiE/x8h5O73wHtwQANOA
	 I1B1YLAfAtkuiAcgL2zo6/AssnEov2EruoKoZObxYqCphVUFTC6O2WYA8WqKDyCKyZAEp
	 VMz+uAgREbDZnvY05eEN0vMeURxwbv1gmiWxxskZiN6fe811qtvLfIWKsyqFqU1h1sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792820322;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=F5lL8gtrm76MfXFYgN7B3cAbNKJht4qocJjaadImFYQ=;
	b=JWQ+nGzc8Untqc67ai+wgbLdCxBoPV0qpXAzFqlkgk39KAjEZs6ubUXrJ9c1G6GfFPHM
	 s8qS/ShVL4fI1BO9qv6CtgfHOs0SoYNO4g82+8cA+uQcoZtLAuO/WQXklyznzYbyOaVtR
	 Llm7KkpCdelSOgY/kfeSZ3X7IwbRqLBbh1DqpNcxcdtlEpShXmoKD7iRqLgtGk/bFq90f
	 1l9FrXdexD4fQ3TL0ORp93ViPa+7Z/6wEtaaEsiTMZ8m9uyk39RBQlaB/qGMct7k5ojy4
	 ORuP+GM4BHfiXlqC+v7eppx2cgMvRR9LHwSNLmar3rfcOU4O2QF7l46cGTkDjY2n0PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QooO+VF2;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818D606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 05:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0818D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QooO+VF2
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36661f953e4so2646598eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 22:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792820321; x=1793425121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F5lL8gtrm76MfXFYgN7B3cAbNKJht4qocJjaadImFYQ=;
        b=QooO+VF2mKZF1OdkNo7N0cpLh+Cz2z527OvmXAKSPZGKrcPko69C3+MMJNjuUFo0Om
         bG0nCQv56us67iLyKSt2imskcZDzdipoTn5hb8XfCXzqBEeuYYfVM4rKBwoXZIEjK9jU
         Gt288ZX0xBYlc2mgvH/HCh4mgW7xPJenkMYQl/xO6bWsRrdH5Thqm0veAOX3MYSgIW4E
         qz6ugdHSffiOW4N4pTuXuvbmC9fIN7/AGRduAn4r8SL0Y8Ldfw3Qixyw2749opq+L2JZ
         Dh4kplGGdt4iKRP9KDd+XpP5TudYRj+OsviNl2x9CbOCfD2q6X4/KtD1R/RSfGyS82f6
         ilHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792820321; x=1793425121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F5lL8gtrm76MfXFYgN7B3cAbNKJht4qocJjaadImFYQ=;
        b=QOMZ1v8N4VZ7twzvY/RxYvQbQJupuawUBLC2SD1X0Nw54YO1sJkTH4VMCxhG36bBwa
         f3+C3cheXE6JeelY+Ire4qqrfH2WR5M80RsMM8RfBQZG9BMzBvC5k+wU99UggdrLXUQE
         LELhsbymMGDK52m/IdZUeXDZD0dSZYyTzmGPDDCXNOtxTiT/xfOxo1a2mbEd3Rfp9trZ
         Byj8/pNu2k+UShyeJQpTZapPegK+M6/mZouqrVNBLmjx5y+uyF/e2zuVJ/rck+0pk9TN
         ILE1N+u4kmLu9Z+2+Q2FLGOeKjVFMf5rxy9rWnZS4xKIBVXFAiksgmVPUzvcpb7f9vgp
         x1Zg==
X-Gm-Message-State: AFq9FYL+JvSjJx+YX0hZCbo+Cvw6/o05lQtvuH45nuYstRfrGmJEQFVd
	+FWZPcals0U1HAIY862sgNFphBrzADIpGOj9fNoV9M6a4oYwF2W0kR/42ukLxg==
X-Gm-Gg: AYBFou1hxJzExGyfK6kWH3l750f6IHiuGoF2BqRTS2MFEEwunv41T9W1oGPs+giN12B
	xAUMt21esCgeGPvJMspojVEdJ2Atbe3ZBQUkAnnBF3tuaHyAmNAHlYgwGCnGAH+BGOIo9zzfpv3
	EbEXsx+rXRaQfG+u+BV/Gxp5AruRghY7ErrSKozS3vN4iHCyg0UfFeYmAMZlfZ58zNDk1guMm22
	sBQktrKhlR+Kzu7P8VkXrFDTBsqeizqjZQseSXMDLTapllBK2O7wvNojLja14xHC7uYYLJzPV3N
	v+P+nISmjG1I+H2JwWnYooeMAKIizOJ/Hm6qMrpYrJ2XSkM8v/wlvLTfGqJ50mJjocW6STjU6y8
	Wi/moPiP+kwg0Dn+c4aWII/r8EEZJi5XgH2LH/myFimBn3UCYCBXT94ViRHT2wHCNKCwjRAptdz
	D5MqlyCB1ikVC8tJJpW207ULCiTiKfr8pOqFrdx5lBWbwTCAJpGTiEeY/mSoLobEJVnSbXF+a/D
	MH1fE95TPTTT4+9AW2sKCk5VhF06aKuPN6QE60SbsG0liUSpi+M+bygPgEd4qeiiryptqQiTut5
	4/jPEJoREwMz2RXi0riyXczlaoTshwVZCOMMWC7631TKfaAxG4ugnwtOwZPYWVqLLUU8Us7DO5J
	tO9nD3IbXBXuZF7j1c9H2UdSJHbxs
X-Received: by 2002:a05:693c:8392:10b0:35f:ef9e:f846 with SMTP id 5a478bee46e88-369e8315eeemr2176820eec.3.1792820321076;
        Fri, 23 Oct 2026 22:38:41 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ecf087sm3813684eec.27.2026.10.23.22.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 22:38:39 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ath11k: don't select ATH_COMMON
Date: Fri, 23 Oct 2026 22:38:38 -0700
Message-ID: <20261024053838.3569557-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
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

ath11k only uses the header-only spectral_common.h and testmode_i.h
from the shared ath directory and none of the symbols exported by
ath.ko, the module does not depend on it. Selecting ATH_COMMON only
builds ath.ko for nothing on systems without another Atheros driver,
so drop it, like ath12k already does.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath11k/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index 44b520d2e66e..99f625b82fe1 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -2,7 +2,6 @@
 config ATH11K
 	tristate "Qualcomm 802.11ax chipset support"
 	depends on MAC80211 && HAS_DMA
-	select ATH_COMMON
 	select QCOM_QMI_HELPERS
 	help
 	  This module adds support for Qualcomm Technologies 802.11ax family of
-- 
2.56.0

