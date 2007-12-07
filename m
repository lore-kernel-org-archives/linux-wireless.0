Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:64092 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXLGOsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 09:48:07 -0500
Message-ID: <47595D4E.6080901@gentoo.org> (sfid-20071207_144811_599046_34BEC380)
Date: Fri, 07 Dec 2007 14:48:46 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: David Miller <davem@davemloft.net>, jt@hpl.hp.com,
	shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <20071206214341.GA6821@bougret.hpl.hp.com> <200712071235.11969.mb@bu3sch.de> <20071207.043407.72593148.davem@davemloft.net> <200712071436.08954.mb@bu3sch.de>
In-Reply-To: <200712071436.08954.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
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

Please correct me if I'm wrong, but adding the "packed" attribute causes 
gcc to generate extra instructions to avoid the potentially unaligned 
accesses.
(i.e. it basically does put_aligned/get_unaligned automatically)

Daniel
