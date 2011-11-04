Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1KDQRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:17:38 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB40EBB.9010402@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
	 <4EAAFAA7.8090403@candelatech.com>
	 (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>
	 <4EB17103.70506@candelatech.com>
	 <1320256263.7846.3.camel@jlt3.sipsolutions.net>
	 <4EB22EE6.3030100@candelatech.com>
	 <1320309058.3950.7.camel@jlt3.sipsolutions.net>
	 <4EB2DACE.2000707@candelatech.com>
	 <1320417771.3969.90.camel@jlt3.sipsolutions.net>
	 <4EB40EBB.9010402@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 17:17:33 +0100
Message-ID: <1320423453.3969.97.camel@jlt3.sipsolutions.net> (sfid-20111104_171741_632460_99A3A673)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 09:11 -0700, Ben Greear wrote:

> > I think maybe a single one would be sufficient, but you'd still have no
> > way of knowing what is actually supported for changing. Maybe you could
> > advertise an ht_mask of things that can be changed?
> 
> That seems feasible, though it still won't help with the valid ranges
> for mpdu-density, for instance.

Well I still think that reducing the density is not feasible, so
userspace can query the HT info about the min and the mask to see if
what it can do.

> How about if I add some way to query this, but leave the code loose
> in that it won't fail if someone tries to set a value that isn't
> supported.  That way, user-space can be lazy if it wants, but
> can also get the details if it cares.

Yeah, that seems like it would be a good way of doing it, although I
think I'd reject it if there's no such configuration possible at all.

> To get this info, I'm going to have to add a new driver API, as far
> as I can tell, and I only have the ability to deal with ath9k, so
> that will be the only driver that reports the mask.  Of course,
> others could modify their drivers as they wish.

I think you just have to add the mask to the wiphy struct somewhere. And
the mask wouldn't be specific to ath9k since any mac80211 driver would
be able to deal with it, just no non-mac80211 driver.

You could just have a pointer to the mask in the wiphy struct and if
NULL then it's not allowed, if non-NULL the mask indicates what can be
changed.

johannes

