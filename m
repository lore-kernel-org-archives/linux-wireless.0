Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:39508 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751052AbXLWMpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 07:45:38 -0500
Date: Sun, 23 Dec 2007 13:41:12 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Mattias Nissler" <Mattias.Nissler@gmx.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re:
Message-ID: <20071223134112.65bc5a86@morte> (sfid-20071223_124545_477967_EA475202)
In-Reply-To: <20071223121951.39030@gmx.net>
References: <20071223033633.710907923@polimi.it>
	<20071223043917.7ec437e9@morte>
	<20071223120124.39050@gmx.net>
	<20071223131135.391cc0bb@morte>
	<20071223121951.39030@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Dec 2007 13:19:51 +0100
"Mattias Nissler" <Mattias.Nissler@gmx.de> wrote:

> Hey,
> 
> I'm a little late on this and away from my development machine anyway, but
> when reading my email, I noticed the following and thought this is
> important enough to point out, even though I only have that crappy
> webmailer and the only kernel tree I can look at is wireless-2.6/everything
> on git.kernel.org
> 
> In rc80211_pid.h, you have the following (this from the wireless-2.6 tree):
> 
>         /* Sampling period for measuring percentage of failed frames. */
>         #define RC_PID_INTERVAL (HZ / 8)
> 
> But rc80211_pid_algo.c says:
> 
>         period = (HZ * pinfo->sampling_period + 500) / 1000;
>         if (!period)
>                 period = 1;
> 
> You see this is completely bogus. My original patch had:
> 
>         /* Sampling period for measuring percentage of failed frames in 0.001s. */
>         #define RC_PID_INTERVAL 1000
> 
> You see why what you posted and John commited is bogus?

Indeed. I didn't notice about this because HZ == 1000 on my laptop. But I
didn't even sign off that patch, I just added a From: on top of it,
and changed this:

+#define RC_PID_INTERVAL (HZ / 1)
[yes, this is present in your original - as sent through IRC - patch]

to:

+#define RC_PID_INTERVAL (HZ / 8)
[and IIRC we discussed about this on IRC]

I'll post a fix for this.

> I'm getting a little fed up with this, you keep screwing up the code with
> my name on it *sigh*

Please, could you show _exactly_ which patches with your name (as in,
From: you) you think I screwed up?

I don't think I screwed up anything yours. I would be very sorry otherwise.

> And again, I still don't think guarding against period == 0 is the right
> thing to do. As I explained privately in IRC, we should make sure the
> sample_interval is larger than HZ when setting the sample_interval
> variable  (once nl80211 is done). It doesn't make sense to do this check
> every time we execute the code when we can do it once in advance.

Exactly, once nl80211 is done. Now, what if the control interval gets
changed after initialization? How often should we check whether it's larger
than HZ? If you got another solution which would work together with the
current debugfs interface, please post it.

> Sigh.

Please stop this. I think that this is:
1) not correct (but I don't care that much);
2) useless;
3) confusing.

Sorry again if I actually screwed up anything.


--
Ciao
Stefano
