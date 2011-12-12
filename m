Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49857 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1LLOiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 09:38:04 -0500
Received: by qcqz2 with SMTP id z2so3548872qcq.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 06:38:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323680785.3442.9.camel@jlt3.sipsolutions.net>
References: <20111209223131.71B17206F0@glenhelen.mtv.corp.google.com>
	<1323680785.3442.9.camel@jlt3.sipsolutions.net>
Date: Mon, 12 Dec 2011 06:38:02 -0800
Message-ID: <CAMcMvsj4ZF8qPbjY5Fx-auAOOnGp9METhBEOGd7rzKUx0-4ObA@mail.gmail.com> (sfid-20111212_153821_913786_588FB004)
Subject: Re: [PATCH] cfg80211: Return beacon loss count in station
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 12, 2011 at 1:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-12-09 at 11:01 -0800, Paul Stewart wrote:
>> If station info contains a beacon loss count, return
>> it to userspace.
>
>
>> + * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
>
> Hmm, this is very vague. Are you sure it does what you think it does?
> Some drivers like wl12xx might not trigger the beacon loss function for
> every beacon, instead aggregating things. I implemented this in iwlwifi
> once and it would only tell mac80211 roughly every 20 beacons about
> missed ones...
>
> This should at least be documented, but I fear it makes the value rather
> useless in the general case.

I actually differ on that.  I completely agree that this is not a
count of how many beacons were lost, but it does represent an
important statistic worth measuring, which is how often the system
enters a state where it is trying to recover from beacon loss.  You
can't get this information anywhere else (unless you turn on
MAC80211_VERBOSE_DEBUG and go trawling through the logs) and my aim is
to collect swaths of this information to get qualitative information
about the occurrence count of this situation for a large population of
users.  It seems like the cleanest way to get at it, regardless of the
somewhat device-specific interpretation (which one can always account
for).

> johannes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
