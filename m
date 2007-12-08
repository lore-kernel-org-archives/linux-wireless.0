Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47728 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXLHLXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:23:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Date: Sat, 8 Dec 2007 12:21:50 +0100
Cc: jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
References: <200712071235.11969.mb@bu3sch.de> <200712071436.08954.mb@bu3sch.de> <20071207.173544.98612200.davem@davemloft.net>
In-Reply-To: <20071207.173544.98612200.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712081221.50684.mb@bu3sch.de> (sfid-20071208_112348_038237_9246BAA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 December 2007 02:35:44 David Miller wrote:
> From: Michael Buesch <mb@bu3sch.de>
> Date: Fri, 7 Dec 2007 14:36:08 +0100
> 
> > The wire protocol for the iv files is the following structure:
> > 
> > struct b43_iv {
> > 	be16 a;
> > 	union {
> > 		be16 x;
> > 		be32 y;
> > 	} ((attr_packed));
> > } ((attr_packed));
> > 
> > How do I handle that in userspace? In kernel space it's simple
> > (and we already use get_unaligned() for the 32bit value there).
> 
> If you marked it packed, on platforms like sparc, MIPS, and IA-64, the
> compiler is only going to use byte loads and stores to objects of this
> type.
> 
> You don't need to use get_unaligned() on members of structures that
> are marked packed.
> 
> If you look at the asm-generic/unaligned.h pure-C implementation,
> it uses the packed attribute, which really shows how redundant it
> is to use get_unaligned() on packed structure member access :-)

Uhm, ok.
But I guess then I'm not the only one who got all this wrong. ;)

-- 
Greetings Michael.
