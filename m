Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61651 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab2CZRCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 13:02:52 -0400
Received: by qcqw6 with SMTP id w6so3460029qcq.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 10:02:51 -0700 (PDT)
Message-ID: <4F70A174.5050009@gmail.com> (sfid-20120326_190256_465342_E10D7DF4)
Date: Mon, 26 Mar 2012 13:03:48 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: mac80211 queue handling in multi-channel
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>  (sfid-20120227_124940_942920_32DA7DE7) <1332778432.5435.50.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332778432.5435.50.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/12 12:13, Johannes Berg wrote:
> So I've started to work on this a bit.
>
> On Mon, 2012-02-27 at 12:49 +0100, Johannes Berg wrote:
>
>> So what changes would this require?
>>
>> First of all, of course the driver needs to advertise the number of
>> hardware queues it supports. We'll have to think about changing the
>> check "do we support QoS" from "hw.queues >= 4" to something else, but I
>> think >=4 will still be a good indication and it seems unlikely that
>> somebody will have a device with a lot of queues yet not support QoS.
> This is a non-issue really.
>
>> Then of course, the driver needs to tell mac80211 about queue mapping.
>> For this, there's one global queue:
>>  * off-channel TX queue
>> Additionally, there are per-interface queues:
>>  * 4 per AC
>>  * CAB for this interface
> This I haven't gotten to.
>
> One issue I noticed though is that the queue mapping might need to be
> changed during the lifetime of the virtual interface (ie. while it's
> UP).
>
> Over in the other thread, I'm discussing channel contexts with Michal,
> and it seems that when the channel context is changed the queue mapping
> might also change. This doesn't seem like a problem, but we definitely
> need to keep it in mind. The way to handle it would be to stop the
> netdev queues, sync_net(), drop everything we have queued up for this
> interface and then we have clean state to start from.
>
>
> The other thing this affects is monitor mode. When the hardware queues
> are only defined per interface, we can't just give a frame to the driver
> on an essentially random queue and hope it can transmit it. Therefore,
> we need more queues, for monitor mode, in some way.
>
> As I was also trying to figure out what a good way to handle monitor
> mode in cases like iwlwifi is where the device really wants to be in a
> special "monitor mode" -- not just different filter programming.
>
> So to address both of these things, I came up with this patch:
> http://p.sipsolutions.net/ad87702d716df6d5.txt
>
> This will allow drivers to be informed of monitor mode when that is the
> only thing active.
>
> Injection would work like this:
>  * when monitor is only active:
>   - use this pseudo monitor interface
>   - if that doesn't exist (driver doesn't have it): discard frame
>  * when something else is active:
>   - if the TA of the injected frame matches any vif: use that vif
>   - if the TA doesn't match: use a vif matching the monitor addr
>   - if that doesn't exist: discard frame
>
>
> I think this strikes a good balance between having injection and having
> to worry about it too much. Obviously, drivers not implementing this new
> monitor mode interface capability wouldn't have pure injection, but that
> seems OK -- it should be relatively easy to add this to drivers.
This all seems very sane to me, I don't have any complaints to register. 
> As mentioned in the patch, the alternative would be to have new API for
> all of this, but that doesn't seem worthwhile.
Agreed

thanks,
Rick
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

