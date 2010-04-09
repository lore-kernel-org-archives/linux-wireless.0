Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42882 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0DIM0c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 08:26:32 -0400
Message-ID: <4BBF1CF1.3090809@openwrt.org>
Date: Fri, 09 Apr 2010 14:26:25 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/9] rt2x00: Align RT chipset definitions with vendor
 driver.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <201004091332.26307.helmut.schaa@googlemail.com> <4BBF150E.3030507@openwrt.org> <201004091423.58803.helmut.schaa@googlemail.com>
In-Reply-To: <201004091423.58803.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-09 2:23 PM, Helmut Schaa wrote:
> Am Freitag 09 April 2010 schrieb Felix Fietkau:
>> On 2010-04-09 1:32 PM, Helmut Schaa wrote:
>> > Am Freitag 09 April 2010 schrieb Felix Fietkau:
>> >> On 2010-04-09 7:10 AM, Gertjan van Wingerde wrote:
>> >> > On 04/09/10 00:28, Felix Fietkau wrote:
>> >> >> On 2010-04-08 11:50 PM, Gertjan van Wingerde wrote:
>> >> >>> Only include definitions for RT chipsets that are also used inside the
>> >> >>> Ralink vendor drivers.
>> >> >>>
>> >> >>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> >> >>> ---
>> >> >>>  drivers/net/wireless/rt2x00/rt2800lib.c |   13 -------------
>> >> >>>  drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++----
>> >> >>>  2 files changed, 3 insertions(+), 17 deletions(-)
>> >> >>>
>> >> >>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> >> >>> index 394c8e4..4bc7e09 100644
>> >> >>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> >> >>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> >> >>> @@ -1209,10 +1209,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>> >> >>>  	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
>> >> >>>  	if ((rt2x00_rt(rt2x00dev, RT2872) &&
>> >> >>>  	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
>> >> >>> -	    rt2x00_rt(rt2x00dev, RT2880) ||
>> >> >>>  	    rt2x00_rt(rt2x00dev, RT2883) ||
>> >> >>> -	    rt2x00_rt(rt2x00dev, RT2890) ||
>> >> >>> -	    rt2x00_rt(rt2x00dev, RT3052) ||
>> >> >>>  	    (rt2x00_rt(rt2x00dev, RT3070) &&
>> >> >>>  	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
>> >> >>>  		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
>> >> >>> @@ -1511,12 +1508,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>> >> >>>  		rt2800_bbp_write(rt2x00dev, 105, 0x05);
>> >> >>>  	}
>> >> >>>  
>> >> >>> -	if (rt2x00_rt(rt2x00dev, RT3052)) {
>> >> >>> -		rt2800_bbp_write(rt2x00dev, 31, 0x08);
>> >> >>> -		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
>> >> >>> -		rt2800_bbp_write(rt2x00dev, 80, 0x08);
>> >> >>> -	}
>> >> >>> -
>> >> >> Why are you removing support for RT3052? IMHO those writes were
>> >> >> necessary, last time I tested the rt2800pci code on the RT3052 WiSoC.
>> >> > 
>> >> > That is because I have not been able to find them in any of the Ralink vendor drivers.
>> >> > Actually, none of the Ralink vendor drivers mention an RT chipset that identifies itself
>> >> > as a RT3052. The only mentioning Ive seen is RT305x devices that identify themselves as
>> >> > RT2872 devices, but even for them I haven't found these BBP initializations.
>> >> > That's why I removed this part.
>> >> > 
>> >> > I have no problem re-instating this if I can find some evidence that these devices
>> >> > actually exist.
>> >> These chipsets won't show up in STA-only drivers, because they belong to
>> >> embedded APs. If you download GPL sources for devices such as ASUS
>> >> RT-N15 you will find ifdefs for CONFIG_RALINK_RT3052 and the above
>> >> values in BBPRegTable in the driver sources.
>> >> I have a few devices based on RT3052, which is why I added this code.
>> >> At some point I even had basic Rx/Tx working on it, but haven't tested
>> >> in a while.
>> > 
>> > I also couldn't find any evidence of the existence of an 3052 _rt_ chipset.
>> > However, the ralink drivers defines a 3052 _rf_ chip:
>> > 
>> > #define RFIC_3052                   9       // 2.4G/5G 2T2R
>> RT3052 is the name of the whole WiSoC chip, not just the MAC or RF part
>> of it. Since wifi is integrated in the SoC, I don't think there is a
>> separate name for just the wifi part.
> 
> There is. I have one 3052 and one 3050 board (basically a 3052 but only
> 1T1R), and both identify themselves as RT2872 with different rf "chips"
> (of course, there are no additional chips). Hence, the check for RT3052
> was never true on both platforms.
Back when I tested it, I forced the chip to identify itself as RT3052 by
taking the id from the platform device.

>> > I don't have such an rf chip in my devices but I don't think the BPP
>> > register setup should depend on the actual rf chip. So, if the register
>> > setup is really needed we should maybe check for rt2x00_is_soc instead
>> > of removing the code?
>> Yes, but rt2x00_is_soc() is not enough, since RT2880 is also SoC, but
>> slightly different compared to RT3052. I've only tested RT3052 myself.
> 
> Right. So, from what I've seen so far it seems like all 305x boards identify
> themselves as rt2872. Hence, we can just replace 3052 with 2872 in the above
> check and leave the code as is.
OK, if that doesn't conflict with any PCI based stuff...

- Felix
