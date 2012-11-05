Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab2KEPbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 10:31:49 -0500
Message-ID: <1352129544.9466.25.camel@jlt4.sipsolutions.net> (sfid-20121105_163229_649243_2442AD63)
Subject: Re: [PATCH v2] wireless: Allow registering more than one beacon
 listener.
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 05 Nov 2012 16:32:24 +0100
In-Reply-To: <508EB4A9.2040203@openwrt.org>
References: <1351288165-24219-1-git-send-email-greearb@candelatech.com>
	   (sfid-20121026_234937_894351_D69F960C) <1351501451.10925.6.camel@jlt4.sipsolutions.net>
	  <508EAC30.8020600@candelatech.com>
	 <1351527990.10925.35.camel@jlt4.sipsolutions.net>
	 <508EB4A9.2040203@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-29 at 17:54 +0100, Felix Fietkau wrote:
> On 2012-10-29 5:26 PM, Johannes Berg wrote:
> > On Mon, 2012-10-29 at 09:17 -0700, Ben Greear wrote:
> > 
> >> >> +	spin_lock_bh(&rdev->beacon_registrations_lock);
> >> > ...
> >> >> +	spin_unlock_bh(&rdev->beacon_registrations_lock);
> >> >
> >> > I have a feeling this is incorrect, this is called with BHs disabled, so
> >> > if we disable/enable BHs here we end up with BHs enabled even if the
> >> > caller wanted them disabled, no?
> >> >
> >> > So I suppose unless we need to be able to call this from hard interrupt
> >> > in some driver (unlikely) we should add a change like this:
> >> 
> >> I get confused with the various types of spin-locks,
> >> and I just copied this code from the mgt frames logic.
> > 
> > Uh, that looks like a bug there as well then?
> As far as I know, local_bh_enable/local_bh_disable (which are used by
> spin_lock_bh) are re-entrant. Using them from a BH-disabled context is
> safe. All I can find with a few simple google searches confirms this.

Hm yeah I must've confused it with something, I'll apply the patch.

johannes

