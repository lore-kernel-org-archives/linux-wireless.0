Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1CETmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 14:42:10 -0500
Subject: Re: [PATCH 1/4 v2] mac80211: Enable mesh security from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikAR4v8T48q7eSoOU+R+foqTUT+6Kr4U6ZnWwu7@mail.gmail.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1299288252-28314-2-git-send-email-thomas@cozybit.com>
	 <1299333920.3826.5.camel@jlt3.sipsolutions.net>
	 <AANLkTikAR4v8T48q7eSoOU+R+foqTUT+6Kr4U6ZnWwu7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 20:42:07 +0100
Message-ID: <1299354127.29845.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-03-05 at 11:34 -0800, Javier Cardona wrote:

> > That last check seems a bit pointless -- I'd trust userspace (aka allow
> > it to shoot itself in the foot) and not check that there's RSN
> > information when it says it wants security -- maybe WAPI will come up
> > with mesh security at some point ;-)
> 
> Enabling security without an RSN will result in mesh node that can't
> communicate with anyone in the mesh, secured or not.

Right, well, I keep thinking that maybe a daemon could still run an
unsecured mesh? But in any case I'm not so sure how that works at all --
see my reply to the intro mail.

> I prefer
> keeping that check in place to avoid annoying misconfigurations.  You
> still think it's pointless?  (In fact I was contemplating a more
> strict check by returning EINVAL instead of ignoring the request when
> userspace enables security and does not pass an RSN.)

I don't see how that misconfiguration could ever happen since you
wouldn't run the daemon if you don't want RSN, and iw would never set
the secure flag?

It just seems that if somebody wants to play with a protocol that
doesn't use the RSN IE but maybe adapts WPA to it, we could still allow
it to work.

johannes

