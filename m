Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56472 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2BHNRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 08:17:48 -0500
Received: by bkcjm19 with SMTP id jm19so451781bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 05:17:47 -0800 (PST)
Message-ID: <4F3275DD.2000107@openwrt.org> (sfid-20120208_141751_454627_D6651C4B)
Date: Wed, 08 Feb 2012 14:17:17 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	zd1211-devs@lists.sourceforge.net
Subject: Re: zd1211rw firmware loading timeout
References: <201111291544.28692.florian@openwrt.org> <CAFAL1Txx=qn3WXdRrtaYPVySY2vx+HinKk-NgthR+2ufcYNMwA@mail.gmail.com> <20120208151536.92555oyai8wffqww@www.81.fi>
In-Reply-To: <20120208151536.92555oyai8wffqww@www.81.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jussi,

On 02/08/12 14:15, Jussi Kivilinna wrote:
> Quoting Florian Fainelli <florian@openwrt.org>:
>
>>
>> Hello,
>>
>> I am running Debian testing kernel 3.1.0-1-amd64, using a 079b:0062 
>> Sagem
>> XG-76NA 802.11bg stick.
>>
>> Upon zd1211rw interface
>> bringup (ifconfig wlan0 up) I get the following timeout:
>>
>> [  950.330573] zd1211rw 1-3:1.0: phy2
>> [  955.108510] zd1211rw 1-3:1.0: firmware version 4725
>> [  955.148532] zd1211rw 1-3:1.0: zd1211b chip 079b:0062 v4810 high 
>> 00-19-70
>> AL2230_RF pa0 g--NS
>> [snip]
>> [  955.204072] zd1211rw 1-3:1.0: error ioread32(CR_REG1): -110
>>
>> A second ifconfig wlan0 up brings the interface up without problems.
>>
>> After a bit more debugging, the call trace is the following:
>>
>> [10241.028130] zd1211rw 1-3:1.0: zd_chip_lock_phy_regs: error
>> ioread32(CR_REG1): -110
>> [10241.028140] zd1211rw 1-3:1.0: zd_switch_radio_on: failed to lock 
>> PHY regs
>> [10241.028148] zd1211rw 1-3:1.0: zd_op_start: failed to set radio on
>>
>> The following small modification works around the issue:
>>
>> diff --git a/zd_mac.c b/zd_mac.c
>> index cabfae1..6bfb673 100644
>> --- a/zd_mac.c
>> +++ b/zd_mac.c
>> @@ -306,9 +306,14 @@ int zd_op_start(struct ieee80211_hw *hw)
>>        r = set_mc_hash(mac);
>>        if (r)
>>                goto disable_int;
>> +
>> +       msleep(10);
>> +
>>        r = zd_chip_switch_radio_on(chip);
>> -       if (r < 0)
>> +       if (r < 0) {
>> +               dev_err(zd_chip_dev(chip), "%s: failed to set radio 
>> on\n",
>> __func__);
>>                goto disable_int;
>> +       }
>>        r = zd_chip_enable_rxtx(chip);
>>        if (r < 0)
>>                goto disable_radio;
>>
>> Is it possible that some chips require more time between a 
>> set_mc_hash and a
>> radio on? Or in general that consequent writes to the PHY regs should 
>> be timed
>> appropriately?
>
> Yes, it is possible. Vendor driver appears to have quite alot sleeps 
> spread around in RF-chip handling code. I might have seen this myself 
> sometimes when zd1211 device has firmware freeze and has to be 
> reseted. But since freeze is hard to reproduce and reset didn't fail 
> always, I didn't bother with it.
>
> Can you give your "Signed-off-by" line for the patch?

Sure, I will resubmit this patch, do you also want me to keep the line 
showing the error?

>
> -Jussi
>
>>
>> When I googled for this timeout issue, I could see quite some reports 
>> of other
>> people having this error while the chip was already operating.
>>
>> Thanks
>> -- 
>> Florian
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

