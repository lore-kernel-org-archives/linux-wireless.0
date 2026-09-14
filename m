Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5736E389107
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416278; cv=none; b=s2btUWqZPIMkfSqp95gqNnh2zFFkWLkNVYQtb5Y2Jx6Ks+GOJiI0hBoF7W2BzMUq6jjQ27nfRprwRHWkTdnei+r+PUAN8k1kXrPSSwrpkXEgcVZEQlWRoZX5f/j1salKHP4EB/uH5DQKgDKCgyqYwoXQJSq56q4Rq7AVuRTEzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416278; c=relaxed/simple;
	bh=fWtIB34HF1Bz4HCg8diowbdp1Z3+dGIea1Q32YVlzI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RggqnZg3xAih9zS46SnYtY8YbzGzH3BtlVIAAe/R0/rTkFmtVsodEKYud3SfR97WbGuSjamSP+pD3hzPaQjIwGYcAiE/rNJKLTDRI2VstPO/qIgNhDLpDxq77dnNnBlt9aDjdqh0Usqf1CRxp4ZCPjTE3zXY8fjoIPefL2+261s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eTNyUvC6; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eTNyUvC6"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so21001845ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416277; x=1790021077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gPHjF43uGTlI2Z7oUAXU9OxdN/wtUZfqVEKhDlGmvvM=;
        b=prQgjDAkbO0duXMapDFveawwBsnd6dDntBW9M8lCHbjRYG44ynFRo3kZlfhLKx9ZbX
         CMgVDSTvSisL3dQBfp99+S/EU0CWam0TLEUu26QW6N/Tvz/iyeJnDmnHtHmkthlXWb8m
         dxjrw4DparUG6cOaTYpUq/Rzr34BnaUAMQUHBQs6tefJfpqI/THM2a8xN6HqslhA7u5m
         KJSsr21jbWO8O5TWhFjjtWuzbnSde9exjEWdAGOLIeQy/Gc6uXD99HWJV2oqniuH57Mk
         GA1Do6Bwos6362ngaL6RpzWiP1lncLTR3JsOtll/qGRTdgA4nFazWRU41V+HFyABcGJ2
         IOEA==
X-Gm-Message-State: AFuF++lRCWcARPUd76DHRt2KRSmVM9qM0n2yQN3LwmWADxq9FlzeWpda
	uWxOXvjh+rjtaqnbY8QR6OU28ji5GOcDA57k7jGG0yfFF/y1gMjagq7CLdhZHOVBeGhlCikQiez
	FeqqTkKmhFuHnEYRldQDhj4WKUACxlyCIiGEbP9g9ooCCaX2PLyME781EoSik9sJJsXk9SOWEFz
	o7oogwTH9b6Qinjqsi/kBqqFvh51f1FYgrPPI9eeguSyiF0/9yvJyOypuUlIMVkHnwIUwv85XTa
	wJWQHpG9vONbU2lt6apc76FOa/i
X-Gm-Gg: AYBFou2hH/WeLBJb4Qag6UHYx0yNrOP+wwBkVPKXIEs7m9WTPKfQpBygmiqh6s+rI96
	FBN3Q2L7zLYJsh4C/6fFo9Jqq4+1zy3XMuIKt5a/vEwpEi01UaWeuxoaq45jDylx6glPTzIkkOZ
	I6brsbgdMf+x5m/Z6RGSX5zKOl851w99wuImMRbI3GN1u1cmgcjXDvdb+Pw38l8YAiPkFh6qHVe
	6lE22gW+WSbgWsaFQBQ+gK+zRP0hMkTuWPohZ14DIWUcRBP3e95oRvTclFn0NOte7wNeuKoK8eO
	StZSB0um3BoZQP/HRomoK4/PfOb9OUDuBAqaKyVlDCJ4uANCe1AMFEJ7YNUJcb8dfmJGnzITRj9
	RrWDWaHJLadoKmweyEC1qH2jI/uuMhkdj8LJMQIJqrX0ayzfT5RPwvgjMSc/XwVDBhJqwlMmPDV
	kVl6LujRt70udchOi5jOJzm8de87DIepKP2+ASfPp5fw==
X-Received: by 2002:a17:902:ecc6:b0:2d6:e074:9cad with SMTP id d9443c01a7336-2dd6c5f3351mr75121815ad.6.1789416271454;
        Mon, 14 Sep 2026 13:04:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2dd2cfe26b1sm4745475ad.21.2026.09.14.13.04.30
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-67149af6070so1868947d50.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416270; x=1790021070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gPHjF43uGTlI2Z7oUAXU9OxdN/wtUZfqVEKhDlGmvvM=;
        b=eTNyUvC6yAwMF6IfCw0POC0d5aNwz4dokro/qA8H2ooqBNT9G5/dpxwssgNiIaqJfK
         HySW/ScAs9H4pPpZQcEaky06Iq0/po/UHaudjvMfmn1AmLPk2ySsUkk3CEC1nhKQ2paJ
         uMv8SS0Vkj9rJuldUvl2llaOBVoCZe2laQi8M=
X-Received: by 2002:a05:690e:d0a:b0:66c:c7f5:df48 with SMTP id 956f58d0204a3-6714dfc875emr1263164d50.1.1789416269661;
        Mon, 14 Sep 2026 13:04:29 -0700 (PDT)
X-Received: by 2002:a05:690e:d0a:b0:66c:c7f5:df48 with SMTP id 956f58d0204a3-6714dfc875emr1263144d50.1.1789416269119;
        Mon, 14 Sep 2026 13:04:29 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm103068516d6.22.2026.09.14.13.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:28 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	Carella Chen <carella.chen@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v6 2/5] wifi: brcmfmac: detect firmware FBT and OKC support
Date: Mon, 14 Sep 2026 22:04:17 +0200
Message-ID: <20260914200417.1744264-5-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911065656.1269623-3-Jason.Huang2@infineon.com>
References: <20260911065656.1269623-3-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 11 Sep 2026 14:56:53 +0800, Jason Huang wrote:
> From: Carella Chen <carella.chen@infineon.com>
> 
> Some firmware advertises Fast BSS Transition and Opportunistic Key
> Caching support through the firmware capability string. Track those
> capabilities so later roaming offload handling can be enabled only
> when firmware reports support.
> 
> Assisted-by: GitHub-Copilot-CLI:gpt-5.5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Carella Chen <carella.chen@infineon.com>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
