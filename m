Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:44306 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaAGQMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:12:44 -0500
Date: Tue, 7 Jan 2014 18:12:41 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Advertise maximum associated STAs in AP mode
Message-ID: <20140107161241.GA9092@w1.fi> (sfid-20140107_171249_069506_78E83FDB)
References: <20140106081151.GA1613@w1.fi>
 <1389110063.4645.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389110063.4645.21.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 07, 2014 at 04:54:23PM +0100, Johannes Berg wrote:
> In theory, I think this is fine. In practice, I'm not sure it really
> covers things too well, and some drivers like iwlwifi might end up not
> being able to set it. The reason is that we have a limit of ~16 stations
> internally, but some may be used for BSS/P2P-client interfaces and some
> are used internally. In addition, when TDLS will be added, concurrency
> might mean that we'd have to set this to a very low number although it
> is likely that you'd never have P2P-GO, BSS clientand TDLS all together.

I think both cases of limiting associated stations will need to be
supported. It can be useful for user space to be aware of some limits
and there are cases where at least 1 vs. 2 vs. 16 vs. 128 can be easily
indicated even if some of the values are not accurate (e.g., that 16 may
actually mean 10 in some cases, etc.).

> Since the current auth/assoc state machine is rather racy with mac80211
> etc. anyway, wouldn't it be better to instead make hostapd take
> advantage of my kernel commit d582cffbcd04eae0bd8a83b05648bfd54bfd21c9
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Oct 26 17:53:44 2012 +0200
> 
>     nl80211/mac80211: support full station state in AP mode
> 
> With that, hostapd/wpa_s can add the station to the kernel, in
> unauthenticated state, before sending the authentication frame, and
> respond negatively if the addition fails. After auth frame ACK it would
> set to authenticated state and then after association set to associated
> state. This would also more accurately reflect the state to the driver,
> which might be helpful for some drivers.

I'm trying to remember why this did not get used, but cannot really
remember.. It would sound useful to support this regardless of the
question of how maximum supported association state count is handled.
While these do have some use cases in common, not all cases can be
addressed with this, or well, cannot be addressed cleanly. I would hate
to have make wpa_supplicant add a dummy station entry into the driver
just to figure out whether one more station can be added..

There are use cases where an AP advertises in Beacon/Probe Response
frames information about how preferable it is for stations to try to
associate with it. I'd expect this area to get used more in the future,
but even now, there is an example that I can give of a deployed
functionality. P2P has a P2P Group Limit field which the GO uses to
advertise in Beacon/Probe Response frames to indicate that no more P2P
Clients can join the group. wpa_supplicant supports this functionality,
but currently, requires user (or well, whoever is building the system)
to configure the maximum limit. This is an extra complexity that could
be easily avoided for cases where the driver were able to advertise the
maximum number of associated stations.

> Additionally, it would go some way towards fixing the race between
> station addition and EAPOL RX, I believe there are some scenarios (WSC?
> WAPI?) where the station sends the first EAPOL(-equivalent) frame, and
> currently stations are added only after transmitting the assoc response,
> so that those frames may be dropped erroneously.

Like I said above, I see value in doing this, but that does not mean I
would see that as replacing need for this patch to allow drivers to
advertise the limit (if known).

-- 
Jouni Malinen                                            PGP id EFC895FA
