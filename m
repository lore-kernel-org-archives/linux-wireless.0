Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1A0Nzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:55:52 -0500
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D406A48.7060503@candelatech.com>
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
	 <1296056188.3635.36.camel@jlt3.sipsolutions.net>
	 <4D406A48.7060503@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:55:51 +0100
Message-ID: <1296136551.3622.57.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 10:39 -0800, Ben Greear wrote:

> The offchannel_stop_beaconing doesn't actually change
> state, it just calls
> 
>   	ieee80211_bss_info_change_notify(
> 				sdata, BSS_CHANGED_BEACON_ENABLED);
> 
> That method will disable beaconing if SCAN_SW_SCANNING is set,
> regardless of current channel.
> 
> So, if that work.c logic is happening during a scan, we
> will always disable scanning, but if we are not SW scanning,
> then that offchannel_stop_beaconing won't actually do
> anything useful.


> My first inclination is to add another check in bss_info_change_notify
> to test if we are really off-channel:
> 
> 		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
> 		    (test_bit(SCAN_SW_SCANNING, &local->scanning) &&
> 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)) {
> 			sdata->vif.bss_conf.enable_beacon = false;
> 
> And either set the SCAN_OFF_CHANNEL flag before calling offchannel_stop_beaconing,
> or perhaps set that flag in offchannel_stop_beaconing.  The first might be
> less risky, but that leaves the work.c logic funky in my opinion, since if
> we are not actually scanning, beacons will still be enabled.

Yes, I'm a bit concerned about that too -- that bit really shouldn't be
in the scan bits, and then we can set it in offchannel_stop_beaconing or
whatever the combination ends up being called.

> I could use some suggestions on how to proceed.  I am overly tempted to
> start changing everything in sight, but that is likely to cause all sorts
> of bugs, subtle and otherwise....

:)

I've long been tempted to rewrite scanning in terms of off-channel work
items ... Not really sure what to do.

johannes

