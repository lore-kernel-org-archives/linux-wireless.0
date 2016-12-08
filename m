Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43394 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbcLHRwt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 12:52:49 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
Date: Thu, 8 Dec 2016 17:52:39 +0000
Message-ID: <20161208175236.GA6121@jouni.qca.qualcomm.com> (sfid-20161208_185315_861995_D1EE5B2A)
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
 <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
 <1481102727.4092.34.camel@sipsolutions.net>
 <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
 <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
In-Reply-To: <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2016 at 09:03:23PM +0100, Arend Van Spriel wrote:
> On 7-12-2016 10:33, Vamsi, Krishna wrote:
> >> -----Original Message-----
> >> From: Johannes Berg [mailto:johannes@sipsolutions.net]
> >=20
> >> What about Arend's comment regarding this functionality overlapping wi=
th the
> >> BSS selection offload configuration?
> >>
> >> Do you think there's any ability to share attributes/functionality?
> >=20
> > Hi Johannes,
> >=20
> > I think the later comment from Luca on this which I pasted below is mor=
e agreeable.
> >=20
> > Yes, similar but not quite the same.  The existing case is for finding =
BSSs that are worth waking the host up for (while disconnected), so it need=
s to be better than the RSSI passed (absolute number).  Now this is about r=
elative RSSI as compared to the current connection, so RELATIVE_RSSI is dif=
ferent than RSSI and I think the same attribute should not be used, to avoi=
d confusion.
>=20
> I noticed the response from Luca, but did not get back on this. I know
> it is not the same, but what I meant is whether we could extend it so it
> also covers your scenario.

I'm not sure I see the point of trying to avoid the new RELATIVE_RSSI
attribute. We need to clearly specify that this new constraint is indeed
for relative comparison against the currently connected BSS.

As far as your second email is concerned, it might make more sense to
use the existing NL80211_ATTR_BSS_SELECT instead of the new
NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF since they cover very
similar purpose in defining RSSI preference between bands. We can take a
look at doing so. One thing to be a careful about this is in what claims
there are about using NL80211_ATTR_BSS_SELECT for capability indication
in GET_WIPHY. I guess we can leave that as-is to apply for _CONNECT and
the new EXT_FEATURE flag we are adding for sched_scan applies for this
attribute in SCHED_SCAN.

--=20
Jouni Malinen                                            PGP id EFC895FA=
