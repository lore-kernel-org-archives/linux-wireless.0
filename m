Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54462 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2GZKU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 06:20:56 -0400
Received: by obbuo13 with SMTP id uo13so2478855obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 03:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501083F6.8060002@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com>
	<50107C35.9050807@net.t-labs.tu-berlin.de>
	<CAFtRNNz2qG5Fsjd1WVfA-BOSPGZ=WvMzrMwyqn8d6tfiBpkSVw@mail.gmail.com>
	<501083F6.8060002@net.t-labs.tu-berlin.de>
Date: Thu, 26 Jul 2012 13:20:55 +0300
Message-ID: <CAFtRNNxEHaON-uBjgLyeJdgN6UKfed6fAeCYPpo6xToi3dixOw@mail.gmail.com> (sfid-20120726_122100_263179_561DCD6D)
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect user
 txpower changes
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/26 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi Nick,
>
> Nick Kossifidis schrieb:
>
>> 2012/7/26 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>
>> There is nothing in your patch that suggests that's related to this.
>> Anyway there's a simple way to fix this:
>>
>> Just move this:
>>
>> 3575         /* Min/max in 0.25dB units */
>> 3576         ah->ah_txpower.txp_min_pwr = 2 * rates[7];
>> 3577         ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
>> 3578         ah->ah_txpower.txp_ofdm = rates[7];
>>
>> above the for loop and you are done.
>>
>> Note rates[i] don't hold tx power values, they hold indices to the
>> channel powertable.
>>
>
>
> Are you agreeing that current ath5k txpower handling set from user space
> is not working and we need to fix it ?

Is that a rhetorical question ? Just check out the TODOs on wireless.kernel.org.

The current code does not preserve the tx power value across resets,
thats the problem and the change I mentioned above fixes it (patch on
the way, it's just that where I am right now I don't have bw to
download wireless-testing) but other than that when we set tx power
without reseting at least it does what it's supposed to do (and the
result is the same with madwifi, using a spectrum analyzer or another
client/monitor interface you see some power levels supported or only
the max txpower supported, it's really up to the vendor, not all of
them follow Atheros's reference designs). Your patch passes 1dbm units
on a function that expects 0.5dbm units, you fix the problem with
preserving tx power but you break the tx power setting.

The change I mentioned above fixes the problem without introducing new
variables just because "Felix will use the other one", I don't
understand why you have a problem with that and why you think I don't
want this to get fixed...

> Beside that, what about a channel switch and wrongly re-use txp_cur_pwr
> on a channel witch other max power levels ?

That won't be a problem, when channel changes we 'll call

reset -> phy_init -> set_txpower -> (calibration) -> set rate target power

and then it's going to get limited before it's written on hw here:

max_pwr = min(max_pwr, (u16) ah->ah_txpower.txp_max_pwr) / 2;

txp_max_pwr is initialized on calibration (the max power for this
channel), then it gets limited by CTL edge information on EEPROM, then
by max_pwr and then max_pwr is limited by rate_info->target_power_X
from EEPROM to create rates[i]. We write rates[i] on hw, not
txp_cur_pwr.

> Lets wait on Felix opinion what he has in mind.
>
> Greetings Thomas

I 'd rather wait for Felix's patches instead to understand what is he up to.


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
