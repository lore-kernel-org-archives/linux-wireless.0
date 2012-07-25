Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37214 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2GYWW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 18:22:26 -0400
Received: by obbuo13 with SMTP id uo13so1708195obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 15:22:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50104135.1030105@openwrt.org>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com>
	<50104135.1030105@openwrt.org>
Date: Thu, 26 Jul 2012 01:22:25 +0300
Message-ID: <CAFtRNNy3kgzbX7=No+YN=4nPZf=Mku6mRXcfXc_PdTbSKD3_SA@mail.gmail.com> (sfid-20120726_002230_307158_FF8DF527)
Subject: Re: [PATCH 1/2] ath5k: fix wrong per rate target power eeprom reads
 for AR5K_EEPROM_MODE_11A
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linville@tuxdriver.com, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, johannes.berg@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/25 Felix Fietkau <nbd@openwrt.org>:
> On 2012-07-25 8:42 PM, Nick Kossifidis wrote:
>> 2012/7/23 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>>> This patch reduces the per rate target power eeprom reads for
>>> AR5K_EEPROM_MODE_11A from 10 to 8, as there are only 8 valid
>>> power curve entries on the eeprom. The former 10 reads lead to
>>> wrong per rate power limits where rates above 24MBit could be
>>> amplified with to high distortion leading to bad performance.
>>> This was fix validated against the madwifi codebase and a new
>>> AR5K_EEPROM_N_5GHZ_RATE_CHAN 8 is defined.
>>>
>>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>>> ---
>>> madwifi cross validation check. Thx to Felix Fiethkau
>>> ---
>>
>>
>> Thanks for catching this but the bug is elsewhere:
>>
>> I've tried to document hw code as much as I can, eeprom stuff is still
>> missing and I'm sorry for that but here is what comments say on phy.c
>> @ DOC: Per-rate tx power setting, that should give you an idea of
>> what's happening...
>>
>> 3498  * Rate power table contains indices to PCDAC/PDADC table (0.5dB steps -
>> 3499  * x values) and is indexed as follows:
>> 3500  * rates[0] - rates[7] -> OFDM rates
>> 3501  * rates[8] - rates[14] -> CCK rates
>> 3502  * rates[15] -> XR rates (they all have the same power)
>>
>> So guess why the last 2 "invalid" power gain values have the same
>> power levels for all rates ? They are for XR mode (they've put it
>> there on the eeprom because XR mode also operates at 5GHz) and since
>> XR stuff is stripped off Madwifi (at least the public HAL) that's why
>> it only reads 8 of the piers.
> It's not just stripped in the public HAL. Every driver that I've looked
> at only reads 8 of the piers in the function that parses the EEPROM.
>
> - Felix

XR mode stuff is being stripped out from anything I got (docs etc) so
in some cases I don't understand something I blame XR :P However I
double checked this and it seems you are right:

a) 11a has 10 cal piers for the channel power table and 8 cal piers
for the rate powertable, not only that but the 8 are optional and
might not even cover the whole freq range.

b) I printed out the offsets and what happens it that the last 2
measurements we got have the same format because they are the 802.11b
cal piers and they have the same power levels because 11b is CCK so it
makes sense.

c) Something fishy is going on with ee->ee_xr_power[mode], is this the
max rate power for all channels on XR mode ? Is that possible to have
the same power index (and a high one) for all channels ? That's the
main reason I suspected these two values have something to do with XR.
If that's the case shouldn't we use that instead of rates[0] on
ath5k_setup_rate_powertable for XR rates ? Does any of the drivers you
've seen use ee->ee_xr_power[mode] ?

Anyway I left the EEPROM code unmaintained for a long time, the
related TODOs on wireless.kernel.org wiki are there too. Since I now
have documentation on EEPROM I'll start working on it again and clean
it up.


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
