Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:53859 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbcEQN4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 09:56:09 -0400
Subject: Re: [PATCH v2] ath9k: interpret requested txpower in EIRP domain
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <201604011711.RmqSBtrr%fengguang.wu@intel.com>
 <1459503428-12492-1-git-send-email-zefir.kurtisi@neratec.com>
 <c884e319-e777-607e-492c-268b3f801d27@nbd.name>
 <573AF860.4040900@neratec.com>
 <9ea6a0db-61de-e442-9027-dd011fe048fe@nbd.name>
Cc: kvalo@qca.qualcomm.com, ath9k-devel@lists.ath9k.org
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <573B22F4.9010202@neratec.com> (sfid-20160517_155614_249697_3013898C)
Date: Tue, 17 May 2016 15:56:04 +0200
MIME-Version: 1.0
In-Reply-To: <9ea6a0db-61de-e442-9027-dd011fe048fe@nbd.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2016 01:11 PM, Felix Fietkau wrote:
> On 2016-05-17 12:54, Zefir Kurtisi wrote:
>> On 05/14/2016 02:50 PM, Felix Fietkau wrote:
>>> On 2016-04-01 11:37, Zefir Kurtisi wrote:
>>>> Tx power limitations at upper layers are interpreted in
>>>> the EIRP domain. When the user requests a given maximum
>>>> txpower, e.g. with: 'iw phy0 set txpower fixed 1500',
>>>> he expects the EIRP to be at or below 15dBm.
>>>>
>>>> In ath9k_hw_apply_txpower(), the interpretation is
>>>> different: the antenna-gain is capped against the
>>>> current txpower limit in the regulatory, but not
>>>> against the user set value. It ensures that the
>>>> resulting EIRP is below the limit defined by the
>>>> active countrycode, but not below the value the
>>>> user requested.
>>>>
>>>> In a scenario like e.g.
>>>>  a) antenna_gain=6
>>>>  b) countrycode limits to eirp=18
>>>>  c) user set txpower=15
>>>> this will cause a setting for AR_PHY_POWER_TX_RATE
>>>> regs resulting in an EIRP > 15.
>>>>
>>>> This patch ensures that antenna-gain is considered
>>>> whenever the txpower limit is adjusted and with that
>>>> the user set limits are kept.
>>>>
>>>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>>> I just noticed this change and I believe it should be reverted. In many
>>> cases the EEPROM antenna gain value does not accurately reflect the real
>>> antenna gain and is used more as a worst case value to prevent exceeding
>>> regulatory limits.
>>>
>>> I believe using this to limit the user specified tx power values will
>>> not only make this inconsistent with other drivers, but it will also
>>> confuse users by using significantly lower tx power than they wanted.
>>>
>>> The EEPROM antenna gain value is already causing more tx power reduction
>>> than necessary, because AFAIK at least the FCC regulatory rules allow an
>>> antenna gain of 3 dB while at the power limit, yet this is not
>>> subtracted from the EEPROM antenna gain value when considering the limit.
>>>
>>> - Felix
>>>
>> Two things to be considered before reverting that commit:
>> 1) the change affects only setups where a valid antenna gain value is set
>> I checked some consumer ath9k cards I collected over time from (rather old) WiFi
>> routers - none of them have an antenna gain set in EEPROM. Therefore, none of them
>> would be affected by the change (alas I have no current ath9k NICs at hand to
>> check if this is still valid). I'd argue that valid antenna gain values are set by
>> manufacturers or professional integrators who took time to calibrate and measure
>> the antennas' characteristics accurately.
> Maybe not many NICs have antenna gain set, but I did see several
> embedded devices with antenna gain set. Sometimes the value was set to
> just 6 db, sometimes it was more than that.
> 
Yes, of course this can and will happen. Alas, if it does, user is in trouble
anyway, since - even without the modification - invalid antenna gain values in the
eeprom would add unjustified limitations. If there is a 6dBi set and the
countrycode allows for 18dBm, with or without the modification the user won't be
able to set antenna port power to more than 12dBm. When typically the txpower is
set to auto, nothing changes with the patch applied.

What it in fact does is, further reducing the antenna port power if the user
*explicitly* sets a lower txpower (below what the countrycode allows).


>> 2) EIRP is what matters
>> As explained in the commit, every layer above the driver is interpreting txpower
>> in the EIRP domain. When you visit a certification lab and the engineer sets a max
>> txpower of 15dBm but measures an EIRP of 18 (as in the example above), the device
>> won't pass the test.
>>
>> I think the latter point is a strong argument to leave the change intact.
> I completely agree that this is something that needs fixing, but I think
> this change is not the way to do it. On devices with detachable antennas
> and a programmed antenna gain value in EEPROM this will make it really
> hard for the user to set the right tx power, especially when using
> different antennas. I think this is a serious regression.
> 
> A much better approach would be to expose the antenna gain to the stack,
> filling in the default from the EEPROM. That way the user at least has a
> chance to figure out what's going on if the tx power is too low and can
> set the antenna gain value to something sane as opposed to whatever
> potentially bogus value is in the EEPROM.
> 
This currently is a minefield and we need to very carefully keep track on what is
going on regulatory wise. FCC is planning to (or already does?) require WLAN
devices to be certified only in combination with the antennas to be used and
corresponding antenna gains set fix (and ETSI usually follows). The motivation is
clear: obviously, attaching a 12dBi antenna and claiming it is only 3dBi is the
easiest way to get the device operating outside certified specs.

Not wanting to wake up sleeping dogs, but given that the mechanisms to fix
manufacturers' mistakes of setting wrong eeprom antenna gain values essentially
are the same as those needed to bypass txpower limitations, 'fixing' bogus eeprom
antenna gain values long-term is not an option. We will have to respect the
manufacturer set values at lowest layer (driver or FW) anyway, therefore I don't
think it makes sense to pass them to the stack.

> - Felix
> 

Nevertheless, if you see serious risks for regressions with this change, I won't
oppose a revert and keep the patch applied privately. In that case it would make
sense to explicitly explain to the user that the txpower he is setting over the UI
/ uci, with ath9k (and others?) needs to be interpreted as antenna port power and
not EIRP.


Cheers,
Zefir

