Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1KGRC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:02:56 -0500
Subject: Re: [PATCH v4 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB806D7.6050104@candelatech.com>
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111104_211056_032573_0C709B20) <1320656776.3993.21.camel@jlt3.sipsolutions.net>
	 <4EB806D7.6050104@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 18:02:48 +0100
Message-ID: <1320685368.3993.49.camel@jlt3.sipsolutions.net> (sfid-20111107_180259_329354_50402589)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 08:27 -0800, Ben Greear wrote:

> >> +	kfree(rdev->wiphy.ht_capa_mod_mask);
> >> +	rdev->wiphy.ht_capa_mod_mask = NULL;
> >
> > That doesn't seem right -- drivers should typically assign a static
> > const variable to this pointer that can't be freed.
> 
> Earlier I think you argued that all of mac80211 drivers automatically supported
> these features as long as I put in the limitations that certain values
> could only be increased and certain only decreased, etc.
> 
> So, I put it in the mac80211 code instead of down in the drivers.
> But, I can move it into ath9k if you prefer.

Err, no -- if I'm talking about "drivers" from cfg80211's point of view,
mac80211 is one of those "drivers"! This comment was only about the
weird way of freeing it and static const etc.

johannes

