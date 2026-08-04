Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3533392C48
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 05:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785821315; cv=none; b=u8ldHyCn255fLU+ophbCnQSkKmi9NvSlwdVHQrOMl9B8pn+XJuoYGE6jp+FHGSoapQN4mQzn4EUrKYE7D2ZfHJTKaL/KZ7e4IN/n8faV+hFL/pePnd2aUHzFYuKjsnuuHtMuV7tbtr/vdDLp/seW9xVSm0qCMsma4BSLV7y8xwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785821315; c=relaxed/simple;
	bh=xLmovQy6eqBUDiJqbaKqkjv8/lbGY1eloaLsznaMOxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kM2vdl7NMwbT5UvOdERgyTJ1ebZw3O/PnU9YcRQCJNLsXQYEtH2yUqqjQkMUrbp87o/N0yKHVKZwolgMAX2AWo0znOvfSNDDTKp5MAd6F4ha6ZOpZk+DkC/kW0DH5GD3i2TqUVvBs/VUuN0l2fFWU2pEvY3fRh7EDAFItni1brE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=ITBriL64; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="ITBriL64"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e3617ba36so4247962a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 22:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1785821312; x=1786426112; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tsAKhlaIH0uKdSxeDJ3Kz8LaG6giInRmw0bCqkHDsjY=;
        b=ITBriL643J49JfWgt7JfcnWKQZJNucnUnxUak6agv7c+eyJEOS/2JtEmzyarsqL3nn
         QVcH1O4hlhsfbHlOXXRJBUMcVi+mPtr5yfUSmGZ7LWnMsrAGlI+XUnpTwA9aZBC7HYSW
         1S6k72p7IC/bAFnzOArDNGn1onktDPOa/6Nwf0BzwFUTWBNDaYJbLo+n9q5gR5cVsmO0
         8U+ohO5XwiQap+RWc1Wclxcc8/UG7HKG0jEm10qFRiuKRuKxbNOQHR29V3VYb81lpNox
         OVoWzo3nbeG093t5rnF88z+aHcrbRXtIwsD4krk5R1gP6GU/nnl7znPbxi3OHnJxphCE
         B9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785821312; x=1786426112;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tsAKhlaIH0uKdSxeDJ3Kz8LaG6giInRmw0bCqkHDsjY=;
        b=Wgxgt/f7v848d3+jlXaBSvSChRw41XuJlcZMTfyhFRwN1yKd1npgd8xfx3vp2FknPC
         EeOl6FAPgznfFl7uWEpELjs1VdIEFr7nlC+FrJx9xDfvvBdo6z0aOfdJxSa5mo0gtiMC
         vXSHcW/LDY4aw1S2BbiaOqMSasc9yC5BjmO1YLWBjpiYo8hKPBuEV5SKEniqtaNK4xmv
         miy7peXFi0orEktVyC2dwnzvVaKpzTqH4ekCPKKZjFi8p3nUgdl/Rkqq9CLkGP7ewBbs
         rAX20UM8rfeJUnxww+/QCYeHsD/X2KIQvrWXG8tmtlu9H+dfCEfqespZnB4fDxYp+Kd3
         hcig==
X-Forwarded-Encrypted: i=1; AHgh+RqxU3n1y91/vN0mcejzX6AfmQxcAGdxxnukOe+a04QvZjP8mlIII2RNKOc5WyJE7kXaVDkp5cMjR9vqxEIEtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzX124QJtoKR0ykCEIF4rddG2Mee2OpP/H8L4q4+/kuDBMiPpFf
	YJDBG+yg8cZPAzA+oGzrkTXgPqyA3NWP6cBub0B2CE9h+B0PG6ENsV+p6Tl7IFEYk3k=
X-Gm-Gg: AR+sD13ZSF3v7NXBRv7oeV2bk0MJWkc9Ox5owEibP6cD+UDMPfKq8eOk2x9lx6ls913
	snmKgT8dcRdrVqxw5JjtvotGxeQxz7zR+LIMEGm+OYJo+ZoP0E66vhCr4kUY3FXbrD6LHlI32xs
	dYyKpJMxgvgYcv3HF7oQypHwvmhDdKTvZKBA7J6Pi4GiQACqWz/myQcM0xFHCdLqRuW1zjpXN0S
	XTAZ1dtX1tq1YPGyJKRk8Wzl9NXkCqfGhNDY+lHM08TZnp50QwHz4siYTglBL/PM/x6P2Bv0hi9
	bPWlyS4OaaWIG/MPsEwABA8Ds6gwlGB653zYhDQAPDExJTyDR5mmUj5cPyOxLzUOEgDQBmMhPUP
	59aSJeEC3ur/BXH2jQJ1jUMhvcPF3SRLTBob8iYYdwwzFPeT5z7FHccGDGIwRUSv8TDkPEaT9yz
	oTNmFzOsniByjwrf6V74nrKFilWVPcVwaP6R4Ugx4w3bUyR8l9OOdqtlhPjuJMykvKqndlnp1GS
	Xb2wHooKNQOwgy0IchkdE9WDEjDmHMwhEWD1Jko623iaUyAkUpJbpYK9jtCPwhwUq9E/Wk1rglH
X-Received: by 2002:a17:90a:d004:b0:381:cef1:11bb with SMTP id 98e67ed59e1d1-38fbc4d6369mr12153174a91.22.1785821311856;
        Mon, 03 Aug 2026 22:28:31 -0700 (PDT)
Received: from Metius ([103.158.43.43])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315834e1eaesm1534690eec.19.2026.08.03.22.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 22:28:31 -0700 (PDT)
Date: Tue, 4 Aug 2026 10:58:26 +0530
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH wireless-next] wifi: brcmfmac: Fix memory leak in
 brcmf_sdio_read_control()
Message-ID: <b67xzhxq3c5s5v7tnwdjtmbfmye7mgvdbowhyr7g7h3xdkdrze@b3w5waih4oku>
References: <20260803093506.1647790-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803093506.1647790-1-arend.vanspriel@broadcom.com>

On Mon, Aug 03, 2026 at 11:35:06AM +0200, Arend van Spriel wrote:
> From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> 
> The memory allocated for buf is not freed in some of the error paths in
> brcmf_sdio_read_control(). Fix that by adding vfree() calls.
> 
> Cc: stable@vger.kernel.org
> Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame buffer")
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> [arend: rework as suggested by Johannes]
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thank you for sending the reworked patch.

Regards,
Nihaal
