Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47153 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2BIKyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 05:54:54 -0500
Received: by bkcjm19 with SMTP id jm19so1605416bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 02:54:53 -0800 (PST)
Message-ID: <4F33A5DE.8020208@openwrt.org> (sfid-20120209_115457_998289_C79F8A03)
Date: Thu, 09 Feb 2012 11:54:22 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, kune@deine-taler.de, jussi.kivilinna@mbnet.fi
Subject: Re: [PATCH] zd1211rw: wait between setting hash table and powering
 radio on
References: <20120208180102.18346jfdlm9wakw8@www.81.fi> <1328783095-8330-1-git-send-email-florian@openwrt.org> <CAGRGNgX-_s_EsbBLxs6UNJd7=3Yk0HECfxb-HSB_-r6cDyyuuA@mail.gmail.com>
In-Reply-To: <CAGRGNgX-_s_EsbBLxs6UNJd7=3Yk0HECfxb-HSB_-r6cDyyuuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On 02/09/12 11:40, Julian Calaby wrote:
> Hi Florian,
>
> A couple of minor points:
>
> On Thu, Feb 9, 2012 at 21:24, Florian Fainelli<florian@openwrt.org>  wrote:
>> I am running Debian testing kernel 3.1.0-1-amd64, using a 079b:0062 Sagem
>> XG-76NA 802.11bg stick.
>>
>> Upon zd1211rw interface
>> bringup (ifconfig wlan0 up) I get the following timeout:
>>
>> [  950.330573] zd1211rw 1-3:1.0: phy2
>> [  955.108510] zd1211rw 1-3:1.0: firmware version 4725
>> [  955.148532] zd1211rw 1-3:1.0: zd1211b chip 079b:0062 v4810 high 00-19-70
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
>> [10241.028140] zd1211rw 1-3:1.0: zd_switch_radio_on: failed to lock PHY regs
>> [10241.028148] zd1211rw 1-3:1.0: zd_op_start: failed to set radio on
>>
>> Adding a 10 milliseconds delay between the call to set_mc_hash() and
>> zd_chip_switch_radio_on() allows successful interface bringups in all
>> cases and matches what the vendor driver did.
>>
>> Signed-off-by: Florian Fainelli<florian@openwrt.org>
>> ---
>>   drivers/net/wireless/zd1211rw/zd_mac.c |    7 ++++++-
>>   1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
>> index 98a574a..bed634c 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -306,9 +306,14 @@ int zd_op_start(struct ieee80211_hw *hw)
>>         r = set_mc_hash(mac);
>>         if (r)
>>                 goto disable_int;
>> +       msleep(10);
> You might want to stick a comment in here to tell future developers
> why we're doing this.

I was counting on the commit message to actually provide the detailed 
explanation, but you are right, some comment might be appropriate here 
as well.

>
>> +
>>         r = zd_chip_switch_radio_on(chip);
>> -       if (r<  0)
>> +       if (r<  0) {
>> +               dev_err(zd_chip_dev(chip),
>> +                       "%s: failed to set radio on\n", __func__);
>>                 goto disable_int;
>> +       }
> It might also be an idea to have it re-try powering on the radio
> after, say 100 msecs, just in case 10 msecs isn't enough for whatever
> is causing this issue.

Here I would rather let the error be printed in the kernel log for 
people to report an issue if 10 msecs proves not to be enough for some 
systems.

>
>>         r = zd_chip_enable_rxtx(chip);
>>         if (r<  0)
>>                 goto disable_radio;
> Thanks,
>

