Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33576 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZD2OdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 10:33:11 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240997537.593.35.camel@johannes.local>
References: <1240997537.593.35.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 07:33:07 -0700
Message-Id: <1241015587.997.76.camel@localhost.localdomain> (sfid-20090429_163317_028923_85061847)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> When we aren't doing anything in mac80211, we can turn off
> much of the hardware, depending on the driver/hw. Not doing
> anything, aka being idle, means:
> 
>  * no monitor interfaces
>  * no AP/mesh/wds interfaces
>  * any station interfaces are in DISABLED state
>  * any IBSS interfaces aren't trying to be in a network
>  * we aren't trying to scan
> 
> By creating a new function that verifies these conditions and calling
> it at strategic points where the states of those conditions change,
> we can easily make mac80211 tell the driver when we are idle to save
> power.
> 
> Additionally, this fixes a small quirk where a recalculated powersave
> state is passed to the driver even if the hardware is about to stopped
> completely.
> 
> This patch intentionally doesn't touch radio_enabled because that is
> currently implemented to be a soft rfkill which is inappropriate here
> when we need to be able to wake up with low latency.
> 
> One thing I'm not entirely sure about is this:
> 
>   phy0: device no longer idle - in use
>   wlan0: direct probe to AP 00:11:24:91:07:4d try 1
>   wlan0 direct probe responded
>   wlan0: authenticate with AP 00:11:24:91:07:4d
>   wlan0: authenticated
> > phy0: device now idle
> > phy0: device no longer idle - in use
>   wlan0: associate with AP 00:11:24:91:07:4d
>   wlan0: RX AssocResp from 00:11:24:91:07:4d (capab=0x401 status=0 aid=1)
>   wlan0: associated
> 
> Is it appropriate to go into idle state for a short time when we have
> just authenticated, but not associated yet? This happens only with the
> userspace SME, because we cannot really know how long it will wait
> before asking us to associate. Would going idle after a short timeout
> be more appropriate? We may need to revisit this, depending on what
> happens.

what about having the hardware set a value for how long something should
be idle before you tell it. I am more thinking about some sort penalty
value from the hardware that can not do this quickly.

Regards

Marcel
 

