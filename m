Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2492 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3HUJ2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 05:28:25 -0400
Message-ID: <52148830.3020004@broadcom.com> (sfid-20130821_112830_128829_D41C6FA3)
Date: Wed, 21 Aug 2013 11:28:16 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/12] brcmsmac: add support for BCM4313 iPA variant
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
 <1377007246-9957-13-git-send-email-arend@broadcom.com>
 <1377023415.2016.63.camel@joe-AO722>
In-Reply-To: <1377023415.2016.63.camel@joe-AO722>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2013 08:30 PM, Joe Perches wrote:
> On Tue, 2013-08-20 at 16:00 +0200, Arend van Spriel wrote:
>> This patch completes the changes needed for supporting the
>> iPA variant cards of the BCM4313 wireless chipset.
> []
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
> []
>> @@ -1826,6 +1826,17 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
>>   		write_radio_reg(pi, RADIO_2064_REG038, 3);
>>   		write_radio_reg(pi, RADIO_2064_REG091, 7);
>>   	}
>> +
>> +	if (!(pi->sh->boardflags & BFL_FEM)) {
>> +		u8 reg038[14] = {0xd, 0xe, 0xd, 0xd, 0xd, 0xc,
>> +			0xa, 0xb, 0xb, 0x3, 0x3, 0x2, 0x0, 0x0};
>
> static const would reduce the object size.

You are right. I will change that.

>> +		write_radio_reg(pi, RADIO_2064_REG02A, 0xf);
>> +		write_radio_reg(pi, RADIO_2064_REG091, 0x3);
>> +		write_radio_reg(pi, RADIO_2064_REG038, 0x3);
>> +
>> +		write_radio_reg(pi, RADIO_2064_REG038, reg038[channel - 1]);
>
> Does anything limit channel to < 15?

The 4313 is a 2.4GHz wireless device so channel will always be in the 
range 1 to 14. This is validated earlier in the call sequence leading to 
this function.

> There seem to be an awful lot of magic numbers
> in the patch.

Unfortunately, that is the case for most of the phy code. Most stuff is 
the result of tuning the phy performance.

Regards,
Arend


