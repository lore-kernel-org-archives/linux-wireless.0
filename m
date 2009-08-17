Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:41043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZHQUCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 16:02:33 -0400
Received: by fg-out-1718.google.com with SMTP id e21so725944fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 13:02:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090817195718.GK5500@tuxdriver.com>
References: <4A85B8DE.3000704@gmail.com> <69e28c910908171232i6828d42bh3aac1d236f789c91@mail.gmail.com>
	<20090817195718.GK5500@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 17 Aug 2009 22:02:14 +0200
Message-ID: <69e28c910908171302s3aed3181w38ba402ca7dfa13d@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix setting TX power control mode during RC
	calibration
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
> On Mon, Aug 17, 2009 at 09:32:42PM +0200, Gábor Stefanik wrote:
>> 2009/8/14 Gábor Stefanik <netrolller.3d@gmail.com>:
>> > Call set_tx_power_control with a LPPHY_TXPCTL rather than an
>> > LPPHY_TX_PWR_CTL_CMD_MODE.
>> >
>> > Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> > ---
>> > This should fix the WARN_ON testers were seeing during init.
>> >
>> > drivers/net/wireless/b43/phy_lp.c |    2 +-
>> > 1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/b43/phy_lp.c
>> > b/drivers/net/wireless/b43/phy_lp.c
>> > index adfa7bf..558224b 100644
>> > --- a/drivers/net/wireless/b43/phy_lp.c
>> > +++ b/drivers/net/wireless/b43/phy_lp.c
>> > @@ -1080,7 +1080,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev
>> > *dev)
>> >        old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
>> >                                        B43_LPPHY_TX_PWR_CTL_CMD_MODE;
>> >
>> > -       lpphy_set_tx_power_control(dev, B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
>> > +       lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
>> >        lpphy_disable_crs(dev);
>> >        loopback = lpphy_loopback(dev);
>> >        if (loopback == -1)
>> > --
>> > 1.6.2.4
>> >
>>
>> John, any news on this one? I can't see it in wireless testing.
>
> Larry said:
>
> With this one, I still get WARNING: at
> drivers/net/wireless/b43/phy_lp.c:1006
> lpphy_set_tx_power_control+0xbf/0xdd [b43]().
>

Previously, he was getting 2 warnings. This fixes one of them, the
other one is handled by commit
1181d724fc2897f11f95bf6ebc86ae111390929c ("Fix another TX power
control abuse").

> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
