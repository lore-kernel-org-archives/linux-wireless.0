Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29278 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYLAVKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 16:10:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 13:10:16 -0800
Date: Mon, 1 Dec 2008 13:10:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tony Vroon <tony@linx.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Allow CRDA to be compiled with -Wl,--as-needed
Message-ID: <20081201211014.GO5992@tesla> (sfid-20081201_221021_807674_63334D8B)
References: <20081130161758.883321007B@gold.linx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081130161758.883321007B@gold.linx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 30, 2008 at 08:17:58AM -0800, Tony Vroon wrote:
> As libraries are passed in LDFLAGS, it is vital that they be specified after the object
> files. Otherwise, --as-needed will discard the libraries as unused and linking will fail.
> 
> Signed-off-by: Tony Vroon <tony@linx.net>
> 
> --- crda-0.9.4/Makefile.orig    2008-11-27 14:44:02.000000000 +0000
> +++ crda-0.9.4/Makefile 2008-11-27 14:45:59.000000000 +0000
> @@ -35,15 +35,15 @@
> 
>  crda: keys-ssl.c keys-gcrypt.c reglib.o crda.o
>         $(NQ) '  LD  ' $@
> -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) `pkg-config --libs libnl-1` -o $@ reglib.o crda.o
> +       $(Q)$(CC) $(CFLAGS) `pkg-config --libs libnl-1` -o $@ reglib.o crda.o $(LDFLAGS)
> 
>  regdbdump: keys-ssl.c keys-gcrypt.c reglib.o regdbdump.o
>         $(NQ) '  LD  ' $@
> -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o
> +       $(Q)$(CC) $(CFLAGS) -o $@ reglib.o regdbdump.o $(LDFLAGS)
> 
>  intersect: keys-ssl.c keys-gcrypt.c reglib.o intersect.o
>         $(NQ) '  LD  ' $@
> -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o
> +       $(Q)$(CC) $(CFLAGS) -o $@ reglib.o intersect.o $(LDFLAGS)
> 
>  verify: $(REG_BIN) regdbdump
>         $(NQ) '  CHK  $(REG_BIN)'

Thanks Diego's patch came in first, I'll apply that, please pull in few
minutes to get all the new updates.

  Luis
