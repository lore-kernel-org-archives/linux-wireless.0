Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40369 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756002Ab0KKTbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 14:31:15 -0500
Message-ID: <4CDC4480.8050206@openwrt.org>
Date: Thu, 11 Nov 2010 20:31:12 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mark Mentovai <mark@moxienet.com>, linux-wireless@vger.kernel.org
Subject: Re: ath9k max_power question
References: <AANLkTikjg+jY6XYhJjRPydwveW0xr+8tLv-Oypsks4ay@mail.gmail.com> <AANLkTimVEm7=c-fof_niToJqy1t+C5fk_JYH_=x1+p5r@mail.gmail.com>
In-Reply-To: <AANLkTimVEm7=c-fof_niToJqy1t+C5fk_JYH_=x1+p5r@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-11 8:22 PM, Luis R. Rodriguez wrote:
> On Thu, Nov 11, 2010 at 11:15 AM, Mark Mentovai <mark@moxienet.com> wrote:
>> In drivers/net/wireless/ath/ath9k/init.c, both CHAN2G and CHAN5G set
>> .max_power to 20, represented in dBm. I’m wondering how this number
>> was chosen. Is it simply a safe generic value? I’m dealing with a
>> device on which the vendor’s madwifi-based binary driver would show
>> 23dBm for 2.4GHz and 18dBm for 5GHz (although only when I asked it for
>> 26dBm and 24dBm respectively, so I’m not sure which set of numbers to
>> believe.)
>>
>> I noticed that in ath9k, if these .max_power limits are raised, the
>> driver is happy to set a somewhat higher transmit power. In this case,
>> it will max out at 25dBm for 2.4GHz and 21dBm for 5GHz. These are
>> still below the relevant regulatory limits. These values seem to be
>> computed by routines in eeprom_*.c, so I’m wondering if they’re based
>> on the card’s own data and safe to use without fear of burning the
>> radios.
> 
> The values are just some safe value to use as defaults but will
> quickly be replaced by the max regulatory allowed and then upon
> further inspection also capped to the lower value of the regulatory
> limit, the max allowed device limit (where things start becoming
> unreliable), and the CTL indexed limit which is calibrated
> specifically for the card you use, so this will vary. You can read
> more about it here:
> 
> http://wireless.kernel.org/en/users/Drivers/ath
That should have already been taken care of by this commit (w-t):

commit 6cdd07721180145b7ef46bd63f1eee636983f0e6
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Wed Oct 20 02:09:46 2010 +0200

ath9k: initialize per-channel tx power limits instead of hardcoding them


- Felix
