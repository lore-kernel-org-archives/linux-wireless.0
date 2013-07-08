Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48818 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab3GHJ0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 05:26:25 -0400
Message-ID: <51DA85C2.1060509@openwrt.org> (sfid-20130708_112627_749558_8CED6102)
Date: Mon, 08 Jul 2013 11:26:26 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/5] rt2x00: rt2800lib: introduce rt2800_eeprom_word_index
 helper
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org> <1372269318-30233-5-git-send-email-juhosg@openwrt.org> <20130703192813.GD2245@localhost.localdomain> <51D4883E.2050607@openwrt.org> <20130704182746.GA2061@localhost.localdomain>
In-Reply-To: <20130704182746.GA2061@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

> On Wed, Jul 03, 2013 at 10:23:26PM +0200, Gabor Juhos wrote:
>>> I have two nit-picks, but they can be fixed later on top of your current
>>> patches.
>>>
>>>> +	if (WARN_ON(word >= EEPROM_WORD_COUNT)) {
>>>> +		rt2x00_warn(rt2x00dev, "invalid EEPROM word %d\n", word);
>>>> +		return 0;
>>>> +	}
>>>
>>> Since we take "enum rt2800_eeprom_word" as word argument, it can not
>>> have different values than already listed, so this warning is not needed.
>>
>> EEPROM_WORD_COUNT is listed in the enums and the word argument can be equal to
>> that, however it is not a valid index for the EEPROM map. Additionally, if
>> someone puts a new enum value after EEPROM_WORD_COUNT by mistake that will be an
>> invalid index as well.
> 
> I do not feel that there is big chance that someone will do such
> mistakes, but yes, they are at least theoretically possible, so warning
> can stay.
> 
>> My reason behind the rt2x00_warn call was that it shows the wiphy name. If you
>> are testing different devices in parallel it is good to know which one causes
>> the warning. However I can use 'wiphy_name(rt2x00dev->hw->wiphy)' to get that
>> information.
>>
>> I will send a follow-up patch which removes the rt2x00_warn calls. Do you also
>> prefer WARN_ONCE instead of WARN?
> 
> I prefer WARN_ONCE variant to avoid possible spamming dmesg with lot of
> warnings.

Ok. Because the patch-set has not been integrated yet, I have sent an updated
version instead of a follow-up patch.

-Gabor

