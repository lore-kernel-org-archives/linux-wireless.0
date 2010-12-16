Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:3461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0LPMqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:46:35 -0500
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id oBGCkXHo007044
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:46:34 -0800
Received: from iyi12 (iyi12.prod.google.com [10.241.51.12])
	by wpaz21.hot.corp.google.com with ESMTP id oBGCkAcZ009188
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:46:32 -0800
Received: by iyi12 with SMTP id 12so1732149iyi.5
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:46:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292502934.3612.15.camel@jlt3.sipsolutions.net>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	<1292482775.3542.8.camel@jlt3.sipsolutions.net>
	<AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	<1292499024.3612.3.camel@jlt3.sipsolutions.net>
	<AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	<1292501047.3612.9.camel@jlt3.sipsolutions.net>
	<AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
	<1292502934.3612.15.camel@jlt3.sipsolutions.net>
Date: Thu, 16 Dec 2010 04:46:32 -0800
Message-ID: <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 4:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 04:27 -0800, Paul Stewart wrote:
>
>> > How so? After resume, mac80211 will invoke start(), add interfaces and
>> > stations back, and then invoke drv_config with all flags in "changed"
>> > set. Therefore, at this point, the device should be reset. Where's this
>> > not working?
>>
>> I haven't dug deep into it, but I can guess at a reason -- ath9k stores idle
>> state in two different places -- one is meant to mirror mac80211's state,
>> and the other one is internal, periodically computed from the state of all
>> wiphys. The ath9k version of the fix modified the
>> internal state without the mac80211 mirror.
>
> But at this point mac80211 doesn't care what the state is any more.

Huh?  I'm not sure I understand this statement.  If mac80211 suspends
and resumes with open_count > 1 (e.g, with an associated STA), I argue
mac80211 _does_ care what the state is.  In fact, although we called
stop() on the driver, there's every expectation that on resume any state
stored on suspend is recovered.  Are you not assuming this?

>> The ath9k config() routine
>> probably does nothing when called with "all changed" on resume because
>> in fact, if we suspend and resume when non-idle, nothing _has_ changed
>> from that perspective.
>
> Hmm, I still don't get it. The "idle just changed" flag is set -- and
> idle will actually be what it was at suspend time. If ath9k was simply
> setting its own idle state on stop(), and returning to what mac80211
> says when it first configures the device after start(), what would the
> problem be?

I don't have the code in front of me (in transit at the moment), but I'm
pretty sure the config routine in ath9k only checks to see whether the
idle state mac80211 passes in is different from the previous passed-in
value. It doesn't care what its internal state is because it believed it was
computed from mac80211 passed-in values.  It may be possible to
rework that code.

>>   I fear that unless ath9k gets changed more
>> substantially, it really does need to be informed of IDLE changes.
>
> I'd rather have ath9k change more than try to enforce this perfectly in
> mac80211. I still think that's brittle, and every little bug in a corner
> case will cause severe problems since it causes suspend/resume to fail.
>
> johannes
>
>
