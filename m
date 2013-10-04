Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:39512 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3JDT6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 15:58:44 -0400
Message-ID: <524F1E10.7020608@openwrt.org> (sfid-20131004_215848_754336_F3D057A6)
Date: Fri, 04 Oct 2013 21:59:12 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 3/4] rt2x00: rt2800lib: fix default
 VGC values for RT3593
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org> <1380823243-11149-3-git-send-email-juhosg@openwrt.org> <20131004143822.GC7842@localhost.localdomain>
In-Reply-To: <20131004143822.GC7842@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.10.04. 16:38 keltezéssel, Stanislaw Gruszka írta:
> On Thu, Oct 03, 2013 at 08:00:42PM +0200, Gabor Juhos wrote:
>> Update the rt2800_get_default_vgc function to use the same VGC
>> values that the DPO_RT5572_LinuxSTA_2.6.1.3_20121022 reference
>> driver uses.
>>
>> References:
>>   RT35xx_ChipAGCAdjust in chips/rt35xx.c
>>   RT3593_R66_MID_LOW_SENS_GET macro in include/chip/rt3593.h
>>   RT3593_R66_NON_MID_LOW_SEMS_GET macro in include/chips/rt3593.h
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
>> @@ -4422,6 +4423,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>>  	} else { /* 5GHZ band */
>>  		if (rt2x00_rt(rt2x00dev, RT3572))
>>  			vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;
> 
> Looks RT3572 values should be also changed ? According to:
> 
>                 if (pAd->CommonCfg.BBPCurrentBW == BW_20)
>                 {
>                         R66 = 0x32 + (lanGain*5) / 3;
>                         if (Rssi > RSSI_FOR_MID_LOW_SENSIBILITY)
>                                 R66 += 0x10;
>                 }
>                 else
>                 {
>                         R66 = 0x3A + (lanGain*5)/3;
>                         if (Rssi > RSSI_FOR_MID_LOW_SENSIBILITY)
>                                 R66 += 0x10;
>                 }       

Yes. I even created a patch for that, but I forgot to add that into the series.
Will send that separately.

-Gabor
