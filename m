Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1LMPiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 10:38:13 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE64522.5090107@gmx.net> (sfid-20111212_191739_160874_7027323F)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>
	 <4EE35877.1060507@gmx.net>
	 (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>
	 <4EE5D2D3.406@gmx.net>
	 (sfid-20111212_110955_792336_68917631) <1323684754.3442.36.camel@jlt3.sipsolutions.net>
	 <4EE5E3CD.1070409@gmx.net>
	 (sfid-20111212_122224_090419_DF83BB07) <1323712082.3442.43.camel@jlt3.sipsolutions.net>
	 <4EE64522.5090107@gmx.net> (sfid-20111212_191739_160874_7027323F)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 16:38:08 +0100
Message-ID: <1323790688.3355.24.camel@jlt3.sipsolutions.net> (sfid-20111213_163817_059702_C83869AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 19:17 +0100, Wolfgang Breyha wrote:
> On 2011-12-12 18:48, Johannes Berg wrote:
> > A colleague pointed out that due to the PCI address space hold we might
> > be seeing larger addresses -- could you try booting the 32 bit kernel
> > with "mem=3G" on the command line (edit it in grub maybe?) and see if
> > you can still reproduce it then?
> 
> mem=3G changes nothing except the amount of memory;-) Exactly the same
> issues occur.

Hm, unfortunately, I can't reproduce this problem, even with 2 minute
GTK rekey intervals. Could you run this program on your machine while
you reproduce it?

http://johannes.sipsolutions.net/files/mc.c.txt

(just save as "mc.c" and compile with gcc mc.c -o mc)

The program will allocate 2GiB memory (edit to suit, should be OK on
your machine), fill them with 0x94 and then continually scan them for
corruption. Identifying what kind of corruption happened will hopefully
allow me to figure out where it's coming from.

It prints out the wrong data & resets the memory so new corruption later
is also identified.

Thanks!

johannes

