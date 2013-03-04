Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35025 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3CDTnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 14:43:18 -0500
Message-ID: <5134F944.9050602@candelatech.com> (sfid-20130304_204321_621891_1BC74D02)
Date: Mon, 04 Mar 2013 11:43:00 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Marco Porsch <marco@cozybit.com>, johannes@sipsolutions.net,
	devel@lists.open80211s.org, vthiagar@qca.qualcomm.com,
	jouni@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath9k-devel@venema.h4ckr.net,
	senthilb@qca.qualcomm.com
Subject: Re: [ath9k-devel] [PATCHv4 2/3] mac80211: mesh power save doze scheduling
References: <1362419675-27127-1-git-send-email-marco@cozybit.com> <1362419675-27127-2-git-send-email-marco@cozybit.com> <20130304192320.GB20505@thinkpad-t410>
In-Reply-To: <20130304192320.GB20505@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2013 11:23 AM, Seth Forshee wrote:
> On Mon, Mar 04, 2013 at 06:54:34PM +0100, Marco Porsch wrote:
>> Configure the device for PS mode if the local mesh PS parameters
>> allow so and the driver supports it.
>>
>> Add two callbacks to ieee80211_ops for mesh powersave:
>> - mesh_ps_doze - put the device to sleep now, wake up at given
>>    TBTT
>> - mesh_ps_wakeup - wake the device up now for frame RX
>> These ops may be extended in the future to allow drivers/HW to
>> implement mesh PS themselves. (Current design goal was to
>> concentrate most mesh PS routines in mac80211 to keep driver
>> modifications minimal.)
>>
>> Track beacon timing information of peers we are in PS mode
>> towards. Calculate the next TBTT per STA. Stay awake to receive
>> multicast traffic after DTIM beacons.
>>
>> When going to doze state, get the most imminent STA TBTT and
>> configure the device to trigger a wakeup on time to catch that
>> beacon. After successful receipt put the device to doze again.
>> Set a timeout for the case that the beacon is not received on
>> time. In this case calculate the following TBTT and go to doze
>> again.
>>
>> For mesh Awake Windows wakeup on PreTBTT/SWBA (beacon_get_tim)
>> and start a timer which triggers a doze call on expiry.
>> Similarly, stay awake for the Awake Window duration after
>> sending probe response frames.
>>
>> Signed-off-by: Marco Porsch <marco@cozybit.com>
>
> I've been looking at power save in mac80211 over the past few days with
> an eye towards allowing multiple interface to be supported, as a result
> of comments Johannes made at [1]. It seems like adding driver callbacks
> for PS which are specific to the interface type is contrary to this
> goal.
>
> The basic idea that's been forming on my mind is add PS states to vifs
> and make the managed, mesh, etc. code manipulate vif PS states rather
> than hw states. Then a PS module would manage the hw state based on the
> aggregate of the vif states.
>
> I don't have a lot of the details worked out yet, and my knowledge of PS
> in mesh networks (and of mesh network operation in general) is pretty
> rudimentary at this point. But afaict any modes which support PS define
> the same two hw states, awake and doze. I wonder whether we should
> instead aim for a single interface into the driver for PS that's capable
> of supporting all interface types.
>
> Anyway, I just wanted to throw this out for discussion.

I would love to see multi-vif (station) power-saving support happen.  I'm low
on development cycles at the moment, but at the least we can do
some testing....

Thanks,
Ben

>
> Thanks,
> Seth
>
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/104064
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

