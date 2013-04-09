Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:37:40 -0400
Message-ID: <1365500246.8465.5.camel@jlt4.sipsolutions.net> (sfid-20130409_113749_590216_C779559A)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 09 Apr 2013 11:37:26 +0200
In-Reply-To: <CAG6hwVOAwtngWU3uEueG7hZX3z5dxLLc8c8-Vd7Q+e93wM-UaQ@mail.gmail.com> (sfid-20130408_215754_514729_5AC29991)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1365444377-9959-3-git-send-email-thomas@cozybit.com>
	 <1365446248.25475.17.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com>
	 <1365449914.25475.20.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOAwtngWU3uEueG7hZX3z5dxLLc8c8-Vd7Q+e93wM-UaQ@mail.gmail.com>
	 (sfid-20130408_215754_514729_5AC29991)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 12:57 -0700, Thomas Pedersen wrote:

> > That seems racy? Even asking whether it's stopped is racy though, what
> > are you even trying to accomplish?
> 
> Yeah, that's why I'd like to get the reason the first time.
> 
> _h_mesh_fwding() checks whether the outgoing queue is stopped, to
> avoid piling frames on the pending queue if the outgoing medium is
> busy. I guess the idea was to avoid queueing frames faster than the
> hardware could unload them. Maybe this doesn't actually happen, but we
> can be a little bit smarter about when to drop forwarded frames. Like
> if skbs are just being added to the outgoing queue, we probably
> shouldn't.

Technically I guess that can happen if your inbound link is better than
the outbound one? But it'll depend on the AC parameters etc. too.

However it seems that ieee80211_queue_stopped() is actually kinda broken
and should only return the 'driver-stopped' reason to start with. If you
fix that, it's probably good enough for you. I don't think in patch 4
you should drop frames for scanning, for example.

johannes

