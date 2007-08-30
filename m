Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:8233 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbXH3Wde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 18:33:34 -0400
Received: by nf-out-0910.google.com with SMTP id f5so575041nfh
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2007 15:33:33 -0700 (PDT)
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: [PATCH] Don't needlessly initialize variable to NULL in zd_chip   (was: Re: [PATCH 13/30] net: Don't do pointless kmalloc return value casts in zd1211 driver)
Date: Fri, 31 Aug 2007 00:30:31 +0200
Cc: Daniel Drake <dsd@gentoo.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <9a8748490708301320o49d8e794vc5c37ffc938006f1@mail.gmail.com> <1188512393.6062.156.camel@localhost>
In-Reply-To: <1188512393.6062.156.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708310030.31713.jesper.juhl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 August 2007 00:19:53 Joe Perches wrote:
> On Thu, 2007-08-30 at 22:20 +0200, Jesper Juhl wrote:
> > Ok, I must admit I didn't check with sparse since it seemed pointless
> > - we usually never cast void pointers to other pointer types,
> > specifically because the C language nicely guarantees that the right
> > thing will happen without the cast.  Sometimes we have to cast them to
> > integer types, su sure we need the cast there.   But what on earth
> > makes a "zd_addr_t *" so special that we have to explicitly cast a
> > "void *" to that type?
> 
> http://marc.info/?l=linux-netdev&m=117113743902549&w=1
> 

Thank you for that link Joe.

I'm not sure I agree with the __nocast, but I respect that this is 
the maintainers choice.

But, I still think the first chunk of the patch that removes the 
initial variable initialization makes sense. 
Initializing the variable to NULL is pointless since it'll never be
used before the kmalloc() call. So here's a revised patch that just
gets rid of that little detail.



No need to initialize to NULL when variable is never used before 
it's assigned the return value of a kmalloc() call.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index c39f198..30872fe 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -106,7 +106,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 {
 	int r;
 	int i;
-	zd_addr_t *a16 = (zd_addr_t *)NULL;
+	zd_addr_t *a16;
 	u16 *v16;
 	unsigned int count16;
 


