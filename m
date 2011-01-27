Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33037 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953Ab1A0SyY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 13:54:24 -0500
From: Kevin Hilman <khilman@ti.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
References: <Pine.LNX.4.44L0.1012212032590.11252-100000@netrider.rowland.org>
	<201012221329.40251.rjw@sisk.pl> <87k4hrtfcb.fsf@ti.com>
	<AANLkTikH0aHQNzShAYQfPLPg4C_0HS_pWEqbJJ4aHZgm@mail.gmail.com>
Date: Thu, 27 Jan 2011 10:54:19 -0800
In-Reply-To: <AANLkTikH0aHQNzShAYQfPLPg4C_0HS_pWEqbJJ4aHZgm@mail.gmail.com>
	(Vitaly Wool's message of "Thu, 27 Jan 2011 19:20:10 +0100")
Message-ID: <87bp32npno.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vitaly Wool <vitalywool@gmail.com> writes:

> Hi Kevin,
>
>> Therefore, what is ideally needed is the ability for A's suspend to
>> simply call pm_runtime_suspend() so the subsystem can do the work.
>> However, since runtime transitions are locked out by this time, that
>> doesn't work.  IOW, what is needed is a way for a system suspend to say
>> "please finish the runtime suspend that was already requested."
>>
>> What I've done to work around this in driver A is to manually check
>> pm_runtime_suspended() and directly call the subsystem's runtime
>> suspend/resume (patch below[1].  NOTE, I've used the _noirq methods to
>> ensure device A is available when device B needs it.)
>
> suppose this driver runs on a platform that has runtime PM disabled.
> How is it going to work then?
>

Then pm_runtime_suspended() will be false, and the bus methods will
suspend the device.

Kevin

