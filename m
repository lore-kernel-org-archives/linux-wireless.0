Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWMU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:20:29 -0500
Message-ID: <1390479620.4142.14.camel@jlt4.sipsolutions.net> (sfid-20140123_132032_566643_614AEAF6)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Thu, 23 Jan 2014 13:20:20 +0100
In-Reply-To: <CA+BoTQm768pE7w1x9p5dN+qTxYjzf8R5u4WASd4zEaQ=v717BQ@mail.gmail.com> (sfid-20140123_113344_104982_CBFDA68E)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <1390403432.4334.33.camel@jlt4.sipsolutions.net>
	 <1390403634.4189.39.camel@porter.coelho.fi>
	 <CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com>
	 <1390458664.4189.48.camel@porter.coelho.fi>
	 <CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
	 <1390462306.4189.56.camel@porter.coelho.fi>
	 <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com>
	 <1390470648.4189.88.camel@porter.coelho.fi>
	 <CA+BoTQm768pE7w1x9p5dN+qTxYjzf8R5u4WASd4zEaQ=v717BQ@mail.gmail.com>
	 (sfid-20140123_113344_104982_CBFDA68E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 11:33 +0100, Michal Kazior wrote:

> An extreme approach would to actually update AP IEs in mac80211. This
> way it would be possible to pull any interface into CSA implicitly if
> you're out of channels. This way single-channel multi-BSS AP could
> probably switch atomically without races and your multi-channel
> GO-possibly-follows-STA would still work.

I don't really like updating IEs in mac80211 much. Asking userspace
shouldn't be *that* much slower.

> > The CAC might take too long.  If we have an AP1 and a STA and the STA
> > gets the CSA from its AP2 with a short count, AP1 may not have the time
> > to CAC.  In this case, AP1 have two choices: trust that AP2 is doing the
> > right thing and moving to a usable DFS channel or shut itself down.
> 
> That's the point. AP1 doesn't have time to perform CAC in this case,
> but it should still be possible for AP1 to _just_ beacon CSA as it's
> only a hint. AP1 could then be stopped to perform CAC, and once it's
> completed restart the AP1.

I don't get this side discussion about CAC. There's no time to do CAC in
the middle of a CSA *anyway* since you can't be beaconing on the old
channel while doing CAC on the new channel, and if you stop beaconing
entirely for the time of the CAC then all clients will likely go away...
I'm not sure I understand how you can ever do a CSA to a radar channel
that would still need CAC?

johannes

