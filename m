Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38091 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752499AbcLTUwd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 15:52:33 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
Date: Tue, 20 Dec 2016 20:52:23 +0000
Message-ID: <20161220205221.GB9756@jouni.qca.qualcomm.com> (sfid-20161220_215237_360124_50AA752C)
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
 <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
 <1481102727.4092.34.camel@sipsolutions.net>
 <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
 <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
 <20161208175236.GA6121@jouni.qca.qualcomm.com>
 <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com>
 <1481644615.20412.25.camel@sipsolutions.net>
 <20161215110635.GA11840@jouni.qca.qualcomm.com>
 <1481882211.27953.18.camel@sipsolutions.net>
In-Reply-To: <1481882211.27953.18.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 16, 2016 at 10:56:51AM +0100, Johannes Berg wrote:
> On Thu, 2016-12-15 at 11:06 +0000, Malinen, Jouni wrote:
> > Maybe the nl80211.h description was not clear enough, but the
> > comments in cfg80211.h should be quite clear on how this was designed
> > to work at the implementation level:
> >=20
> > "If the current connected BSS is in the 2.4 GHz band, other BSSs in
> > the 2.4 GHz band to be reported should have better RSSI by
> > @relative_rssi and other BSSs in the 5 GHz band to be reported should
> > have better RSSI by (@relative_rssi - @relative_rssi_5g_pref).
> > If the current connected BSS is in the 5 GHz band, other BSSs in the
> > 2.4 GHz band to be reported should have better RSSI by
> > (@relative_rssi + @relative_rssi_5g_pref) and other BSSs in the 5 GHz
> > band to be reported should have better RSSI by by @relative_rssi."
>=20
> Oh, right. Should probably be in nl80211.h too, to set expectations
> from userspace.

Sure, we can update that in the next revision.

> > At minimum, we would need to clearly document struct
> > nl80211_bss_select_rssi_adjust, but even if we do, I'm not sure it
> > really is ideal mechanism to move to now that I realized it is not an
> > array, but a single band,delta pair.
>=20
> We can move to an array easily in the future by extending the attribute
> length and advertising the number of array entries that are supported,
> if that's your biggest concern? I don't see it as being very useful
> right now since I don't think we'll see offloaded roaming between 2.4/5
> and 60 GHz anytime soon. This may change when we add more bands later,
> I suppose.

Hmm.. So do you want us to move to using this packed struct in the new
attribute instead of using a signed 8-bit integer as the variable value?

> > If we are talking only about roaming within an ESS (a single SSID),
> > that would sound clear, but which relative RSSI rules would apply if
> > there are match sets for both the currently connected SSID and
> > another SSID that the candidate BSS is for?
>=20
> Right, I see how this might become a problem. I generally see no issue
> with supporting multiple matchsets with different SSIDs but all having
> the "relative to connected BSS RSSI filter" (which would disregard the
> SSID specified in the matchset), but this then would become a problem
> when multiple matchsets are specified with *different* such RSSI
> filters, e.g. one matchset would specify that you want a 5G preference
> of 10dB, but the other would specify a preference of only 5dB.
>=20
> Conceptually in this approach, that would be supported, but firmware
> likely would not be able to express this, I suppose?

That's certainly not at the level we were planning on implementing.. :)

> > I think I'm missing something here.. Where would the threshold value
> > (how much better new BSS needs to be) be stored? And do we really
> > want something like the combination of
> > NL80211_BSS_SELECT_ATTR_BAND_PREF and
> > NL80211_BSS_SELECT_ATTR_RSSI_ADJUST which seems to be two different
> > ways of doing band preference (the former without specifying delta
> > and the latter with specific delta)? Or am I still not understanding
> > how NL80211_BSS_SELECT_ATTR_* really works?
>=20
> No, you're right, I missed the "better by" threshold.
>=20
> I think between that (unless we add that, we could technically extend
> flag attributes to allow them being an int as well, or add a new one)
> and the fact that the device may not support different relative RSSI
> matches in different matchsets, I'm almost convinced that adding new
> attributes is better.

I'm not completely sure how to interpret all this and also the last
email from Arend in this thread. Could either (or both :) of you provide
more detailed suggestion on what exactly you would like us to change, if
anything, in the attribute design now so that we can try to close on
this?

--=20
Jouni Malinen                                            PGP id EFC895FA=
