Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61036 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3ABQV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 11:21:58 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so6710725wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 08:21:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <016301cde8eb$8b92ba60$a2b82f20$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>
	<CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com>
	<CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com>
	<50E2FE5E.6040300@openwrt.org>
	<CAJ-Vmo=kbvLSdA8wGaRacAOvoZBdksJwQZ+Z52RbiUAq-T4weA@mail.gmail.com>
	<016301cde8eb$8b92ba60$a2b82f20$@acksys.fr>
Date: Wed, 2 Jan 2013 08:21:57 -0800
Message-ID: <CAJ-VmokpOeKc6zR+JUWqzZ1tsRNdWR8gK9OTRb5HsUnKYVE__w@mail.gmail.com> (sfid-20130102_172204_191310_B6A037E6)
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
From: Adrian Chadd <adrian@freebsd.org>
To: voncken <cedric.voncken@acksys.fr>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... interesting. The allocator choice is enough to cause your CPU to
run too far behind the workload?



Adrian

On 2 January 2013 05:17, voncken <cedric.voncken@acksys.fr> wrote:
>         Thanks for your answer.
>
>         I found a workaround for my problem.
>
>         In my Linux kernel, the default SLAB allocator was changed in
> default settings.
>         SLOB  was used in place of SLAB.
>         I select the SLAB allocator and that fix the default because it runs
> faster.
>
>         However  the infinite loop can still happen if the cpu is heavily
> loaded with other tasklets.
>
>         Best regards.
>
> Cedric Voncken
> -----Message d'origine-----
> De : adrian.chadd@gmail.com [mailto:adrian.chadd@gmail.com] De la part de
> Adrian Chadd
> Envoyé : mercredi 2 janvier 2013 00:41
> À : Felix Fietkau
> Cc : Mohammed Shafi; Cedric VONCKEN; linux-wireless@vger.kernel.org
> Objet : Re: [RFC] ATH9K: infinite loop in Tasklet
>
> On 1 January 2013 07:18, Felix Fietkau <nbd@openwrt.org> wrote:
>
>> I think the best way to properly fix this issue is to implement NAPI
>> support (which mac80211 already supports).
>
> Sure, but there may be some underlying issues (maybe even on just that
> particular platform) that need to be addressed.
>
> Migrating to NAPI / breaking out of the tasklet early should also be done,
> but it's potentially orthogonal to the OP's problem.
>
>
> Adrian
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
