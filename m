Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900023;
	b=ZFW3cph0DMvQ1VtCqtMhnTw+52L9Es6vgadYSdFIr2oSoTEHc2nwVUEjZoDYsu/mnjaN
	 Qp/yWz6l2MjOhvl6DfBXz6pr+0GDg5rL4OqlJo6LfhVkaYxrbcz/iVyS+JLdzd9kYwzT/
	 DsjpXKJxR9hlGNxdt+det6IIri5i3ULpMAQr/b/CgltviVyS4fh6uofgbXlySlfEBOt4u
	 YWo+Yv2r2M3IfEi4/4Bn7aR+3gD6WywCt0K8AG6yyxaTvg+uDTuswLRZYckU995G/unoO
	 CyHAWRDMsSxCX4s4phU6DsIsBnXqSLtfMzrZqjfMEQSI5iwjMxRWcA18t/C4Q0DEI2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900023;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:CC:Date:
	 Message-ID:In-Reply-To:References:User-Agent:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=zaFE8iTb8ZQzitBt5EqDvKEkChXKzQMc8ot83f0D0Wo=;
	b=SqQf5QPSAppy3RzexgIUcDyJdx9WYDjfkh55UHuXxdXGGXYvpVrfRAcqtRkyHRBxaGWc
	 I1yaAHrb9CXKN6OrjYLnoEL3QaPKXcvFwxC1+qplM3wvSxvabWcikld2qJO6FAo6vFHHW
	 Xg3xiFdl2iojDLr0UPxnSqvOK0y97ZYSg4ixnCIZJSLd8FuCxAuYsyXp+jXIxaC1qSGRa
	 OsXl3hYU3n4cgLCsNU6veP7EjWwcT0cvWagoUj6YiTjJMjQlx8KQYD5M85fX6j918S4w9
	 4wCwVnadmze3QE5L0PwHd0ZigpvyuE2uSJAyXnYxP0PlZ2zdWhu2DVMogi4wYKc2YAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Op+CqBud;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB729606A331
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB729606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Op+CqBud
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso908883a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:33:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900022; x=1794504822;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zaFE8iTb8ZQzitBt5EqDvKEkChXKzQMc8ot83f0D0Wo=;
        b=0+WAx2nGjlq7QuzDOEH4VQEiNddLW6YiwlG8MuNKF0pR9s1EKf8RgfDz0Xkr4wLj5/
         xKtEdzBOh6UXY6fcl4nTz+4dyJWG+uocIkiFlfbXvIYPHFH6UuVpYGZhSfu8Bxt+VwXa
         QGB2U2r5pVJYLac1DcWWvaIPcfw7nwQY4MajBYy7XA81KPa6TVqyoKlOhp+/RfF8sWGG
         e0MxbNLI/nY5xoyXi/MXju0mUXZG4HbqfyHjA8cSsj/xB2Y+5AJW34Hc1PSpQcaZ8GIy
         rmzGeeL0MI8K+rWaINITnMG+egZLGDO93FxPQ13fBQRlZhMJ/+zCBPvHGL95UrBtZ8gQ
         qXtA==
X-Gm-Message-State: APuU4Z8BK95ilMLkFGEbeBwmFAvkl2yvA2rulwZ5VT3bfxVOHZ4V/piU
	2lKTXGBn0Is1QITBrbs5xm6MzjtmPzreots13JGtFfDBD1cp1/X0kvnDl6Ep0SCk7LOvaWyPH+W
	dFjzt4xzpbxU3lBYNCyUqPEl2h4xfbxajIajsyrYwe6m5ln+pHOWCS19/W4Kd0sDIJNM1RfoAz7
	+OUcHobIu9C5M1vqEbCQl49asbXn3wRQxuWvAKuPUNLpeUJ3xjKykWWtsRGR/phfleEM6jCGV4q
	uzzRBusDlhiJ/PMV6U9gll4CA==
X-Gm-Gg: AYBFou0j8MuG7+pnGuZYf/ZkZZrPBErhlgetpbk6/CX9dRpk7OrAirVWvfH3jqZe8Ip
	bS9ZK80jjM26PbasufXmPsU1eGWDQI1ZO/owSsXiQFSaP5KlZeqjskUgXbS7+8WLxt67CcbI8n5
	gjGLtRIKomZsVvMS8+sWzOPsnFGKsCHqYoYvuXi+NtJpXPKK78ttnOAC613XW8mY01nHmGhWpso
	vsZs0Iv+OWmiuIdR5KWXCW9rsapISvp+N92q9Dh9LOx+wtsuKO3dE36I5Srer3legq8y1wtPLFb
	Idx5suTFJG0GUNkuLCOj6BsT2xLmDbexl7oIQFOUG3ADgsjTSDgoavxdHxikZ6DopdXRIjaRgD6
	wxYtL7stSpqQ65pxyhsSnWg9P7ZuKZ1szmDpEy5TIGEUXTEBE2R1IXHeawJVdbBNPjo8juuHTgL
	4u6PjfTPI1T6GKergo9+BRbuC68/c6IA3jpTs9u0E=
X-Received: by 2002:a17:90a:fa12:b0:3b0:b64e:1e34 with SMTP id 98e67ed59e1d1-3b0b64e1fa7mr2168917a91.51.1793900021894;
        Thu, 05 Nov 2026 09:33:41 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09919c5b4sm1811568a91.3.2026.11.05.09.33.41
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 09:33:41 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3adeba76cadso1728419a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793900020; x=1794504820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zaFE8iTb8ZQzitBt5EqDvKEkChXKzQMc8ot83f0D0Wo=;
        b=Op+CqBudRC2BNL/CFbVEwAY44VtofBamITEhOFo9pE1wlKliFv+N3lwbx4l3MeqCp9
         jpPNvVStIYUEtLXxjk58n2c0zpI2vcVh7GJqhuGNsaan0NU5QKgDQY4T/uHN+tD/Y0jp
         Hwow7/qkT3nSd28UK/By/dFHX88m/jsLkTzgs=
X-Received: by 2002:a17:90b:3944:b0:3ad:4a8b:c703 with SMTP id 98e67ed59e1d1-3ae896f8649mr15916791a91.19.1793900019906;
        Thu, 05 Nov 2026 09:33:39 -0800 (PST)
X-Received: by 2002:a17:90b:3944:b0:3ad:4a8b:c703 with SMTP id 98e67ed59e1d1-3ae896f8649mr15916774a91.19.1793900019449;
        Thu, 05 Nov 2026 09:33:39 -0800 (PST)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b328a04asm4597873a91.14.2026.11.05.09.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 09:33:38 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Andre Eikmeyer <dev@deq.rocks>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>, Aditya Garg <aditya.garg@linux.dev>, Yossef Osman <Yossef.Osman@proton.me>
Date: Thu, 05 Nov 2026 18:33:34 +0100
Message-ID: <1a1acc5e9b0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20261104151547.70333-2-dev@deq.rocks>
References: <20261104151547.70333-1-dev@deq.rocks>
 <20261104151547.70333-2-dev@deq.rocks>
User-Agent: AquaMail/2.8.1 (build: 200801029)
Subject: Re: [PATCH 1/7] wifi: brcmfmac: match firmware capabilities as whole words
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 4 november 2026 16:15:51 schreef Andre Eikmeyer <dev@deq.rocks>:

> brcmf_feat_firmware_capabilities() looks for each capability with
> strnstr() in the space separated reply of the "cap" iovar, so a
> capability matches inside a longer one. The Apple firmware for the
> BCM4364 lists "hp2p" but not "p2p":
>
>  ... evt_ext lpr_scan bkoff_evt hp2p rng_reseed arpoe
>
> The driver still sets BRCMF_FEAT_P2P and advertises the P2P interface
> types. wpa_supplicant then creates a P2P device, which fails because
> the firmware rejects p2p_disc and p2p_da_override with
> BCME_UNSUPPORTED:

[...]

> Fixes: ec64241c9fd2 ("brcmfmac: obtain feature info using 'cap' firmware 
> command")
> Reported-by: Aditya Garg <aditya.garg@linux.dev>
> Closes: 
> https://lore.kernel.org/all/MA0P287MB021718EE92FC809CB2BB0F82B8BD2@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM/
> Tested-by: Yossef Osman <Yossef.Osman@proton.me>
> Tested-by: Aditya Garg <aditya.garg@linux.dev>
> Signed-off-by: Andre Eikmeyer <dev@deq.rocks>

Nearly identical patch was already accepted in the 4388 support series. 
Dropping this one.

Regards,
Arend

> ---
> .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 14 ++++++++++----
> 1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> index cc19e5e7ebf..b324eb53a69 100644
> ---


