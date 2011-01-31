Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1AaN4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 08:56:25 -0500
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D431778.1000604@candelatech.com>
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>
	 <1296136347.3622.55.camel@jlt3.sipsolutions.net>
	 <4D41BA91.30608@candelatech.com>
	 <1296220846.5118.1.camel@jlt3.sipsolutions.net>
	 <4D431778.1000604@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 14:56:23 +0100
Message-ID: <1296482183.3812.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > However -- I was thinking of something else, not data packets. While
> > scanning, all received beacons will be handed to the scan code. But if
> > the mlme code isn't told to stop looking for them, it'll still expect to
> > see the beacons.
> 
> Currently, it seems mlme timers are stopped when we start scanning,
> and then started when scanning is complete.

Ok, I wasn't quite sure about that part -- whether it happened when
going off-channel or when starting scan. If it happened while going
off-channel this would've been problematic here.

> However, I don't see any similar effort in the work_work() method
> when it goes off-channel.
> 
> Should we move the timer pause & restart logic into the offchannel_stop_vifs
> and offchannel_return methods?

Well, sort of no, and sort of yes -- both will disrupt that code in a
sense, but even scanning on the same channel will disrupt it due to the
beacon diversion, unless we copy the beacons and give them to both sides
(scan and mlme)?

johannes

