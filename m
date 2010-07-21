Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35470 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0GURaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:30:12 -0400
Date: Wed, 21 Jul 2010 13:19:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pauli Nieminen <suokkos@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
Message-ID: <20100721171926.GE2355@tuxdriver.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
 <1279572443-14361-1-git-send-email-linville@tuxdriver.com>
 <AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
 <20100721133320.GB2355@tuxdriver.com>
 <AANLkTint5uT6PQ8pmEIVSoVYOSCZE5k-TGB1knwHtupw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTint5uT6PQ8pmEIVSoVYOSCZE5k-TGB1knwHtupw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 08:07:56PM +0300, Pauli Nieminen wrote:
> On Wed, Jul 21, 2010 at 4:33 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Wed, Jul 21, 2010 at 08:08:41AM +0300, Pauli Nieminen wrote:
> >> On Mon, Jul 19, 2010 at 11:47 PM, John W. Linville
> >> <linville@tuxdriver.com> wrote:
> >> > The existing code seemed to be somewhat based on the datasheet, but
> >> > varied substantially from the vendor-provided driver.  This mirrors the
> >> > handling of the rtl8185 case from that driver, but still neglects the
> >> > specifics for the rtl8180 hardware.  Those details are a bit muddled...
> >> >
> >> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >> > ---
> >> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
> >> >  1 files changed, 8 insertions(+), 3 deletions(-)
> >
> >> I tested this version of patch. Patch didn't apply cleanly for some
> >> reason even tough when I mnauly typed it diff looks same.
> >
> > Please try the v2 version of the patch.  Some "back of the envelope"
> > math suggests that the v2 version of the patch will give numbers more
> > to your liking.
> >
> > John
> > --
> > John W. Linville                Someday the world will need a hero, and you
> > linville@tuxdriver.com                  might be all we have.  Be ready.
> >
> 
> But version 2 doesn't change the fact that driver is going to report
> same signal strength even tough I know that only one wifi should have
> 100 % strength and others less than 50 %. There is only one router in
> same room with me and all others routers are a lot more father away.
> So driver is either reading wrong bits from hardware or my hardware is
> broken.
 
Did you try the patch?  I suspect not.

I can't really decipher what problem you are reporting here with "100 %
strength and others less than 50 %".  In any case, if you have RTL8185
hardware then this patch changes the signal calculation to match what
the Realtek-provided vendor driver does (which doesn't seem to match
their datasheet, FWIW).  If you have a better source of information
then I am happy to receive it.

If you have RTL8180 (i.e. not RTL8185) hardware then neither version of
the patch is likely to help you much (beyond avoiding the warning you
originally reported).  I hope to improve that as well in the future.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
