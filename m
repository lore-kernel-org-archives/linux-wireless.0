Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA811F131A
	for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2026 06:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776321264; cv=pass; b=lTkMrY200CX8DuvAHpA/ufZ7JVm7+0xXJWwX8iDuiPlBuChL+8ymjzrcYsCdUqQs58UKby5lEqPJjAzDB+0U9D3gmWbG5TbKTRjCbNk41Y1CJBMsvbamsQOrEipHD5p6kAEWuYVIMxvE/9dgEiy9wl9s3NlaQDFISDXtPNGck9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776321264; c=relaxed/simple;
	bh=Q9CfvctdQPhjfr15Htv7JUHNt6E+mYP/N7i/bg3F730=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eaM9Bo6kpzGJn7dqU2vHLP4p8JbYltaCFCjLYJWayzYAk5F7le1kpF+VtQHijeQUj9noA2DkweWZjiSb7s3B60YWPGBs1FDooWsSubCa2mvHoWFcdFFSHuDMnGxiBQNpudzSJQi3SB2lW2OItNftIywVJPpQyd+z7grPDx7rpps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nvWRkalI; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nvWRkalI"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-649278a69c5so6341957d50.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 23:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776321262; cv=none;
        d=google.com; s=arc-20240605;
        b=U2GdKCOq5Fu7RsImfPj+TV/Z+I/aPJg+n3stpCrB+5WC+2umS+OviiBgswe6gQGNnO
         I9gyxe4myZTUzmKmJ5bibOECsO8lOKC/jfHI/+BddwnAKUvwZIhvId1iYDMTQ2Z4IDFK
         B3AtpXU0lYO+UHV9brQRgbzQ1SRpfvvLUqedjf5VQ7L5E2NrbE5x6AmH5R/UWfvyGeCi
         1nQDQnvvX4jP+qxUYH9Gz9VcKR+fGD5o5VkqUtaWaLLtBzdUIsu7C9dozOC9hlKBktxo
         MTWS1zn9LQfAnJJMx+AzMyZH5mjTUtjPTS24BEqcbHKPFjn8/mrCuU/dX4vJvw/67PCE
         xWfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7RYmBpi8DAAjfdBJ9S/wjNWLah959PM2SroLcRHKoFc=;
        fh=jypTA3z+CeXilduPwhRwCfoHkJ/UK8sr9jB1UlZcz3A=;
        b=N1qmg1SgHJFcM4am9VSLTaXUti4OrY6EnqkB/OQN/TSuxCibRJFjdM7NFwF3uOLeTt
         wXYifgumvADeUjdPKKdmJJD32kETyJUWRMLg4fV2IMOl0ceeZDQowBBhJg3QgqyAGnrd
         bHPg4aN7RbTkwMi33ACL/YQT0R2FWe9gLFCIPTF2ZirI8WFipOziuwuHYMA3Ut+eDiSA
         NaMvcS14RX7ReGp1Ac1ZFh5x/3pCK2WYGCcCm1t/aDafGLM2XmOiN5NU0mpRh5DEPQi9
         FEkBnoIo5J1oBaVFXw8HdirdslWhuJNj9Z1WUoILFu0PV04pE1RMelB2vfXbnTNQ2mwj
         uxdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776321262; x=1776926062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RYmBpi8DAAjfdBJ9S/wjNWLah959PM2SroLcRHKoFc=;
        b=nvWRkalI1dxOljVuSouIVHFmEJ4QtkhXLyqcBuFcxXzuQIEfo6NPxaqPAVoHKAJeol
         cv0DQcGNeGGQwo6MqNbWNvZ8k61w5xubR0OyUvwuLnwl/CyM14qN8Vml9+w0HgO4tTgq
         H4oIHtJMMGZJGFKpkuETI0Q+TRhiX/QfsaAJEtvUpB/yHcrX5mJXH8+jnFq8PnqW7H1a
         zddufKMEyaZdChKEumxH3C3oevkHNLnVAY5s4I94h8NCuRJDdzvecC7c0RVueR7U5yhy
         jcqZEuuCAzzcP1jxPW54zPn3+B1SRlcs76vZKBx3VPSfYfQEAyd+6bC5jRoiGNmDXp2f
         i1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776321262; x=1776926062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7RYmBpi8DAAjfdBJ9S/wjNWLah959PM2SroLcRHKoFc=;
        b=TOs3X9uYgPDZO3RtYjYSw3zwvJyO0hlW2KHqRJKUypecipcfJoPDMLAEE4dxruioL6
         3XQiZ3oM3nSai1Cdxd6/NEm5FvaKokGs5LvLv2RyAv3ojsBKb2MyQg20Exg1qPVRmN6i
         WErtaJf72z1TQ5e5H+vYlQkK3jHPefUNiWF6RbeooGw/ByUjbIYP8vKAnAPeWICxkt9l
         WL2YwH1Fb6A8qN3PYnuUbvqsNbVOwklzWhiADVptW6w7qaUWxEfboADkKbPIcyXE0Eac
         d6Pu/yArIV9ITgbpHNVLoukx4lLkWbLKKN9eM65WeJmDNxjnYCME3zLTizr/z4vEc2yH
         0wVw==
X-Forwarded-Encrypted: i=1; AFNElJ/kDAUIIum49IpjlqX+UM8OXhtFZbsdTu8zxaNb75PCNKsy4A2wBgviYkTPRkZMI1lX0vQK3wEF2NnaP72Viw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwE8e7SMx0AOeC6dk5H7HyL0ynLXNO7VMvqwBYJh7uFdH8zbIe8
	B6zy9RB+epnYFB6g4cZTcA+VBlEM2HiEPVxljQLunC5+BG5Z0oGS7CJYgPBzT8LB1LhG2yG8bMn
	K237G4gJbv5buuNMxgGmvuhb/iPqtPZ7Z4A==
X-Gm-Gg: AeBDieuVZDm+VVbX/zTC3cbLdg68/pQ5wE8wr4Ikoyf/BDzeuiXHz2WjqN4RXaqSu7+
	2G3y605afFjeR2B9O00ZBuRRBUsNdFp4sXCWX0GLA7UUix8UXXVxVCVMWReNVp1A/XtWCpaqvNc
	HlPS96DxKHOzN+94QjD161jq5SFU6WPWVqFcueCvY2xoPuG1CtvuVB6k240hERfQ5Pvzp0rQzfS
	Y4xqOx2KFzYN6xEsqw3fR7RaWF9E27d4aFPEPG6Pta5WpF7JZVg07QnEGVV/SayBQZQcQNGlT5L
	LjzM6XKsMSc0fcLpJSyDe/cjsMeQ1bqh8hQK4MsoG+RSvdBDHIazdOX1WrqOTiuMbFxiOqarnAE
	H
X-Received: by 2002:a53:bb86:0:b0:650:7a79:219 with SMTP id
 956f58d0204a3-65198aad325mr16661486d50.11.1776321262631; Wed, 15 Apr 2026
 23:34:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260415222425.1544638-1-tristmd@gmail.com> <20260415222425.1544638-3-tristmd@gmail.com>
In-Reply-To: <20260415222425.1544638-3-tristmd@gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 16 Apr 2026 08:34:11 +0200
X-Gm-Features: AQROBzAWONLGXD2falmbEIGrHCNW_JP_y1RhkenRsVimwwENFZRAJONitowHj0Q
Message-ID: <CAOiHx=kpVH3jq_XuDKp==13yNx1AMcvVaRe4R2-bScOo5otMaA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] wifi: b43: fix OOB read from hardware key index in b43_rx()
To: Tristan Madani <tristmd@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org, 
	b43-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 16, 2026 at 12:24=E2=80=AFAM Tristan Madani <tristmd@gmail.com>=
 wrote:
>
> From: Tristan Madani <tristan@talencesecurity.com>
>
> The firmware-controlled key index in b43_rx() can exceed the dev->key[]
> array size (58 entries). The existing B43_WARN_ON is non-enforcing in
> production builds, allowing an out-of-bounds read of 1 byte from struct
> b43_firmware. A non-zero OOB value causes RX_FLAG_DECRYPTED to be
> incorrectly set on un-decrypted frames.
>
> Replace with an enforcing check that skips the key lookup for invalid
> indices.
>
> Fixes: e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx=
 devices")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---
> drivers/net/wireless/broadcom/b43/xmit.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wirel=
ess/broadcom/b43/xmit.c
> index XXXXXXX..XXXXXXX 100644
> --- a/drivers/net/wireless/broadcom/b43/xmit.c
> +++ b/drivers/net/wireless/broadcom/b43/xmit.c
> @@ -704,7 +704,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *s=
kb, const void *_rxhdr)
>                  */
>                 keyidx =3D b43_kidx_to_raw(dev, keyidx);
> -               B43_WARN_ON(keyidx >=3D ARRAY_SIZE(dev->key));
> +               if (keyidx >=3D ARRAY_SIZE(dev->key)) {
> +                       b43dbg(dev->wl, "RX: invalid key index %u\n", key=
idx);
> +                       goto drop;
> +               }

B43_WARN_ON() returns the condition's result, so if you keep it you
can shorten this to

if (B43_WARN_ON(keyidx >=3D ARRAY_SIZE(dev->key)))
        goto drop;

Best regards,
Jonas
