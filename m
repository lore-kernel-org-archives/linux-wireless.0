Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2LGXPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 18:15:54 -0500
Message-ID: <1354922175.9124.34.camel@jlt4.sipsolutions.net> (sfid-20121208_001556_957920_FA07AD69)
Subject: Re: [PATCH 16/24] regulatory: clarify locking rules and assertions
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 08 Dec 2012 00:16:15 +0100
In-Reply-To: <CAB=NE6VmfjfYeDirc-L-cPMmE6b4f_4iAK+nuDUs1-XUeLCO7w@mail.gmail.com> (sfid-20121208_001212_101049_8080CCCD)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-17-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6VmfjfYeDirc-L-cPMmE6b4f_4iAK+nuDUs1-XUeLCO7w@mail.gmail.com>
	 (sfid-20121208_001212_101049_8080CCCD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 15:11 -0800, Luis R. Rodriguez wrote:

> > The reason for this is that nl80211 uses the regdom
> > without being able to hold reg_mutex.
> 
> Hm, do we want to do this or add a caller to reg.c that gets nl80211
> to copy over the current regdomain over for it to parse and then send?
> In that case we'd only need the cfg80211_mutex for
> update_all_wiphy_regulatory(). Thoughts?

I think you should look at the later patches :)

johannes

