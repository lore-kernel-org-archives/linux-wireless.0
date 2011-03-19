Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48958 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab1CSCDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 22:03:15 -0400
Received: by bwz15 with SMTP id 15so3815481bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 19:03:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: Dividing by a non-static value in carl9170-fw?
Date: Sat, 19 Mar 2011 03:03:06 +0100
Cc: linux-wireless@vger.kernel.org
References: <20110116031600.GA21973@zenon.in.qult.net> <201103190143.27042.chunkeey@googlemail.com> <20110319012244.GA4157@zenon.in.qult.net>
In-Reply-To: <20110319012244.GA4157@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_b7AhNqTUE5y4bJZ"
Message-Id: <201103190303.07310.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_b7AhNqTUE5y4bJZ
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

On Saturday 19 March 2011 02:22:44 Ignacy Gawedzki wrote:
> On Sat, Mar 19, 2011 at 01:43:26AM +0100, thus spake Christian Lamparter:
> > I gave it a try and It worked?!
> > 
> > [54670.551750] ieee80211 phy14: FW: a:0x4537 b:0x2c a/b:0x192 (0x192 = 402).
> > 
> > (It was nothing else than just define "a" and "b" (as global variables) and
> > add the INFO("a:0x%x b:0x%x a/b:0x%x", a, b, a/b);)
> 
> I suppose in your case the values are known at compile time and the compiler
> does the calculation statically.
sometimes its just down to "luck" ;)

> If you define the global variables as volatile, then the optimization is
> forbidden and you should get the bogus results.

???
No, "global" is enough. As long as you don't select "const".
(In fact there's more of a story behind "const volatile"
than you might think, or have you ever wondered why carl9170
still ships with gcc 4.4 instead of 4.5? Anyway that's OT)
 
> BTW, I used udivsi3_i4i.S from the Linux kernel, modified it as you indicated.
> Please find my version attached.
You are right, I can reproduce your problem with the attached udiv.
The crux is seems to be "hidden" inside the kernel's Makefile:

>udivsi3-y                       := udivsi3_i4i-Os.o
>
>ifneq ($(CONFIG_CC_OPTIMIZE_FOR_SIZE),y)
>udivsi3-$(CONFIG_CPU_SH3)       := udivsi3_i4i.o
>udivsi3-$(CONFIG_CPU_SH4)       := udivsi3_i4i.o
>endif

It looks like the version you are using is "made" for SH3+,
however the AR9170 has a SH2. (Jup, I can't believe it either :-D)

Best Regards,
	Chr

(didn't really bother with the "signed" div.)

--Boundary-00=_b7AhNqTUE5y4bJZ
Content-Type: text/x-csrc;
  charset="UTF-8";
  name="udivsi3_i4i-Os.S"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="udivsi3_i4i-Os.S"

/* Copyright (C) 2006 Free Software Foundation, Inc.

This file is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2, or (at your option) any
later version.

In addition to the permissions in the GNU General Public License, the
Free Software Foundation gives you unlimited permission to link the
compiled version of this file into combinations with other programs,
and to distribute those combinations without any restriction coming
from the use of this file.  (The General Public License restrictions
do apply in other respects; for example, they cover modification of
the file, and distribution when not linked into a combine
executable.)

This file is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; see the file COPYING.  If not, write to
the Free Software Foundation, 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.  */

/* Moderately Space-optimized libgcc routines for the Renesas SH /
   STMicroelectronics ST40 CPUs.
   Contributed by J"orn Rennecke joern.rennecke@st.com.  */

/* Size: 186 bytes jointly for udivsi3_i4i and sdivsi3_i4i
   sh4-200 run times:
   udiv small divisor: 55 cycles
   udiv large divisor: 52 cycles
   sdiv small divisor, positive result: 59 cycles
   sdiv large divisor, positive result: 56 cycles
   sdiv small divisor, negative result: 65 cycles (*)
   sdiv large divisor, negative result: 62 cycles (*)
   (*): r2 is restored in the rts delay slot and has a lingering latency
        of two more cycles.  */
	.balign 4
	.global	___udivsi3_i4i
	.global	___sdivsi3_i4i
	.global	___udivsi3_i4
	.set	___udivsi3_i4, ___udivsi3_i4i
	.type	___udivsi3_i4i, @function
	.type	___sdivsi3_i4i, @function
___udivsi3_i4i:
___sdivsi3_i4i:
	sts pr,r1
	mov.l r4,@-r15
	extu.w r5,r0
	cmp/eq r5,r0
	swap.w r4,r0
	shlr16 r4
	bf/s large_divisor
	div0u
	mov.l r5,@-r15
	shll16 r5
sdiv_small_divisor:
	div1 r5,r4
	bsr div6
	div1 r5,r4
	div1 r5,r4
	bsr div6
	div1 r5,r4
	xtrct r4,r0
	xtrct r0,r4
	bsr div7
	swap.w r4,r4
	div1 r5,r4
	bsr div7
	div1 r5,r4
	xtrct r4,r0
	mov.l @r15+,r5
	swap.w r0,r0
	mov.l @r15+,r4
	jmp @r1
	rotcl r0
div7:
	div1 r5,r4
div6:
	            div1 r5,r4; div1 r5,r4; div1 r5,r4
	div1 r5,r4; div1 r5,r4; rts;        div1 r5,r4

divx3:
	rotcl r0
	div1 r5,r4
	rotcl r0
	div1 r5,r4
	rotcl r0
	rts
	div1 r5,r4

large_divisor:
	mov.l r5,@-r15
sdiv_large_divisor:
	xor r4,r0
	.rept 4
	rotcl r0
	bsr divx3
	div1 r5,r4
	.endr
	mov.l @r15+,r5
	mov.l @r15+,r4
	jmp @r1
	rotcl r0

	.global	__sdivsi3_i4i
	.global __sdivsi3_i4
	.global __sdivsi3
	.set	__sdivsi3_i4, __sdivsi3_i4i
	.set	__sdivsi3, __sdivsi3_i4i
__sdivsi3_i4i:
	mov.l r4,@-r15
	cmp/pz r5
	mov.l r5,@-r15
	bt/s pos_divisor
	cmp/pz r4
	neg r5,r5
	extu.w r5,r0
	bt/s neg_result
	cmp/eq r5,r0
	neg r4,r4
pos_result:
	swap.w r4,r0
	bra sdiv_check_divisor
	sts pr,r1
pos_divisor:
	extu.w r5,r0
	bt/s pos_result
	cmp/eq r5,r0
	neg r4,r4
neg_result:
	mova negate_result,r0
	;
	mov r0,r1
	swap.w r4,r0
	lds r2,macl
	sts pr,r2
sdiv_check_divisor:
	shlr16 r4
	bf/s sdiv_large_divisor
	div0u
	bra sdiv_small_divisor
	shll16 r5
	.balign 4
negate_result:
	neg r0,r0
	jmp @r2
	sts macl,r2

--Boundary-00=_b7AhNqTUE5y4bJZ--
