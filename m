Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48994
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbXLHBfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 20:35:45 -0500
Date: Fri, 07 Dec 2007 17:35:44 -0800 (PST)
Message-Id: <20071207.173544.98612200.davem@davemloft.net> (sfid-20071208_013551_179104_C8D7F507)
To: mb@bu3sch.de
Cc: jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712071436.08954.mb@bu3sch.de>
References: <200712071235.11969.mb@bu3sch.de>
	<20071207.043407.72593148.davem@davemloft.net>
	<200712071436.08954.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>
Date: Fri, 7 Dec 2007 14:36:08 +0100

> The wire protocol for the iv files is the following structure:
> 
> struct b43_iv {
> 	be16 a;
> 	union {
> 		be16 x;
> 		be32 y;
> 	} ((attr_packed));
> } ((attr_packed));
> 
> How do I handle that in userspace? In kernel space it's simple
> (and we already use get_unaligned() for the 32bit value there).

If you marked it packed, on platforms like sparc, MIPS, and IA-64, the
compiler is only going to use byte loads and stores to objects of this
type.

You don't need to use get_unaligned() on members of structures that
are marked packed.

If you look at the asm-generic/unaligned.h pure-C implementation,
it uses the packed attribute, which really shows how redundant it
is to use get_unaligned() on packed structure member access :-)
