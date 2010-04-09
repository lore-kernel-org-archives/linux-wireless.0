Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2802 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab0DIFK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 01:10:59 -0400
Message-ID: <4BBEB6E1.70300@gmail.com>
Date: Fri, 09 Apr 2010 07:10:57 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/9] rt2x00: Align RT chipset definitions with vendor
 driver.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-4-git-send-email-gwingerde@gmail.com> <4BBE5879.8000304@openwrt.org>
In-Reply-To: <4BBE5879.8000304@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/10 00:28, Felix Fietkau wrote:
> On 2010-04-08 11:50 PM, Gertjan van Wingerde wrote:
>> Only include definitions for RT chipsets that are also used inside the
>> Ralink vendor drivers.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |   13 -------------
>>  drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++----
>>  2 files changed, 3 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 394c8e4..4bc7e09 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -1209,10 +1209,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>>  	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
>>  	if ((rt2x00_rt(rt2x00dev, RT2872) &&
>>  	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
>> -	    rt2x00_rt(rt2x00dev, RT2880) ||
>>  	    rt2x00_rt(rt2x00dev, RT2883) ||
>> -	    rt2x00_rt(rt2x00dev, RT2890) ||
>> -	    rt2x00_rt(rt2x00dev, RT3052) ||
>>  	    (rt2x00_rt(rt2x00dev, RT3070) &&
>>  	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
>>  		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
>> @@ -1511,12 +1508,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>>  		rt2800_bbp_write(rt2x00dev, 105, 0x05);
>>  	}
>>  
>> -	if (rt2x00_rt(rt2x00dev, RT3052)) {
>> -		rt2800_bbp_write(rt2x00dev, 31, 0x08);
>> -		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
>> -		rt2800_bbp_write(rt2x00dev, 80, 0x08);
>> -	}
>> -
> Why are you removing support for RT3052? IMHO those writes were
> necessary, last time I tested the rt2800pci code on the RT3052 WiSoC.

That is because I have not been able to find them in any of the Ralink vendor drivers.
Actually, none of the Ralink vendor drivers mention an RT chipset that identifies itself
as a RT3052. The only mentioning Ive seen is RT305x devices that identify themselves as
RT2872 devices, but even for them I haven't found these BBP initializations.
That's why I removed this part.

I have no problem re-instating this if I can find some evidence that these devices
actually exist.

---
Gertjan.
