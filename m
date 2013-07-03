Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35261 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab3GCUXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 16:23:14 -0400
Message-ID: <51D4883E.2050607@openwrt.org> (sfid-20130703_222321_151460_5CD3A53D)
Date: Wed, 03 Jul 2013 22:23:26 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/5] rt2x00: rt2800lib: introduce rt2800_eeprom_word_index
 helper
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org> <1372269318-30233-5-git-send-email-juhosg@openwrt.org> <20130703192813.GD2245@localhost.localdomain>
In-Reply-To: <20130703192813.GD2245@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Thank you for the comments.

> On Wed, Jun 26, 2013 at 07:55:17PM +0200, Gabor Juhos wrote:
>> Instead of assign the offset value to the
>> enum directly use a new helper function to
>> convert a rt2800_eeprom_word enum into an
>> index of the rt2x00_dev->eeprom array.
>>
>> The patch does not change the existing
>> behaviour, but makes it possible to add
>> support for three-chain devices which are
>> using a different EEPROM layout.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> I have two nit-picks, but they can be fixed later on top of your current
> patches.
> 
>> +	if (WARN_ON(word >= EEPROM_WORD_COUNT)) {
>> +		rt2x00_warn(rt2x00dev, "invalid EEPROM word %d\n", word);
>> +		return 0;
>> +	}
> 
> Since we take "enum rt2800_eeprom_word" as word argument, it can not
> have different values than already listed, so this warning is not needed.

EEPROM_WORD_COUNT is listed in the enums and the word argument can be equal to
that, however it is not a valid index for the EEPROM map. Additionally, if
someone puts a new enum value after EEPROM_WORD_COUNT by mistake that will be an
invalid index as well.

> 
>> +	map = rt2800_eeprom_map;
>> +	index = map[word];
>> +
>> +	if (WARN_ON(word != EEPROM_CHIP_ID && index == 0)) {
>> +		/* Index 0 is valid only for EEPROM_CHIP_ID.
>> +		 * Otherwise it means that the offset of the
>> +		 * given word is not initialized in the map,
>> +		 * or that the field is not usable on the
>> +		 * actual chipset.
>> +		 */
>> +		rt2x00_warn(rt2x00dev, "invalid access of EEPROM word %d\n",
>> +			    word);
> 
> I prefer not to use WARN_ON() and rt2x00_warn() together, please use just
> one of them, i.e:
> 
> WARN_ONCE(word != EEPROM_CHIP_ID && index == 0,
> 	  "invalid access of EEPROM word %d\n", word);

My reason behind the rt2x00_warn call was that it shows the wiphy name. If you
are testing different devices in parallel it is good to know which one causes
the warning. However I can use 'wiphy_name(rt2x00dev->hw->wiphy)' to get that
information.

I will send a follow-up patch which removes the rt2x00_warn calls. Do you also
prefer WARN_ONCE instead of WARN?

-Gabor
