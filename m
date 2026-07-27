Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825F83DDAF7
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154562; cv=pass; b=tacMvis+QQP9HiJ/0MKTr6HtUGLhuQXyctQa7ySKXZg1zGltGzwc6e0bGoJl2oVcaRQg+xSIV2+KQ7+kT2UdO3VFUDRyszBOvxE4UHBxLEkDB9ipsieZ5iavLhJupmYp3+5/5OUQ5uoVSsaR8B1bgLcY+gXKr0Lu3WJgO6+cmzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154562; c=relaxed/simple;
	bh=2dnykRpHze8TEvIX/f6BP3ebkvsUAMvb1oehjQu7tTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fFQBZUSsTtnD8jgfa9+EGcV+MggB1xQzN8UgYiftpD+/EHwSZMszDtgXiN/RdIixKGXf1N08SIdOQ2kQ2MekAYAeYEXzcktD/v1+xXFTu8KgD4aFcHIIQJMJLeBD803pIMBNBn0VUOmLERpQDXLDQAEQoaY/ilHzslXi/+uCL5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B/1u+YeR; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B/1u+YeR"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aeb24c0807so1807193e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:15:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785154551; cv=none;
        d=google.com; s=arc-20260327;
        b=ag57lokQ7q7P65/tyCu3vsb+XP4bsjEaEDKplDEz7tbFmahIzCrDBXrl8ucxBzcxdI
         PK4uEPuv6zEfmKdSae+F4P1dgE81zOjqv/8CQrryjuTeapjozadyws3V3BMsV6zLXsLn
         C+SYQanTcMqB70vqc7apgHs10hcajhWqthV7L+ZmsxqWQReubHpswO8EoAJGYxkqO5Mt
         TUjhE2K31dlXHrkWFVYgsaeVZAqFIvxXSyAh4RgTxWLhEkddwNYB2dEg52jHdSiZw/j6
         /XbCMMgVR9NhaXB2sg+oknQbbCZFWEEKjb5C7kOrMV9SCVDZc++TAU9GqXD4mJxEcXWC
         9Bmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2dnykRpHze8TEvIX/f6BP3ebkvsUAMvb1oehjQu7tTE=;
        fh=tnmsUW76rbdqGaq4tnCQ9KsEh/qoLLhELbLIsdhy9dk=;
        b=etA0roJEeiNModq025JP4Z/N8mGlpTgfkKvJ6pRVT3dncBq5zwSokMwzxmkmNdvzdZ
         dCHwrWsnYOjQKnbAc4XC1nSzgx1aW2sFABG8lieWMmJASMRe+fUBT75/8nA1evPcv7tM
         29AQB7BqdtM3VKtW4YEGH/hWq/RsUmcdvEpewK7l+cBkH7NpKjcOSaMsRpc5I8cV/zuq
         m/BEaivqDWit0NzYcW+JHba9gPLJ0zK+2Q144+RnKtgCdFG6F3TaHv3DRd8J4j/XNawx
         EVeUu1//DtZpbOamCmAv3vVaJ7jAY/2Msykzq/h1ybGbaWXQuGQz9+vBtaEq3xaGaybo
         YLtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785154551; x=1785759351; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2dnykRpHze8TEvIX/f6BP3ebkvsUAMvb1oehjQu7tTE=;
        b=B/1u+YeRoOVwGnakjDyZDTJXXvSVltFVaP7oYuq6phuM7+FHGkIFtE26s3W23vJ9dn
         ZqTbZ3oqXC/o/3mcEnNqcQY16xAJ/1vXwO8pEZHSeaH74rkLyj7xSCboHqVzzxq817Ng
         w38ioiY430ayLR1u6ArxcJVULNvhNWXhDPpOwQhy5rqIjBf0VzaljCP45q8/esQeohJT
         qieJKj4SwBRXGzPiP+RL0G+50AfYQLAMUPJe6dOWvbBoX5TvYpPFv9ybTic83LGHcnio
         JO2Og2SCY7zvqFUGPUXBALU/N0uhppnxg/gmSTtoUDnOxJ79RJxhOA2UTVOxtTByzl2k
         SyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154551; x=1785759351;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2dnykRpHze8TEvIX/f6BP3ebkvsUAMvb1oehjQu7tTE=;
        b=l+S0wmtF/dzOEc541DCvrM53bdT8/q7Oagv7oDC623sP0slZMzZjlAQvzjWybP2BXe
         QZkG6+ZbbhtSfAO57gM0WYnj/L+MaH4j0lt+iNL2kr4+WBV4W/UCQf0Gfv5ISO5deW4R
         iKUdePl0EwqASdvGkVubyiB2VE6XNvwDPcNqJoQ1GBAhSpNVmZeW20d52looUz0oWNte
         LR5SAs5+6l9YDl23mgVdnTu+duG31c4MSxLbRThNhNejAUmfRE2MoGgdR2Vux88kaKMa
         fmMS/88YcJgyQcKCD6K0PVfbGkCYbBRgPUzCEgg8vGWdCHzCvgKKvWpcHaTPYYIHdZdT
         sckw==
X-Forwarded-Encrypted: i=1; AHgh+RptOo8sSd0ePbAnISNIisFO+45B8kEh4tz790QofnEAYMOZUeCvxQ5vPqLCWmVFzfUFQqEq4rc1rb1IEyNl4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzW4IVR419mTJ8WOL1n3llYBXkSXagcBLsRiMrtwKvoYtV1qy57
	ezPSoWvGHJTUyyaeBwC91qDhlh6IzrhjgHVrRaBe0b0XXrNgbeYBisHuyFnzv79ihKE63qP0fcW
	DHP3Vvq6AXxBDLlEu4OToNnIra3DAxuE=
X-Gm-Gg: AR+sD136LegibtTIZY50gFpy/U+5bIcrDuz7sMUWaJTuKb6IxNpgAgafmKjqydNNCpL
	XOZJG7TJJ0TfYQAUSbX2xAwdvzMgg6yJzfZeoDF7vTbORBtFAl3ZJma6bWwcjHPKl5F93JrA40+
	6zxMEWrcHtltvqV5alDUU6Y7bvmhtrM1sGpev6ACByz1wxJfapbGhbEJPNS+2EsuweKI07RJe86
	mUXkLuFa02FXkAUnth+TWCpj7FvgGNE36XCCCIwKibCVt/e0H9ULoMrN7UTB1zEzjd6NyyoTiQk
	+/VA0rlYw1NEhos50ywQM3TxG1Jf8pUuOzCUkgJOAw==
X-Received: by 2002:a05:6512:318c:b0:5b0:141d:ec5a with SMTP id
 2adb3069b0e04-5b2c1afb57amr1663610e87.13.1785154550644; Mon, 27 Jul 2026
 05:15:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712221709.7099-1-gvalkov@gmail.com> <20260715145228.GG56330@francesco-nb>
 <CADOrJmYwYs08REP3eSwiTQegcKHFLwW0gpUexhomLDtO91ASMA@mail.gmail.com>
 <20260716085942.GA99146@francesco-nb> <CADOrJmbJAfNoyAuRq5OxP17r6rCAYFFJPy-Nvj4D+1zv=heK2g@mail.gmail.com>
In-Reply-To: <CADOrJmbJAfNoyAuRq5OxP17r6rCAYFFJPy-Nvj4D+1zv=heK2g@mail.gmail.com>
From: George Valkov <gvalkov@gmail.com>
Date: Mon, 27 Jul 2026 15:15:37 +0300
X-Gm-Features: AUfX_myGzWRT0vMuD4XimDF2RYBSlHK6CH_z43UcRHdj4YC8E-D6w2CjthHNS5w
Message-ID: <CADOrJmYyAXzx9wVdLMwtvaFBcKcEPWxCv8OAGkkDYZjZGzoOCw@mail.gmail.com>
Subject: Re: [PATCH] wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware
To: Francesco Dolcini <francesco@dolcini.it>
Cc: johannes.berg@intel.com, Dan Carpenter <error27@gmail.com>, briannorris@chromium.org, 
	s.kerkmann@pengutronix.de, kees@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Any update on the progress? Do I need to do or change anything?

On Thu, 16 Jul 2026 at 21:01, George Valkov <gvalkov@gmail.com> wrote:
>
> Thank you! Note taken and I will try to do better when
> I submit my last planned patch for this driver, soon.
> I wanted to collect opinions from OpenWrt members first.
>
> Georgi
>
> On Thu, 16 Jul 2026 at 12:00, Francesco Dolcini <francesco@dolcini.it> wrote:
> >
> > On Thu, Jul 16, 2026 at 11:26:54AM +0300, George Valkov wrote:
> > > Please backport to 6.18 and 6.12, which are used by OpenWrt.
> > > Initially I did not know that I could insert
> > > free text between the commit message and the patch.
> > > I apologise for that. I am still learning how to use git send-mail.
> >
> > Please see Documentation/process/stable-kernel-rules.rst
> > It should explain everything you need on this regard.
> >
> > Francesco
> >
