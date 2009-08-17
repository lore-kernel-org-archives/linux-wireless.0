Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:43289 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZHQUDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 16:03:35 -0400
Received: by fg-out-1718.google.com with SMTP id e21so726079fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 13:03:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090817195607.GJ5500@tuxdriver.com>
References: <4A85AD1B.1060008@gmail.com> <69e28c910908171233l75b4f72cq8981fb048ad8ffbb@mail.gmail.com>
	<20090817195607.GJ5500@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 17 Aug 2009 22:03:16 +0200
Message-ID: <69e28c910908171303m69a575f0kad6e32592d3184ea@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix reading old mode in the set TX power
	control routine
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/17 John W. Linville <linville@tuxdriver.com>:
> On Mon, Aug 17, 2009 at 09:33:06PM +0200, Gábor Stefanik wrote:
>> 2009/8/14 Gábor Stefanik <netrolller.3d@gmail.com>:
>> > Check the mode the hardware is in, not the mode we used the last time.
>> >
>> > Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> > ---
>> > Mark, please test if this fixes the TX power control WARN_ON you were
>> > seeing.
>> >
>> > drivers/net/wireless/b43/phy_lp.c |    4 ++--
>> > 1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/b43/phy_lp.c
>> > b/drivers/net/wireless/b43/phy_lp.c
>> > index 292ee51..76457f7 100644
>> > --- a/drivers/net/wireless/b43/phy_lp.c
>> > +++ b/drivers/net/wireless/b43/phy_lp.c
>> > @@ -1015,9 +1015,9 @@ static void lpphy_set_tx_power_control(struct
>> > b43_wldev *dev,
>> >        struct b43_phy_lp *lpphy = dev->phy.lp;
>> >        enum b43_lpphy_txpctl_mode oldmode;
>> >
>> > -       oldmode = lpphy->txpctl_mode;
>> >        lpphy_read_tx_pctl_mode_from_hardware(dev);
>> > -       if (lpphy->txpctl_mode == mode)
>> > +       oldmode = lpphy->txpctl_mode;
>> > +       if (oldmode == mode)
>> >                return;
>> >        lpphy->txpctl_mode = mode;
>> >
>> > --
>> > 1.6.2.4
>> >
>>
>> John, any news on this one? I can't see it in wireless testing.
>
> Larry said "It does not fix it here. I'll take a look at the specs"...

It did not fix the warning, but it is nevertheless a legitimate fix.
(I found this bug when I was looking for the source of the WARN_ON -
this is not the source of the WARN_ON, but still a bug.)

>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
