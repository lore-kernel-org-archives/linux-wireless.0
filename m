Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr7.hinet.net ([168.95.4.107]:63809 "EHLO msr7.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1FUNJ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:09:28 -0400
Date: Tue, 21 Jun 2011 21:07:52 +0800
From: Ali Bahar <ali@internetdog.org>
To: Fred Plissonneau <cohomewp4@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Makefile deletes previous driver install when two WiFi
 interfaces are from the same chip vendor
Message-ID: <20110621130752.GB8462@internetdog.org> (sfid-20110621_150931_925248_A2CFB7CF)
Reply-To: ali@internetdog.org
References: <BANLkTimvMcb5yRHSE91VPTLdy7k5WEDo0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTimvMcb5yRHSE91VPTLdy7k5WEDo0Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 11:59:17AM +0200, Fred Plissonneau wrote:
> From: Fred Plissonneau <cohomewp4@gmail.com>
> To: linux-wireless@vger.kernel.org
> 
> 
> Anyone can help ?

Not me!
But let me see if I at least understand your problem:

 
> On Tue, Jun 14, 2011 at 4:19 PM, ch wp4 <cohomewp4@gmail.com> wrote:
> > Hello,
> >
> > I am facing an issue during installation of an external USB-WiFi stick
> > on my Linux box (Ubuntu 10.04).
> > Actually, I have already successfully compiled and installed ath9k
> > driver using compat-wireless-2.6.38.2-2.
> > The internal WiFi NIC is fully operational.
> > Now, I want to add temporarily an external USB-WiFi stick (D-Link DWA
> > 160). I've found that this hardware
> > is using an ar9170 chipset and therefore I've recompiled
> > compat-wireless targeting now the carl9170 driver.
> > Once again, this working perfectly.

So you have an on-board ath9k, which does work, and an ar9170 USB
stick, which does work.


> > But when I switch-off and back on my PC, only the latest installed
> > WiFi interface is working.

So only the on-board ath9k fails?


> > Digging into the system, I've found that ath9k has disappeared from the
> > /lib/modules/2.6.32-27-generic/updates/drivers/net/wireless/ath directory.
> > It looks like the 'make install' command is doing some cleaning which

Ha? Why does 'make install' run after a power-cycle?!! That ran only
after you compiled the driver.


> > has, in my particular use case, an undesirable
> > side-effect.
> > Can someone point me to the line in the Makefile causing this problem
> > or is it the desired behaviour ?

Again, the makefile does not come into this. After you've installed
the drivers, you can forget about the makefile.

So are you saying that the ath9k module somehow got deleted from your
file system?

later,
ali
