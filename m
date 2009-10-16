Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:44957 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZJPTIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 15:08:32 -0400
Received: by pxi1 with SMTP id 1so433008pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 12:08:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910161741.19731.hs4233@mail.mn-solutions.de>
References: <200910161741.19731.hs4233@mail.mn-solutions.de>
Date: Fri, 16 Oct 2009 12:08:37 -0700
Message-ID: <45e8e6c40910161208q4ef6d9aeyda0b50561807fadf@mail.gmail.com>
Subject: Re: BUG: endianness issues with libertas if_spi.c
From: Andrey Yurovsky <andrey@cozybit.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger.  Thanks for checking these and for all your recent work
with Libertas!

On Fri, Oct 16, 2009 at 8:41 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> Andrey, can you fix this?  I don't have SPI hardware and wouldn't
> be able to check the functionality after the fixes. However, some
> things are obvious, e.g.
>
>
> u16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
>
> should either be
>
>  reg_out = reg | IF_SPI_WRITE_OPERATION_MASK;
>
> or
>
>  __le16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);

It used to be as per your first suggestion but Sebastian changed it to
the current version in commit f488b72d (he was using a PowerPC-based
SoC and was thus on a BE architecture vs. our LE systems, so it was a
good catch).  Changing it to be a __le16 sounds reasonable.  Are you
in a position to go ahead and make these changes and have me quickly
test your patch (on LE hardware though, unless Sebastian can chime in
and help us)?  I have time to apply and test a patch but unfortunately
I don't have time to nail down all of the sparse warnings you posted
this week.

> Here's a run with sparse:
>
> $ make -C /usr/src/linux-wl/ modules SUBDIRS=drivers/net/wireless/libertas C=2 CF=-D__CHECK_ENDIAN__
> drivers/net/wireless/libertas/if_spi.c:137:16: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/libertas/if_spi.c:137:16:    expected unsigned short [unsigned] [usertype] reg_out
> drivers/net/wireless/libertas/if_spi.c:137:16:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:191:16: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/libertas/if_spi.c:191:16:    expected unsigned short [unsigned] [usertype] reg_out
> drivers/net/wireless/libertas/if_spi.c:191:16:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:256:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:256:24:    expected restricted __le32 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:256:24:    got unsigned int *<noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> --
> http://www.holgerschurig.de
>
