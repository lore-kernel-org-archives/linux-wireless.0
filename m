Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:36656 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0LPLvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 06:51:20 -0500
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id oBGBpI2M000629
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:51:18 -0800
Received: from iwn2 (iwn2.prod.google.com [10.241.68.66])
	by wpaz9.hot.corp.google.com with ESMTP id oBGBp16l012138
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:51:17 -0800
Received: by iwn2 with SMTP id 2so3536754iwn.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:51:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292499024.3612.3.camel@jlt3.sipsolutions.net>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	<1292482775.3542.8.camel@jlt3.sipsolutions.net>
	<AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	<1292499024.3612.3.camel@jlt3.sipsolutions.net>
Date: Thu, 16 Dec 2010 03:51:16 -0800
Message-ID: <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 3:30 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 03:17 -0800, Paul Stewart wrote:
>
>> > I thought this was solved in ath9k differently? Was that somehow
>> > inadequate?
>>
>> Unfortunately previous attempts to solve this problem failed.
>
> I thought ath9k was fixed to simply go idle when stopped? Why didn't
> that help?

So, I'm trying to balance two fairly nasty problems here.  On one end
we have the problem before any changes where the device is not shut
down when it legitimately should be -- we ifdown the device while scanning
but the device in ath9k is not set to "idle".  Fixing the problem in ath9k
alone causes a separate problem.  If you stop the driver from mac80211's
pm.c, ath9k would set the device ps_idle, when mac80211 does not
consider the device to to be idle.  Thus, when we resume from suspend,
the device stays quiescent (mac80211 has no reason to believe it needs
to do anything special to be able to tx, receive beacons, etc.)

>> Here's a slightly better rationale, as I'm getting to understand the problem.
>> ieee80211_do_stop() decrements "open_count" so early during the function
>> that if the device is not idle at this point (e.g, due to scanning),
>> drv_config()
>> will never be called on the the lower-level driver, since ieee80211_hw_config()
>> tests for "open_count > 0" and silently returns no-error.
>
> Yes, I realise that -- but also Luis said this change wasn't sufficient
> in his tests, he also needed something in scan code itself. Also, this
> is really quite intentional if you read the comments around the area
> you're modifying -- mac80211 assumes that after it shuts down the device
> with stop(), the device will be powered off under control of the driver
> until start().
>
> I just don't think it'll be easy to actually make sure that we always go
> IDLE before calling stop(). This patch might solve part of the problem,
> but what about hardware scan, that might have to be stopped by the
> driver during stop()? Similar things might come up with other features.
>
> Therefore I'm not sure we should even try. If we stop() the hardware,
> what's preventing the driver from doing whatever it needs to put the
> device into a low power state?
>
> johannes
>
>
