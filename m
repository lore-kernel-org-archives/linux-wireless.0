Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3BDSDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 13:03:22 -0500
Message-ID: <1360001021.17993.26.camel@jlt4.sipsolutions.net> (sfid-20130204_190325_456713_4F467CB0)
Subject: Re: [PATCH 2/3] mac80211: generate mesh probe requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Feb 2013 19:03:41 +0100
In-Reply-To: <CAG6hwVO+FvT4K3W5m0ddcyUBnFfMeg5eJrXE=77ipG1G-MbA7Q@mail.gmail.com> (sfid-20130204_185846_251995_0F69E0FD)
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
	 <1359853341-29237-3-git-send-email-thomas@cozybit.com>
	 <1359999522.17993.20.camel@jlt4.sipsolutions.net>
	 <CAG6hwVO+FvT4K3W5m0ddcyUBnFfMeg5eJrXE=77ipG1G-MbA7Q@mail.gmail.com>
	 (sfid-20130204_185846_251995_0F69E0FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 09:58 -0800, Thomas Pedersen wrote:
> On Mon, Feb 4, 2013 at 9:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Sat, 2013-02-02 at 17:02 -0800, Thomas Pedersen wrote:
> >
> >> -     pos = skb_put(skb, ie_ssid_len);
> >> -     *pos++ = WLAN_EID_SSID;
> >> +     if (ieee80211_vif_is_mesh(vif)) {
> >> +             pos = skb_put(skb, 2 + 2 + ssid_len);
> >> +             *pos++ = WLAN_EID_SSID;
> >> +             *pos++ = 0;
> >> +             /* NOTE: mesh ID will be out of order */
> >
> > Why put it out of order?
> >
> > Also I'm not convinced that it's a good idea to translate "SSID" from
> > the userspace API to "mesh ID" silently? Might make more sense to have
> > those separately maybe? I mean, it seems reasonable to even think you
> > might scan for a mesh network when you're not a mesh interface, for
> > example?
> 
> Yeah that makes more sense,  but will obviously require more work.
> I'll just drop this for now.

I guess the other question is if you actually want this at all. I mean,
if you just do patch 1 and 3, then unless you want to actively scan for
multiple networks you can just include the mesh ID in the IE parameter.
Seems for many purposes that could be acceptable already. Now I'm not
saying that you shouldn't put it into the kernel, there certainly could
be value in that, just saying that in terms of effort that might be
easier?

johannes

