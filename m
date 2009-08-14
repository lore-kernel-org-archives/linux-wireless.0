Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:23097 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZHNUvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:51:00 -0400
Received: by fg-out-1718.google.com with SMTP id e21so403197fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 13:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A85CC6C.1030005@lwfinger.net>
References: <4A85B8DE.3000704@gmail.com> <4A85CC6C.1030005@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 22:50:41 +0200
Message-ID: <69e28c910908141350i67eca251x4d88d17feaa92e55@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix setting TX power control mode during RC
	calibration
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/14 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>> Call set_tx_power_control with a LPPHY_TXPCTL rather than an
>> LPPHY_TX_PWR_CTL_CMD_MODE.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> This should fix the WARN_ON testers were seeing during init.
>>
>>  drivers/net/wireless/b43/phy_lp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
>> index adfa7bf..558224b 100644
>> --- a/drivers/net/wireless/b43/phy_lp.c
>> +++ b/drivers/net/wireless/b43/phy_lp.c
>> @@ -1080,7 +1080,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
>>       old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
>>                                       B43_LPPHY_TX_PWR_CTL_CMD_MODE;
>>
>> -     lpphy_set_tx_power_control(dev, B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
>> +     lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
>>       lpphy_disable_crs(dev);
>>       loopback = lpphy_loopback(dev);
>>       if (loopback == -1)
>
>
> With this one, I still get WARNING: at
> drivers/net/wireless/b43/phy_lp.c:1006
> lpphy_set_tx_power_control+0xbf/0xdd [b43]().
>
> To get rid of them, I need to modify the enum b43_lpphy_txpctl_mode{}
> as I wrote earlier.

Is ctl still 0? Please check.

>
> I'm also seeing the interface stopped and restarted. I'll try to track
> that down.
>
> Larry
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
