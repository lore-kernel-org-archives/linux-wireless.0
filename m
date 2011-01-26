Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1AZPg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 10:36:28 -0500
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:36:28 +0100
Message-ID: <1296056188.3635.36.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 10:05 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This should decrease un-necessary flushes, on/off channel work,
> and channel changes in cases where the only scanned channel is
> the current operating channel.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v2:  Check channels instead of flag when determining if we should
>   do a channel change in scan_completed_finish.

Can you look at work.c -- where we call
ieee80211_offchannel_stop_beaconing etc.

In this patch, you're moving the call to
ieee80211_offchannel_stop_beaconing next to
ieee80211_offchannel_stop_station in scan.c.

Therefore, you can combine those two into one function.

However, I guess it'd also be nice to also address the TODO in work.c
and move the "don't do so much if not really off-channel" logic into
that function? You must run into that when trying to associate on one
vif and the others get stopped etc. unnecessarily to do that.

johannes

