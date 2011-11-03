Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCIbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:31:01 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB22EE6.3030100@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
	 <4EAAFAA7.8090403@candelatech.com>
	 (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>
	 <4EB17103.70506@candelatech.com>
	 <1320256263.7846.3.camel@jlt3.sipsolutions.net>
	 <4EB22EE6.3030100@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:30:58 +0100
Message-ID: <1320309058.3950.7.camel@jlt3.sipsolutions.net> (sfid-20111103_093106_603513_CB9D55F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 23:04 -0700, Ben Greear wrote:

> I think I made at least most of the other changes you were asking
> for, but I'm still baffled about what to do about fullmac drivers.
> 
> Based on the comment above, if I simply left out the mac80211 stuff
> then the new values passed in to the associate/connect logic will just
> be ignored.
> 
> So, I suppose the fullmac drivers will just silently ignore the new
> variables as well.  I looked, but didn't figure out where fullmac
> connects into the cfg80211 logic.  If I can find it, then I could
> add explicit checks for the new variables and return failure if
> they are set..but I'm not sure that is any better than just silently
> ignoring them anyway.

So I think just ignoring it would be a bad idea, because you have no way
to know whether or not the values were used afterwards. That might be
sufficient for you right now, but typically becomes a support problem at
some point because people try it and can't figure out what part broke.
That's why I think silently ignoring something like that is not a good
idea.

Hence the typical handling of this with a wiphy flag that you set and if
it's unset but userspace is requesting this you reject the command.

johannes

