Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC959389107
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416234; cv=none; b=phMG8mzTBkDS/I/DND+9pcHOJE55p00I3JyLz46Otg7agDcyVoe3CJnEwXCODt5+BN6folgKoxfsEyME8V+w7GdHYsa/xJ1fxcDVPDBLUXGG8Vg5JKYMXL2FJD+viuSS4uiIqTFRvkPtwTkCCJQpMZqFgxjrmzPQaxJ6Wp21odo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416234; c=relaxed/simple;
	bh=WLlK9vA+L8oxHFesUqYqdLRnT+52G2hRnMZGKPaGcEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcqEDT1x5qknFDT5x6ZIsnc2uZXgWhcuFfim4FXEE2EI06sE/SvdASJkJ7LrJczuZUHQzEsa7bp1ZSc8BrfFKerZTP50kaTZDL9UvH8sykIcVkjOD9KEV+CxwSZR80uxmPnJCAjHShvOytnNzqqhxPJ0Ok6nhPTYBGBonqLi8/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aIahCWFM; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aIahCWFM"
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-93a1d527d11so50766685a.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:03:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416232; x=1790021032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C/Rp3IqEWYKaSCV7MCT7ZQkcorp3p2cAmZSJQ5iTWXU=;
        b=PDigwPCqdVVpS7JHiZwwZ9f3pHA5mCu+7YuorLuUr/02m8AthXBdEG2CKxXsSy4bHg
         hnuTkmQYpisQ7xJFmG0qLC7xyfOd1EOmKjVuIByL9Y/jP7pc2RM4GJxVtSzDZOnvf9rl
         wIxv5OaR8E5ZJGy4T1afRQTJllL8a8akZlBgALn2LH5pKahAQjLBRxXOBU2t9eDJ8OIh
         GqJQjFORPl4YHNUNwLhWsXKrg2ESG7oSzB/0pjl/hOLhqp8c0J7GZnogrx+8DVDVMZN+
         sdYOTpPoV79tuftRJPhQcPTKoqZF7hp7g88h8feEI1QxkvVZptjfSjZ0Xi/uvgQ0+5KK
         Gy/A==
X-Gm-Message-State: AFuF++mt6nqjhg3M3i5Ncm7xbvAMUs1KyIO1FgHfCDHxy3j+9CraUxIL
	IIp9xT2aOj96Bt5AiXtYiNeZm8yZljAm5uvgVVJAy1lCC+xQIUFofF0LY5bl5hNCKLW6s0HviA9
	NcfEdYU7IywG45w+lxewQYjTVwwWIQCmMvCBzLLqA2g9hQwx1qoZhrZKSa36sN2pTapru5YN5u8
	mPFEIMuA9Cew3CFnA0hcG+Jw0J4Dx5YzL7a2w2sG+iNmzpDPlHZwWWDCqTanS6FRquVaNLdPiP0
	WSE5d9aykreQf9qtXpXnAOUWLcj
X-Gm-Gg: AYBFou3lKMq+/MpIRPTP1fWKwivnraerwwlDOQwWtD3UNgvdxLK/JbGVC8m2LTy4yxZ
	jsPMi7nf9xzpOVy2jQE3p+v5iHNL27WKxTtL153x6a5gCtmYqnHoJ1YkRwIJ74FyxkLJlxedS8t
	VOMsb+Ueu6ETKpwvx+cb26z8JO3Oh2wqo3Dd2rOvNNTcz19IbENWvKBJo75beMSYwjkLSV+Jd4q
	Iqyi/rPQUpeg+tGFe7SGr1kXp4vT9pkWQfYZttBwHtGAnoyGXX/nU29vgbvv1gmJhsW8yZzSkbw
	tKF6DxIYlXWIdD/lXFnGf6semK1PMge+gdT8iDywIu5LmQgcOYLw0YF7zSGJ7TwNWV0UMF+TeBz
	mLSmairvnuOT0RNWVVxrllW0Uh8IwFVKSAmcUCuljUbmOCoYa+cehKrLyho+W+o3PyN6LYuY5QS
	otyUCSqK34Eo6G5NNJD5HOubHjtxfR0RAqGR+7p8E=
X-Received: by 2002:a05:620a:43a1:b0:939:a834:98f2 with SMTP id af79cd13be357-93a2985b776mr567461985a.15.1789416231565;
        Mon, 14 Sep 2026 13:03:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-939e8243298sm109412585a.3.2026.09.14.13.03.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:03:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-671217c949cso6160470d50.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416231; x=1790021031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/Rp3IqEWYKaSCV7MCT7ZQkcorp3p2cAmZSJQ5iTWXU=;
        b=aIahCWFM9gz8G1DXQxoOooKf56NQPuZ1P90uXOFJpj+BZGt8rrMexcCtV5YqeBnYKl
         jYa6Itdnq8Dtl0fiU5omjVzdGU9SUzlr8kd3suOdlt02nSd6IbysQnBkcUCb8KQXRYWk
         I8bOr+f9CMOCoLlf8yv+tErhoPDuJa2ZKVRfg=
X-Received: by 2002:a53:9004:0:b0:66f:c467:f786 with SMTP id 956f58d0204a3-6714e1a4145mr898114d50.100.1789416230600;
        Mon, 14 Sep 2026 13:03:50 -0700 (PDT)
X-Received: by 2002:a53:9004:0:b0:66f:c467:f786 with SMTP id 956f58d0204a3-6714e1a4145mr898104d50.100.1789416230127;
        Mon, 14 Sep 2026 13:03:50 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f202856sm103059276d6.2.2026.09.14.13.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:03:49 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Girish Rudrappa <girishbukkasagara.rudrappa@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	johannes.berg@intel.com,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	bogdan.nicolae@gmail.com,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH] wifi: brcmfmac: Set extsae_pwe parameter to Infineon firmware in SAP mode
Date: Mon, 14 Sep 2026 22:03:46 +0200
Message-ID: <20260914200347.1743016-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831061213.240270-1-girishbukkasagara.rudrappa@infineon.com>
References: <20260831061213.240270-1-girishbukkasagara.rudrappa@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Mon, 31 Aug 2026 06:12:13 +0000, Girish Rudrappa wrote:
> Parse and configure the extsae_pwe according to the information from the
> supported rate/extended support rate and RSNX IE
> 
> Parse the beacon IEs on start_ap() and set the extsae_pwe iovar.
> Set sae_pwe to 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> membership selector is present, 0 otherwise.
> 
> The changes are tested with FW Version 7.45.286

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Girish Rudrappa <girishbukkasagara.rudrappa@infineon.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 77 +++++++++++++++++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c |  6 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h    | 11 +++
>  3 files changed, 94 insertions(+)
