Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714385;
	b=VutV4STJhCptNfQY9fcS6OD3jzDY2JKv0SitNUENq0reI17wQJzBpcmaEkzlko8y6kHt
	 3Ma9VQ/JnHkHYIQCSqkr8MlIt59mYGnM/H2teF5NeVMj6IPODE0rIFdStUczMt8SuSNrt
	 DuUlP3u/qCqYR6YSmdZWNY/eHE5IVfV9fCWx6eeggGYfwKqxuHGRNgGIAnueuKoh/+scz
	 m6d42bcLTy6I29IDTwq5MRmT2lIfI/7cXcgSrsGnsXGHuxC3T85zTsIqfo+2zwztylz69
	 OONngC5UzC2g7n6awLFyOIBl5G4ZEh4Bo6GTJ9XWxsDRdQVeZZiKHCGSMrto0pSf6Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714385;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=TR67u4JxnjJub76U3ECbURlUoxwJMuJHoq+jVOWi5Uc=;
	b=yuZ1ZF3T5hFT2DzDq2aDAMnl18/5zOw/OLyuvsCP+4yl069xZG+GKPeaABE9An+giy8a
	 8AvBqYOVmoqFXInqAispBoCSt5aN/NXN17e+VfJUZyBTP5uqagME+wKFHTKRfMzREURGU
	 Ttx9XEsP/bGuJcT/Hqi2jaQXUkM5f3opk5aoA5XU7pr5msbfVb81zyu05UUAFw4r+bdRs
	 rTFppO+S8xe9ky//3uheuW9wFRwZDpKs3uwPsg8RG7790Wk0FHpTX+uJknitvKXwNp7X5
	 ptYn3LRQOcwqGXn708MZHGjfXjXMIOIxGimVc5FnCVgCD4i3rOPLRivjrt9b32IGXWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=eeDjGu8i;
	arc=none smtp.remote-ip=209.85.219.98
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDFF606D81C
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DDFF606D81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=eeDjGu8i
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-91c79a9a739so63866666d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714384; x=1794319184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TR67u4JxnjJub76U3ECbURlUoxwJMuJHoq+jVOWi5Uc=;
        b=jDLlmdEeXUYKRm6L3DmGPsBQQFPbn4RGdom++9dNq0YlpWR8QO0z23umxNS9GlHcWy
         /UG7wUbtr9tAkQTqLHzb8XMgOHvPcaTHuhDVgtIjLH7HieCe7NjXT6hwO8rqYie6p5Qj
         6RzME381mHIbrCBhIvWkt0FkTLTD+XmWcUIFuvGHV9J+T4WvpQK99fpzW7y9Iyx9yVSw
         Y40wxvsMWe1ERKdy9A73bavFiUHGFSBo0Rvzii8fGf8EQLm4A0gFlVHOgq/Jjx3FirMM
         o9+/2npnilv9ylYvvqp9ctXA9Fku94FoQheTTeW/cfN/khaISEms1nfsTkY3dne6o1yc
         bodw==
X-Forwarded-Encrypted: i=1; AKwUvBySggwcxKYCjp7+MCczuQOi91mNqmd87cVb9o/mufctSZfDqsEMexX6IHmd5FYtj5zXJ/gngrIq1ZcDII1DKw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+O71gxCC9iFGc9082PnJk6jrHZxSn83yuQhXjJpxWTRNm4ilLH
	ewKVDNt0KWVWDF+2kYWhKE2wXcLADhIvcgjTs5iJx0Mczw0gJ0HrJCY5ixfy2NOCx2P69jEOp1N
	+j3eaOKNuESfKcuQpx4UgpbvWOxuObcHXD6oLUU0+oU++53cNffTEmY7Dp9P8M27rmjlGfN86s4
	Adx4LWFY8VPtjwTUMfasc3/xTuiFVj6xqD8vcBm999g71hNJs7v+xmUdEEcQOBAFlEp2am7q38y
	OrdNcGhV9yuqLRC6cWXTnpIfug2
X-Gm-Gg: AYBFou2rz1jgnADTkW1sRnoZvKo6HgAqxZel12kmPhanm62cBgljhPMYgyjWePn+AK2
	O1dsFDuFBpzf7NpFKac+/E46SEUF5qD7A3BMqkIXmkoT+ViMJEiE5/L+IHE9x/4r1Zw/XKeMPQZ
	HQuA+49cOQnzYbJxTDGH99mAHnT2t/ZbGTM2UdMBKIqjUA0OXEglmsuEbY+iJzVBgf1mfQzUdDP
	B3GMOxxyzDOcOC+GanI8NLcFE5Em00hxrHpWrKr/E034kbLPxtAB18Aw7aow3bC/UwX//f3FAZ+
	meZb6uR+XrRBiXPN808dkg71ufemyY9ouOaeLgb0XEKXj6z4xPJuPu8rio/dcW1+FTHp1N2Npoc
	q/38Zfz40VBzd1US1QhiQwAYYx7jic+mKQgEFYfABm8sYJb8/RFLvbYhFmogFn4qOqEuVhFhGyb
	Qcp4cbJLVuOcs3jq6Yv+sfOnFuYZla/bVSdTA4Hns=
X-Received: by 2002:a05:620a:2693:b0:939:3a81:326 with SMTP id af79cd13be357-944216964dcmr2077283185a.37.1793714384275;
        Tue, 03 Nov 2026 05:59:44 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9442585c6ebsm113677485a.19.2026.11.03.05.59.43
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:44 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-15c16792146so2612724c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714383; x=1794319183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TR67u4JxnjJub76U3ECbURlUoxwJMuJHoq+jVOWi5Uc=;
        b=eeDjGu8i626ywMWsC59NcSQKW2UIVjT7DC1IeTC1ssUNVkLLiCocmLBJL+KrAZ4Gx9
         9Zix8yQZjzoFgqJy3tG274SoaGz+WZkFKd3iWCDDmLkvjSVrdzKurWiu+laVs7mfZdIj
         0N0PvuMh7tHUxMhouuEw5iixQ3HpowdvAklto=
X-Forwarded-Encrypted: i=1; AKwUvBzYn6V+GHbow6IV6H6EO5eiJ5Uyn9MECPdEb7LhpTW/YUC3aAiHGZPJhYNBt6n+L/iomdQV8KWevAReShbCyw==@vger.kernel.org
X-Received: by 2002:a05:7022:ea56:10b0:176:a225:e364 with SMTP id a92af1059eb24-1ac5de547afmr19489905c88.35.1793714382831;
        Tue, 03 Nov 2026 05:59:42 -0800 (PST)
X-Received: by 2002:a05:7022:ea56:10b0:176:a225:e364 with SMTP id a92af1059eb24-1ac5de547afmr19489867c88.35.1793714382225;
        Tue, 03 Nov 2026 05:59:42 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:40 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>,
	Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 07/13] wifi: brcmfmac: Use event_msgs_ext for event masks
Date: Tue,  3 Nov 2026 14:58:52 +0100
Message-ID: <20261103135856.3676311-9-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-7-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-7-b5cbc2cde2fb@gmail.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 25 Sep 2026 23:43:42 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
>
> BCM4388 firmware rejects the legacy event_msgs query during preinit but
> supports the structured event_msgs_ext command.
>
> Probe event_msgs_ext during feature detection and initialize the event
> mask after feature flags are set. Use the extended command when
> supported and retain the legacy path otherwise.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Co-developed-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  23 ----
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  39 +++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    | 130 ++++++++++++++++++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |   1 +
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  26 +++++
>  7 files changed, 199 insertions(+), 27 deletions(-)
