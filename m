Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:34227 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab2DKLAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 07:00:34 -0400
Message-ID: <4F856449.3000804@etit.tu-chemnitz.de> (sfid-20120411_130039_717553_DE4F5AD5)
Date: Wed, 11 Apr 2012 13:00:25 +0200
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	javier@cozybit.com, Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
References: <4F630AEA.10703@etit.tu-chemnitz.de> <20120316204547.GG18861@tux> <4F63BA31.1080608@etit.tu-chemnitz.de>
In-Reply-To: <4F63BA31.1080608@etit.tu-chemnitz.de>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/12 23:09, Marco Porsch wrote:
> On 03/16/12 21:45, Luis R. Rodriguez wrote:
>> On Fri, Mar 16, 2012 at 10:42:02AM +0100, Marco Porsch wrote:
>>> Hi,
>>>
>>> I am trying to implement the IEEE 802.11s power save schemes in mac80211.
>>> In 11s it is defined that power save STA doze AND send beacons AND
>>> wake up periodically for multiple neighbors beacons.
>>>
>>> Is this actually possible with current hardware/drivers (especially ath9k)?
>
> [ ... ]
>
>> I don't have time to review this but it sounds correct that the part
>> you want to focus on is introducing a wake up mechanism when you
>> need to initiate radiation for your own beacons.  I think right now
>> we simply disable PS in mac80211 completely if we have a mode of
>> operation that require beconing.

I did some hacking and can now answer part one of my question:
yes, beaconing and power save are not mutually exclusive with ath9k [1].

Second question: what about power save doze and waking up for _multiple_ 
neighbors' beacons?

Currently the whole sleep scheduling seems to be determined by 
conf->beacon_interval and conf->dtim_period in case of a station 
(client). Unfortunetely, these are the same variables that determine the 
STAs own beacon interval in case of AP/mesh/ad-hoc. Additionally, for 
mesh mode we will need a whole list of wake-up events (light sleep 
neighbors' beacons).

Thus, I think we will need an additional/extended interface 
mac80211<->driver here.

I see two possibilities:
a) request the next wakeup time from mac80211 each time the hardware is 
put to sleep (e.g. from ath9k_ps_restore).
b) give a whole list of periodic wakeup events of all vif to the driver. 
Then the driver is supposed to sort out the closest event.

What would be the better approach for such an interface? Or maybe a 
completely different idea?

Positive side effect: this will also enable power save when multiple 
managed interfaces are up - or combinations of different 
powersave-enabled interfaces.

Regards,
Marco


[1]
In mac80211 I removed some restrictions for mesh and basically hand the 
own STAs beacon interval to the driver (similar to ieee80211_recalc_ps).
In ath9k I merged the contents of the functions ath_beacon_config_sta 
and ath_beacon_config_adhoc with the result that beaconing is enabled 
and a power save schedule is set up.

The result is that I see an alternation of AWAKE and NETWORK SLEEP state 
with the given beacon interval period. Additionally, the log shows that 
no packets are received during the NETWORK SLEEP period, so the receiver 
seems to be actually suspended. I have not yet measured the power 
consumption though. Capturing with wireshark shows that the own mesh 
beacons are still sent regularly.
Of course, currently this breaks any connectivity when mesh PS is 
enabled. But it does not crash. And connectivity resumes when PS is 
disabled once again.
