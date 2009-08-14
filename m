Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:8876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZHNWBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 18:01:18 -0400
Received: by fg-out-1718.google.com with SMTP id e12so144215fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 15:01:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A85D7A3.9020009@lwfinger.net>
References: <4A85D070.6070702@gmail.com> <4A85D7A3.9020009@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 15 Aug 2009 00:00:59 +0200
Message-ID: <69e28c910908141500s2e6ee71avcebffd6107fe5a1@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix another TX power control abuse
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/14 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>> This should fix the remaining WARN_ON.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> drivers/net/wireless/b43/phy_lp.c |    7 ++++---
>> 1 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_lp.c
>> b/drivers/net/wireless/b43/phy_lp.c
>> index bf89173..3872a31 100644
>> --- a/drivers/net/wireless/b43/phy_lp.c
>> +++ b/drivers/net/wireless/b43/phy_lp.c
>> @@ -1059,7 +1059,8 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev
>> *dev)
>>     bool old_txg_ovr;
>>     u8 old_bbmult;
>>     u16 old_rf_ovr, old_rf_ovrval, old_afe_ovr, old_afe_ovrval,
>> -        old_rf2_ovr, old_rf2_ovrval, old_phy_ctl, old_txpctl;
>> +        old_rf2_ovr, old_rf2_ovrval, old_phy_ctl;
>> +    enum b43_lpphy_txpctl_mode old_txpctl;
>>     u32 normal_pwr, ideal_pwr, mean_sq_pwr, tmp = 0, mean_sq_pwr_min = 0;
>>     int loopback, i, j, inner_sum;
>>
>> @@ -1077,8 +1078,8 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev
>> *dev)
>>     old_rf2_ovr = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_2);
>>     old_rf2_ovrval = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_2_VAL);
>>     old_phy_ctl = b43_phy_read(dev, B43_LPPHY_LP_PHY_CTL);
>> -    old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
>> -                    B43_LPPHY_TX_PWR_CTL_CMD_MODE;
>> +    lpphy_read_tx_pctl_mode_from_hardware(dev);
>> +    old_txpctl = lpphy->txpctl_mode;
>>
>>     lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
>>     lpphy_disable_crs(dev);
>
> Yes, this one got rid of the warnings.
>
> Larry
>
>

I guess the device still doesn't TX/RX.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
