Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42528 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751280AbaCYFzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 01:55:15 -0400
Message-ID: <1395726908.28231.9.camel@dubbel> (sfid-20140325_065526_701798_4498F172)
From: Luca Coelho <luca@coelho.fi>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Mar 2014 07:55:08 +0200
In-Reply-To: <CADqH6VwvNPCeeXxSTYbbtQ8+Z=2ONXdfYDQUvqRv+W=FjsnC8w@mail.gmail.com>
References: <CADqH6VygZFB4HEgcSesZB0cAhB4OvGnST+9mvTjw_QEAD_6QnQ@mail.gmail.com>
	 <1384765780.22010.42.camel@porter.coelho.fi>
	 <CADqH6VxgwbZkFgEkpiaabKekijeU+e=DMg0VVHoiXBQmjQfE0Q@mail.gmail.com>
	 <a84c8a1f-f71b-48ca-9c8e-782c19aef609@email.android.com>
	 <CADqH6VwvNPCeeXxSTYbbtQ8+Z=2ONXdfYDQUvqRv+W=FjsnC8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: WL12xx support for WL1270 and ti-connectivity firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-25 at 09:48 +0800, Jaya Kumar wrote:
> On Tue, Mar 25, 2014 at 2:32 AM, Luca Coelho <luca@coelho.fi> wrote:
> >> The good news is that
> >>the chip is detected and wl12xx/wl12xx_sdio loads. However, I haven't
> >>been able to get it to get any scan results and can't associate with
> >>any AP (even open).
> >
> > Usually this happens because you're not getting any interrupts. Are you sure the WLAN IRQ GPIO is correctly configured?
> >
> > There's nothing very useful in those kids
> > It just shows that the scan command was issued but you never got the scan complete interrupt.
> >
> 
> Hi Luca,
> 
> Thanks for your reply. I think the wlan irq gpio is configured. When I
> look at /proc/interrupts, I see it increasing each time I try to scan.

Interesting.  Try to take more logs, use 6625 for instance.  This will
produce a lot of messages.

Another common cause for failed scan (and RX in general) is a wrong
clock frequency for the WiLink chip.  Make sure you're using the correct
values in your board file.

HTH.

--
Luca.

