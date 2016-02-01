Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33387 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbcBACXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 21:23:13 -0500
Received: by mail-io0-f194.google.com with SMTP id f81so10995146iof.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 18:23:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9ED4FD@hasmsx107.ger.corp.intel.com>
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
	<1453760341-30008-1-git-send-email-mar.kolya@gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9D2EC6@hasmsx109.ger.corp.intel.com>
	<CALGY4fv5t7k9Xcw1iysL3gyLih7S4z2Y7ShXTJiXWc5aDVVM_A@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9E3F16@hasmsx107.ger.corp.intel.com>
	<CALGY4fsx3uPox8+=S13thXarW0yGLK+8BSqzjwqRtubrAG1ybQ@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9ED4FD@hasmsx107.ger.corp.intel.com>
Date: Sun, 31 Jan 2016 21:23:12 -0500
Message-ID: <CALGY4ftjhwJjDsgwwfL7NoCnpdqEATL4tsUAPM9yhdsm7ZChqg@mail.gmail.com> (sfid-20160201_032317_730254_F70F78DF)
Subject: Re: [PATCH v2] iwldvm: fix chain gain calibration when firmware
 return zero values
From: Nikolay Martynov <mar.kolya@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"julian.calaby@gmail.com" <julian.calaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-01-28 2:43 GMT-05:00 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>>
>> 2016-01-27 2:46 GMT-05:00 Grumbach, Emmanuel
>> <emmanuel.grumbach@intel.com>:
>> >> Hi
>> >>
>> >> 2016-01-26 3:28 GMT-05:00 Grumbach, Emmanuel
>> >> <emmanuel.grumbach@intel.com>:
>> >> >
>> >> >
>> >> > On 01/26/2016 12:20 AM, Nikolay Martynov wrote:
>> >> >> It looks like sometimes firmware returns zero for chain noise and
>> >> >> signal during calibration period. This seems to be a known problem
>> >> >> and current implementation accounts for this by ignoring invalid
>> >> >> data when all chains return zero signal and noise.
>> >> >>
>> >> >> The problem is that sometimes firmware returns zero for only one
>> >> >> chain for some (not all) beacons used for calibration. This leads
>> >> >> to perfectly valid chains be disabled and may cause invalid gain
>> settings.
>> >> >> For example this is calibration data taken on laptop with Intel
>> >> >> 6300 card with all three antennas attached:
>> >> >>
>> >> >> active_chains:                         3
>> >> >> chain_noise_a:                         312
>> >> >> chain_noise_b:                         297
>> >> >> chain_noise_c:                         0
>> >> >> chain_signal_a:                        549
>> >> >> chain_signal_b:                        513
>> >> >> chain_signal_c:                        0
>> >> >> beacon_count:                  16
>> >> >> disconn_array:                         0 0 1
>> >> >> delta_gain_code:               4 0 0
>> >> >> radio_write:                   1
>> >> >> state:                                 3
>> >> >>
>> >> >> This patch changes statistics gathering to make sure that zero
>> >> >> noise results are ignored for valid rx chains. The rationale being
>> >> >> that even if anntenna is not connected we should be able to see
>> >> >> non zero noise if rx chain is present.
>> >> >
>> >> > But then the firmware will continue to send zero for signal and
>> >> > this will impact lots of flows like roaming. If the driver allows
>> >> > the firmware to use that antenna, the firmware may use this antenna
>> >> > for scanning and roaming will be broken.
>> >> > This seems to be a bug in the firmware, but there isn't much I can
>> >> > do about it.
>> >> > Sorry, I have to NACK this patch.
>> >>
>> >>   Could you please elaborate on how this patch would affect roaming
>> >> or other things. As far as I can see this patch doesn't change much
>> >> behavior apart from ignoring invalid values from firmware.
>> >> Disconnected antennas still get disabled (as before) connected
>> >> antennas still work (more often than before). So I'm not sure I can
>> >> see how this patch would change what firmware does at all. I really
>> >> hope you could find a moment and explain this.
>> >>
>> >
>> > What you are saying here is that there is a bug in the firmware which
>> > makes it report wrong values for one of the antennas. But when you
>> > will have this antenna enabled (with your patch), the firmware will
>> > keep sending bad signal / noise values for it. If the driver allows
>> > the firmware to use this antenna (after your patch), the firmware will
>> > choose this antenna to receive beacons or to scan. Then, the driver will
>> look at the beacons' rssi (which will be wrong) and it will think that an AP
>> which is very close is in fact far away.
>> >
>> No. That is not correct, I think. What I'm saying is that sometimes (not
>> always) firmware is sending 0 (exactly 0) for signal and noise for some (or all)
>> chains.
>> The case when all chains get 0 seem to be a known problem: it is worked
>> around in iwl_find_disconn_antenna. The case when only one chain gets
>> zero is not currently handled.
>> And just to clarify - all chains are affected by this problem, it's not like one
>> specific chain is broken in some way and gets zero. So both of the cards I
>> have may be running with 3 chains or with 2 chains depending on how lucky
>> I'm during initial scan.
>>
>> It's just firmware that has a bug that sometimes returns zero for chain 1,
>> sometimes for chain 2, and sometimes for all of them.
>> So currently driver is already enabling chains for which we may get zero later
>> for rssi (presumably this is true) if it gets non zero during scan for first 16
>> beacons.
>> Moreover, if it gets non-zero for 15 out of 16 beacons the chain is not
>> disabled but gain values are wrong because of this - and one chain would be
>> amplifying things more than it should - this is currently happening to the best
>> of my understanding.
>>
>> So my patch filters out results that we know are bad to account for this
>> firmware bug.
>> With this patch all chains with antenna attached get signal and noise reading -
>> suggesting that firmware actually returns zero only some times and after
>> several retries we get reasonable statistics. It looks like there are some
>> 'transitioning' processes in firmware and if we out-wait them we get good
>> statistics.
>>
>> I'm not sure I see how this patch makes anything more worse than they
>> currently already are.
>> Currently it is already (presumably) possible to get wrong rssi reading
>> because chain that may have been enabled during first scan may get zeros
>> later. All my patch does is to enable all equivalently good (or bad) antennas,
>> instead of two equivalently good (or bad) as current code does.
>>
>> Does this explanation make any sense? Is it flawed in some way?
>> If patch in it's current state seems too controversial would patch that enables
>> this check if some module parameter is set (and it is not set my default) be
>> more acceptable?
>>
>
> Are you sure that the antenna that reported 0 "recovers" and reports good values later?

In fact it does, but apparently that's not the problem (I've checked
with monitor device and after seeing zeros during calibration I see
packets and max rate coming in from AP).

I've done some more testing and it turns out that original problem of
one antenna being disabled is caused by power_save parameter being set
to true. I cannot reproduce the problem with that parameter being set
to false.

I guess firmware turns off some receiving antennas to conserve power
and reports that stat as zero.

I see there is some logic to prevent power saving from affecting this
calibration but it looks like it doesn't work properly when
power_save=true and unfortunately I could not immediately figure out
why.

Please disregard this patch because original problem is cause by power
saving, not by firmware issue (at least as far as I could reproduce).

Sorry for not testing it more thoroughly before sending the patch and
thanks for kindly reviewing it and providing comments!

-- 
Martynov Nikolay.
Email: mar.kolya@gmail.com
