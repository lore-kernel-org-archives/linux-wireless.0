Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:44652 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CEJbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 04:31:37 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so5495295wgb.9
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 01:31:36 -0800 (PST)
Message-ID: <5135BB76.2060200@cozybit.com> (sfid-20130305_103143_416349_FF651BE8)
Date: Tue, 05 Mar 2013 10:31:34 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Seth Forshee <seth.forshee@canonical.com>, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCHv4 2/3] mac80211: mesh power save doze scheduling
References: <1362419675-27127-1-git-send-email-marco@cozybit.com>  <1362419675-27127-2-git-send-email-marco@cozybit.com>  <20130304192320.GB20505@thinkpad-t410> <1362428733.21028.53.camel@jlt4.sipsolutions.net>
In-Reply-To: <1362428733.21028.53.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 04.03.2013 21:25, schrieb Johannes Berg:
> On Mon, 2013-03-04 at 13:23 -0600, Seth Forshee wrote:
>
>> I've been looking at power save in mac80211 over the past few days with
>> an eye towards allowing multiple interface to be supported, as a result
>> of comments Johannes made at [1]. It seems like adding driver callbacks
>> for PS which are specific to the interface type is contrary to this
>> goal.
>
> Yeah, this is a concern. I didn't really stand in the way of doing mesh
> powersave though, and it seemed that the new interface here would
> actually be somewhat suitable, since for mesh any kind of powersave code
> needs to know when to wake up/sleep. I would've liked to see less
> reliance on host timers directly in core mac80211 even for the going to
> sleep part though... basically I'm not sure for mesh just having PS
> state will cut it. For managed mode this is easy because it only needs
> to sync with a single AP, but for mesh that's a bit more complicated and
> I think the whole sync should stay in mac80211. In the general case,
> just having the TSF might not be enough, but that can be solved as
> needed.
>
>> The basic idea that's been forming on my mind is add PS states to vifs
>> and make the managed, mesh, etc. code manipulate vif PS states rather
>> than hw states. Then a PS module would manage the hw state based on the
>> aggregate of the vif states.
>
> Yeah, that about matches what I was thinking. But like I said above,
> while this is fairly simple for managed mode, at least as required
> today, it's clearly not as simple for mesh.
>
> For managed mode, we also assume that we can send packets while the
> device is sleeping, and the device will do the right thing to wake up
> for beacons from the AP etc. For mesh, there are many more wakeup
> sources, from what I can tell.

I also assume that the device deals with TX while sleeping.

The complete list of wakeup sources for mesh are:
- awake window after beacon and probe response TX
- authentication, peering, scanning procedures
- frame release in mesh peer service periods
- RX peer's beacons and DTIM multicasts (only in mesh light sleep mode)

>> I don't have a lot of the details worked out yet, and my knowledge of PS
>> in mesh networks (and of mesh network operation in general) is pretty
>> rudimentary at this point. But afaict any modes which support PS define
>> the same two hw states, awake and doze. I wonder whether we should
>> instead aim for a single interface into the driver for PS that's capable
>> of supporting all interface types.
>
> Such an interface would probably have to be the interface now defined
> for mesh, telling the device when to wake up and go to sleep? But this
> interface is rather inefficient for most chipsets...

I guess the case of a single managed mode vif should be handled 
separately to benefit from the HW support most devices provide.

--Marco
