Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59231 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2GYS4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 14:56:03 -0400
Message-ID: <50104135.1030105@openwrt.org> (sfid-20120725_205607_614132_C7D0CFBC)
Date: Wed, 25 Jul 2012 20:55:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linville@tuxdriver.com, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH 1/2] ath5k: fix wrong per rate target power eeprom reads
 for AR5K_EEPROM_MODE_11A
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com>
In-Reply-To: <CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-25 8:42 PM, Nick Kossifidis wrote:
> 2012/7/23 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>> This patch reduces the per rate target power eeprom reads for
>> AR5K_EEPROM_MODE_11A from 10 to 8, as there are only 8 valid
>> power curve entries on the eeprom. The former 10 reads lead to
>> wrong per rate power limits where rates above 24MBit could be
>> amplified with to high distortion leading to bad performance.
>> This was fix validated against the madwifi codebase and a new
>> AR5K_EEPROM_N_5GHZ_RATE_CHAN 8 is defined.
>>
>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>> ---
>> madwifi cross validation check. Thx to Felix Fiethkau
>> ---
> 
> 
> Thanks for catching this but the bug is elsewhere:
> 
> I've tried to document hw code as much as I can, eeprom stuff is still
> missing and I'm sorry for that but here is what comments say on phy.c
> @ DOC: Per-rate tx power setting, that should give you an idea of
> what's happening...
> 
> 3498  * Rate power table contains indices to PCDAC/PDADC table (0.5dB steps -
> 3499  * x values) and is indexed as follows:
> 3500  * rates[0] - rates[7] -> OFDM rates
> 3501  * rates[8] - rates[14] -> CCK rates
> 3502  * rates[15] -> XR rates (they all have the same power)
> 
> So guess why the last 2 "invalid" power gain values have the same
> power levels for all rates ? They are for XR mode (they've put it
> there on the eeprom because XR mode also operates at 5GHz) and since
> XR stuff is stripped off Madwifi (at least the public HAL) that's why
> it only reads 8 of the piers.
It's not just stripped in the public HAL. Every driver that I've looked
at only reads 8 of the piers in the function that parses the EEPROM.

- Felix
