Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53805 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968Ab2GYPsq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 11:48:46 -0400
Message-ID: <1343231325.1693.13.camel@joe2Laptop> (sfid-20120725_174849_669438_1C08A9C6)
Subject: Re: [PATCH V2] b43: be more user friendly with PHY info
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Date: Wed, 25 Jul 2012 08:48:45 -0700
In-Reply-To: <CACna6rwDo=oW42mEwHXT0M5c56tWWtBqqb+Wv+L0iKzSasux8A@mail.gmail.com>
References: <1343227629-14161-1-git-send-email-zajec5@gmail.com>
	 <1343225435.1693.10.camel@joe2Laptop>
	 <CACna6rwDo=oW42mEwHXT0M5c56tWWtBqqb+Wv+L0iKzSasux8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 16:22 +0200, Rafał Miłecki wrote:
> 2012/7/25 Joe Perches <joe@perches.com>:
> > On Wed, 2012-07-25 at 16:47 +0200, Rafał Miłecki wrote:
> >> use PHY names instead of magic numbers.
> > []
> >> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> > []
> >> @@ -4277,6 +4277,37 @@ out:
> > []
> >> +static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
> >> +{
> >> +     switch (phy_type) {
> >> +     case B43_PHYTYPE_A:
> >> +             return "A";
> > []
> >> +     }
> >> +
> >> +     b43err(dev->wl, "Unknown PHY Type: %d\n", phy_type);
> >> +     return "UNKNOWN";
> >
> > In general, it's a bad idea to emit error messages
> > in a generic call like this.
> 
> This function is not supposed to be called anywhere else, it's only
> for a single user-friendly message.
> 
> 
> >> @@ -4337,13 +4368,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
> >>               unsupported = 1;
> >>       }
> >>       if (unsupported) {
> >> -             b43err(dev->wl, "FOUND UNSUPPORTED PHY "
> >> -                    "(Analog %u, Type %u, Revision %u)\n",
> >> -                    analog_type, phy_type, phy_rev);
> >> +             b43err(dev->wl, "FOUND UNSUPPORTED PHY (Analog %u, Type %s, Revision %u)\n",
> >> +                    analog_type, b43_phy_name(dev, phy_type), phy_rev);
> >
> > The extra message doesn't add much useful info
> > and can also cause errors in continued messages.
> 
> By "extra message" do you mean the one from b43_phy_name? I wanted to
> print PHY type as digit somewhere (in case it is not recognized). I
> can't use simple
> return ("UNKNOWN %d", phy_type);
> , such a solution would require allocating memory for string and
> freeing it. It would complicate the function.
> 
> Do you have any suggestion for better handling this?
> 

Change the UNSUPPORTED PHY message to

	"...Type: %d:(%s)...",
	..., phy_type, b43_phy_name(dev, phy_type), ...


