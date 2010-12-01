Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab0LAVP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:15:29 -0500
Subject: Re: [RFC 5/5] cfg80211/mac80211: add mesh join/leave commands
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
In-Reply-To: <20101201210226.159495600@sipsolutions.net>
References: <20101201205939.009530439@sipsolutions.net>
	 <20101201210226.159495600@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 22:15:29 +0100
Message-ID: <1291238129.4199.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 21:59 +0100, Johannes Berg wrote:
> plain text document attachment (022-cfg80211-start-stop-mesh.patch)
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of tying mesh activity to interface up,
> add join and leave commands for mesh. Since we
> must be backward compatible, let cfg80211 handle
> joining a mesh if a mesh ID was pre-configured
> when the device goes up.
> 
> Note that this therefore must modify mac80211 as
> well since mac80211 needs to lose the logic to
> start the mesh on interface up.

I just noticed that this will lose mesh parameters when you leave the
mesh, unlike previously where they would be kept. I'm not sure which
behaviour is more desirable though -- if I was doing this from scratch
I'd sure go with the reset behaviour, but we may need to keep the old
behaviour?

johannes

