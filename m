Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp07.msg.oleane.net ([62.161.4.7]:55457 "EHLO
	smtp07.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3ABRPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 12:15:46 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Adrian Chadd'" <adrian@freebsd.org>
Cc: "'Felix Fietkau'" <nbd@openwrt.org>,
	"'Mohammed Shafi'" <shafi.wireless@gmail.com>,
	<linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>	<CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com>	<CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com>	<50E2FE5E.6040300@openwrt.org>	<CAJ-Vmo=kbvLSdA8wGaRacAOvoZBdksJwQZ+Z52RbiUAq-T4weA@mail.gmail.com>	<016301cde8eb$8b92ba60$a2b82f20$@acksys.fr> <CAJ-VmokpOeKc6zR+JUWqzZ1tsRNdWR8gK9OTRb5HsUnKYVE__w@mail.gmail.com>
In-Reply-To: <CAJ-VmokpOeKc6zR+JUWqzZ1tsRNdWR8gK9OTRb5HsUnKYVE__w@mail.gmail.com>
Subject: RE: [RFC] ATH9K: infinite loop in Tasklet
Date: Wed, 2 Jan 2013 18:15:35 +0100
Message-ID: <018d01cde90c$c7145410$553cfc30$@acksys.fr> (sfid-20130102_181553_944334_BD4B4B33)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Yes, 

	I used an mpc8314 at 400Mhz, with 128 Mbit of RAM for my test.
	
	To find it, I measured the time elapsing in ath_rxbuf_alloc(..) with
the kernel function local_clock().

	With SLOB I found around 123 us (and I have an infinite loop in
ath9k tasklet, because when I have consumed one packet the next packet is
ready to rx process)
	With SLAB I found around 22 us
	With SLUB I found around 10 us

Cedric Voncken 

-----Message d'origine-----
De : adrian.chadd@gmail.com [mailto:adrian.chadd@gmail.com] De la part de
Adrian Chadd
Envoyé : mercredi 2 janvier 2013 17:22
À : voncken
Cc : Felix Fietkau; Mohammed Shafi; linux-wireless@vger.kernel.org
Objet : Re: [RFC] ATH9K: infinite loop in Tasklet

... interesting. The allocator choice is enough to cause your CPU to run too
far behind the workload?



Adrian

On 2 January 2013 05:17, voncken <cedric.voncken@acksys.fr> wrote:
>         Thanks for your answer.
>
>         I found a workaround for my problem.
>
>         In my Linux kernel, the default SLAB allocator was changed in 
> default settings.
>         SLOB  was used in place of SLAB.
>         I select the SLAB allocator and that fix the default because 
> it runs faster.
>
>         However  the infinite loop can still happen if the cpu is 
> heavily loaded with other tasklets.
>
>         Best regards.
>
> Cedric Voncken
> -----Message d'origine-----
> De : adrian.chadd@gmail.com [mailto:adrian.chadd@gmail.com] De la part 
> de Adrian Chadd Envoyé : mercredi 2 janvier 2013 00:41 À : Felix 
> Fietkau Cc : Mohammed Shafi; Cedric VONCKEN; 
> linux-wireless@vger.kernel.org Objet : Re: [RFC] ATH9K: infinite loop 
> in Tasklet
>
> On 1 January 2013 07:18, Felix Fietkau <nbd@openwrt.org> wrote:
>
>> I think the best way to properly fix this issue is to implement NAPI 
>> support (which mac80211 already supports).
>
> Sure, but there may be some underlying issues (maybe even on just that 
> particular platform) that need to be addressed.
>
> Migrating to NAPI / breaking out of the tasklet early should also be 
> done, but it's potentially orthogonal to the OP's problem.
>
>
> Adrian
>
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

