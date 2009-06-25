Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47694 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFYUez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 16:34:55 -0400
Received: by bwz9 with SMTP id 9so1659518bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2009 13:34:56 -0700 (PDT)
Received: from rz by localhost.localdomain with local (Exim 4.69)
	(envelope-from <rz@linux-m68k.org>)
	id 1MJvd5-0001HQ-K8
	for linux-wireless@vger.kernel.org; Thu, 25 Jun 2009 22:33:07 +0200
Date: Thu, 25 Jun 2009 22:33:07 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-wireless@vger.kernel.org
Subject: rt2x00/rt73usb random memory corruption
Message-ID: <20090625203307.GA4476@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

tried to pin down the occassional mysterious crashes. The crashes occur in several
different places, but almost allways the culprit  is a "CR2: 00000000000d5a0b" which
in my configuration causes an illegal access.

As the kernel mostly survives the boot this gave me the opportunity to look at the 
live kernel  - interestingly a quick grep of /proc/kcore allways shows exactly one 
instance of 000d5a0b. In all cases it looks it did overwrite something else that was
supposed to be at that place and just these 4 bytes were modified.

Looking at the addreses that were modified did not yield any interesting patterns
(like page/struct offsets) that would give me any hint. Seems like in the case I looked 
at some module ELF information was overwritten, this was during boot so the address
to this location was quite likely found somewhere on the stack?

So far no luck to provoke a crash at the place where the memory corruption happens.

Any ideas? Given that the destination location is probably picked from the stack
- has anyone experience with trying various stack alignments in kernel code?

Here is 2 examples of memory blocks that get overwritten..

Case 1:
*
6621354520 6978652e 65742e74 00007478 00000000
6621354540 696e692e 65742e74 00007478 00000000
6621354560 646f722e 2e617461 31727473 0000312e
6621354600 736b5f5f 61746d79 70675f62 0000006c
6621354620 636b5f5f 61746372 70675f62 0000006c
6621354640 74636573 736e6f69 00000000 00000000
6621354660 f645bef0 f8178020 00000000 00000000
6621354700 f645b7c0 f8235020 00000000 00000000
6621354720 6978652e 65742e74 00007478 00000000
6621354740 f645bf40 f8178020 00000000 00000000
6621354760 f645bff0 f8178020 00000000 00000000
6621355000 f645b740 f8178020 00000000 00000000
6621355020 00000000 00002c0c 00000786 0006b651
6621355040 ** 000d5a0b ** 61726665 70695f67 00003476 ******
***6621355040  \v Z \r \0  e   f   r   a   g   _   i   p   v   4  \0  \0   *******
6621355060 646f722e 2e617461 31727473 0000312e
6621355100 75625f5f 61745f67 00656c62 00000000
6621355120 74636573 736e6f69 00000000 00000000
6621355140 6978652e 65742e74 33007478 00627375
6621355160 696e692e 65742e74 00007478 00000000
6621355200 645f666e 61726665 70695f67 00003476
6621355220 61726170 6574656d 00007372 00000000
6621355240 f645bbd0 f645b180 f8db9bc8 00000000

same with od -c

6621354520   .   e   x   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621354540   .   i   n   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621354560   .   r   o   d   a   t   a   .   s   t   r   1   .   1  \0  \0
6621354600   _   _   k   s   y   m   t   a   b   _   g   p   l  \0  \0  \0
6621354620   _   _   k   c   r   c   t   a   b   _   g   p   l  \0  \0  \0
6621354640   s   e   c   t   i   o   n   s  \0  \0  \0  \0  \0  \0  \0  \0
6621354660 360 276   E 366     200 027 370  \0  \0  \0  \0  \0  \0  \0  \0
6621354700 300 267   E 366       P   # 370  \0  \0  \0  \0  \0  \0  \0  \0
6621354720   .   e   x   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621354740   @ 277   E 366     200 027 370  \0  \0  \0  \0  \0  \0  \0  \0
6621354760 360 277   E 366     200 027 370  \0  \0  \0  \0  \0  \0  \0  \0
6621355000   @ 267   E 366     200 027 370  \0  \0  \0  \0  \0  \0  \0  \0
6621355020  \0  \0  \0  \0  \f   ,  \0  \0 206  \a  \0  \0   Q 266 006  \0
6621355040  \v   Z  \r  \0   e   f   r   a   g   _   i   p   v   4  \0  \0   *******
6621355060   .   r   o   d   a   t   a   .   s   t   r   1   .   1  \0  \0
6621355100   _   _   b   u   g   _   t   a   b   l   e  \0  \0  \0  \0  \0
6621355120   s   e   c   t   i   o   n   s  \0  \0  \0  \0  \0  \0  \0  \0
6621355140   .   e   x   i   t   .   t   e   x   t  \0   3   u   s   b  \0
6621355160   .   i   n   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621355200   n   f   _   d   e   f   r   a   g   _   i   p   v   4  \0  \0
6621355220   p   a   r   a   m   e   t   e   r   s  \0  \0  \0  \0  \0  \0
6621355240 320 273   E 366 200 261   E 366 310 233 333 370  \0  \0  \0  \0
6621355260 270 207 327 370 270 207 327 370 310 233 333 370  \0  \0  \0  \0




Case 2:

6621133760 f64495f0 f6b08b00 f8f6fbc8 00000000
6621134000 f8ee67b8 f8ee67b8 f8f6fbc8 00000000
6621134020 f8b4d964 f6b08b20 f8f6fbc8 00000000
6621134040 61726170 6574656d 00007372 00000000
6621134060 6978652e 65742e74 33007478 00627375
6621134100 696e692e 65742e74 00007478 00000000
6621134120 646f722e 2e617461 31727473 0000312e
6621134140 f8fe672c f8fe672c f9070740 00000000
6621134160 74636573 736e6f69 00000000 00000000
6621134200 00000000 00002c0c 00000786 0006b651
6621134220 *** 000d5a0b 636f6c6c 78616d5f 00000000 ****
6621134240 f64497c0 f8fc7cb4 f9070740 00000000
6621134260 75625f5f 61745f67 00656c62 00000000
6621134300 6e757278 6265645f 00006775 00000000
6621134320 61657270 636f6c6c 00000000 00000000
6621134340 645f666e 61726665 70695f67 00003476


same with od -c

6621133760 360 225   D 366  \0 213 260 366 310 373 366 370  \0  \0  \0  \0
6621134000 270   g 356 370 270   g 356 370 310 373 366 370  \0  \0  \0  \0
6621134020   d 331 264 370     213 260 366 310 373 366 370  \0  \0  \0  \0
6621134040   p   a   r   a   m   e   t   e   r   s  \0  \0  \0  \0  \0  \0
6621134060   .   e   x   i   t   .   t   e   x   t  \0   3   u   s   b  \0
6621134100   .   i   n   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621134120   .   r   o   d   a   t   a   .   s   t   r   1   .   1  \0  \0
6621134140   ,   g 376 370   ,   g 376 370   @  \a  \a 371  \0  \0  \0  \0
6621134160   s   e   c   t   i   o   n   s  \0  \0  \0  \0  \0  \0  \0  \0
6621134200  \0  \0  \0  \0  \f   ,  \0  \0 206  \a  \0  \0   Q 266 006  \0
6621134220  \v   Z  \r  \0   l   l   o   c   _   m   a   x  \0  \0  \0  \0 ********
6621134240 300 227   D 366 264   | 374 370   @  \a  \a 371  \0  \0  \0  \0
6621134260   _   _   b   u   g   _   t   a   b   l   e  \0  \0  \0  \0  \0
6621134300   x   r   u   n   _   d   e   b   u   g  \0  \0  \0  \0  \0  \0
6621134320   p   r   e   a   l   l   o   c  \0  \0  \0  \0  \0  \0  \0  \0
6621134340   n   f   _   d   e   f   r   a   g   _   i   p   v   4  \0  \0
6621134360 270 322 304 302 354 322 304 302     340 304 302   T 340 304 302
6621134400   .   e   x   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621134420   p   a   r   a   m   e   t   e   r   s  \0  \0  \0  \0  \0  \0
6621134440   .   e   x   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621134460   .   i   n   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621134500   .   s   m   p   _   l   o   c   k   s  \0  \0  \0  \0  \0  \0
6621134520   s   e   c   t   i   o   n   s  \0  \0  \0  \0  \0  \0  \0  \0
6621134540   _   _   k   s   y   m   t   a   b   _   g   p   l  \0  \0  \0
6621134560   s   n   d   _   h   d   a   _   i   n   t   e   l  \0  \0  \0
6621134600   _   _   k   c   r   c   t   a   b   _   g   p   l  \0  \0  \0
6621134620   n   f   _   d   e   f   r   a   g   _   i   p   v   4  \0  \0
6621134640   _   _   k   c   r   c   t   a   b   _   g   p   l  \0  \0  \0
6621134660   _   _   k   s   y   m   t   a   b   _   g   p   l  \0  \0  \0
*
6621134720  \0 220   D 366 320 224   D 366   t 034 373 370  \0  \0  \0  \0
6621134740 310   O 021 370 310   O 021 370 020   O 264 370  \0  \0  \0  \0
6621134760   r   t   2   x   0   0   l   i   b  \0  \0  \0  \0  \0  \0  \0
6621135000     317  \t 367 354 322 005 370 020   O 264 370  \0  \0  \0  \0
6621135020   s   n   d   _   h   d   a   _   i   n   t   e   l  \0  \0  \0
6621135040 030 367 200 370 020 226   D 366 020   O 264 370  \0  \0  \0  \0
6621135060   r   t   2   x   0   0   l   i   b  \0  \0  \0  \0  \0  \0  \0
6621135100   .   i   n   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621135120   .   r   o   d   a   t   a   .   s   t   r   1   .   1  \0  \0
6621135140   s   n   d   _   h   d   a   _   i   n   t   e   l  \0  \0  \0
6621135160   .   i   n   i   t   .   t   e   x   t  \0  \0  \0  \0  \0  \0
6621135200   r   t   2   x   0   0   l   i   b  \0  \0  \0  \0  \0  \0  \0
*
6621135240   s   n   d   _   h   d   a   _   i   n   t   e   l  \0  \0  \0
6621135260   T 240 375 370 220 224   D 366   t 034 373 370  \0  \0  \0  \0
6621135300   s   e   c   t   i   o   n   s  \0  \0  \0  \0  \0  \0  \0  \0


Richard
