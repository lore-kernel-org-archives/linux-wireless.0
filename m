Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876DF49CF5B
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416310; cv=none; b=YK+F368d+mYv27PSUp0uV/g0/y5ZCKSe5MwMnFgZepLACok70JC8Jvle7osPfNvYTmPoBarIE4xISCYhK8KwfJjrMYvdPo6MAmyUym/Y+gi3qyXB8484sT1xfHJSvn57+sFJU4g+2zEHPwgYXZreCQr/PusTblHiBrH1a6uBxCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416310; c=relaxed/simple;
	bh=AzKSoRwvTjlokWKwNtPUDkmp7fh7XU/ixZUbBOqey1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sww9erkCxzaiqGjkRbYbZGlPJaL/1JIdBfgbAgULcKaVRPoI3YbtHjJpBUWOp+KYWLRca8CqxD+tx/0XE8P8y1ekqBU6frJ2m8hcg48enPGCpZ1qzT043Jtxm2Zr+0I4z91P9+w9Lcz2AJPvIifk8Ks4ogr1Sjm7LMbIxkgzP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=W+UONO1O; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="W+UONO1O"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2d942c7cc2fso36629005ad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416309; x=1790021109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OIidc7nfo4IBJ7tzqZdeeXEx50mWtljjao4fEGgMHU8=;
        b=hZe8Z03jZYhsfCaShbdC6ukJ7VHonYx4mwD0NGLzeLis0nSA2F6pIoTXBU1DavjXK/
         CXATNGgaYiwwkwLUMu8Pmng/HnkAPTQLUO1/geFQ/PsTyfGgpMqBH/RnDLih4BDY4fNF
         tUFLtczwbwhfZkq4veS+QDdUqJUqVCyuTJPxOZQSo6gVsermly8lgYhIXl8PaxYfUlIx
         tkVRWeh48S+Ee6lo1Br619fo+K8io9T5V+XsrNNfNadPmhxZnaWxlwZaacJOdK+OQ9Hl
         9E3SPvWFp88R13Ah9VRFxIIUE71QyarHKylrG0/1EtT1Lf0xbv5709VM2gON8kRadi1o
         EBzw==
X-Gm-Message-State: AFuF++maj/dGXBLRKCmMMhFjFYyVS7zGO4kY4DKB4JYnf6eohSYIvFlN
	zW2wOKJjm8BOkiL6G8oMC12TCaBOoCKTZQebgnd13nTK8X3uQwrtmZ9vOdR8G+3xE02RectVDO/
	/3R5OTbUvgwnIeIHvp6gzlF7J5TNgK1xfdoSiLGr/Jvc4FqU1A2Q5CAHQyS0Nkva9ADMF+Gj8WX
	iYhJsVV3GKOYzcynnYt5oSsL/3ZBJleCey869MsReTTzISqINP793eQLpsb8UBXIFnTNA3kdZ17
	RB4z7lbWvIU0575sWpe8pO5vpGj
X-Gm-Gg: AYBFou1Z32biR/VzfgZpc9/dfkVaCu5cm4czTAzC717kAhesstAkY/Xkkroc+IBUNbR
	lVzZARoL4Y3TpTKxYTmY/Ngj8tKHxVgntKb3evu7MGipj/TdBYr/ZTxCZYDMI4HWVC/y8FeFJIG
	BztNPgZ3hfPOrPs1EvOuM5zAf5XOSoM8N5YbOcgFZY8U17zRjxyBZzJsms+dQKK+eZ+GlVKARCP
	aRlLMdY2e73EfeVX5gNo8njBechBoeuRhoQx7Y7csCd4DsUB31QuOzyLgsEXHfZbwErnAJJ7w/n
	VfxZFi4gc9rcrEgv7QmNf2m7MngI7kD0ljLnj1LbwJbRlZY27y2xqCYhEiveTTj+AIfdzyOqr8d
	FwuZXnHAsgYqVd1LoPY+sk3zhHinJpPPviTPSs77mY5R6xSNoMjwPnR18XhpvcU0=
X-Received: by 2002:a17:903:2b0e:b0:2db:5052:fd6f with SMTP id d9443c01a7336-2dd6c70b250mr83193065ad.17.1789416308557;
        Mon, 14 Sep 2026 13:05:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2dd2d0224adsm4989285ad.38.2026.09.14.13.05.06
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:05:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9104eedb5b0so75729006d6.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416306; x=1790021106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OIidc7nfo4IBJ7tzqZdeeXEx50mWtljjao4fEGgMHU8=;
        b=W+UONO1ORBoFXDkLQnuKDTxqTbRrwvs/wkeNmgYOHdUMx0L7GXFBEZndPXsCmMZL+a
         zcCByEUUcsW+qjgdrbnoz54fadGlE9hQ8cJ+k9WN3OGy85JLGAttUlHFammZ51pbtTo1
         lcZoD3Msp9JeFveRGAW2Xixhr3o31OEISSHcY=
X-Received: by 2002:a05:6214:5003:b0:90c:e613:4e33 with SMTP id 6a1803df08f44-9122e52e2a2mr65468096d6.23.1789416306095;
        Mon, 14 Sep 2026 13:05:06 -0700 (PDT)
X-Received: by 2002:a05:6214:5003:b0:90c:e613:4e33 with SMTP id 6a1803df08f44-9122e52e2a2mr65467406d6.23.1789416305608;
        Mon, 14 Sep 2026 13:05:05 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm103081106d6.22.2026.09.14.13.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:05:05 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Ryohei Hashimoto <laurel.medalist12@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH wireless-next v3] wifi: brcmfmac: log the firmware status when a connect fails
Date: Mon, 14 Sep 2026 22:05:02 +0200
Message-ID: <20260914200502.1747715-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913165526.4426-1-laurel.medalist12@gmail.com>
References: <20260913165526.4426-1-laurel.medalist12@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Mon, 14 Sep 2026 01:55:26 +0900, Ryohei Hashimoto wrote:
> brcmf_bss_connect_done() receives the firmware event in @e but discards it
> on the failure path.  Every failed connect is reported to cfg80211 as
> WLAN_STATUS_AUTH_TIMEOUT (16), whatever the firmware actually said, so
> userspace only ever sees:
> 
>   wlan0: CTRL-EVENT-ASSOC-REJECT bssid=00:00:00:00:00:00 status_code=16

[...]
 
> The status reported to cfg80211 is left alone; changing it would alter what
> userspace sees.
> 
> [1] https://github.com/RPi-Distro/firmware-nonfree/issues/38
> [2] https://github.com/raspberrypi/firmware/issues/1829
> 
> Assisted-by: Claude:claude-opus-5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Ryohei Hashimoto <laurel.medalist12@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
>  1 file changed, 2 insertions(+)
