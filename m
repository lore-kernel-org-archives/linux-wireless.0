Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4487412276
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521212; cv=pass; b=JKG4zJEOqgVcinyyFr6Ye+sktMIzv72oMj8GmtilHND5aXBMoodE+DLwL9SbeUvwJ0hNT0wygm4GQ03nAxMcTPdlhF/ZyBulJ2hLD/pUr3bqO5soR5a4u1hSUGXEKGZPgbsQA5pS7d9OlANiLP3WdR/2ovtKItQBiJsRSM+IqyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521212; c=relaxed/simple;
	bh=75FUM3b7OAtHGBd70o/lKojikJnhrJpzsSjnacprDyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BY35vzWC+Kq4T+HPsZDz5qY3fYQqeypgH+FkWvZUBOuNK8gah4bq33Dbxy+rqxmm1Z+shtXCYBOvbQhqlSe3J9Vjsh0CdUJcO7+CfLX4gVE3qpesYFVeCvGkbrEeF0PzgqZrCpyGkgXnZXPJkgzVWoY5LTWwGlX6+eSs87u6GEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHxjpNXR; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHxjpNXR"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69edc72e513so258417a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 11:06:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785521209; cv=none;
        d=google.com; s=arc-20260327;
        b=iX0Cdi8OjYaQGj743UqB3VMVixzq+rj0zBIZcvzsOOJ28vu7Z3xZDyHewSKVD3WDMd
         yLNr+66orNDWli3raDWDK8IksX8+9LReCIgK4oDuDY0y852dIeaJ5+QxC91+kb66C3C6
         mtNWEuFgtgmmdeZxPAgpVNdE0jilGJIO4J8C0bHSvXObxKPjC+OvvZnp5vfJi/fRgG+u
         XGL3Qse9lzv6XnoiTONsnHQpwOh9iiL1o/qclX2Zxo7ymy/P/4/I9hNAgsHnxyBGu5Ka
         V3s//DbDW6yKOJXDL4jdS2dAl50K40uaMFifRbI6SprKk/Jr03bVVstpTM7GUM6zRkCI
         KfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=75FUM3b7OAtHGBd70o/lKojikJnhrJpzsSjnacprDyY=;
        fh=llCHyW53v7CZ+MduWb4DMK2LhsYtvoR/YKWmoUTlQvM=;
        b=oQNkMUXnrVkuO+dYMf0RG2BknfuniB0huGkjp0BrHpHVsJqBnTMeSa0N5MAHxp8pbc
         yxve+5C54tna2iiew5SMLSdwnbc3hOVOeC8yoC2YbBZCRK605GAOYi5bB/zWCXCCFC8T
         Hu/G5gCrIsM/A1EtQ4o6+TGeXEdn68xRGiRKxBkb0jMLRPI7QejMxVPjP7JgbMkH8Bqi
         fH+jW3XfsnVzfY+HuUhGmdluV9ay/hBPexjUPAVMPCq94jXQg7N4HXUeqdmPfHhze873
         D4OGn6QPzCWLgpDm8CiEfGJnMtBZEJ0RK7ixAzDl2uqLY9b7OZIaoMwcsv6ssPJGsvIw
         UFYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785521209; x=1786126009; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=75FUM3b7OAtHGBd70o/lKojikJnhrJpzsSjnacprDyY=;
        b=QHxjpNXRfPJyoo3wb1CH+pHn3BnPx45qcijA9Z9eI7eCQHZ+qi+6eA42ayZy529PbH
         b3qTkWHMDt20KTqbLGqHp9BfPgItmtQtxMq3mKgu0dLzWcda1vF0HecH5NpifhnR+big
         mYWlfDTSw/KgEbElflWIOIh1+Fokt2KBbbuJi7sP6WNZGxBsJs3wY3fdgdSjnPklEDDz
         XzwVYsF0L4ET6N38HPXA3pIRBSWRGt3DL73+SIk8m1s9+jL838fmzJ19J85afWwOZTGR
         yDjewBebeRJPNDl7FTzKHQbpy4vKrbkxkuoiEQ3WErBlr3r5tSH3UMhQfaklwcQCBEdK
         TXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785521209; x=1786126009;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75FUM3b7OAtHGBd70o/lKojikJnhrJpzsSjnacprDyY=;
        b=CE4MWC+Xp4u16ebFzJsXFA2bWPg9G+tBuOFopiERmhZ95YtGV/UCN8nVRhvzAXrYbD
         6vcnWiZlmRD0KoGmEzj88nfWs10yOinfdP2RgHsnb6sBwNLhoQAK83vUlQIRnzlRqKCg
         v5A4MuB77UymUmgTdIboltYCav8yB10l5aVNEggHVoZd9Zk8QOJmhtnszh4pI/1Jzs0d
         peFCYA684XdRrWC42oTWDHu2Pw66aSon7xauEcUE9iljR4HOTFLIFB8aW5g651dbUO60
         Z9afmyvOEIzuVX/nwSAl/48KwB2o1cr8hrkgxHy607BDRENyIfiZ7My43m2mTvcx5329
         SCWg==
X-Forwarded-Encrypted: i=1; AHgh+RqPy2zGhQUX/yXBs4jVlKE3fn1pRZOG763Z12S5GvYFA6Jlat+d/bwx81cSuI8gy5awdNDqp8tCQVpmtDO7/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVmYg3hTCBc6wluJhgtyhWMC/TAC9ANb0qVyLUErWRz/9ijaB8
	UU/br9WbuT4dEVQ7N4ZH8Gokv2jf3KqGFrJK+x7c23LUQ4v/ZkFp/ubmOWcOJEr7/z3GkgTEIHJ
	rKfQOEPF7kPktaMS+M64kOd/MxPLaoQY=
X-Gm-Gg: AR+sD13V/D/8Vbp5itUeFnkanfYozxvEfUNqOOyKbSu1bEvsZ5iYJlZKp/Nkaq1xs65
	ghaxQInx3t2l0YZuD/9zjitr8LjgpBjK4W4z5rgmGPkS0vShPX91ZdI2NRvuUwyO+cAStKo1pqK
	zgEdr5adI31A/G+gNs9MLbQGr2ZBcgWhs/ye3YLLbJVOEGDSYZcsLRnvsAPrwgH2UL21mhqDHLe
	H/+9Cs1sBkEUtlxdRpj5sCFFKcMBC8fpFeQMCXGcsU+KCgJW4X9vKZjev3oiCEi2em2RQVBXdWJ
	RBo+/cmalABPkcyO+X/KhSpEaxiN3m0KXB8ecHmVt84f8cctTVX4LjwS6SiFvZymM/UCyDEshZ7
	U4ImZriGtS+fYKK8o41Tr/YnKRiPtnVW/t8no5e70i6+T
X-Received: by 2002:a05:6402:2111:b0:699:6415:751e with SMTP id
 4fb4d7f45d1cf-6a0a7d096f8mr496683a12.4.1785521208653; Fri, 31 Jul 2026
 11:06:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com> <CA+ORkNQntwC4k2arcngGdYB3mwsbJCkCRNTJRJ2GoRxjdGXLzA@mail.gmail.com>
 <c452116c-6215-4d62-b96b-72ae23a478e1@broadcom.com> <CA+ORkNSsb8Z5eUVH1GRvWtO_he6A+_b67ov2Cm6VJuWciJeKZQ@mail.gmail.com>
 <CA+ORkNSG45LrTu09AiHNwTZ882Yybq-3E-=enwe+2eA36fEO4g@mail.gmail.com> <fn7xsi3b5k6bshyueeybjdb4vzudsdwt6arjn3swj3lszew5nv@v5xtmaxhslbm>
In-Reply-To: <fn7xsi3b5k6bshyueeybjdb4vzudsdwt6arjn3swj3lszew5nv@v5xtmaxhslbm>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Fri, 31 Jul 2026 13:02:57 -0500
X-Gm-Features: AUfX_mzigRw56usW4zRA0dC1msoMuDsClGXIVm8msldK4FoPAVRdIM9slRQauzg
Message-ID: <CA+ORkNR0itadq+Wy0sSLwrLbDYrf6rFdUj0+L4u9K=Dczw6yWQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
To: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>, linux-wireless@vger.kernel.org, 
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	linux-kernel@vger.kernel.org, wlan-kernel-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Gokul,

A detailed explanation is available in this issue:
https://github.com/raspberrypi/linux/issues/7528

On Fri, Jul 31, 2026 at 8:51=E2=80=AFAM Gokul Sivakumar
<gokulkumar.sivakumar@infineon.com> wrote:
>
> Could you help us with the exact version of 43455 firmware, Raspbian dist=
ro and
> kernel that you are currently using in your RPi ?

Kernel 6.18.39 (fork form official rpi kernel):
https://github.com/bnicolae/linux-rpi (main adds code to capture
firmware trap; wpa3 branch configures the new iovars)
Firmware: BCM4345/6 wl0: Oct 28 2024 23:27:00 version 7.45.286
(be70ab3 CY) FWID 01-95efe7fa
Infineon Backports (used as a reference): v6.1.145

> Regards,
> Gokul
