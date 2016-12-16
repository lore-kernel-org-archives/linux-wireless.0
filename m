Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55488 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760343AbcLPJ4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:56:54 -0500
Message-ID: <1481882211.27953.18.camel@sipsolutions.net> (sfid-20161216_105719_239081_854A5C81)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 10:56:51 +0100
In-Reply-To: <20161215110635.GA11840@jouni.qca.qualcomm.com>
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
         <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
         <1481102727.4092.34.camel@sipsolutions.net>
         <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
         <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
         <20161208175236.GA6121@jouni.qca.qualcomm.com>
         <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com>
         <1481644615.20412.25.camel@sipsolutions.net>
         <20161215110635.GA11840@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-15 at 11:06 +0000, Malinen, Jouni wrote:
> On Tue, Dec 13, 2016 at 04:56:55PM +0100, Johannes Berg wrote:
> > Regarding reusing attributes, we have (for the BSS selection thing)
> > the attribute NL80211_BSS_SELECT_ATTR_RSSI_ADJUST, which is really
> > quite similar to your
> > new NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF since while
> > connected (which BSS_SELECT_ATTR_* assumes) the current BSS is
> > always part of the considered BSSes, I'd think.
> 
> It seems to have somewhat similar meaning, but it looks more generic
> by not being tied to just two bands (2.4 and 5). And now that I
> actually looked again at this, it does not look like
> NL80211_BSS_SELECT_ATTR_RSSI_ADJUST actually allows more than a
> single band,delta pair to be provided and as such, it actually would
> not work very well with more than two bands even if it might be a bit
> more generic by allowing band to be set to something else than 2.4 or
> 5. 

Agree, it wouldn't work well with more than 2 bands. Not that we have
them now (60GHz doesn't really count here).

> By the way, nl80211.h does not seem to document what values struct
> nl82011_bss_select_rssi_adjust band uses..  Is this enum
> nl80211_band?

I believe so, we should fix that.

> Neither does it say that delta is in dB (is it?).

We should also fix that, but let's assume so for the sake of this
discussion.

> > OTOH, the new NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF doesn't
> > make this quite clear - is the current BSS to be adjusted before
> > comparing, if it's 5 GHz? If so, the semantics are equivalent. If
> > not, it doesn't actually make much sense ;-)
> 
> Maybe the nl80211.h description was not clear enough, but the
> comments in cfg80211.h should be quite clear on how this was designed
> to work at the implementation level:
> 
> "If the current connected BSS is in the 2.4 GHz band, other BSSs in
> the 2.4 GHz band to be reported should have better RSSI by
> @relative_rssi and other BSSs in the 5 GHz band to be reported should
> have better RSSI by (@relative_rssi - @relative_rssi_5g_pref).
> If the current connected BSS is in the 5 GHz band, other BSSs in the
> 2.4 GHz band to be reported should have better RSSI by
> (@relative_rssi + @relative_rssi_5g_pref) and other BSSs in the 5 GHz
> band to be reported should have better RSSI by by @relative_rssi."

Oh, right. Should probably be in nl80211.h too, to set expectations
from userspace.

> I'm not sure I'd describe this as adjusting the current BSS RSSI, but
> more like adjusting the RSSI threshold value if roaming would be from
> one band to another and doing that adjustment by adding or
> decrementing based on whether the roam would be from 2.4 to 5 or from
> 5 to 2.4.

It's functionally equivalent to doing the following adjustment

compare_rssi = current_bss_rssi
if current_bss_is_5ghz:
    compare_rssi += relative_rssi_5g_pref

and then comparing all values (again adjusted for 5 GHz BSSes) to this.

(which is what I meant by "adjusting the current BSS RSSI").

> > So assuming that it is in fact taken into account after the same
> > adjustment, the two attributes are equivalent, and then perhaps it
> > would make sense to use struct nl80211_bss_select_rssi_adjust for
> > the new attribute. If a driver doesn't support arbitrary bands, but
> > just 5 GHz as in your example, it can just flip it around to 2.4
> > GHz by switching the sign.
> > 
> > Perhaps we should even consider doing that in cfg80211 and
> > adjusting the internal API for both that way?
> 
> I'm not completely sure I understood. One thing to note about
> differences here is that NL80211_BSS_SELECT_ATTR_* seems to be
> defining some preferences for BSS selection based on RSSI with an
> additional band preference, but it does not seem to define the
> threshold by how many dB the new candidate BSS should be better.

It's defining more than what we're talking about here, absolutely.
Clearly somebody thought a pure band preference might be useful (to
never connect to a 2.4GHz AP if a 5 GHz AP is available, regardless of
their relative RSSI), but that's not what we're looking at here.
(That could probably also be achieved by setting the adjustment to
90dB, but whatever)

> At minimum, we would need to clearly document struct
> nl80211_bss_select_rssi_adjust, but even if we do, I'm not sure it
> really is ideal mechanism to move to now that I realized it is not an
> array, but a single band,delta pair.

We can move to an array easily in the future by extending the attribute
length and advertising the number of array entries that are supported,
if that's your biggest concern? I don't see it as being very useful
right now since I don't think we'll see offloaded roaming between 2.4/5
and 60 GHz anytime soon. This may change when we add more bands later,
I suppose.

> Arend:
> > > I am not saying it should be avoided. Just looking at it
> > > conceptually
> > > the scheduled scan request holds so-called matchsets that specify
> > > the
> > > constraints to determine whether a BSS was found that is worth
> > > notifying the host/user-space about. As such I would expect the
> > > relative RSSI attribute(s) to be part of the matchset. That way
> > > you
> > > can specify it together with the currently connected SSID in a
> > > single
> > > matchset.
> > 
> > I think this makes a lot of sense.
> 
> If we are talking only about roaming within an ESS (a single SSID),
> that would sound clear, but which relative RSSI rules would apply if
> there are match sets for both the currently connected SSID and
> another SSID that the candidate BSS is for?

Right, I see how this might become a problem. I generally see no issue
with supporting multiple matchsets with different SSIDs but all having
the "relative to connected BSS RSSI filter" (which would disregard the
SSID specified in the matchset), but this then would become a problem
when multiple matchsets are specified with *different* such RSSI
filters, e.g. one matchset would specify that you want a 5G preference
of 10dB, but the other would specify a preference of only 5dB.

Conceptually in this approach, that would be supported, but firmware
likely would not be able to express this, I suppose?


> > We already have NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, which asks to
> > be reporting only networks that have an *absolute* RSSI value above
> > the value of the attribute - a new attribute to make it relative to
> > the current network instead would make sense.
> 
> When you say "current network", do you mean the current BSS? This
> gets complex when thinking about multiple SSIDs (which some call
> "networks") and there being NL80211_SCHED_SCAN_MATCH_ATTR_SSID and
> multiple match sets..

Yes, I did mean "current BSS". And yes - it does seem complex, see
above.

> > That would indeed be equivalent to NL80211_BSS_SELECT_ATTR_RSSI
> > then.
> 
> NL80211_BSS_SELECT_ATTR_RSSI is a flag attribute.. BSS select
> mechanism does not provide an absolute RSSI value or threshold; it
> just seems to indicate use of RSSI-based selection mechanism without
> defining what exactly is better. There is
> NL80211_BSS_SELECT_ATTR_BAND_PREF that gives a preference to a
> specific band (without defining what that preference is) and then the
> NL80211_BSS_SELECT_ATTR_RSSI_ADJUST that can actually give a specific
> RSSI adjustment value (in dB?).
> 
> > Now, if we consider this, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI
> > actually is equivalent to NL80211_BSS_SELECT_ATTR_RSSI (a flag
> > attribute indicating whether or not RSSI-based selection/matching
> > is done) and NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF is
> > equivalent to NL80211_BSS_SELECT_ATTR_RSSI_ADJUST, both need to be
> > given with the flag and affect operation.
> 
> Hmm.. So you did notice it is a flag attribute.. So how would this
> match NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI which provides the
> threshold value for how many dB better the new BSS needs to be for it
> to be reported?

Yeah, umm, I think I got confused. There's no threshold in the
BSS_SELECT case, and maybe there doesn't need to be (at least not to
avoid host wakeups, though you'd want some hysteresis to avoid swapping
around too much).

> > So, how about we move these into NL80211_SCHED_SCAN_MATCH_ATTR_* as
> > suggested by Arend, and define them with the same content as  the
> > corresponding NL80211_BSS_SELECT_ATTR_*?
> 
> I think I'm missing something here.. Where would the threshold value
> (how much better new BSS needs to be) be stored? And do we really
> want something like the combination of
> NL80211_BSS_SELECT_ATTR_BAND_PREF and
> NL80211_BSS_SELECT_ATTR_RSSI_ADJUST which seems to be two different
> ways of doing band preference (the former without specifying delta
> and the latter with specific delta)? Or am I still not understanding
> how NL80211_BSS_SELECT_ATTR_* really works?

No, you're right, I missed the "better by" threshold.

I think between that (unless we add that, we could technically extend
flag attributes to allow them being an int as well, or add a new one)
and the fact that the device may not support different relative RSSI
matches in different matchsets, I'm almost convinced that adding new
attributes is better.

> The main concern I have for optional features with sched_scan is in
> whether the device ends up being woken up constantly if the driver
> does not understand a constraint that user space is trying to use to
> avoid being notified all the time.

Agree.

johannes
