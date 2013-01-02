Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34400 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3ABUsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 15:48:05 -0500
Message-ID: <50E49D03.60207@openwrt.org> (sfid-20130102_214810_433632_91DF76B6)
Date: Wed, 02 Jan 2013 21:48:03 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: voncken <cedric.voncken@acksys.fr>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local> <CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com> <CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com> <50E2FE5E.6040300@openwrt.org> <CAJ-Vmo=kbvLSdA8wGaRacAOvoZBdksJwQZ+Z52RbiUAq-T4weA@mail.gmail.com> <016301cde8eb$8b92ba60$a2b82f20$@acksys.fr> <CAJ-VmokpOeKc6zR+JUWqzZ1tsRNdWR8gK9OTRb5HsUnKYVE__w@mail.gmail.com> <018d01cde90c$c7145410$553cfc30$@acksys.fr> <CAJ-VmomkzNgSyicAwcj_TWg24v-DH+Q7U6ifXFFognx-7nEZvw@mail.gmail.com>
In-Reply-To: <CAJ-VmomkzNgSyicAwcj_TWg24v-DH+Q7U6ifXFFognx-7nEZvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-02 9:13 PM, Adrian Chadd wrote:
> On 2 January 2013 09:15, voncken <cedric.voncken@acksys.fr> wrote:
>>         Yes,
>>
>>         I used an mpc8314 at 400Mhz, with 128 Mbit of RAM for my test.
> 
> Ah!
> 
>>         To find it, I measured the time elapsing in ath_rxbuf_alloc(..) with
>> the kernel function local_clock().
>>
>>         With SLOB I found around 123 us (and I have an infinite loop in
>> ath9k tasklet, because when I have consumed one packet the next packet is
>> ready to rx process)
>>         With SLAB I found around 22 us
>>         With SLUB I found around 10 us
> 
> Cool. That's significantly more CPU.. :-)
> 
> So yes, the right thing to do here is to break out after a limit is
> reached, and if we hit that limit, re-schedule that tasklet to run.
I don't think it's worth adding such a band-aid. NAPI handles this much
better, as the network stack specifies a limit for the number of frames
to be accepted and doesn't poll if it doesn't have room for more, thus
solving this in a much better way.

- Felix

