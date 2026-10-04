Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB773E5595
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 09:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791107136; cv=none; b=m3A5BbVJbVQTqlZuapx55owQ9LJH+MPfTeHPr8XbBTleC9xma97QfVY0nSXZ0ma3fZcT6+m4QqgPC6CGev+KfXpbQwI5rUOk9xIbLnTEzh+FQ0F3JB8riOCT17pkFRYe1LG7Bhs60TwuMcHjia4+vKMajQIegOqIC5h1unt3dgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791107136; c=relaxed/simple;
	bh=Ag0BlF3KCDLbw6AuOgxKAn9Hp07BqMJmHxvcfpE05iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fs/xQWA80IvV+mto5v5aPXtP3bOI1lCzCADkU7SGI0NEkvDS3zCOCQTXKvDHZBuYVj2O5zq3J5aZTsLNTKTBappAqdxl/rqQNzLIsrvBRlRDQzC69qY2R5a6zFv7NI48A8NzpEqgH4Dfk9PnUyKj1z4b5QR8c1HYSbeDO/hDFH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LXQndhNJ; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LXQndhNJ"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-66c70f69d3fso472577d50.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791107127; x=1791711927;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XGGB/zmyhc8PrzLjB8k1OEa3HYhJUNYtp/EwY8fznLU=;
        b=jWZYsNJ6k8wYIvkgtQgoC+pwt+E94yAF7gV1pEZDl5MFUFn1JITDY4YvA4Rt0GK21v
         SV6JMhhAsMv8Pu/OWSGzd+6a1/0Qh3Upxp7XQXP3zoSGX7A/BcCGBR6A+0mXlCpoJadN
         KdWxWCSS1+n7M0NayH9LWKDDEAT8tPnYLaaA/LqVODzinerxssp0eGpAWZM27nnu7qey
         ZCtHQjqddHe1lhsBrBIQdPgND/wU5uwQUlViJ7kB56S01ToI5YHES5BNChGHWlyQTvTX
         nqobJuPiSIw7mlP6AfPk/ris5CFajZ/xdQ4Gi43wKtNL7w81tQ/G1Ygj8rLhtyDAX+uT
         Ncyw==
X-Gm-Message-State: AFq9FYJtK8FBemahMrL0Q/9WOAOMGEhH0GaAuwxjVePErlShQDqwvze8
	n6QR6Q+oj6n6IscJJkeigm4EPp+4NMmGff4tUFXtnAr3iAkphkZoGMHQHyhqqWg2rZkM4hK41Rm
	SDV5c01V7AL9PR5HKlksAEHs1iO85ICW6wPwRwvsoQd9jBRGPhUSsz6rvYxtl1HcyariezB40Q7
	fea5utHbtVjPltftSm4f5CCaD/Qkku6u+/An7f2RmnmwqoUadyPk8hKbZcBrLgP9zqjpZ15zGyI
	0ZDgqzZG1kvqHe7dWKjmCy0h474
X-Gm-Gg: AYBFou1ixiV0cn6C1ieHo1uYNylJaGOsV2936BOcvZ6WUgytb39GHeWzGTGlPPSd/E/
	Y1Y0sIjKXSRDVGBgGxk13feADWt7IhLL/kG4ZmvNQSdI1uFLz00hhRIkufzL69IS+qtRLbtLCer
	xsa3vk4WhPcfw9j3PZ2BNQ9tsfKEMm14RSWF5sjisWoBcHfphLLDtdMuFTX4ALkFbAsyS3Z2bRB
	oqGxGL4ibFOfivUmw5nhdsLtoHoIvLmDQEb/uwJu7AV+zNQ+kja+8nVWN3+ObHMpgGubMQzQ7kQ
	zGllrEyyDCAQgn1gq+GEX4a/b+GLatvJL1ZAMOEUX6iA/oRGLSylRY6DsUqCc3OllQ5nCtqI5xx
	dUxrqhDtjAtMtq6TR5DoRlWTY6nJYkprYbFlACtX/ZynHnjN22dM61AgjhFlo3DTUt3GX8Q6nfj
	J+7C+3DKILQQ5PTLt2UrTun2StZP0ANcM+EBSrStqGTA==
X-Received: by 2002:a05:690e:1505:b0:676:8d24:b5b2 with SMTP id 956f58d0204a3-677bd1872demr1064607d50.7.1791107126712;
        Sun, 04 Oct 2026 02:45:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-677c1947b1asm725032d50.4.2026.10.04.02.45.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 02:45:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-150efa76c57so1001060c88.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791107125; x=1791711925; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XGGB/zmyhc8PrzLjB8k1OEa3HYhJUNYtp/EwY8fznLU=;
        b=LXQndhNJCNY6y81QcFW4pryfaj1xWpO5gN6dBgVvHqJTFqR8G9trstQ5dEbKf7kL3k
         M+FV4qODUUuUOersU56gJ+6yp+50chkUgSnbzcBrTRz8P4A32n6GA+Fib9c286ScruiK
         NjJHvYPYXU+ygSfpMty5mnPFzqB7FKIee/vrA=
X-Received: by 2002:a05:7022:3b8c:b0:137:fa50:a242 with SMTP id a92af1059eb24-151c0b1ba0emr5886125c88.1.1791107125220;
        Sun, 04 Oct 2026 02:45:25 -0700 (PDT)
X-Received: by 2002:a05:7022:3b8c:b0:137:fa50:a242 with SMTP id a92af1059eb24-151c0b1ba0emr5886105c88.1.1791107124612;
        Sun, 04 Oct 2026 02:45:24 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fa74fa1csm13821366c88.1.2026.10.04.02.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:45:24 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: =?UTF-8?q?Vin=C3=ADcius=20Ramon=20Fontanela?= <vfontanela@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] wifi: brcmfmac: allow ISO3166 fallback for BCM4350
Date: Sun,  4 Oct 2026 02:45:19 -0700
Message-ID: <20261004094519.1323940-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260915174300.28363-1-vfontanela@gmail.com>
References: <20260915174300.28363-1-vfontanela@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 15 Sep 2026 14:43:00 -0300, Vinícius Ramon Fontanela wrote:
> BCM4350 devices using brcmfmac on x86/PCIe may have no platform-provided
> country code map. In that case brcmf_translate_country_code() falls back to
> ISO3166 codes only for chips accepted by
> brmcf_use_iso3166_ccode_fallback().
> 
> BCM4350 is currently missing from that list, despite the adjacent BCM4345
> and BCM4356 being present. Add BCM4350 so these devices can use the ISO3166
> country code with revision 0.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Vinícius Ramon Fontanela <vfontanela@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
>  1 file changed, 1 insertion(+)
