Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2GIIaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 04:30:01 -0400
Message-ID: <1341822596.4455.6.camel@jlt3.sipsolutions.net> (sfid-20120709_103008_660382_999FC01F)
Subject: Re: [PATCH] mac80211: use full power if off-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 10:29:56 +0200
In-Reply-To: <4FF99A80.9040700@candelatech.com>
References: <1341740130-6199-1-git-send-email-johannes@sipsolutions.net>
	 <4FF99A80.9040700@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 07:34 -0700, Ben Greear wrote:
> On 07/08/2012 02:35 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Instead of using full power when scanning, use
> > full power when off-channel. This is different
> > since off-channel can be remain-on-channel.
> 
> What if we are scanning on our current channel?  Shouldn't
> it be full-power then as well?

Arguable. If we're on the channel that the AP explicitly told us to use
less power on, and we're not stopping normal traffic, then I'm not sure
we should.

johannes

