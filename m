Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F4E3DFC6A
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 08:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190433; cv=pass; b=DhLF3zPYxdkt7TToS1gg0gUHPjS5yYOXA7kbBJ9JAp06yqExto9WPp4dUx0SWwn4YcPTRFLWXTFGhvmUHrgcL8KiHgLOOJ6wyhFc+yIK3Ca7NnEOC0YIGoBqNbf66DykOXnDfDU/RwPatKhpb5kfsT1MtGp0rQodyo7mdWtfrCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190433; c=relaxed/simple;
	bh=WFACAylUZ0HP0xKRoQatfOWkwjndONJlJvIWE6oL+4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J2gh/2gxTCunj8FQohIyBtva5nA5C00ryDVA9+bkgmW+ysqjZKgbDhQAVJzziZLje82Xt6Hp7eKOx38gW7cBWr0NOfOoZY85eTT7WPDvwRvLt4eONt3Uc/ssE9b6KdMLarMeuPx0umt5WIDgycvULh4UzFm4+VkccmUAhxGq6jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6LgO2SW; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6LgO2SW"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-81e8fa1b8d6so55312797b3.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784190430; cv=none;
        d=google.com; s=arc-20260327;
        b=kt7JkXHUZTZNfjmh9ECWAwO5ZoAScfjRPRKmy7OlYIHrRhT7T6jQW+WhWMhFLqVlZJ
         j5fdLOdyTE01c/PFC0CA3VGntUwkFwQ0D0aXc5nlSm9m9xDlwZVq1z6XxHMMk4ABkvqw
         H5zFMqAWfXH5PVZPYl8X+YsE474K0OiVw6os7unl3S92FQXN/QFCqc6kq2r+ZkKd+/q8
         1pOqI2v/5KZslxI/gxGcHDKKR8lFz6rC6roWExeBa/KjdpfT52oqYK9Nr1mlv2a3lRf1
         Cjre4gUPTWpGRlFaUTsYvKdXEAroCFAqQU+L7XkEoP2S5sgN7rfwGEejtPzI2NJ85i1L
         Ptxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vpauZo/tgDqjVS5OsHV+PB/DFoQC8D96R3Vc7c3M6nA=;
        fh=bF5m0ZcXH88j3ih8m3lcTXwLQ7ki0TX6e8QOJDL7hQY=;
        b=YvpT8tWOrzHKFsiPDzwhqd+rY9z+bPRsoJzb8woF4LENTTy6gz51HO96hItSRrQu1v
         8PLr3Z5BU3TX5cH9CNXJtVJ7VaZmVepWLJelDQoZSomTHlAG2s7K2JnwKgsG09l+tatM
         fJ7jzX6+iNJa3Ch7Tek5obW2cqosf/mkdbCcwPTblIt2CPkISZ0fTX6/W4fqFTfM5Li7
         gitW4PzJxwlWQxff2DSovy6b2jIB0e4Fdd46DeAPT8isNZtLi5beMJf66vQR/V1+QrJK
         7dfLuqYKzG6poZZNiUbHQqavA2dXYiiPoMUxebuFb3Sx6y1XQ7KI4xfIJXbIVsvjUllS
         xNmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784190430; x=1784795230; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vpauZo/tgDqjVS5OsHV+PB/DFoQC8D96R3Vc7c3M6nA=;
        b=W6LgO2SWL5QDpZXmPfGEPy8zyeAJnEvl4LX9VwymExoOUzSiV/6/rkeklopECpqgPe
         Fr+XGjwrkIN/e3DjlWe/z4KVf6fERyGi6ZQaQWHimrF9z2kyKSFN7QQIXoYLI8BP7V09
         mNYs+JhHJUx3/HAprU4I1kTgvXZ5gNJlA+d+0l4t/N0gnNW1bENDXi2VNJKms6VGItaW
         W6OZIo6HeFoqI8EyxzLfjSRSm4IRQ5gFqEYMi3JUYRIqcrSUqlusLUZ8aZrNn5e/Ezef
         guVqcBjLAdcV1MbhJxsXdB+LuSSlZXxokTYSUSH0uWf9xNlrnKqOKVePNNA+Quk1/lCW
         R87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784190430; x=1784795230;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vpauZo/tgDqjVS5OsHV+PB/DFoQC8D96R3Vc7c3M6nA=;
        b=U9z+Y0PhLi53C8hCybdjY2Ho6bWvIVxCQgcoYGg8A66/SWcAK3d5PByCSV+TL8190X
         3I94K0WU4l9fhpOipEJY6/bMmdcC6MrOgRj10aTGhYIYWTDqP3aSmVUEi0j+Z817m+pM
         jxUj3dtLd4y6Efs33t6Lq+iqF2LUCjtz2jA9rKD4NMJb6yyFP/mimJ2cixbcmk4s6eXl
         B7B1ukOWS7V+W2Vzk0SSaUab49RSZyPcx/6QAKXjMCrLt8n9ldd0AniJvmoII1LB9Gye
         J7K6zSLHuNey8LNs1sIJj52fVCT0eX/VCHh4YaIAqj7HkXzVwPkxUvnxaUNlLdFB5ZzL
         19bg==
X-Forwarded-Encrypted: i=1; AHgh+RpG0QeLPhZWfGDurkGnqv3+izSClljgBotrsJWP4wkr0YG1nskra+SJ3LdA9vytcSUlfCBsH0UWh/GfOXx6pw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yys3IXoDHJeUiESKooyYLncg8SkoqI4BAoHtILevRspH2a397U5
	5oLOnDRo4n0w6RBYmjarOGzB1OZd4QauSCZ7biwd2splCY+0TrH+tzlstLTd6S3r1zNMamqEFFd
	XuY68+awRu1nCIOtNmsISkY4YzJ+/IT4=
X-Gm-Gg: AfdE7cm+MI+7t3kYUfsCox7N5TSwdGdSevccNnhvW5/DmcL/Nj+i6vDM1oOVmZWXu7h
	OeGuGo4DmiNI5n0LJE4ySOFWvcaiBxRNEPcGDaabTrJjybv3nvuOO+cMPTbElCZ6LVQ66sUrtBB
	7rbENZKRlaeYJYAVbV/FlHi8S1F1h4X1CW4OjEWFCsVwJOcPE6j/3WIMDjG5f3FwyAahwjqAKnZ
	BBgB17iGS/7hO3ONTeUqJgxYn/I4LA463YeL4qUDV9mhe/I0Z2DhlaPi0Hae0kJdW9bOyRTfMks
	XJ3ATZWmeu/sa2Nk3ZvK+m1g+OZgddb3swpdXC/Y4sw+
X-Received: by 2002:a05:690c:a87:b0:81e:29d9:7b13 with SMTP id
 00721157ae682-81ebfd71f13mr72764147b3.18.1784190430138; Thu, 16 Jul 2026
 01:27:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712221709.7099-1-gvalkov@gmail.com> <20260715145228.GG56330@francesco-nb>
In-Reply-To: <20260715145228.GG56330@francesco-nb>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 16 Jul 2026 11:26:54 +0300
X-Gm-Features: AUfX_myObMt8htlBZqgfYKHId75U1l06HsPHA1lkc6D_3sDQZbIgZgIfjRPZ0W4
Message-ID: <CADOrJmYwYs08REP3eSwiTQegcKHFLwW0gpUexhomLDtO91ASMA@mail.gmail.com>
Subject: Re: [PATCH] wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware
To: Francesco Dolcini <francesco@dolcini.it>, johannes.berg@intel.com, 
	Dan Carpenter <error27@gmail.com>
Cc: briannorris@chromium.org, s.kerkmann@pengutronix.de, kees@kernel.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Please backport to 6.18 and 6.12, which are used by OpenWrt.
Initially I did not know that I could insert
free text between the commit message and the patch.
I apologise for that. I am still learning how to use git send-mail.

On Wed, 15 Jul 2026 at 17:52, Francesco Dolcini <francesco@dolcini.it> wrote:
>
> On Mon, Jul 13, 2026 at 01:17:09AM +0300, Georgi Valkov wrote:
> > Fix regression in rgpower table loading, caused by using
> > request_firmware(): when the requested firmware does not exist, e.g.
> > nxp/rgpower_WW.bin does not exist on OpenWRT builds for WRT3200ACM,
> > request_firmware() falls back to firmware_fallback_sysfs(), which expects
> > the firmware to be provided by user space using SYSFS. No such utility is
> > provided in this configuration, so the entire system locks up for 60
> > seconds, until the request times out. During this time, no other log
> > messages are observed, and the device does not respond to commands over
> > UART.
> >
> > The request_firmware() call is performed in the following context:
> > current->comm kworker/1:2  in_task 1  irqs_disabled 0  in_atomic 0
> >
> > Fixed by using request_firmware_direct(). This prevents fallback to SYSFS,
> > and avoids delay. The rgpower table is optional. The driver falls back
> > to the device tree power table if the firmware is not present.
> >
> > The error code is printed for debugging and returned to the caller,
> > which only cares for success or failure, so there are no side effects.
> >
> > Fixes: 7b6f16a25806 ("wifi: mwifiex: add rgpower table loading support")
> > Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
>
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
>
