Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59353 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab2DOR05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 13:26:57 -0400
Message-ID: <4F8B04D7.4080605@openwrt.org> (sfid-20120415_192659_802352_0E247815)
Date: Sun, 15 Apr 2012 19:26:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 1/3] ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
References: <1334433719-1144-1-git-send-email-juhosg@openwrt.org> <4F8AA38E.1040702@openwrt.org> <4F8B03A3.6030804@openwrt.org>
In-Reply-To: <4F8B03A3.6030804@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-15 7:21 PM, Gabor Juhos wrote:
> Hi Felix,
> 
> Thank you for the comments.
> 
>> On 2012-04-14 10:01 PM, Gabor Juhos wrote:
>>> The REDUCE_SCALED_POWER_BY_THREE_CHAIN symbol is
>>> defined in different eeprom files, and the value
>>> varies between the different files.
>>>
>>> In eeprom_def.c and in ar9003_eeprom.c the value
>>> of the symbol is 9, however the comments in these
>>> files indicates the value should be 10*log10(3)*2
>>> which is 9.54242509439325. Replace the the value
>>> to 10 in these files.
>>>
>>> Also add comments to eeprom_9287.c.
>>>
>>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> I think we should keep the value 9.
>> If I understand the logic behind the power increase through chain
>> combining properly, this value only describes the worst-case (wrt.
>> regulatory compliance) upper limit of tx power, whereas in practice the
>> measured combined power output will be much lower than that due to
>> signal/phase differences.
>> Regulatory compliance is already properly tested on all devices with the
>> truncated value 9, so I don't think that we need to be even more
>> conservative and round up here.
> 
> Ok, I will rework the patch.
> 
> Apart from the inconsistency between the REDUCE_SCALED_POWER_BY_THREE_CHAIN
> values, there is another thing which confuses me.
> 
> In the 'ath9k_hw_set_*_power_cal_table' functions the driver uses the
> REDUCE_SCALED_POWER_BY_THREE_CHAIN constant to reduce the power values.
> In the 'ath9k_hw_update_regulatory_maxpower' function it uses the
> INCREASE_MAXPOW_BY_THREE_CHAIN constant to compensate the reduction. However the
> two constants are different. I might be wrong, but in my opinion the driver
> should use the same constant in both functions.
I just checked with Atheros sources, and it seems I was wrong about
sticking with the value 9.
It appears that Atheros changed it to 10 at some point, and ath9k
contains a mix of the old and the new version. Consistently using the
value 10 for 3 chains for both increase and reduction seems to be the
right thing to do.

- Felix
