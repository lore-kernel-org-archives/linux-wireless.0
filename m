Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19822 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760633AbYCSTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: Marvell 88w8335 [Libertas]
Date: Wed, 19 Mar 2008 11:24:03 +0100
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
In-Reply-To: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803191124.03743.hs4233@mail.mn-solutions.de> (sfid-20080319_195444_941878_74A0B78A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The module loads (does not bail out in the interrupt handler)
> and creates the devices:
...
> It is not yet fully working, however. The card does not seem
> to react on the scanning/set_channel commands:

This mailing list is more for the 838x chips, but we don't have a 
problem with occassional 833x e-mail traffic here.


However, my advice is the following: As long as the driver's home 
is on some "obscure" tar files, it will always suffer from 
bitrot and not-so-much contribution by third partis. So aim to 
bring the driver into the linux kernel. Talk with John W. 
Linville on the linux-wireless mailing list about this. 
http://linuxwireless.org should give you pointers. For drivers, 
sometimes Linux accepts even not-so-good-code, when there is a 
chance that the beast get's better via re-factoring over time.

When if_cs.c went into the in-kernel-libertas driver, a few 
people that I never heard of found errors or sent bugfixes.


Second advice: I think the BSD people (FreeBSD possible) have a 
m8k driver in their kernel tree. As I have heard, this beast 
actually works. So either look there for inspiration or try 
*BSD, pepper the code with debug printks and try to understand 
the differences between their code and the current linux code.
