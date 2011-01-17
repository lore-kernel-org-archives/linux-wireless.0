Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34999 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab1AQNy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 08:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTims0DPfG+u9qynuuj_-0WjUr1nAGLuFz3k706T-@mail.gmail.com>
References: <AANLkTi=GDcy50zsC6=Dgv1-Ty3cYK2qpx9o=q3JdXuCh@mail.gmail.com>
	<1295261783.24530.3.camel@maggie>
	<AANLkTikJcug7LUTgX_YDD4Z8ZBrdkAdLq8_Epa6TkA5f@mail.gmail.com>
	<1295265468.24530.23.camel@maggie>
	<AANLkTims0DPfG+u9qynuuj_-0WjUr1nAGLuFz3k706T-@mail.gmail.com>
Date: Mon, 17 Jan 2011 14:54:24 +0100
Message-ID: <AANLkTinwGaqg8ahGWd3+_dfhrCNTQNOfO1E-EUepFJ+C@mail.gmail.com>
Subject: Re: Merging SSB and HND/AI support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 17, 2011 at 14:43, Jonas Gorski <jonas.gorski@gmail.com> wrote:
> On 17 January 2011 12:57, Michael Büsch <mb@bu3sch.de> wrote:
>> Well... I don't really like the idea of running one driver and
>> subsystem implementation on completely distinct types of silicon.
>> We will end up with the same mess that broadcom ended up with in
>> their "SB" code (broadcom's SSB backplane implementation).
>> For example, in their code the driver calls pci_enable_device() and
>> related PCI functions, even if there is no PCI device at all. The calls
>> are magically re-routed to the actual SB backplane.
>> You'd have to do the same mess with SSB. Calling ssb_device_enable()
>> will mean "enable the SSB device", if the backplane is SSB, and will
>> mean "enable the HND/AI" device, if the backplane is HND/AI.

> P.S: Any suggestions for the name? Would be "ai" okay? Technically
> it's "AMBA Interconnect", but "amba" is already taken.

If it's AMBA, can it be integrated with the existing code in drivers/amba/?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
