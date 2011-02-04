Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1BDTJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 14:09:29 -0500
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D4C4C61.7060605@candelatech.com>
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com>
	 <1296672941.5671.38.camel@jlt3.sipsolutions.net>
	 <4D4C4C61.7060605@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 20:09:26 +0100
Message-ID: <1296846566.3671.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-04 at 10:58 -0800, Ben Greear wrote:
> On 02/02/2011 10:55 AM, Johannes Berg wrote:
> > On Wed, 2011-02-02 at 10:18 -0800, greearb@candelatech.com wrote:
> >
> >> * Do no blindly go off/on channel in work.c  Instead, only call
> >>    appropriate on/off code when we really need to change channels.
> >
> > Based on the powersave comments I had earlier, maybe we should remove
> > that bit for now? Work items here require powersave is disabled, but we
> > won't do that right now if we're on the same channel.
> >
> > Scan, on the other hand, will still disable powersave (right?)
> 
> With regard to scanning and power-save:  If we are scanning on
> channel, I think we should still be able to receive normal traffic.
> 
> The offchannel_ps_enable has this comment:
> 
> /*
>   * inform AP that we will go to sleep so that it will buffer the frames
>   * while we scan
>   */
> static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
> 
> 
> So, do we really need to call this method for on-channel scanning?
> 
> My naive assumption is that we would actually want the NIC to disable it's
> local power-save logic while we are scanning so that it doesn't
> get sleepy and miss beacons?

Right. We don't need this for on-channel stuff. But we do need to
disable PS for on-channel stuff as you point out.

johannes

