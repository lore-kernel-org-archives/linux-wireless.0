Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:42691 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab3EQGTm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 02:19:42 -0400
Date: Fri, 17 May 2013 08:00:42 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Ignacy Gawedzki <i@lri.fr>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
Message-ID: <20130517060042.GA21663@sig21.net> (sfid-20130517_081953_783463_4D73AAB6)
References: <20130515134258.GA9033@zenon.in.qult.net>
 <5194DEB3.2060407@rempel-privat.de>
 <20130516172030.GD21850@zenon.in.qult.net>
 <51951B90.70909@rempel-privat.de>
 <20130516185030.GB16833@zenon.in.qult.net>
 <20130516234857.GA17867@zenon.in.qult.net>
 <20130516234526.GH3795@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130516234526.GH3795@alittletooquiet.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 16, 2013 at 07:45:26PM -0400, Forest Bond wrote:
> On Fri, May 17, 2013 at 01:48:57AM +0200, Ignacy Gawedzki wrote:
> > On Thu, May 16, 2013 at 08:50:30PM +0200, thus spake Ignacy Gawedzki:
> > > I'll try on yet another one and will tell you the results.
> > 
> > Just tried on ICH7, same thing.  The easiest way to reproduce the bug is to
> > boot into single user mode ("recovery mode" on Ubuntu), in order to prevent
> > any NetworkManager or udev from interfering.  Then, without any attempt to up
> > the interface, reboot the system by typing "reboot" in a root shell.
> 
> FWIW, this has also been a problem for me on Ubuntu 12.04.  I can reproduce it
> the same way.

FWIW, I also met this problem after I added ath9k_htc
to my initrd (via /etc/initramfs-tools/modules).
So I removed it and the issue went away.  I first
noticed it after resume from suspend-to-disk, but
later found it doesn't work after warm reboot, too.
The mainboard has Intel H77 chipset, the TL-WN722N is
plugged into USB2.0 port.


Johannes
