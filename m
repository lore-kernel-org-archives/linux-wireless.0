Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714351;
	b=fq+FWIlXgPSE59oW40noDXEDPZSHa6oBNLiSu8/H4R0vCWxnJKVAuXyY4MZ83190Njqu
	 nBz/DkiR+TzymRG7JlJNsR3lctK3h8biVlBV3H3WFnp87g9UcGiAZ4HNWdBBTMtE6NyrO
	 XMxgkBsVHLdCxZbeOfgsenhfhWIfEP2oba1F+4OG5EHfjYq+ma9Rlp+tewQhAsi+ejVJr
	 NMa49+L13DValCgUvVgh/LqQeT8He9QB4iQCe5rRgFLVZeI7TjbHC9uKfBolagioNQX5B
	 gxbG88yUcCy4M4odW+/tuyQPZWfu8DoUvVfi29cginT8dFk6mXwaAbo4qQ5u/l/U4wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714351;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=ccP5HEXTeJ0Y3jbzqMoy8v3yamoeB3mTuClgVh9AD5I=;
	b=z88lPEhy8omNZosmjEw2VKzGJ+jPcoUKgECzzx/cw6PLx4XXgoH/KlnUlI8NDHXhg+JD
	 9r5EeRRZE6J+Fr51e0m7ObuJuCs63fOxZenLeMmnZqgnOT3MHw4bAFtPKub6++2mpbz/H
	 wc9nq5WXAvw5/DqjhSP/4PnVqKR1ViPLpFbHHOUtoiudewvCJRIQgROVVQsJLPvR9i31G
	 vtersvUhsY1dbvkmbt8eL+DwRw6jJAdhKk2x0Zgw+LJAKf8LyXjVZHOLpfOwpaK/kWhQX
	 SPRo13GiuZ4E6p79Q4TwJwsfHUrZ1A25GIxbVIPdkmUdPwjaNKUY2LUxcjmCZ/tCZhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RMAZnIWi;
	arc=none smtp.remote-ip=209.85.222.226
Received: from mail-qk1-f226.google.com (mail-qk1-f226.google.com [209.85.222.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469CB606D808
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 469CB606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RMAZnIWi
Received: by mail-qk1-f226.google.com with SMTP id af79cd13be357-93f079a63b8so412156585a.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714350; x=1794319150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ccP5HEXTeJ0Y3jbzqMoy8v3yamoeB3mTuClgVh9AD5I=;
        b=un7LdDpuwzNwsRpBVsAhRyUDSDT+CnZQleG0xk7yiaDnA4qkOthY26+WNvN41ydKww
         UTEjeI6JPsZe//+a+sUxtUUsBCJ0xJyqFQKzm8aI7nr/QOctXsC07enX9+I5xO1dkHHu
         moKT9n67wx4Id08Ju8CAlFFCIxfSoPXI+i75VtqkpY1fLMJJ6TRQzJXbH0Zsoqfmn2mS
         I6bhfdO9dI+9S7rGkOWEVBON1ogH9uA2ew0HuH6nZ6v6FcrblU4UXCtbMPgMQE41/SA6
         L7iZt/0tpTT9deZ1jrC/a76rLIb//VtOtWy6hoS+zNmehsL1ElkbyvSvmgupCN7gCmCD
         M9sg==
X-Forwarded-Encrypted: i=1; AKwUvByguizZJFBdQF/3auQPPVGzRPBhrGccHYaswuvsVDMZ+8imwBmfIJPO+jS0hRx25Ujt4l5V/NcGyzA4wYEKvw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+NwaSHpsoGmFDqJZ2LWzDZiYRrpS2EsyjtmukFS/v6EH01VXY2
	NL+RtLcDCpKk0uxTsiCPe4+q1xA/9B0vRLYlW6JOPzFw4OdMXjf6+Kw9hBrEz8fygeSyEo7X/a6
	iSPBMK5fCLSBv9sIH9zNOcV0m7mLmUkLrrBOQzdHIdBNtEUsHephPK3SEn8vG6C51zh4rDCfUeQ
	ZVTZEO0+a7Y64A443A7yA7JAMcm0yvul4xXppZjJ3j1WGHvizY6TNxRduLR0GKb5R4kjTsQK1HA
	CEvoQOo/dV9Hve8UlxcusJ+/E5T
X-Gm-Gg: AYBFou1DuJEl5vbSLWxVltLE2hlGS3HqwNwXRV3gcCtZnsK45WeAmevlQ30PV7zT6ew
	kKwa1s8lxnvxj07tkBisZU8mXzPG9aqegu087h/JVUHf7LLpnYEq8PaUX6+Dk5VrKj5NXXsvVEW
	w+xYgSno+7G+vNio/cfGtPvkZ9G+Irg02bpZ0qNpbxnlDEiNiWlUMcd6db22qa0nk2IdEhnQDbZ
	P6DdyjptViMkV+9D9U6OuOjYgcajydk813RMRvbwGu6I3ffUUkj22mbFbE51oNlQuCE58X7dSU5
	bzcE0ZF11d7mipajSWjyBG+4P5BU1dxs8Twgcoj9stFOaw1cx8CG/abNK6exXbty781axoEzb+X
	apptK4Vbm1zvIuTsLGATUCQRzysC9SnHHDN5ZibWvX88IKFr98OmFEvx8UJ4JLtQ6WWPqatYbjU
	ZMofJigd8XyLBkKKrsETJXx9OgDHPMlQw6eHfQyyc=
X-Received: by 2002:a05:620a:608e:b0:943:fbaf:6f62 with SMTP id af79cd13be357-94421795effmr2177536385a.58.1793714350260;
        Tue, 03 Nov 2026 05:59:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-94425810d8bsm116872885a.13.2026.11.03.05.59.09
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-14373747468so5533825c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714349; x=1794319149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ccP5HEXTeJ0Y3jbzqMoy8v3yamoeB3mTuClgVh9AD5I=;
        b=RMAZnIWiFfRJoex6o5xMUANJBFWQC6wSRALcRXyo1dHHHP6MEzHp/RwWVLlWZmyxzZ
         0k61IZ0PaWLzU+C/Kk+A4B+gR/AKLjy2ycVL2IFbfNeh7liW6wF9Oi3HXq1dN+9rXYgY
         IqojDwR3yiTYQdSXrgR4s1PP+EvhdtRgkS5IE=
X-Forwarded-Encrypted: i=1; AKwUvBwbXEK42smFizOKK8SaOsZAT50NIWCmBbaA7UX32cXbWr84Ycsj4+8iT1ewvzvYrXcPECunCKxmMFKidXxwAQ==@vger.kernel.org
X-Received: by 2002:a05:701b:2702:b0:143:5cb4:30 with SMTP id a92af1059eb24-1ac5577508cmr18346095c88.3.1793714348723;
        Tue, 03 Nov 2026 05:59:08 -0800 (PST)
X-Received: by 2002:a05:701b:2702:b0:143:5cb4:30 with SMTP id a92af1059eb24-1ac5577508cmr18346046c88.3.1793714347953;
        Tue, 03 Nov 2026 05:59:07 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:07 -0800 (PST)
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
Subject: Re: [PATCH 01/13] wifi: brcmfmac: pcie: Report the detected chip ID to the bus
Date: Tue,  3 Nov 2026 14:58:45 +0100
Message-ID: <20261103135856.3676311-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-1-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-1-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:36 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
>
> The devinfo->coreid field is never assigned, so bus->chip remains zero
> and chip-specific feature checks cannot match. Assign bus->chip from
> devinfo->ci->chip, which contains the detected chip ID.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
