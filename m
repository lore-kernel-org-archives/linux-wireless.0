Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1AaRcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 12:32:35 -0500
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D46F1B4.1020504@candelatech.com>
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>
	 <1296136347.3622.55.camel@jlt3.sipsolutions.net>
	 <4D41BA91.30608@candelatech.com>
	 <1296220846.5118.1.camel@jlt3.sipsolutions.net>
	 <4D431778.1000604@candelatech.com>
	 <1296482183.3812.29.camel@jlt3.sipsolutions.net>
	 <4D46F1B4.1020504@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 18:32:33 +0100
Message-ID: <1296495153.3812.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 09:30 -0800, Ben Greear wrote:

> > Well, sort of no, and sort of yes -- both will disrupt that code in a
> > sense, but even scanning on the same channel will disrupt it due to the
> > beacon diversion, unless we copy the beacons and give them to both sides
> > (scan and mlme)?
> 
> Seems to me both sides should get them.  I'll try to figure out how to
> do that properly today.
> 
> But, if work_work() takes us off-channel often enough, wouldn't that
> cause undue beacon loss and/or timed-out tx acks?  

Not TX ACKs really -- the device shouldn't be switching inbetween, but
beacon loss yeah.

> Are there any guarantees
> about how often and how long work_work() can take us off-channel?

No, with p2p it can be quite a bit of time.

johannes

