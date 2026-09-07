Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650A437852
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788773995; cv=none; b=JDZgN8qGxc/yoFy0+nGXigjZ0mZT39o+640hOMSXVbD4plduznN75X6yk/OIPmBz49uwfYj07rMAiExGgFKLLsIfC4dv5moa8gh9tBaM2EA9kwm3kGgBTspJIJabSGeqLpbfefEys1Hiw4bi/z0aHxl7QNMxV1BcD8+vAH2Ow+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788773995; c=relaxed/simple;
	bh=WlL+j/Ie6m0Twd+B1P3rICow2WcfWKryEoGQ+1VVbBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g0YVEISKE9I4OO47oKiH/UZId0AznnhzoOe6T3tCWVry5s3ZLfUCFDZU/805mtGL9NSgYQvcTAvkiNo/H7o5kieAsh8Dm2hT9L9V9SOKLMILNwkUVPcJ4YxHaA7tN084UIkVLrf6X7YOAXISDEMtzTfgjqmt6tXrr4z9tUwzpSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5bfc5b77c02so3134758e0c.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788773992; x=1789378792;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=idsP1neYZsT92lOTYUcwf/RINlIKDTK8HxAaGpjV2+8=;
        b=jCLkfZVqkZCxdhPaR0DgPZPxqeoFoYHp+B3+msqcqjLjOsk7bpBLdgS6k/E2d/U42m
         2inen2+oCTe3fAeCnarpk714TVy1ObzEPj+4+jJLpp7D3yjdHAi+I3+ORNbwoQXP8J3f
         otdtYq4htW0ZGq+hqCApUzaQs+6x+h1n9Ue94d6/ywxwSusXpq2ZYQcNav47ro35tGrc
         ovtHJPoFH6qK50fSny5MeRGnkm2DZraBsJjVgtUAfg02URzKb9fnzkyWx9+DE7E/bYcG
         4iusggcXvv3gVKOIUZ9oUf6iu7PUCaRqWrPmLp1iqaALXO8VicLT+oOSV7pNgyz8IZ47
         1d1Q==
X-Forwarded-Encrypted: i=1; AKwUvBz6sASNuXrXn2GHrE+v/5cMb67zgEr2TyJtWsRYBErSHgh9hRJ6gFhS9A3dSvuTzsrNzKuyPvt66B9FHy2w0Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nSSQj4b0kAou9GTxbDe88y0L9IJ9ZRSR25trp5Sl38ZjDid+xn
	0bgw6v4jZ3nCH9BGl4tZNy427tZY6R9DuBeSuFFh/dW1hYfr70HQX4Ik1LjIb7h1
X-Gm-Gg: AYBFou3ikiMDfLdHXx6+REdbQaX8/3R11N6tTsH/1L+s9wkgWhCy0kxGtjsFYajSHUM
	+fEAbCQu3XmCbr+tQXaRZ3zATaKSUCQalA1t84ogfwryf4lVv3Y64H7v1O6wkLU8TShz8Munsoc
	aHbM2QxlNLqRIKAndhe7B9oNY8aLT1RYUWg8GBv+XYTTdyDMJPZMQFh9xvPf5btUEz5WhoHT3tI
	jxk26An+LyeZf5FEzLcUSNb+c/NJbCKGMw3S1f9/69oWiVsNj8RgBNSdvTFkGSipQ8ni9bSsB/5
	FF1ecYwWkEvv2nE3iMLMAE880laZioQMZAT2o1LcwNXFjTBKSIfB9zN5GgUBZZKeUF4bwkwrraW
	SXrjcssb7KuL/a47vtY3KVnZ/Gy9HV4rLPZLZZ91eW/dHaaClZnaRzEEhM14QtVoi+v9T33ymkW
	nLNxDruvbtRoQCAQpAOPRI2nZjsFk3gsVwJ+2KufaggW1mtRFbUO5JjOlXPMJovVXXlyT11KMv1
	d9oFTd2bARTq4392/ZRLwj15K/kTA==
X-Received: by 2002:a05:6122:c8f:b0:5c6:4bab:4cb2 with SMTP id 71dfb90a1353d-5c7ed80403dmr10646540e0c.6.1788773992449;
        Mon, 07 Sep 2026 02:39:52 -0700 (PDT)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com. [209.85.221.178])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c7ec35d85fsm7571676e0c.12.2026.09.07.02.39.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 02:39:52 -0700 (PDT)
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5c7d4c663e9so2593109e0c.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:39:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxYv7cETEdwoMpIT44a2viCNwjKHHnNvf4M5pV/Plg5nwirw/BiOZfY4sTkIeqHssY4IEq9apDcWUFMO8mkSQ==@vger.kernel.org
X-Received: by 2002:a05:6122:c8f:b0:5c6:4bab:4cb2 with SMTP id
 71dfb90a1353d-5c7ed80403dmr10646528e0c.6.1788773992044; Mon, 07 Sep 2026
 02:39:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907090956.2825703-1-arnd@kernel.org> <20260907090956.2825703-2-arnd@kernel.org>
In-Reply-To: <20260907090956.2825703-2-arnd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 7 Sep 2026 11:39:40 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVc=ntgrDDqdNUzEbeQ=qjh7Pw=B3TSN+qOD5bRY4_i+g@mail.gmail.com>
X-Gm-Features: AcwNN1Wp7dWP-FBPz6xYVraXlAq6_uFTgT8pt9uLR2DvecmC1uG2AIElIe46m7g
Message-ID: <CAMuHMdVc=ntgrDDqdNUzEbeQ=qjh7Pw=B3TSN+qOD5bRY4_i+g@mail.gmail.com>
Subject: Re: [PATCH 1/2 v7] gpiolib: turn off legacy interface by default
To: Arnd Bergmann <arnd@kernel.org>
Cc: Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Kent Gibson <warthog618@gmail.com>, 
	Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-wireless@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sept 2026 at 11:10, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> All users of the legacy interface now select CONFIG_GPIOLIB_LEGACY,
> so it can be turned off by default and only get built on platforms
> that still have one unconverted driver.
>
> Allow turning it on manually for compile testing, in order to keep
> the build coverage of the legacy drivers in allmodconfig and
> randconfig.
>
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com> # for input
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
