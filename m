Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714380;
	b=mbjS0l5kUDviNSKAoDqfZLqImKVxh/oqvn2r1DbMrjU0gvPFdW/AzBDggHvCTHX8oVWj
	 N0sLfr1vvpJXyiWkaCV6dE9e5N0pYeKoRGDyNRYJsAwXJPSaZ5DNmgV4BebILYO77oUP5
	 GBj6pr9ylOy4+SDeBlPASqpXYjc+jufWlxz60qQqLUH3OFGuca7ZMkXz+JpqXPm12ODQE
	 fujF6dDyztLx+zr/Ud47hzMzkJbH25ruk5QTPSREsPORR5Vgojc36fUzNBs4qeRKy11lO
	 +DgHIai+Qtl8HpSmynEK1ge3XJjGN1naA8N0muDpX763H6pg4bd1fR5PESihES2wOsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714380;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=MKbHGKv5YTUZyLi0eTwdWhkz8iHCBkMeD/Uh/c0x5O8=;
	b=FzRvwwf/bYS4J/AzeVAS9gKv1GXBIVEjxYUIwgGMUK3+eSholmyaB/HQrXcPe5ljP34Q
	 AVYTJEmfHKts9bp+jwnbsXl9Ll7TT50Djd5tJgdnjp3h8aOhZHeprYPGbxCFhGHUmkLSM
	 v9VNrWBQIONKe2hKTVW7+x9x4Efwt+ElWueNPzQmCZUUUPFQZ6JsUBSgpa+QekDvW/nNo
	 +gGj6CUl9mioqhLchgm5sKonJCdIOOApfAiS+XzI6D1ohqahHYaqeHqAj9OoucoWz5t8q
	 jFdqfGzeMlWpskovgC2AcLAMFfn3vFMtKKRCxQwAmhjRay+Vv056rUINBzdGYzbYE2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=en3WPw1z;
	arc=none smtp.remote-ip=209.85.219.98
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0749C6082BD3
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0749C6082BD3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=en3WPw1z
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-91befbcad6dso72249626d6.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714379; x=1794319179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MKbHGKv5YTUZyLi0eTwdWhkz8iHCBkMeD/Uh/c0x5O8=;
        b=Fq+YmjFeds9+xGhzl5To/T6s/1BOwkWD4UZ6djyMdfLg+ksnZ0ryPH2LdM86YG2F7i
         omaok28BSPJdYZI1x8BdAKtMxMF6eLQtdkoCL4qoiVLWb63G0dqjwYbBrVV/fne9JIJd
         +9AkErfJSyqHUaSGyiu2wvygU3wkE6Gqbhy21J3c4yHhXAjcqNr1W+U64oHxIA2IBjbJ
         8c1c3Ot0fXRMiQp4N//a9nA09SfxGk/tcter5b8EAtCPt6HsJMfm07C9wiqcIuPnMFzc
         h+8F9n13OxCMqJx7JSfzjNlfQIjxD51Ps2b+FPC7Zd80GUFdtXEDWfp3eAVT01IIHaCm
         3rtQ==
X-Forwarded-Encrypted: i=1; AKwUvByhQcHcuZXy/PX1j+c9xxU3fQlypl92KaG2yft+ecZ6suejd8j8b8lUBtg4WQQRmBC10Rs23ELh4Uq2Bllmmg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/YQzi8nHG3M2kqwsyvrTTXPO/l5nAhLrgW3WNbkNz3RNR14nv3
	P1/fDpVOPz/IPZ/DJIuuv0J1+zmI117eMbfJrZehPBu1wze8dPMpc2KJ3mp1FKeN5y2CbSA4VnI
	7SRusw2vp+JSh2SOgKDl4brXRXl7/YBkucndeaHou1HY2FrS1QEgO3bkjzndapaMR93KMWmA13T
	Wx67nUkII+u3gymNo//HMu6OOXNsA4iZtD60NqFKa6tVEP3OcNf9jx5i6FyKRkmOnuQFeUtOlFe
	PsMSqKGs0H8HH2+O2mchiH9FZW1
X-Gm-Gg: AYBFou2fo51gOmSP403jEneCC9K8sv05sOhKcz6Hg7Gu8U6NOCFdIZ4GKi0NJxERBNq
	PkM5EVjgLqZc74SCGlFYp8huPRWHeAu12ep1erkbT3KxAEO9Eue9bv8yXUC341MAYK6QZkrUxt2
	Rbw7hXTzpaf+NBxf6i3uudzlik+DI9f54+ZwpV03jUCt2q9Pjj0DcA4jfPEl0xLTV7iYoyQVI2i
	Fu/rfD1mb/4rtYjDMKQZ3lbaKoeHAtySWYcHuMFtG4VQv6cFCi8YvlS2Nc3nGYOn3Dy9i1wCkJq
	mXWtQu2m571Q71SvqT4lVLJgUXmVYxNDVt8PfVaMhVbFrBtrdwGUg/6vwcWJZtGuU5NO3kFu4/y
	8KBgGNoYhc3GHPrjPGJEjCWzUPbDcWE4rixWhsBq0QJyaAyVPRFNbGtgYdpgT6ic1l9DzEiXvjk
	/OIbAMjfqtcTwk+fk4MTzTBW8WTPl1PgFZU6QrDt0=
X-Received: by 2002:a05:6214:acb:b0:917:a58b:3629 with SMTP id 6a1803df08f44-91ca4b2301fmr203225146d6.26.1793714378842;
        Tue, 03 Nov 2026 05:59:38 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-91ca7f2116csm1795286d6.14.2026.11.03.05.59.38
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:38 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1acbaf81bebso894105c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714378; x=1794319178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MKbHGKv5YTUZyLi0eTwdWhkz8iHCBkMeD/Uh/c0x5O8=;
        b=en3WPw1zyGoktCfoGeKUdzD89gWlxRJysz0phYIbTUWx4g2Da3oZ1YQOcUhKeQDr0f
         njn6IFZW+FgFdCruMIKhu2lyZl0XRfUM3K/s5+0SfM4e74IVuWRYWr1DEwfQDnWPwQXU
         wmUeeBtnboIJC1V39trJgZp4oBBTxG8xsxRq8=
X-Forwarded-Encrypted: i=1; AKwUvBx/nQb7bIxHjAbLCVWACWLTil3fFDmWEpYAF3J7kwOrejm+omYeBbipAJfNjJYB5oWc5xM8qJUcvswUBzHYQA==@vger.kernel.org
X-Received: by 2002:a05:7022:2581:b0:1a8:7b58:6f1b with SMTP id a92af1059eb24-1ac5cfe587cmr24855350c88.19.1793714377496;
        Tue, 03 Nov 2026 05:59:37 -0800 (PST)
X-Received: by 2002:a05:7022:2581:b0:1a8:7b58:6f1b with SMTP id a92af1059eb24-1ac5cfe587cmr24855289c88.19.1793714376827;
        Tue, 03 Nov 2026 05:59:36 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:36 -0800 (PST)
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
Subject: Re: [PATCH 10/13] wifi: brcmfmac: Support versioned scan parameter layouts
Date: Tue,  3 Nov 2026 14:58:51 +0100
Message-ID: <20261103135856.3676311-8-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-10-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-10-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:45 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Daniel Berlin <dberlin@dberlin.org>
>
> Newer firmware uses scan parameter layouts with version headers, wider
> scan flags, and additional fields. Requests must match the layout
> expected by firmware.
>
> Select builders for versions 1 through 4 from the scan_ver response and
> use the selected layout for both scan requests and aborts. Fall back to
> version 1 when version discovery is unavailable.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Daniel Berlin <dberlin@dberlin.org>
> Co-developed-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |   1 +
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 203 ++--------
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  17 +
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  46 ++-
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  65 ++++
>  .../broadcom/brcm80211/brcmfmac/scan_param.c       | 416 +++++++++++++++++++++
>  .../broadcom/brcm80211/brcmfmac/scan_param.h       |  13 +
>  7 files changed, 594 insertions(+), 167 deletions(-)
