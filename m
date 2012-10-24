Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab2JXR3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 13:29:46 -0400
Message-ID: <1351099817.10709.6.camel@jlt4.sipsolutions.net> (sfid-20121024_192951_972852_9F737875)
Subject: Re: [PATCH 0/4] multi-channel/interface TX power handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Oct 2012 19:30:17 +0200
In-Reply-To: <508817E0.5050504@candelatech.com>
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
	  <50880BD0.6080603@candelatech.com>
	 <1351093332.10709.5.camel@jlt4.sipsolutions.net>
	 <508817E0.5050504@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-24 at 09:31 -0700, Ben Greear wrote:

> > Yeah that'd be the only way, most scripts I've seen always just use the
> > interface anyway though? I'm not totally happy about this, maybe we
> > should iterate all interfaces? Not really sure ...
> 
> Well, I think we should make setting the wiphy work...just iterate
> all interfaces.  Breaking backwards compatibility just causes too
> much problems for user-space, and many users may either not notice,
> or not be able to change whatever software is screwing up.

Yeah I guess.

> But, I think we also need some way to know if we can set individual
> vifs to different tx-power successfully.
> 
> Maybe a /sys/class/netdev/wlan0/tx-power file to read current power could
> be added in this patch series?  Then user-space could key off of it's
> existence, and it would give a simple way to read the current tx-power
> settings (and possibly set it as well)...

sysfs file sounds like about the worst possible way (except maybe for
procfs), an nl80211 feature flag could be worthwhile though :)

johannes

