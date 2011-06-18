Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60504 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1FRMED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 08:04:03 -0400
Date: Sat, 18 Jun 2011 15:03:56 +0300
From: Pekka Paalanen <pq@iki.fi>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Lock up when faking MMIO read[bwl] on some machines [WAS:
 Faking MMIO ops? Fooling a driver]
Message-ID: <20110618150356.1b9e31cb@farn.lan> (sfid-20110618_140431_662987_2A960067)
In-Reply-To: <BANLkTinf8X1AUEHteMnU3MMBEPEO1WNtzA@mail.gmail.com>
References: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
	<20110618133957.378b5266@farn.lan>
	<BANLkTikT3qoZhTrd0uF-JNehNhTCRjF6kw@mail.gmail.com>
	<BANLkTinf8X1AUEHteMnU3MMBEPEO1WNtzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 18 Jun 2011 13:26:14 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> W dniu 18 czerwca 2011 12:57 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
> > Not modified MMIO tracing works great on this machine, I've
> > grabbed dumps 10-20 times without a lock up or anything.
> >
> > I'm using different drivers on both machines, because Macbook
> > Pro 8,1 has unique BCM4331 card that I can not buy and that is
> > not available with PCI(e) slot. Is uses some vendor specific,
> > PCIe compatible slot. Simple commenting out "set_ins_reg_val"
> > work fine on this Macbook, PHY reads are tracked correctly.
> >
> > As for differences in struct pt_regs... yeah, I think that
> > happens. I'm using x86 kernel, while on Macbook we use x86_64
> > as it's required to use 64bit driver in ndiswrapper.
> >
> > I can try to find out, which register we try to overwrite on
> > Macbook.
> 
> This is what does happen on my machine (working):
> [  122.550991] mmiotrace: ZAJEC: read PHY 0x20
> [  122.550994] mmiotrace: ZAJEC: overwriting 0x20 with 0xFFFF
> [  122.550997] [ZAJEC] setting AX with 0xFFFF
> (...)
> [  122.551071] mmiotrace: ZAJEC: read PHY 0x22
> [  122.551074] mmiotrace: ZAJEC: overwriting 0x22 with 0xFFFF
> [  122.551077] [ZAJEC] setting AX with 0xFFFF
> (...)
> [  122.551198] mmiotrace: ZAJEC: read PHY 0x27
> [  122.551201] mmiotrace: ZAJEC: overwriting 0x27 with 0xFFFF
> [  122.551204] [ZAJEC] setting AX with 0xFFFF
> 
> 
> This is what does happen on Macbook:
> [  166.886438] mmiotrace: ZAJEC: read PHY 0x810
> [  166.886649] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
> [  166.886860] [ZAJEC] setting AX with 0xFFFF
> LOCK UP
> 
> 
> So on both machines we modify AX register in the same place. My
> function set_ins_reg_val is a copy of get_ins_reg_val which works
> fine... So no idea what may we be doing wrong on this Macbook
> x86_64...

Ok, so it is a 32 vs. 64 bit arch difference, or difference in
driver binary. AX on 64-bit is actually RAX... well, depending
on data width.

I actually missed you patch attachment before, sorry.

I have minor notes, but I cannot see them being a reason for a
lockup:

- instead of set_reg_w32(), you should be able to simply
*get_reg_w32() = (unsigned long)value; or equivalent since
it returns a pointer.

- you are not checking the data access width, but you assume
it is 32 bits. Maybe you should verify that? get_reg_w8() is
very different. I think you should reproduce the switch on
get_ins_reg_width() statement from get_ins_reg_val() in
your set_ins_reg_val(), and use unsigned long instead of u32
to account for 64-bitness.

Yes, get_reg_w32() is a little badly named.

Maybe the driver is doing a 16-bit wide access, and happens to
store something else in the other 16/48 bits of RAX?

I assume the lockup is silent, since you have not shown
anything. Have you tried a serial console, if you have one?


HTH.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
