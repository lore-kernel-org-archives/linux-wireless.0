Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793659941;
	b=Mp+kVqkZn5n1Rx/7AsUKJY0Oz6UoRH3Y7W9BPNXwgdMQmpuH05Ay//h1l7bPVaChbDYM
	 fr5xPUQGQHPrFtIdtv6OWda7ButEqHBgYYb2qb6/caFCRCC4Jyj/VHgN2d1p1J35IxaQd
	 7S+RwCkhmLHPdoqkilAGtO5D8ATVkVTNVK7+VlpXdEIYfO8cCUbNgDS+8BW4fASL4z/fn
	 ZVWGjL7ux/s3Nzg9g9JDhNXdeP7jjc6pzKxBBWDZJbQaxuByJs7yI75tylikIXp/kJxE0
	 WtgqAftTF1yKuPpLOIKC6YjCEyeFWiVtoY2cQirU5Mt+VApxd54nONCb7w0oJ1a7tDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=yGaVQZD0KZYDPqiDkr26iRqLwAumk7gYrARBO9XOcpA=;
	b=coqaBm2Zh4izgJmR4Qj+gPFIVeSalOrN/w4gUSeNzeZzV1mTiIUoZnLsR1fxrjBywvLQ
	 WIocOCQEqqVvCBfbzmyc/MwWNa7M/RHPhI55u40RONI7B9xsbL/s2vVpOVlHjnqi/anMB
	 ImaLu+I0Ta+a+B39Wx1f3vgOTsrkp47Hwf0CsLFxwbr4eQELHw7ZRQ7M6qjvSZRRkLkFT
	 LBZT3Zvjs6QM7rMUoX9Gz/BvKXDSKhkWq6T7R3WYKyh4IBa4SVbUqYwtRD3S2lsSvHT3I
	 b0/R/Bte/PNRfIXplaJ4q5cR4tM3kqWLHAFY5P79Bt4b2ls/n8uu4Ey+7ARrLyUQMbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nagashi.ma;
	spf=pass smtp.mailfrom=nagashi.ma;
	dkim=pass header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=YTuAzXZp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B9D606A336
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:52:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7B9D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=YTuAzXZp
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c38ac26cc5dso552941766b.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 14:52:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793659938; cv=none;
        d=google.com; s=arc-20260327;
        b=ohUGl9XdvIgffTSFer03q8ieJU6MvmZcMn9NBCotahDyXu1CsW52R2pb9L9RgxF62H
         44q8Mxp6ruDym0C5Y0R2c43XE0i0hPH3QJuJ2MYwrRLqn9Qqu9Zby9OzJeG7yHQFbsQ9
         K0JBj/nnBlO8I5ww21F2OtRMu61XfP0sUJFoa+7YI+71wV5bz3EpIkkqNiZ3YXrjpzKW
         +tiD0Ckn+R+6h+vsj1fOkOmWi4QE3Q9usPaRNZo51N4c8fFNp7qyQTnEgLUzPqPxHwPR
         BsXO5Bhmna917+e3xbl/odpnvZY6letvPuyBFRKQrXfo+Gmz00WDKG7QzagqgAoqR5Rt
         i4ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yGaVQZD0KZYDPqiDkr26iRqLwAumk7gYrARBO9XOcpA=;
        fh=OSpSdcZobA9BuVCUY+YWu4XNolnmfYIXWc8SiLIL26c=;
        b=P1R7v2OYASIxaiKqwJSot6uXpTgeZJxGlHuXCqCFAvsZ1nHZ+9Hz/XaLM84wWBQaoE
         HqQAokmQCqJzJrGF2meRmy9IX6QVFUPeXlyB377m6qbXsbFQD4wANJdJSoc3HJ2ULsiu
         idLWLaS6jCvPu7h+0oYnE95BTaUUXxXYMRcp20swwMX5Wjd8FUnkQ34N2Hg7ZyerGfn6
         2g0d3FpRmBCyjEoVgQnCV2lnm21peRa4AA369AB59USLewnrq1bS1KnOyViTUCGgf5h0
         nJIJp0NC1uUrbkG+YbgaTcMjICAL3n2Bd84ao3t855COMw1BraqnX4/9rI3DicxOofxg
         sG/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nagashi.ma; s=ggle-ngsma; t=1793659938; x=1794264738; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yGaVQZD0KZYDPqiDkr26iRqLwAumk7gYrARBO9XOcpA=;
        b=YTuAzXZpkWWcS1KHI/jAs78YtXsCquut5lPpUS+otiXL7qWoETNt9KqWXjrON+h2pF
         ntsF0O0ut6+LSxuEGzNlJyGmW306hyxUr/Xi6cMvIir3TnIHQZg9S+nBVqOQls7EDLkk
         ZU4we3zk0/xd2ipIvCArfl7wHYAuITLuKoh9plqDX1eW2ZFMQHNqO2Ksp1AhhhQUvArF
         Jm+cJPts7gBJezehc2FaaQgv+ibqQBJ60+Yf4Mz+HvSDNtRCDWpy4dt7KajSVR+/qyXc
         /UfD9BmRP3KYZuiqdZtGR6qMo8PxBNjeqBFND23ujL8gsoQRwL7T8Oqnpis4P/QlyavA
         qeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659938; x=1794264738;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yGaVQZD0KZYDPqiDkr26iRqLwAumk7gYrARBO9XOcpA=;
        b=mYFbD1Res3Ce8egGkL+tQwgLWI1+ldAJkTt4X5ojJPGFayqVNhed2ecRoOGkPAqZ1r
         X6Yx6DWsj7elGs7gJ+uk6WnvQGdXG4IFAPo5cOqmkJbzXqO8sWkFBxZxyA5r3ZtbO0zL
         l4YuG476lgiz34QnyUv5fzgAEScys/jfbZbZ2triMuZ8vamZ0bkB2epVAKrtLkgC5Tjg
         9NaXWlPJpeASnvc7TF3n9nlSpIyxxSQQFBVjXY+J99yUwVnAtucnwAHcDaMAGiQgQn4A
         TIMqUGw5pPT0c2dOm0n1DtPac6cn6HHHH2MJFQVPl+QRNCInvBbLL9o/GWxPd9pQIy/h
         jiZw==
X-Forwarded-Encrypted: i=1; AKwUvBxej58UkGktDF4IPr/Cllm16Wru9JKM/X4FcXdF+UVcXusHNqCVpIlzAEEAFZT5fzU0N1ok161PjCpxxyttHg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9Jl4Vp5vhe0Tg3Z4je4+kUEqZD8O0CisUXSRQ3W9b3O64CTgJ3
	3z+eF0DbGBzqceFGqU97K0nn/pGks+bJjrTkYdV0/Nzi5d7LWIqS6O3aLdeD+Qy7FKIJWDUsmCQ
	KewmIei/slfaU+9Ko+U2xvF34ecZOrrYh7PmJ8lE5
X-Gm-Gg: AYBFou0rQQEqD0xcjC3DknddFbZuwXkJ1gukPpLAQ7vBtEVr9uUDByJximGUOwj2oIO
	TudVwY+GYzQUJZ3/pGm3z9ae9toUNSzZcrPLRsMDfInUY/E6Hoal7x6f0BiMXxFjhlElRsHFD5K
	E9nQ0SygvQ8mDPZHQwz/1yJBGczkpTNh/d/Q6fl+j4iHroSoDMPAeQ4FkfZWLrp5ATnomGjE3QC
	mXgtWMrvhmKxKTxbRQMDDpGbdxkFqngeeXRpotrXtuGEKR6BiYt0BmISzoVwbWuDXB/9ORjQoXJ
	9MtzytFoZJI7Y/VobmzCp3sCZ7MeQbjRNMbDYXKCGIbX1eVL9gxMALFdgOXKUIcH8MAwkR6T1z8
	qxOTPV1Ay9tY+klYCn48TRKvzBhOMHbWbuwKmtaQoGOb6UiMXEcwJEnxYQETVdxc++nKIkKwJpU
	A/bF7vdTlfGzcRGWI89Xq6Eb8knmuUtVylv/+9s+mhSvldTBU+vK8bng==
X-Received: by 2002:a17:907:960e:b0:c31:9a1c:de76 with SMTP id
 a640c23a62f3a-c4ca7a4d998mr941316566b.14.1793659938062; Mon, 02 Nov 2026
 14:52:18 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma> <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
In-Reply-To: <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
From: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Date: Tue, 3 Nov 2026 07:51:51 +0900
X-Gm-Features: AclHuK-sLaEQW8IrNvFSowd7lBj_NX50xJF9W8-RPIjopaVz_mLHu4yEVmc3eEg
Message-ID: <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Heidelberg <david@ixit.cz>, Fabricio Akio <fabricioakio@gmail.com>, 
	Aleksei Kharlamov <aleksei.kharlamov@gmx.de>, "Conn O'Griofa" <connogriofa@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Loic,

On Mon, Nov 2, 2026 at 12:56 PM Loic Poulain wrote:
> So why not updating firmware-5.bin file instead?
>
> There is a tool available here:
> https://github.com/qca/qca-swiss-army-knife.git

Thank you for the suggestion and for the pointer to ath10k-fwencoder.

I had tried that first. On my comma four, a local firmware-5.bin with
the mfp-support bit set gave the same result as this patch: the
protected Deauth carried a live PN, and the next association was not
rejected. It is also the file I used for the overnight PMF runs in the
notes of patch 3.

I went for a driver change instead for two reasons:

 - I was not sure whether it was fine to change a firmware file that
   Qualcomm provides.
 - Other devices seemed to have the same problem. No WCN3990
   firmware-5.bin in linux-firmware sets the bit, including the newest
   one (shikra), and Aleksei (WCN3988) and Conn (QCA9377) reported the
   same issue in this thread.

So I'll drop this patch and send a firmware-5.bin update to
linux-firmware instead. Patches 2 and 3 do not depend on this one.
Should the update change the shared WCN3990/hw1.0/firmware-5.bin, or
add a file for one board?

Aleksei, Conn: a firmware file update only helps devices that load that
file. If you have time, could you make the same change to the
firmware-N.bin your device loads, test it, and send it to
linux-firmware?

I worked through this with Claude (AI). English is hard for me, so AI
helped write the English. I ran all the device tests myself on my comma
four.

Thanks,
Shunsuke Nagashima <shunsuke@nagashi.ma>
