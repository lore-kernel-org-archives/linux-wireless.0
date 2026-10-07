Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3CB23D7C2
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 03:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791342927; cv=none; b=J/K8BpQAAewlQBvS08upNfQVBm5/I2LfWbB66xMAaFHHK9aSYpPSzqgE0KwOJT5x9Eodzml2kAdZI0Y+49IXkBWFbPTxLdNMJPlNDejLL6sNtqZ9sy+xr2NN4NnGZuYYIqgBuFWagnLhHu+zfhswal871+splmrJSyLV0EDwT5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791342927; c=relaxed/simple;
	bh=8KrDMNZ3lLoSq8KiV6wo0+UcYegtNQ3QGnSy6WjiYgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rufojGOLVTIwrTSr1ivUi8xO8mB72YHLa3cOPslMmh8d0+oN6xWyLs0e4SM0WztOSXjzp2+kT9kz2QxuOyPD8+tbLEQkwzWrdddRXEQ+x0qLSiF+DgLj9U5uBCTZiw4ZvGzdWCiLTfYA0VAvnaOvTkmzNwysBc1b3qNyF6dLTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=sM6vsbf2; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="sM6vsbf2"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e2de97b4d2so11895305ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 20:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791342925; x=1791947725; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=70ZhN2CxNGLiDnPBlxtAiGoFZYkaEoZZZjA+drHf5ns=;
        b=sM6vsbf2YWSY7oJHdszojc3HalFHc3Onl1DCIWv3kB7nIKpm0B6yBcA4f1XPu2fkW1
         tqYOCtpAOg9M86uPNoa5ARKYCtu+7sO23U44CooxJg2ieyDblSLHEZnVVpzADRqSLOs4
         F+w9t9S1p54P4EexO+yVFu/vUGTTIQ47ptU6mITKTP/opymo+7FVlksZJvz+aGJKTuyl
         vnB6Zs3IEGYtUS+fQ7AjwLUeeKt1I0Go4bjqypdrJc5lhjdlmhK94BbN5fRFZqbl5gB1
         Tem5rKnkgJNVB5XKDzH1+bDLq3/kCAVPD2ez9Qqtc0HDEhXv1o0S0nHH1Z/dqUa9SYVJ
         LEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791342925; x=1791947725;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=70ZhN2CxNGLiDnPBlxtAiGoFZYkaEoZZZjA+drHf5ns=;
        b=E0jXAqYjcxbsot3qqtbjik7AmAOYES32oPfWFmrS94sUcqsfrVmCL4U2o3x3dw4ovN
         Z6R1ai0uPpK2XP4gigiiXpG1/7sgjbn0Vd28uPY/+qEcBP58un6kDdsP+C3KAJ189w4t
         xznr1C5XkC9IT/sCDoxS5Iq7+ViLVGO3s/U1eSpIItE86YkVC5Ca346hxe98gliEvJyR
         6RILIaJDVGXwTHyfqPjVMco2kexF3pjcEcUAI+pHnGkeW58sq53N8Cnpbtb4HU1lxjlW
         YM51qRZTcGFpsSPsGsoM/JyySpYhtpogqxKcpBtoNbkFYfM+TfjV46TO4EcpGzikUGXM
         d5KA==
X-Gm-Message-State: AFq9FYKidvEW1N0CdIL2p3UhQV7m53Sa5YZYvgZSJn1EmzPIPADC96Mb
	ON496fi+7UrECLrIhLoB6kH9+wsVabDEhqlqGecu5rjrpbJo3CKbS07OSvNo6gm1s/E=
X-Gm-Gg: AYBFou1CZFXL00lXRqM0ZRNYggV7jlHMbIbqJ3CH3RO/9wBsNfw326N8AXSMYJfIvWE
	+CApA/ZM8oB9wcbGYs4pspNwB8xmot86kNlyyctUOKmhiDrsIdodq6MwfrvpnC7m8zgxt3EYFzN
	m4D5a2015SqsgsAg6Wk7Pj+6rWxBib1Fbg0PJkNzGoZRiO5fd8prlHFoQKDrn/qSWAiJrR8MIgM
	06V57yl/94oucZHimlWgsFSPqHZ1jsOaM6+uOINQWu0UgRWP2dZaBTqVGNgGa6vUSLatNormzUL
	IUc8s0u+vqtgMDDMh/YiK97FfZreh5UCt+0s8+zzxLRSjGHJoqFhsyP33ouoKRF/ZthCQcVhYMq
	INQpFIC/gR9YER0fmewKfgw4OIlyEHSwzM0+7acfhLPNGxZpj4iz/YOLHVF0tTG+/p0RFM+0lli
	6w9Yt69Fqsyp1ncIA/gqvdphU+ewnSAq79gt0QoACQx4Wry/BVnBiK9JQ0Jq/U0TnTUimDtzDqO
	gdDQ4Xr+Ik5iJUJvTgkIayPwF2KY95ypQbWwWnT+XHWyotSpDGAx4bryekMI7ey7GHT5Oc=
X-Received: by 2002:a17:902:f642:b0:2df:ab36:f15f with SMTP id d9443c01a7336-2e6005392b7mr9855325ad.43.1791342925500;
        Tue, 06 Oct 2026 20:15:25 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe224sm3753765ad.19.2026.10.06.20.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 20:15:25 -0700 (PDT)
Date: Wed, 7 Oct 2026 14:15:22 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Felix Hoffmann <f3lix.dev@gmx.de>
Cc: linux-wireless@vger.kernel.org, 
	Dan Callaghan <dan.callaghan@morsemicro.com>, Arien Judge <arien.judge@morsemicro.com>, 
	Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mm81x: validate YAPS receive framing
Message-ID: <lrsghye5vfzs5o4pljrbm2ubfcxgc3mkcpyc2sbutsq6td6qug@36liwxdx6j5i>
References: <20260910201030.85862-1-f3lix.dev@gmx.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910201030.85862-1-f3lix.dev@gmx.de>

> -	if (pkt_size == 0)
> +	if (pkt_size <= YAPS_RESERVED_PAGE_SIZE)
>  		return false;

Can we not use YAPS_DELIM_GET_PKT_SIZE instead which already accounts
for delimiter length so it's a bit easier to read?

lachlan
