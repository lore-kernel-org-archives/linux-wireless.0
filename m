Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1BCIT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 03:19:58 -0500
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D49D6BB.1050503@candelatech.com>
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com>
	 <1296672941.5671.38.camel@jlt3.sipsolutions.net>
	 <4D49AEFA.6090202@candelatech.com>
	 <1296682103.5671.41.camel@jlt3.sipsolutions.net>
	 <4D49D6BB.1050503@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 09:19:56 +0100
Message-ID: <1296721196.3854.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 14:12 -0800, Ben Greear wrote:

> > But if we pretend all work is off-channel, won't it be OK to return from
> > off-channel, even if it isn't really another channel?
> 
> That should be fine unless a scan can run in conjunction
> with work.  Then, it could confuse scan's idea of whether it
> is off or on channel.
> 
> Seems they are currently mutually-exclusive, so I guess
> it doesn't matter currently.
> 
> I'll take a look at what it would take to do the power-save
> stuff and we can then decide if it should be broken into
> separate patches...

Ok, thanks.

> I'm seeing multiple APs reported in my testing.  Receiving all beacons
> seems to be related to setting the filter properly.  I'm using ath9k
> though...maybe other nics behave differently about this?
> 
> Or maybe my NIC is so busy it never goes to power-save anyway?

ath9k doesn't enable PS by default -- you'd have to enable it with
iwconfig or iw.

johannes

