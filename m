Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.160.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793465430;
	b=ZjthzQW1XRKPe5XpHXAi15z6sfd6oGzYjSRn813pBBC2GYgO1wdQiP7wyqRrF105lFXq
	 XAC5+BDcw2jWaHTjxj2S+or02C+ttQcNG8hGLQondMyFS30ZhxmuuTanTMEvZctWzYPhK
	 MdHy1kcPUowV4CtQQsH6CDYlvl1cq79nQxHtHPe6oTYZBZ/q/pz+fwo+hT4EkHGiD8hDs
	 IIFYRcR3LD6uMNcLZs7YJLNQUIgB66bgg5hYYDRE12cMQOXUoy7LQ4coebJXqjGkyo8Z6
	 RbiJyDEZnDA0WH7L8JMRfuTC23ISfFWhzjCDb8MY5dJtPARQTeCGkopvOMqq5o5sBCA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=p7THrwOGLzbplnbkF72+f87VrPU0qVDjWjDR7mNS6ek=;
	b=JWBQywlZ60L+4Dr7rd3O2FrLD20yhPIakEtYy9fO+hogmyy60+G7qY1QrIyDkLasbbns
	 VdS6Vt6tIVSZzJk6/1rfA8cbwSBoZoMDxg1TGkHQfDjbATbG0/UUKfTvwvThWClmItzeB
	 yupAUtKrwUvNWQoR0vkK7bBlKLjWakVNtJ5Yne0hEq8wZoOf4CQE/HwzOlcvI0PX8w30B
	 AyEfzpDGmFin+X9d2KkVwygFeLSMmVg4SWexpG+WFqtlqv+XvYs30/36ugDBU3aAhjDUc
	 2ZCXDhvs5mtFXZzWfB5/zF17ehvkW7tqPGu9J6AAD+k08gOas117bO/DK2jrNFkX8+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="xU/989yO";
	arc=fail smtp.remote-ip=209.85.160.44
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D27606A31D
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14D27606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xU/989yO
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4a76f0cce5fso908328fac.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:50:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793465429; cv=none;
        d=google.com; s=arc-20260327;
        b=dpsQTqAVGdjOghyGrKQZapY4LrflSD/SIZUqSHkZFFAD5B9iPHAg7RKHdzXbPPp7Mb
         RWlDj30/iqEhANfintkat6iVfOz6mldS4kk1dGY53+xnV5PtTIleH0uZzfVNYrzcrMon
         QjhWbaVLs4ZeXQ218XTklfqCaVxs+0whgg3K8l3gj7p6DUAe7HnHHEmrMLhacZjfT0+G
         CO5QG4eiTjjX9+Ox3RgVCeE1uWRNJmllCp0p7mHSuHoy6ixenT9Pz6AYrNXjVM7dTMb7
         fzsVg0bAvIZ2/9nQlpI9sRjDqqv6xa+UBwq5NqUST74Bwo724pBZVemomFJgPWFpPqLZ
         ghsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p7THrwOGLzbplnbkF72+f87VrPU0qVDjWjDR7mNS6ek=;
        fh=f9hFQUVjbQq8USMzmbA7B+6DLDxgXYGTKGlXxISsNwQ=;
        b=fsqPuCLqnT4TDz2oIOHzS0ai9J7T1zIokg4RYehCUO9aae3R5+4gL/QJIj8fEbn8JL
         IucopOnL/OyBAbDgGNpES8LZC0gn8JQTZ3jMMI+YaZ6NaioHR/kqv8ZkEhcHVwkVKn9d
         vjLJ8EKBF8O8Had9Z+N4k85L1L1QNcUFpxHfCNrdWH+uspTmr22pJBI5ol94ReNvylnl
         f225B0BZ9cWQWQAjN1cxwqsrtKLiwZf79JTx8aUYh4AUQqj9OaWnc32LdOGFZhm7PUxT
         xf2whNFjMHEI4oDUEuyX9iG8WeCOc9C5VDvbHBntjC4atQARaa7damI4L7OcldpZ+ULq
         6Hig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465429; x=1794070229; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7THrwOGLzbplnbkF72+f87VrPU0qVDjWjDR7mNS6ek=;
        b=xU/989yOodyTP9zIdhLr9aOv6sWCWIBE1VClDUpQLlePRo7VRMBqTNi6eOjbPAPu54
         mYEcfRm+u1PKEkOTpXkvePHM7nxebemIwPy3mGmYk7Sm/RX6HOBCO+jKGUsAsg655OsE
         1vOx9J7QeUe+MfjEPG2KdwDk/1blaXpiDqo+hMtdxDf6RBhJ6mJ6SoFtT0Yo7Yywt7wX
         SMaBsCd/ZaSFceR42o++LgP7AzBwmO5fJVq5WV1cXuArYg9R1BiBR/fPBysPOSlZDQrM
         rx+7BeZqHcjtqzK2+jioOQsaLt1WOY6ZebBo6AUE3NByHTkrGQ3dL/uIykYwtcFUoAF5
         SGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465429; x=1794070229;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=p7THrwOGLzbplnbkF72+f87VrPU0qVDjWjDR7mNS6ek=;
        b=lkcl2zOGiO3m9Ut4HHGEwA/Tu34yRLGHxyIg/aoUmI1hACQNYq301qbRdmL1iyc0TQ
         hA89YM/ce972gSZzjodIzhlUxb0XHBDfn8ae6CLUN9aXinq5u2YsL4ZkTvHcvlyHHJMw
         sU9qDbzAw+poZitoq5ed0Qwz0Dvk4WIwj2CT4OBc/S1ICIJjoSdF0I0Opr+CXZLNWlMh
         LSS9RPrBN5GYeq6NfzW6eOP4MQQKO73DlXLDOmqTjGItQuoWaUYKQ6GH38Gm5lNgpBWY
         LMzd3PVXoPW8D1VLY2x4qIgbU4kqJXWfO/IZiIBDZDGjGCZtRus8O+Sv91W+npBBnGE1
         3uXQ==
X-Gm-Message-State: AFq9FYL2K2ReqN40tGu7LYbvpP5SYmxVH/WkyYxaBEd4OT006uZCwCxm
	FHwPKmGr0Akc4CkE589AAQ4297Heh5MLKlPrIiMA5JWcw/jyuAQnCPMGpNbVxxKu++X4iLCT4Z9
	er3Z1ovcERd1Fvk8GT5haMxV4EmEDwlzPcW0zn7A+ng==
X-Gm-Gg: AYBFou1k0qszysIeztuy3G71LpwdG9i2YsB/OWuO9K9eaCYPEBaauHk/kIKcHw7AU7R
	ZrwZpQGUW0hf+Nanby3O1QFxUIiQpD+QB2lCt4gmEKLU77Lw8xh/7eoluAB4iIbrHpTo+SvMHF3
	7amp6sAHNpSdlrn/FY8eqeRj46yZQSq7eZkaHe5LmLleXHCspE2BUHB1wo9B6ua2k6ceYHfxM2Q
	fJNleA07RAH9GMLzpz5ry64tJUGLHChBq7Ciqkri74Bc9SvnWeXZej3mpTXLGTG+byyjVB/TIjP
	PaRCzQiNwvDV8gJWCyC/Zko3Gha9fzxZl+e6yys0hXkpZht6j2n4fwanSKrCA4U4XjxMpThYeCA
	BWBN11Jw9EB0xhT0vY6V9eqAGvg7Cm3O0QX+LT2d3KqLFDe+FCLdWPzSuAH8SJtKjGg58ni0=
X-Received: by 2002:a05:6871:ed4e:10b0:48f:e3f5:c41d with SMTP id
 586e51a60fabf-4a942ec0e6cmr345290fac.62.1793465428799; Sat, 31 Oct 2026
 09:50:28 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029134752.1299130-1-hjf3108@gmail.com> <20261029134752.1299130-3-hjf3108@gmail.com>
 <20261031105217.GB31143@wp.pl>
In-Reply-To: <20261031105217.GB31143@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Sun, 1 Nov 2026 00:49:52 +0800
X-Gm-Features: AclHuK99EmjXHytrhAXfUc1juGAzdAptbINp4Vqbhf42x0phiWF-brtKCtwlhmI
Message-ID: <CABOQOSXEDgrxy9+J7DmrAdSz5esprHdX7nK4+2H6ehf+DMKyVQ@mail.gmail.com>
Subject: Re: [PATCH wireless-next 2/8] wifi: rt2800: calibrate the crystal of
 RT3593 with the beacons
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 31 Oct 2026 at 18:52, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Thu, Oct 29, 2026 at 09:47:43PM +0800, Ho Jie Feng wrote:
> > On a Netgear WNDA4100 (RT3593), as the adapter warms up, the
> > frequency offset drifts enough to affect the link quality.
> > In certain cases it can cause the link speed to drop
> > to 1Mbit/s or below.
> >
> > Add a frequency calibration step function to RT3593 to use
> > the frequency offset obtained from the beacon frames of the AP
> > for tuning.
>
> Presumably this is based on vendor driver? Could you point
> the sources i.e. a link for some Github repo where the
> correspond code is?

The code is taken from here:
https://github.com/boundarydevices/rt5572/blob/54265ac82ece4a1c6008a3d44d4abe96bf445479/common/frq_cal.c#L176
