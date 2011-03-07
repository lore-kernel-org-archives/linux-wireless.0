Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1CGTD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 14:03:57 -0500
Subject: Re: [PATCH 1/4 v3] mac80211: Enable mesh security from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinFXU+bh=A-qPgQ8oh2GZs7XhPbJe4s3WZMy-0D@mail.gmail.com>
References: <1299288252-28314-2-git-send-email-thomas@cozybit.com>
	 <1299356245-13926-1-git-send-email-javier@cozybit.com>
	 <1299356769.29845.12.camel@jlt3.sipsolutions.net>
	 <AANLkTinFXU+bh=A-qPgQ8oh2GZs7XhPbJe4s3WZMy-0D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 20:03:54 +0100
Message-ID: <1299524634.6739.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 10:47 -0800, Javier Cardona wrote:

> >> + * @is_secure: or not
> >
> > Given what we just discussed over in the other thread, should we rename
> > this to "userspace_station_mgmt" or something like that?
> 
> Are you suggesting to change the name of the flag both in nl80211 and cfg80211?

Yeah, I was.

> Currently ENABLE_SECURITY means "let userspace manage stations", but
> also "ok to accept mesh management frames from secure mesh peers".
> And when the Authenticated Mesh Peering Exchange is implemented, it
> will probably mean "verify mesh peering frames in userspace" and
> "protect mesh peering frames".  You either do all these tasks or none,
> so for nl80211 I would prefer a single flag.

Indeed. I forgot about the RSN checking part etc. I suppose we should
just leave it as is then.

> > Also, does it make sense to advertise support for this somehow?
> > Otherwise the new tools will have strange failure cases on older
> > kernels;
> 
> Ah, I see.  Older kernels would not return an error to userspace if an
> attempt to set a non existing flag was made, right?

Right.

> Are you suggesting to define something like an
> NL80211_MESHCONF_CAPABILITIES mask?

I haven't thought about how I'd do it really -- yes something like that
might make sense.

> > and I can also imagine situations where the mesh APIs are in
> > firmware or so that can't cope with userspace station mgmt.
> 
> Ah mesh in firmware... who would want to do that? :)

:-)

johannes

