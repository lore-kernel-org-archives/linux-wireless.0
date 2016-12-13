Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50406 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932760AbcLMP46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:56:58 -0500
Message-ID: <1481644615.20412.25.camel@sipsolutions.net> (sfid-20161213_170026_876273_904A6E1A)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Dec 2016 16:56:55 +0100
In-Reply-To: <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com> (sfid-20161208_213521_115415_9F816683)
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
         <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
         <1481102727.4092.34.camel@sipsolutions.net>
         <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
         <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
         <20161208175236.GA6121@jouni.qca.qualcomm.com>
         <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com>
         (sfid-20161208_213521_115415_9F816683)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok... this is getting complicated :)

Regarding reusing attributes, we have (for the BSS selection thing) the
attribute NL80211_BSS_SELECT_ATTR_RSSI_ADJUST, which is really quite
similar to your new NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF since
while connected (which BSS_SELECT_ATTR_* assumes) the current BSS is
always part of the considered BSSes, I'd think.

However, I tend to think now that reusing the attribute is perhaps not
the right thing to do - but defining them with the same semantics would
still make sense.

Assuming that the value defined in NL80211_BSS_SELECT_ATTR_RSSI_ADJUST
applies also to the *current* BSS, it's actually quite pointless to
define there the band to adjust - if you want to adjust 2.4 GHz
positively you might as well adjust 5 GHz negatively, and vice versa,
and both ways are supported.

OTOH, the new NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF doesn't
make this quite clear - is the current BSS to be adjusted before
comparing, if it's 5 GHz? If so, the semantics are equivalent. If not,
it doesn't actually make much sense ;-)
So assuming that it is in fact taken into account after the same
adjustment, the two attributes are equivalent, and then perhaps it
would make sense to use struct nl80211_bss_select_rssi_adjust for the
new attribute. If a driver doesn't support arbitrary bands, but just 5
GHz as in your example, it can just flip it around to 2.4 GHz by
switching the sign.

Perhaps we should even consider doing that in cfg80211 and adjusting
the internal API for both that way?

> I am not saying it should be avoided. Just looking at it conceptually
> the scheduled scan request holds so-called matchsets that specify the
> constraints to determine whether a BSS was found that is worth
> notifying the host/user-space about. As such I would expect the
> relative RSSI attribute(s) to be part of the matchset. That way you
> can specify it together with the currently connected SSID in a single
> matchset.

I think this makes a lot of sense.

We already have NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, which asks to be
reporting only networks that have an *absolute* RSSI value above the
value of the attribute - a new attribute to make it relative to the
current network instead would make sense.

That would indeed be equivalent to NL80211_BSS_SELECT_ATTR_RSSI then.

Now, if we consider this, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI
actually is equivalent to NL80211_BSS_SELECT_ATTR_RSSI (a flag
attribute indicating whether or not RSSI-based selection/matching is
done) and NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF is equivalent
to NL80211_BSS_SELECT_ATTR_RSSI_ADJUST, both need to be given with the
flag and affect operation.

However, NL80211_BSS_SELECT_ATTR_BAND_PREF doesn't exist, and reusing
the BSS_SELECT namespace also doesn't make sense.


So, how about we move these into NL80211_SCHED_SCAN_MATCH_ATTR_* as
suggested by Arend, and define them with the same content as  the
corresponding NL80211_BSS_SELECT_ATTR_*?

If they're part of match attributes, we might even remove the feature
flag entirely - those were always defined to be optional, but it very
well be worthwhile for userspace to know if they're supported if it
wants to behave differently depending on whether they're supported or
not, I'll leave that up to you since presumably you know the userspace
implementation that you're planning to create.

johannes
