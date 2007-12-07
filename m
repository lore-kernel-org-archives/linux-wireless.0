Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51220 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbXLGNiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 08:38:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Date: Fri, 7 Dec 2007 14:36:08 +0100
Cc: jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
References: <20071206214341.GA6821@bougret.hpl.hp.com> <200712071235.11969.mb@bu3sch.de> <20071207.043407.72593148.davem@davemloft.net>
In-Reply-To: <20071207.043407.72593148.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200712071436.08954.mb@bu3sch.de> (sfid-20071207_133827_181650_4F08DD05)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 December 2007 13:34:07 David Miller wrote:
> From: Michael Buesch <mb@bu3sch.de>
> Date: Fri, 7 Dec 2007 12:35:11 +0100
> 
> > So, how do we handle unaligned data in userspace then?
> > A _lot_ of applications are broken if that's right what you say.
> 
> Applications make sure data is always properly aligned, that's how
> it's handled.  I don't see what the big mystery is. :-)

That's not always possible. For example if we are handling
some kind of wire protocol data.

let's give you some real world example: b43-fwcutter

The wire protocol for the iv files is the following structure:

struct b43_iv {
	be16 a;
	union {
		be16 x;
		be32 y;
	} ((attr_packed));
} ((attr_packed));

How do I handle that in userspace? In kernel space it's simple
(and we already use get_unaligned() for the 32bit value there).

-- 
Greetings Michael.
