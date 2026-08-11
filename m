Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7736441D209
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 21:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786484353; cv=none; b=eYganYkRYcx/hfq93cM9YlJNLo7gxh54JBqrco5vrtsY8/VOGFDtV2pSqgjMudoHC3smxWEqKJ1W2q40NOfgmqqBUZr2KSqDAkPWjuhELv5/ovfjKZk+cXwVG0DSQDN5hkUczASIZr37lb5304gDJ8t/T3j91Od/YCHtagj55uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786484353; c=relaxed/simple;
	bh=pfwDYX8VFy478Sr2JoJKNhy3KslAV2qaL0+IxyNz0Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVEE7whtAieQzK2PbXNnXO81rpkihc2IwaQ3epeM2WC641SjkQYMauPxHrtZ69thHoqOb65KfrTt7vMtShtXXLqOgSTsTM6RoU5HAX7aMUenfOO2LPNxN6PGCeeKfCiZIC/VdBZlYe8DjzCtPhp060m9sRFkqe6/InMvajRoZIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KL3plXLM; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KL3plXLM"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a17c04563fso489674a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 14:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786484350; x=1787089150; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PrgfFfaTrFq8c1E5Q2gDfQwMd1L8fsWns2o2BnEFJGU=;
        b=KL3plXLMnkjU7HJdsCFzvY5PAnkx9nv/iI6sjzt/O/ppvgmtezGm+S7JGO8gnqQOqZ
         bhce6JR73FYC/vXhf5d+hjbGBehn+QyvUQ8yC/hV9HQoGDLjTJXgE4qujh4/9f3JzNTW
         ILF+jQTz2nEVRBPwJCKroTSsiepk8iGADOc/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786484350; x=1787089150;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PrgfFfaTrFq8c1E5Q2gDfQwMd1L8fsWns2o2BnEFJGU=;
        b=g+YNPyyCgpc3S6RJ0TkO7J/4+8cpU58OGPHs0WOj2xTMjNPqVlWIUJaa5EZ27Qv5p9
         8mRMfioplwGbX8LGGeve5qoW93Z3l8ttT5iENKTvIKxvs/TiNmx0ZDf+X+K7nHFVpBVB
         xWtd9wRGt+8KOSD9rhY0T3sq5IAs2I84J1accrbKizlVoDxqJ/cTec8N0tcQZcp9V5tx
         fydsI/KKs2JwKsX1RQuK1sdUCojr3DfwplOnHUQ6qpy5uzwKm3VzEtBJcyF+okClI60N
         nYRwcyKBthfPa4pVU/53m4QX0zK+ngDCN559aVoeYM4rc/ivwM9wndYaHSrdlAReF9Q4
         Cr8w==
X-Forwarded-Encrypted: i=1; AHgh+RroNJkyCY0IFDo+4Moo5BGraEG0Q45GUuI+ydb6I6XVZh7xBucif/VAaQW8sC4SWWFrNW3+I0Vu4j1YHgCJIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGhVM3OcSi6yuf18u8aKDOkPZp6gOA631IkfDcA7/WaVxfHZJN
	rCWb/ADTncTQqQny4KHFUUy+kX8YS3vCkph/s13tjMtJ5IEqf+7yNhcv/x5MjTUV6w==
X-Gm-Gg: AR+sD13uzrJJV6JWJV3b5p6J2Nwqq0g60pilOpqmCrcir6NWToHhVV7s7z41+70nkC1
	hjDTVFT+UftRbh1eo1WU6EAgF+JVSxpOJGEJH9+m8BDWkxepGXrhSX5Mo5kMPlov+RjeF7puggh
	oY/D8GNC/w1P5sgafRxn7vk1h0xEJ18foEM4Abg85NJyRAJrspeLFqUmghUySry14F2PphzKAVA
	5Ds5Yr+xBg4UZIAc0ZPYlDoAhmeQvTaytCKWfJJ6h2TDb81HJgKPvZkh9N98d2Er7EZPVBUClOy
	Ui4XDdWUICQk2oxiFs96h8QdK3+bVYfaNP6UfwSP8aMNxngZ6AZyaETKxNMwK7rKhmUbjWCndjq
	5MP5IKe+1Hcq5fCVCJsbZdadLZtiW+461xe3AkLXlYsBEdez9YlWZpa3xJ0cPWIG2QJWrIV/cXd
	cGYgeH1fM6WtK6U2XDjV4FEsMmBI7ztySeerl9luqUrZbF9IylOBqRVEOjrTLPLwuV5AAvw5J6d
	sYthFhvS+uGt6WXCLgVdJOSXeadsTE/pmAraA==
X-Received: by 2002:a05:6402:320e:b0:6a1:28d8:2306 with SMTP id 4fb4d7f45d1cf-6a36446fc31mr3285128a12.1.1786484349756;
        Tue, 11 Aug 2026 14:39:09 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:79fa:d268:80cb:4947])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6a362e3adc2sm1042864a12.13.2026.08.11.14.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 14:39:08 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:39:05 -0700
From: Brian Norris <briannorris@chromium.org>
To: david.laight.linux@gmail.com
Cc: Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH net-next] drivers/net/wireless/marvell/mwifiex/sdio: Use
 strscpy() to copy strings into arrays
Message-ID: <anuWeccD8vRRbX8k@google.com>
References: <20260608095523.2606-3-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608095523.2606-3-david.laight.linux@gmail.com>

This isn't how driver patch subjects should be formed. It should be:

  wifi: mwifiex: ...

On Mon, Jun 08, 2026 at 10:54:47AM +0100, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> Replacing strcpy() with strscpy() ensures that overflow of the target
> buffer cannot happen.
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>

Acked-by: Brian Norris <briannorris@chromium.org>
