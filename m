Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51967 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754615AbcILMYA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 08:24:00 -0400
Message-ID: <1473683031.2930.3.camel@hadess.net> (sfid-20160912_142404_766612_1A650671)
Subject: Re: Support of rtl8723bs
From: Bastien Nocera <hadess@hadess.net>
To: Hanno Zulla <abos@hanno.de>, linux-wireless@vger.kernel.org,
        Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, anthony.wong@canonical.com
Date: Mon, 12 Sep 2016 14:23:51 +0200
In-Reply-To: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-12 at 11:20 +0200, Hanno Zulla wrote:
> Hi Jes,
> hello linux-wireless,
> 
> I'd like to know more about the current progress of rtl8723bs support
> for Linux.
> 
> Googling and reading the mailing list archives found an older vendor
> driver
> https://github.com/hadess/rtl8723bs

This is the canonical location.

> plus patches at
> https://github.com/lwfinger/rtl8723bs

This is an old tree.

> which both aren't ready for Linux according to
> https://github.com/hadess/rtl8723bs/issues/96
> 
> According to
> https://github.com/hadess/rtl8723bs/issues/98
> 
> there is a newer vendor driver from Realtek at
> https://github.com/anthonywong/rtl8723bs
> which Anthony wants to get ready for inclusion to the Ubuntu kernel.
> 
> But after reading
> https://marc.info/?l=linux-wireless&m=146902477024130&w=2
> it appears that even that newer vendor driver isn't ready for Jes's
> work.

The "hadess" driver above is an older vendor driver with 2 years of
cleanups, and lots of code removal:
 430 files changed, 81387 insertions(+), 254812 deletions(-)

Anthony's repo is just a dump of a newer version of the driver.

What would be useful would be to compare the newer vendor driver with
the last time the "hadess" driver was rebased
(a2e5bb366f6d6c19dcab6db47b68a944256e8228) and pick out bug fixes.

Anyway, as an owner of such a device, I'd like to help somehow, and
be
> it as a guinea pig to test on my hardware. The newer vendor driver
> crashed on Ubuntu' 4.4 sources and doesn't compile yet on Ubuntu 4.8-
> rc
> sources.
> https://github.com/anthonywong/rtl8723bs/issues/1

I really don't care about the vendor driver. There's no way to track
changes other than through code dumps.

Longer term, it seems likely that improving Jes' driver is the way to
go. At least there's 170k less lines of code to read in the rtl8723bs
driver to get things going.

Cheers
