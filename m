Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:38838 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab3GTTlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 15:41:12 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: Larry Finger <Larry.Finger@lwfinger.net>
Reply-To: thomas@fjellstrom.ca
Cc: linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: wil6210 driver compilation failure
Date: Sat, 20 Jul 2013 13:40:21 -0600
Message-ID: <1546638.YtIzlZyRv2@balsa> (sfid-20130720_214115_386425_77B0F5B3)
In-Reply-To: <51EAE191.90401@lwfinger.net>
References: <6363399.uASIm9rubl@balsa> <51EAE191.90401@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat 20 July 2013 14:14:25 Larry Finger wrote:
> On 07/20/2013 01:37 PM, Thomas Fjellstrom wrote:
> > Hi,
> > 
> > Recently while trying to figure out a separate issue, I did a
> > make allmodconfig and a make oldconfig with debian's default config on
> > the 3.10.1 kernel, and debian's config with 3.10.0.
> > 
> > It failed in the wil6210 driver.
> > 
> > The system it failed on is running a fresh install of Debian Sid, with gcc
> > 4.8.1.
> > 
> > This is the error I got:
> >    CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
> > 
> > drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_print_ringâ:
> > drivers/net/wireless/ath/wil6210/debugfs.c:163:11: error: pointer targets
> > in passing argument 5 of âhex_dump_to_bufferâ differ in signedness
> > [-Werror=pointer-sign]> 
> >             false);
> >             ^
> > 
> > In file included from include/linux/kernel.h:13:0,
> > 
> >                   from include/linux/cache.h:4,
> >                   from include/linux/time.h:4,
> >                   from include/linux/stat.h:18,
> >                   from include/linux/module.h:10,
> > 
> >                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> > include/linux/printk.h:361:13: note: expected âchar *â but argument is of
> > type âunsigned char *â> 
> >   extern void hex_dump_to_buffer(const void *buf, size_t len,
> >   
> >               ^
> > 
> > drivers/net/wireless/ath/wil6210/debugfs.c: In function
> > âwil_txdesc_debugfs_showâ:
> > drivers/net/wireless/ath/wil6210/debugfs.c:429:10: error: pointer targets
> > in passing argument 5 of âhex_dump_to_bufferâ differ in signedness
> > [-Werror=pointer-sign]> 
> >            sizeof(printbuf), false);
> >            ^
> > 
> > In file included from include/linux/kernel.h:13:0,
> > 
> >                   from include/linux/cache.h:4,
> >                   from include/linux/time.h:4,
> >                   from include/linux/stat.h:18,
> >                   from include/linux/module.h:10,
> > 
> >                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> > include/linux/printk.h:361:13: note: expected âchar *â but argument is of
> > type âunsigned char *â> 
> >   extern void hex_dump_to_buffer(const void *buf, size_t len,
> >   
> >               ^
> > 
> > cc1: all warnings being treated as errors
> > make[5]: *** [drivers/net/wireless/ath/wil6210/debugfs.o] Error 1
> > make[4]: *** [drivers/net/wireless/ath/wil6210] Error 2
> > make[3]: *** [drivers/net/wireless/ath] Error 2
> > make[2]: *** [drivers/net/wireless] Error 2
> > make[1]: *** [drivers/net] Error 2
> > make: *** [drivers] Error 2
> > 
> > please excuse the mangled quotes, fresh install and I negelected to set up
> > the locale properly. It's fixed now, but it seems I need to restart X for
> > it to notice.
> 
> This error should be fixed by the attached patch. Please test.
> 
> Note that my system did not issue a warning for this "problem". It seems we
> have different warnings turned on in the compiler.

The warnings have gone away, and the first error, but the second one is still 
there.

> Larry
-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
