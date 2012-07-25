Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:56404 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab2GYXHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 19:07:35 -0400
Message-ID: <50107C35.9050807@net.t-labs.tu-berlin.de> (sfid-20120726_010806_978155_25FA9EA5)
Date: Thu, 26 Jul 2012 01:07:33 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linville@tuxdriver.com, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	nbd@nbd.name
Subject: Re: [PATCH 2/2] ath5k: fix phy_init() to respect user txpower changes
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com>
In-Reply-To: <CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

Nick Kossifidis schrieb:

> 2012/7/23 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>> In such cases where phy_init() function got called, tx_power is always
>> set to ah->ah_txpower.txp_cur_pwr which is never updated with txpower
>> specified by the user instead it equale max chan power and got
>> potentially incremented by ah_txpower.txp_offset.
> 
> Never updated ?
> 
> It gets updated when setting the rate powertable (the final step of
> the whole process):
> 


As it took a while that I got my head into the function calls, let me
try to explain what is going wrong in the current state of ath5k
regarding tx_power.

In short: ah->ah_txpower.txp_cur_pwr is probably intended to respect the
power level set by the user, BUT it is jut reused and changed in
different places that make it difficult to follow and brake the tx_power
level specified.

-long-version-in-code:

- assume you configure your device to use 17 dBm and max power is 19dBm
and you are just in the boot process

-in the last steps to init you Atheros Wifi, the mac802.11 calls
hw_config, as it recognise a change in tx-power from maximum(19dBm) to
user_txpower(17dBm)

-this leads in case of ath5k to call the ops representative function
ath5k_config... which transforms 1 dBm steps in 2 half-dBm steps ...
concrete: ath5k_hw_set_txpower_limit(..34 half-dBm..) is called which
calls ath5k_hw_txpower(..34 half-dBm..) .. and in here .. just before
writing the power to registers.. it calls
ath5k_setup_rate_powertable(..34 half-dBm..)

- now lets jump into ath5k_setup_rate_powertable(..34 half-dBm..):
our 34 half-dBm is now transformed to 68 quarter-dBm stored in max_pwr.
max_pwr is re-assigned as to be the minimum of (our user_txpower 68
quarter_dBm and ah->ah_txpower.txp_max_pwr) / 2 ... so it is set back to
34 half_dBm

-one step further:
rates[0..5] = min(max_pwr (34 half dBm), 		rate_info->target_power_6to24
(38 half-dBm);

-now it gets interesting:
for i [1..16] rates[i] = rates[i] + OFFSET 	(line 3560)
{
.. and OFFSET is in my case 18 .. so rates[0] = 34+21 = 55
}
ah->ah_txpower.txp_cur_pwr = 2 * rates[0] = 2 * 55 half_dBm = 110 half_dBm

+BREAK: ah->ah_txpower.txp_cur_pwr is at 110 half_dBm but not yet used.
+in ALL cases where ath5k_hw_phy_init() is called ... queue reset, wifi
up/down, iwconfig set same txpower ..  we reuse this wrong set txpower
variable which does not represent the user setting

-now our ah->ah_txpower.txp_cur_pwr is just reused in the function
ath5k_hw_phy_init():
ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr (110
half_dBm)?
	ah->ah_txpower.txp_cur_pwr / 2 (55 half_dBm): AR5K_TUNE_MAX_TXPOWER (63
half_dBm));

.. which leads to the call ath5k_hw_txpower(..AR5K_TUNE_MAX_TXPOWER (63
half-dBm)..)

.. to its end ... txpower is changed from 17 dBm to the maximum. So the
OFFSET summation is the cause of a wrong ah->ah_txpower.txp_cur_pwr
usage. My path fixes exactly that and keeps ah->ah_txpower.txp_cur_pwr
unused for Felix :)

Greetings Thomas


