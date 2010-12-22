Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:35010 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab0LVPM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 10:12:28 -0500
Message-ID: <4D121554.9050404@neratec.com>
Date: Wed, 22 Dec 2010 16:12:20 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] DFS: interface for common pattern detector
References: <2121764975.11097.1292943781910.JavaMail.root@idefix> <1874584253.11108.1292944512342.JavaMail.root@idefix> <AANLkTimYjJFUjDmEjSe9pF3-EGVemRXnCd1nitfL5HC2@mail.gmail.com>
In-Reply-To: <AANLkTimYjJFUjDmEjSe9pF3-EGVemRXnCd1nitfL5HC2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2010 05:32 PM, Luis R. Rodriguez wrote:
> On Tue, Dec 21, 2010 at 10:15 AM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com>  wrote:
>>
>>
>> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>> ---
>>   include/net/cfg80211.h |   41 +++++++++
>>   include/net/dfs.h      |  100 +++++++++++++++++++++
>>   2 files changed, 141 insertions(+), 0 deletions(-)
>>   create mode 100644 include/net/dfs.h
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 03b3bae..c3ace0e 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>
> Why not just keep this on dfs.h?
>
With the proposed design the notification about radar pulse events and 
radar detection events are handled by mac80211. That's why I assumed 
this would be the right place.

If we change that now (as discussed) to have per-wiphy detectors 
processing the pulse events locally, we still will need to have the 
notification for radar detection events send to mac80211. But sure, this 
will change during design evolution...


>> @@ -1820,6 +1820,47 @@ struct ieee80211_rate *
>>   ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
>>                             u32 basic_rates, int bitrate);
>>
>> +
>> +/**
>> + * DFS pattern detector interface
>> + */
>> +
>> +/**
>> + * ieee80211_add_radar_pulse - add a pulse detected by HW to detector
>> + *
>> + * @freq: channel frequency in [MHz]
>> + * @ts: time stamp in [us]
>
> Is this the best known resolution we are aware hardware can use?
>
We might go for nsecs here, but the time stamps reported by ath9k in the 
events seem to have already a deviation of several usecs, so it might be 
useless to increase resolution (at least for current HW).

>> + * @rssi: rssi value for the deteced pulse
>
> RSSI values are vendor defined values, for Atheros it happens to be in
> dBm above the noise floor, and the value is measured during the
> preamble and PLCP; i.e. with the initial 4us of detection. If we can
> assume other radar pulses from other vendors will match this same
> definition then we can share the pulse rssi information, otherwise we
> can't.

Agree. In fact, the RSSI value is currently not used in the detector. 
Initially I was assuming that the RSSI values of proximate radar pulses 
should be similar and therefore usable as indication for true pulses. 
But the measured values disprove this assumption, i.e. subsequent events 
have randomly fluctuating RSSI values.

So, not sure if RSSI can be used to improve detection at all. Will maybe 
be removed, pushing the validity decision to caller.

>
> Ideally I wish we could use instead RCPI but I am not sure if AR9003 /
> AR9280 can support a translation of the RSSI value to RCPI, IIRC we
> could not, but there was some goals in newer hardware to make this
> happen, so maybe AR9003 can.. we'll have to check.
>
>> + * @width: pulse width in [us]
>> + *
>
> I suppose us is a reasonable value to use, but do we want a higher
> resolution just in case for the future?
>
Agree. In fact, we already need a higher resolution, since ETSI defines 
pulse widths starting at 0.8 us.

In practice, this is not quite relevant, since we measured that the 
values reported from ath9k are anyway 0 for widths < 3us.

But sure, we can use nsecs here.

>> + * Each pulse the HW identified as radar is fed into the detector via this
>> + * function. The three values for ts, rssi and width are those relevant for
>> + * pattern matching, while freq is required to map the pulse to the correct
>> + * DFS channel.
>> + * No value is returned, assuming the HW does not need to know about the result
>> + * of pattern matching. The further processing of matches is done at mac layer.
>> + */
>> +extern void ieee80211_add_radar_pulse(u16 freq, u64 ts, u8 rssi, u8 width);
>
> Maybe we should just keep pulses specific to the drivers and only let
> them inform us of the actual radar signals determinations. Seems
> overkill to share pulse information, or at least pointless if we
> cannot sure or have to address a lot to try to share. Unless of course
> we can share RCPI based DFS radar pulse recipes.
>

That was one core topic when we discussed where to place the detector. I 
was arguing that it is well placed in a common location, since pattern 
matching should work the same way for all devices that detect pulses.

You opt to put it close to the PHY to use additional information not 
common to other chipsets. But, at the end of the day - after you took 
all available information into account - you need to do this binary 
decision: either it was a pulse or it was not. So, why not use all 
available info to ensure that there was a pulse and then send it to 
common detector?

I stick to this issue for a very practical reason: as soon as pattern 
detection is not HW independent any more, I can not test and fine-tune 
the detection algorithms to balance it out with pure SW based simulation.

>> +/**
>> + * ieee80211_radar_detected - notify mac that DFS radar was detected
>> + *
>> + * @freq: channel frequency in [MHz]
>> + *
>> + * This function is used to inform the mac that a DFS radar was detected on
>> + * the given channel frequency. It might be called from the DFS pattern
>> + * detector or from device drivers that do DFS detection in HW.
>> + *
>> + * It is meant to be the central hook that initiates all subsequent actions that
>> + * need to be performed after the detection, including
>> + *  - put channel to Unavailable list (or adjust channel state periods
>> + *    in case channel was already not on Available list)
>> + *  - everything else required to select new channel and initiate
>> + *    channel switch
>> + */
>> +extern void ieee80211_radar_detected(u16 freq);
>
> So drivers and mac80211 would call this right?
>

Everyone who detect radars should do, being it the driver of a HW 
supporting on-chip radar detection, being it the pattern detector, or 
being someone else who knows that there is a radar (think of nearby APs 
in mobile networks).

>> +
>>   /*
>>   * Radiotap parsing functions -- for controlled injection support
>>   *
>> diff --git a/include/net/dfs.h b/include/net/dfs.h
>> new file mode 100644
>> index 0000000..1dccc10
>> --- /dev/null
>> +++ b/include/net/dfs.h
>> @@ -0,0 +1,100 @@
>> +#ifndef DFS_H
>> +#define DFS_H
>> +/*
>> + * Copyright 2010, Neratec Solutions AG,<zefir.kurtisi@neratec.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +/**
>> + * DOC: Introduction
>> + *
>> + * DFS radar detector interface
>> + *
>> + * This is a proposal for a common DFS pattern detector interface.
>> + *
>> + * It should be used by devices that are able to detect radar pulses and need
>> + * pattern matching (as defined by ETSI, FCC, JP regulatories).
>> + *
>> + * An instance of the proposed DFS handler is supposed to exist during an
>> + * endpoint's lifetime within mac80211. WLAN devices should report the radar
>> + * pulses they detect during their uptime, the DFS handler aggregates them and
>> + * keeps track of channel states (as defined by regulatories).
>> + *
>> + * On channel state changes it notifies mac80211 to initiate all required
>> + * processing.
>> + */
>> +
>> +
>> +/* TODO: move those to more common place */
>> +enum dfs_domain {
>> +       DFS_INVALID_DOMAIN      = 0,    /* Uninitialized dfs domain */
>> +       DFS_FCC_DOMAIN          = 1,    /* FCC dfs domain */
>> +       DFS_ETSI_DOMAIN         = 2,    /* ETSI dfs domain */
>> +       DFS_JP_DOMAIN           = 3,    /* Japan dfs domain */
>> +};
>
> You can use the values I posted on my series for this.
>
ok.
>> +
>> +/* TODO: move dfs_state to more common place */
>> +enum channel_dfs_flags {
>> +       CHANNEL_INVALID         = 0x00,
>
> Do we really need INVALID ? Please document each of these.
>
ok.
>> +       CHANNEL_UNAVAILABLE     = 0x01,
>> +       CHANNEL_USABLE          = 0x02,
>> +       CHANNEL_AVAILABLE       = 0x04,
>> +       CHANNEL_OPERATING       = 0x08,
>> +};
>> +
>> +/**
>> + * struct pulse_event - events fed to the dfs handler
>> + *
>> + * @ts: absolute time stamp for start of pulse in us (e.g. as TSF)
>> + * @freq: channel frequency in [MHz]
>> + * @rssi: rssi value for the given pulse
>> + * @width: pulse width for given pulse in [us]
>> + *
>> + */
>> +struct pulse_event {
>> +       u64 ts;
>> +       u16 freq;
>> +       u8  rssi;
>> +       u8  width;
>> +};
>
> Yeah, this seems hardware specific, so likely not something we can
> share I think.
>
Basically, as said above. If a device is capable to detect radar pulses, 
the relevant information for the events should be available (besides the 
now unused RSSI info). This values are the only ones that can be used 
for pattern matching.

If some driver can not provide them, no pattern matching is possible.

If some driver needs to reconstruct them from other information, ok 
(like set width fixed to 20 if chirping was detected to generate a valid 
event for ETSI radar pattern #4).

>
>> +/**
>> + * struct dfs_handler - DFS handler pseudo-OO interface
>> + *
>> + * @exit: terminate DFS handler and release all resources
>> + * @add_pulse: add given pulse event to detector lines
>> + *             returns 1 if added event triggered a pattern match
>> + * @data: private instance data
>> + *
>> + * To easily attach pulse detectors implementing different types matching
>> + * algorithms, a pseudo-OO design approach was taken with a tiny interface is
>> + * chosen.
>> + */
>
> Not sure I get what this is for.
>
This is the base class for DFS handlers. DFS handlers support pattern 
matching for all DFS channels in a given DFS regulatory domain.

In its simplest form it uses one pattern detector and simply forwards 
the events received and returns the detector's result unfiltered.

More sophisticated handlers might use multiple pattern detectors with 
different matching algorithms and employ voting based decision making 
for proper balancing.


>> +struct dfs_handler {
>> +       /* VFT */
>> +       void (*exit)(struct dfs_handler *_this);
>> +       int (*add_pulse)(struct dfs_handler *_this, struct pulse_event *event);
>> +
>> +       /* private data */
>> +       struct dfs_data *data;
>> +};
>> +
>> +/**
>> + * dfs_handler_init - DFS handler constructor
>> + *
>> + * @dfs_domain: DFS domain to detect radar patterns for
>> + *
>> + * A DFS handler instance is allocated via this constructor.
>> + * On success the pointer to the fully initialized handler is returned that
>> + * can be fed with radar pulses during its lifetime. Allocated resources are
>> + * released upon calling the destructor.
>> + *
>> + * On failure NULL is returned.
>> + */
>> +struct dfs_handler *dfs_handler_init(enum dfs_domain dfs_domain);
>
> Same here.
>
That's the constructor that allocates the DFS handler object.

Or what is unclear?

>    Luis

Cheers, Zefir
