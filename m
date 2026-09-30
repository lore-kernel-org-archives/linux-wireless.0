Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58B440BCC8
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753229; cv=none; b=lRvlVOkPlrj6eQQsYiNQ9PdFESaDoKelmlBE6+ZgOT5wDopfHh260qR3NU9u+XjLi0J8kEEikoANMhmVtYCFyxbVNLJVRTHgceY3rXLMeyXFWxX+SsJ4uPSRLNbtgS1KncH8Y7Jc/f0mMqS/2wyh3+rPEgyGRnou2fUOZ0sXjYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753229; c=relaxed/simple;
	bh=bHLJL5B7MvFZaFWnj48RHwfjVHKRLYwyTAtbbTpBQb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxPQ+YjdXbdgXRLNQ/zi8H7bbUJWLttss54xFDASrnDWg2bSxWIMClD8VWGzJkwqWEPSjVShC4IFGRHj22NL0BFIcgrWdXzap+PnE9fMNuqiRkGlN/HoJaD9I+UAbMtVlW6LOqzE0CpLTwIHpQzCpqQkaYLApLJQGbuMWh33W2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6MIp9yy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6MIp9yy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffde3cec6so20352845e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 00:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790753226; x=1791358026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qLFV8VQJPR2EUGQBE7Yw6RyHTydVlS4Yy5dyO7hAtvE=;
        b=X6MIp9yyhRT3nGwHx/kYX/95zOAXUmKE8dTu0HLU/nM2qTBzc66/tMXyxBJTgGPMQG
         U89qSev34cPMN+jEpWgd+X6QC0qAVEymLM3tgTkQayR8F55g6m0oXMi63W314ii6OnNV
         OL0S9Pq90SxWgFxSE2O1vfOGX83JOjOcqQD7/esvlpVdNLTmjvDzMOLnxK3WU0Id7Xzj
         qwd3sadZQbJ8ZpFXvCWmwRyxCetpzFwgmTw3bacxFEsCPY4naydMXoy44HhLccyzV0Kd
         wvfOcSKEwcJOFK4EQYHe/oHu710G7kALi1QLTScHjFQFcxw2Pm2aPTOscPldNBVyV7Br
         e1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790753226; x=1791358026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qLFV8VQJPR2EUGQBE7Yw6RyHTydVlS4Yy5dyO7hAtvE=;
        b=hAY62CISWcSVMGGJCrd888eGtucVlf0Mm1042eTc0WQ2iUEAvSScFuzryX5z1dKhg9
         xWuHCC5t/zYjaNpkpszf8SbWE5uh+Hwrmh7Aof5muRs+yEpDnK9d8u0btikI6akkJn77
         Mit/I8iRpQcNmi+CSzRtZs5s04GbhQizf3Ra/bvexx1g8SSO3OwifJGOCiHAiPHRStou
         z49pQ0Q3JgvMlZxrs0yZEk8Plx0PMHTLX2GqcaGpszonV+DLVYYUjmrydNXtIvRtzmao
         nbodnoOVKf4dmd4uIu/s/gKylUd+e8ALlJrlxIVuo0zfIFJQqSP0tDmkQdnrnt8EOKlE
         YuRA==
X-Forwarded-Encrypted: i=1; AKwUvBwadkp7HwyqD4k4rd5MmfaLRibAXeFeh5OOimEtbst32QPypBG9YMVXs20HVLx4LPWg/Ykd7UJmOQdwiitA+w==@vger.kernel.org
X-Gm-Message-State: AFuF++njsKyTbdZyZU0e8I4RFCm2SALCEjpupc9sAVIHlyf6N5USnaRY
	YVH1zdFrCSnbuOuqG3s2lItbvz+eLQToghaRADXgjxNA6Csr/2b1JO3B
X-Gm-Gg: AYBFou2SWGvOtwhQcpPC6Xf4NoRz2PELMgmdoGKBcXj4kkHbOvgntBa5hiSmqteyR8I
	+tscRmgbhsvK2QmQxX4UxdW3zsWXXEOF0RdcitXxFFA3aZGKJ1qNBtuLDcYitJJOKOeM+e5uvG4
	L6wS53Fz4MQJfJLpEHbG+lY3bqIqC3rTujaflyQmyp960chkzIPlgyPRlUaQqpaZOuvRNorsauA
	iDMuAxUF6y7FD0Ev9B6eozahPe2uzgydPN6ndMFaSpBSb35uLyHXXBZmozEje04c6t+tSIeTkcN
	K0rhkhpY08Cr8mBp8Cyc+hVf2SKhcgZAihAzaRBw0Nacv9Kk82dGvKIBf41uQhfGgiUGSkitiz/
	BMoVIgtyT4BAEW5P0cC7XYjQp+5H5vldL+fKK/aEXjPvlVeJRJihieOYn/01W5pkxUjVWP34s59
	WjP4b5ZKJp/5y2JNZ+B7ujUVOZAyozMxyWTsDixoKn9CEVUkBTyZB/4e1uSsaRmEciI0Fafi9yX
	dHO
X-Received: by 2002:a05:600c:46cf:b0:49f:e4ca:e1d with SMTP id 5b1f17b1804b1-4a01b115536mr6566685e9.27.1790753225797;
        Wed, 30 Sep 2026 00:27:05 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a017504518sm32000775e9.13.2026.09.30.00.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:27:05 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next 2/2] wifi: rtw88: support channel switch in AP mode
Date: Wed, 30 Sep 2026 09:27:04 +0200
Message-ID: <20260930072704.1981414-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <bef3467b008b4bc790ae2baedc1f4625@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-09-30 Ping-Ke Shih wrote:
> No need to mention rtw89, which you have mentioned in cover letter.

Dropped in v2.

> > +       rtwvif->rtwdev = rtwdev;
>
> Move to be first statement of this function followed by a blank line.

Both this and the INIT_DELAYED_WORK() are gone in v2: the work is now a
single wiphy_delayed_work in struct rtw_dev, initialised in
rtw_core_init(), so add_interface no longer touches it and a hw restart
cannot re-init an armed work.

Best regards,
Mehmet
