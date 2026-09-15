Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB7040681D
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 17:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494443; cv=none; b=R2oFmpasJAiaYiiSUkxDlR5Cdjti6X3hy+wOL5cStP/rHFPKcRnXSjgct6cC/sruyAv/fn89HjMxcI4cy5jTAftPk5zFWvtYA6+2CXkNllhATflMcUThdiZE5OppQVPhYSzTtseenlpggfaLURtr2uw8TYdNtRqIlzis+XbmhBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494443; c=relaxed/simple;
	bh=I4KI1aweFFig+SZlrBdaO4mP05yecfWNr+LbmApZG/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qi2/FjfgHtz/J6EVB/mBBdDz+XW7dUs9RYIh4snPS3qgzoqnjQirnFdJXiLWthWcKwwtSHgXcTrvi6M6bpILyLrOGxPxKcspTt8TvbPBhFUsSyZngTdvMnmXy+YcGnkOB3gDJ7U8ohmybuMXCj6DWO3h6+Uv/S3guL/mWgw1/iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VuyRU6W9; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuyRU6W9"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so62873a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 10:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789494441; x=1790099241; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XpMG1qjPop6FoZkaj0fsmzVch6Tcbe08TjxPfHV5ihU=;
        b=VuyRU6W9oOA+cxiJDl42MTH1xUnI6/pGuJTc/7yCd+32RPftTniZ37WbA82nFLYnGd
         LcClt4N1I1OyPZeW5VvswOi31an/84YXfxG639UOpErSo6huHLPVEJW8kg5RJH9/Y49H
         fhNtLTMWD4CfYiZGofN9HIB2bIyAohKpMdREyNj+wvApzucCVnvsbYEmGtcBzmpa2atu
         5/Ztfx87nW07cO4hL8pj5TIUQsXqmRLpQCMBdLPRNym2GJCoPMX5jB1TL9biVLJau+EB
         NobpRUYFwfv7DkaUprxS75ktWb+r/yqQlyxUPrYeKET3rIkfHsBkdwhhQVWuyFgVt/hL
         E7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789494441; x=1790099241;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XpMG1qjPop6FoZkaj0fsmzVch6Tcbe08TjxPfHV5ihU=;
        b=AaOgLcbfwHBJBmxE479sMCok/nmjauaWuB6eDAw3f2c+l0g9CgsgPYl/j/hZ4FKPr5
         oxAEq2HgvFoNPAsgN68iJrUA0WJQfL2UPyIJpttLysiP/x63zMlZoZ317/LBlbh929lS
         Es/sSbjrlelWIwsi1Lvu23VhIywwB2i2xa3VuGcq6OeWCk+SbfUTtXbBWTz1/baq7+dX
         sQ9bhOJWf6XQX3nSKKtqRF4R7YmhnSBcdufBCbXAUZCa1TFRRtKNUpgE+oXRMnKnHz04
         0PFLqr7jmJbJGtiyLrQQ+gy/IJu1vS8uOGc2D4OcdWPdGZ6V9WZWpLjzTc8HV7kiXx73
         Xuvg==
X-Gm-Message-State: AFuF++lRvJk5X4SEhoVuIjhjzcBzV/G18k0IAedlpKmeIwq4gzfoNamS
	22Y4qFXMe9q7ooejQvHZG7ZAv82kswigwYxcoD4CvDQZcYlvuF2B2/en27dPX+PNi4bS6rG/
X-Gm-Gg: AYBFou2lBJrrl8brX/nCHvc8cepA8h7oplFHYXZOmgSdkv1xRpMiwNH7uv43HEZsyJR
	93cOWAQaryiO+DAa6yCxpY9Qn+AXrv55+JBqBQc6PmJi2fRnljMp4Ia0IU7lBxisFSsKHwk5TSp
	h7jraHy2dd1LdZLeQYbYd6IDaocn16vHi966Z2knARxb3XCNkmPXh6pGbXnLZnfM4qNrazGBEYL
	AXTiWmw+SuD4L9xcYwnZ58BG4hTIaAErFyy2/C8Xn2kWC5IRCX9SmQVMvrzjjzYB0+BORCn2blZ
	4YXszgtl1DYRTpQds999P2rSBJI6ah5j2tZyt3YHrjvQNg/iDlq7dO9x0/wEiHqvdh8wl4blDC/
	+D92ErYh7f5oxvoOENzuSe9Bp5k4/2ipExOa4IpUlqCxfQp05BboSjjfDS0TgrVW/RsQzCtcvmj
	XAk9ir8o1hsfrOa7NBHlrKsVcMO1+MiejSuqASca21goZ/QCICMt0w8ZbQpakBPW4Q3AHqV8JnK
	F2HZTF2TotijDS2IwQVXV31qwXUyYOOPQ==
X-Received: by 2002:a05:6a20:6a11:b0:3d0:ba81:79b1 with SMTP id adf61e73a8af0-3db400361e3mr16492369637.0.1789494440774;
        Tue, 15 Sep 2026 10:47:20 -0700 (PDT)
Received: from macpro17.tail61d16e.ts.net ([2804:14c:7bd0:701b:a9d3:4f15:11fc:30f5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5aca3fbsm545337eec.20.2026.09.15.10.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 10:47:20 -0700 (PDT)
From: =?UTF-8?q?Vin=C3=ADcius=20Ramon=20Fontanela?= <vfontanela@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	=?UTF-8?q?Vin=C3=ADcius=20Ramon=20Fontanela?= <vfontanela@gmail.com>
Subject: [PATCH v2] wifi: brcmfmac: allow ISO3166 fallback for BCM4350
Date: Tue, 15 Sep 2026 14:43:00 -0300
Message-ID: <20260915174300.28363-1-vfontanela@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914200357.1743468-1-arend.vanspriel@broadcom.com>
References: <20260914200357.1743468-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

BCM4350 devices using brcmfmac on x86/PCIe may have no platform-provided
country code map. In that case brcmf_translate_country_code() falls back to
ISO3166 codes only for chips accepted by
brmcf_use_iso3166_ccode_fallback().

BCM4350 is currently missing from that list, despite the adjacent BCM4345
and BCM4356 being present. Add BCM4350 so these devices can use the ISO3166
country code with revision 0.

Signed-off-by: Vinícius Ramon Fontanela <vfontanela@gmail.com>
---
v2: resend using git send-email to avoid line wrapping/corruption in v1.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 9d8ce7bb0..2b819dbe6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -8076,6 +8076,7 @@ static bool brmcf_use_iso3166_ccode_fallback(struct brcmf_pub *drvr)
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43430_CHIP_ID:
 	case BRCM_CC_4345_CHIP_ID:
+	case BRCM_CC_4350_CHIP_ID:
 	case BRCM_CC_4356_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
 		return true;
-- 
2.55.0
