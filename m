Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50356 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755749AbeFOMTe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 08:19:34 -0400
Message-ID: <1529065171.10037.16.camel@sipsolutions.net> (sfid-20180615_141940_332912_5A6E6E07)
Subject: Re: [RFCv2 1/2] nl80211: support per-rate/per-station statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sriram R <srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Jun 2018 14:19:31 +0200
In-Reply-To: <1527514479-6696-2-git-send-email-srirrama@codeaurora.org>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
         <1527514479-6696-2-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-28 at 19:04 +0530, Sriram R wrote:
> Per-rate/per-station statistics can be desirable to have but they're
> quite expensive (keeping the four counters for each rate would take
> close to 4k of memory per station only for VHT MCSes for a moderately
> capable VHT chip (with 2 spatial streams and 80MHz support) so it's
> not a good idea to keep all of this in the kernel.
> 
> Instead, this API provides a way for interested clients in userspace
> to subscribe to such statistics. When supported by a driver, it can
> then start collecting the data only when subscribers exist. To avoid
> the kernel's data collection becoming too big, it can send out the
> data at any point in time, for example to limit the counters to u16
> internally and send it out when they're close to reaching the limit,
> or to keep a hash table and sending it out when too many collisions
> occur. Userspace can then keep track of the full state.
> 
> Based on below implementation by Johannes Berg <johannes@sipsolutions.net>
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172
> with following changes,

Err, that's pretty much an exact copy of my patch ...

You should keep the author attribution and signed-off-by, and if you
want your work to be separately attributed then just put the changes you
made into (a) separate patch(es).

>  1. Allow rx bytes stats to be collected

This seems OK.

>  2. Rate info sent to userspace is encoded into 32bit value

This I don't like at all. It's fine for the internal representation, and
I know I did something like that in mac80211 (though I guess at the time
it was only 16 bit), but it's not OK for the userspace representation.

I just merged patches to support HE in the userspace representation, and
that's properly taken into account in struct rate_info which I had here
in my version of the patch.

johannes
