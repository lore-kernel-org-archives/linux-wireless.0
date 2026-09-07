Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3448B44E659
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774636; cv=none; b=QrkDloVlX2UwgAJoOCk9iOtwLz3nmMUb3pSX5ZUEnovHTTvnejCoPcMOojbonxmHV0wexVLfO+iYMevc1DwQ0Tk9jlS8LuhV7c8lg10bF0oxAEtCAR0qX25DPQbb5F3upe3UPOefMdGhKoyP344HzsIXZziCPSS+1tiQi+S4MCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774636; c=relaxed/simple;
	bh=EJi4g5va8T1f1BIn66h2FvU8Mw088XXg+dMLppSZj+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sU9zNbYnX0H1jScy4HaEb+tkPVyzUEpWsuRIP5j2PGJwL5LHssnPsJEkK7m4nt1hRY5Xc6DHoJe8rFMxLaI1NpuRPT1KO9gwlK0QPMZBQ8+xFrXZ2bj67XH/ii8k6xOB4bzmQzao/SXQTz+V/kqiMvpZ/WhOU7RAjS6WXwEbKrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-785d603efdeso1083375137.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774632; x=1789379432;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jpyiT01uqi3z67FMkXpZRYNDQ41NByhvT2i+cHhX0n0=;
        b=WN3UkoK/uMlC7F3Cvvj8pX/j/iOH/a4iXOnuYCw2Vt2FjEuqKdwLxqI97L67F9DzHf
         TVwj+9nCGEMDXfHaZDUxuiqbP2CkBIj5aJ7vJyssn8OsBovjy7XAu3u+DNPQfeqvgvXj
         +MszFVyR6Vk1cMW5MtGIKlc/4bP2+NPFxqIaGGISuIIx0E3xmrx0V5hOK/FogyxwBVZ/
         41Q8dJca6jwLRqv/uBANrMp4Xg2csXSIew1MdQwjQuayPVECkyHz9Sjvvep3+IJPIQit
         agssYJPUdghqoHW5r8lLDhMiRElmK3Rehefw3VwdoLoaNcj//xkYmJcgoYbqk67s+ARK
         58/A==
X-Forwarded-Encrypted: i=1; AKwUvBx4xPWEoAUmB3Ci1cy4vQ4+IF1Q+4cgFRufons0aiFp6Z0bkFo5SqXHlP/XrNzQZx2LOpjDNzhfX3z3nhRHvg==@vger.kernel.org
X-Gm-Message-State: AFuF++kuLu0TNbvgAmjq+PWCovA6VGp+s9W5KT73Upn+zNnxUl6BqcNr
	akv0+pcoBPlQA4z+crIsxK80WmXhKtjyID1d/bv5MFhCRQKeW6VPYCxmD776YuJ0
X-Gm-Gg: AYBFou1xl891miKXZOW8PIoFW+7T8NYsb/wcgTa3D2iMpziSLqVnLSjhnxHNkBgZgI/
	h8ZMZPAcnRhEiVvy1+GVE5hizwY/LJuYdF/GpMF9s2ES8XPPh6b5SzH9+E5O2abxFzZ5APwF8EQ
	lggWhCPKoNd11/GLDzcSzWsfjyaO7sfHj1RwouD8bb1K8mqAN+eYAyjlX1i1ZvZm9kYx/6pWMPE
	Q0y1ji4/Wd6hFmHiQIYhkL/WdnwpvLPDNzJ+tAxV4p35jtp1NXUSSl/1lsbpaklbmNvNYeusf/l
	RiTszJPHQ+ct+ydAW8jalGc8S8nkOkKbe0vDHsfEdr+TTRSpgpQoYEzcSpwgHmfORIS2mZ6k/+4
	ICQN2l1UUiP2eva6vaR66Ey+MiXTGTh3WhtAPeipciZrJjLmjTpoRms+jR/uXeqyaJWYWhUedyI
	ICwUK9CqSiWoVt6dChbdR406HhmjmRxUNHUDSncO3NNR+VfmY5Xi13WoX4gjp+ADvMovu0Yr60p
	fBj27OMorGbHpgZqNvp4NA4WPhOib63gRDtHg==
X-Received: by 2002:a05:6102:3ca8:b0:786:724a:4e94 with SMTP id ada2fe7eead31-78a4ab072f2mr6332796137.11.1788774631706;
        Mon, 07 Sep 2026 02:50:31 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9808ed1dc86sm6912212241.5.2026.09.07.02.50.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 02:50:31 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-789fef9422fso918476137.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:50:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz7KDxbxfBEWNXah5L3RbMMOCyejJRLwL5RU3CeR0ScMtXczgW537DKc0LCL91R1vhFJXZp/iZrC3yJn5kA/Q==@vger.kernel.org
X-Received: by 2002:a05:6102:2ac4:b0:778:30ee:f44b with SMTP id
 ada2fe7eead31-78a4ab31a99mr6505412137.13.1788774630709; Mon, 07 Sep 2026
 02:50:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907090956.2825703-1-arnd@kernel.org> <20260907090956.2825703-3-arnd@kernel.org>
In-Reply-To: <20260907090956.2825703-3-arnd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 7 Sep 2026 11:50:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdULSA1XeuyNR2oM0m3bGt6HzKMZkYYKEchy49nztpgNww@mail.gmail.com>
X-Gm-Features: AcwNN1VEYucUOC047DGmcAJRGb8pjtBq2r0j3GGqGyncqZYd9LFOaI3FEXXAmV4
Message-ID: <CAMuHMdULSA1XeuyNR2oM0m3bGt6HzKMZkYYKEchy49nztpgNww@mail.gmail.com>
Subject: Re: [PATCH 2/2 v7] gpiolib: remove linux/gpio.h
To: Arnd Bergmann <arnd@kernel.org>
Cc: Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Kent Gibson <warthog618@gmail.com>, 
	Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-wireless@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sept 2026 at 11:10, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> After all other drivers have converted to linux/gpio/consumer.h
> or linux/gpio/legacy.h, remove the final leftover bits here.
>
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
