Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38092C1788
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 23:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651065; cv=none; b=WUQ7nTl48pvCseWx5eeKyrEWYJTE5Up2Sv5I52Z0xP9IV0mzSqajTeHSnp3ucE64GVkA6YcE4FZBlGBVuZ6G/bFXtsmGeFDxBtUXflrG8ucBdFoFFWlgyluItB7jknG3gWIfTIynE4/mq2MsATDuWzJoPFKago+B0Qaoz6CaM1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651065; c=relaxed/simple;
	bh=1gjw1JLl6E4CZT0M7vNz4xDeXI03YlilM+CEuXg2mtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRwO3vCEFE/TzWHbHl2zg7s6dC9svo9WehdVJShAIhb9EsqT2dUqxzmFKQDIoLGnU7q/zP4t0KLBYTZhRhGbdud+c7qMWdkP9RZMMLCodM7wH7G9WODpFF5iH65jZOM9cgHDFHNyTWYzW0AxXCVaHdYB/6jVBRZRmfjiHz8KhEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gv+VUho6; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gv+VUho6"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b4a95ab94fso3333075e87.0
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 16:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788651062; x=1789255862; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7yzJKanOzKSOnMYKEyJngbZRM6LI+anOWm8IP0V+9O0=;
        b=Gv+VUho6SHSF0OTM+gpDWVPwYMPGD1WQl8zD+4nWhqzaru9wBY3NCaYkA0Hxbn5q0v
         koftgGwIU0fc8Gf+uDr7jfM3//At4lPPFQum0+3prz0XvW5yDA57ydYe4bQZrzl5vRi3
         i2KJgajJsAPW49zR597ZeRY66AFooBpgMbcXDfc2NhIHMHRxe+FTbTjpM2OWC6Q5+Xad
         Unlab/ykn/auvqrL6KTJQ0CTutrb9PvRSmaMFWwnwCrh5zATS+pT0bklxLWgcAsnNLw+
         JpjeKbLUJgMgOYPlogUwZl2sXjUm3Z4ShoxasBTcFiKPIXgVJu7tKF/ZwkKOzEhjqdox
         Kawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788651062; x=1789255862;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7yzJKanOzKSOnMYKEyJngbZRM6LI+anOWm8IP0V+9O0=;
        b=Nqbti8YbaqA18ytzg8FZ3GJekIgBRtjtrdwM9Mn63ZY2tyEnQon9mLMXrpx+zsq0yX
         /6a6YBk6PXNPr9QWpLCo64scUe2d2Gac0GApEGOEVy1dwRQXhkDWDxnrWEspKZ59sW+Y
         47rLkCO0wPKMp/r356NWK0dyM5EBbEpeiy8N5L5WMXTiaVSZMevonCk4+CHpEZj0l4mT
         c8w+P1pj6ylXOQHwSFFZhnZ4kALobkmPYidMUO7e53HkgVP0f3TpNLbtP/hnIA16Znwe
         i7+OHiPybFdQBoy32NjOEgRXc58DtG1KRuBcRpDRBqhw4EPJ4w6JpPB3Ogo/n9oRc/eB
         g8uQ==
X-Gm-Message-State: AFuF++niDpTEhu+Aa62Z+yFPBvSOB/SV+w1LNExfUEfRdwo66CBxLUCx
	jny4EHGUaakUWp4USrhxBd9pdaPNo2asGLHEYtDqgWEKObzbguMtmCMk
X-Gm-Gg: AYBFou1aWsfcr96RFYNZRcxWjZjEOKHj4/vqoR0gukWIQ2xEzuWCAZ1KHb4k6RlZsTg
	uDpUbupgJYvDYPIC9+L6iLRZAlHU1RC/Fj/YK5f4O8izlMfSX+5kJrYvocqta8MolK0pI1jW6l+
	zwUruDr7cyvHqEBK1jtyZm1802LlXEqIbFl4O/JtyX9ZHLs2vtS80BGmWfDJT3ggeuvoHbCnn0Y
	MczZ4+guNRGlpdY3uLUnOkR3WHL09W8bBMTLOkwMNUNmgw5WP5OPHs6l2n2J0v+/aNhMkNeJrlm
	Hd8bhjUWc+zzLKYgYnuYhX/wSLUNJGKyXiSULeuIVHZ8TUg03M5XzXlt2cWI8GiKrGDSWJw/eVM
	czrTDX+89wiRu5xCZdxgdGpRgOFlDYDQl0g/+c2YWkf3NvGG4HDTmckfFPLDQ79rXpmUN/XmGs7
	/P7832/CK9Ygr82In526Rke0Ejfh+JnCKuNtwFHdNC5FoKQzPmyNGNleYH4212I9nEiuAgrwIaw
	Scl5g==
X-Received: by 2002:a05:651c:510:b0:39c:a24b:f0b8 with SMTP id 38308e7fff4ca-3a372c9383bmr12639611fa.2.1788651061389;
        Sat, 05 Sep 2026 16:31:01 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.20])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a370588231sm16849751fa.22.2026.09.05.16.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 16:31:00 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: nfraprado@collabora.com,
	pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: Re: [PATCH] wifi: rtw89: Don't return default channel from disabled bands
Date: Sun,  6 Sep 2026 02:30:28 +0300
Message-ID: <20260905233031.5561-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
References: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Aug 12, 2026 at 04:36:28PM -0400, Nícolas F. R. A. Prado wrote:
> Update rtw89_get_default_chandef() to consider the available bands when
> picking the default channel.

Tested on RTL8851BE (rtw89_8851be), applied on top of wireless-next at
base-commit ca800a9302764c445de0da0e84d2252400a770ee.

This chip declares BIT(NL80211_BAND_2GHZ) in support_bands and does not
set RTW89_QUIRK_DISABLE_2GHZ, so it takes the first branch of the new
logic -- the path that has to keep behaving exactly as before. No
regression observed:

 - driver probes cleanly, firmware 0.29.41.3 loads, no WARNs and no
   backtraces in dmesg
 - both bands still enumerate in 'iw phy': 14 channels on 2.4 GHz,
   24 channels on 5 GHz
 - association and traffic verified on both bands separately, 2.4 GHz
   (channel 6) and 5 GHz (channel 36)

Tested-by: Maxim Skokov <skokovmaksimevg@gmail.com>
