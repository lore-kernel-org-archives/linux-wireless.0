Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58637 "EHLO
	sipsolutions.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757541Ab3EHR70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 13:59:26 -0400
Message-ID: <1368035937.8279.25.camel@jlt4.sipsolutions.net> (sfid-20130508_195928_373223_E53CA029)
Subject: Re: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting
 station.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 08 May 2013 19:58:57 +0200
In-Reply-To: <518A7AD4.2060100@candelatech.com>
References: <5182C38B.7060107@candelatech.com>
	  (sfid-20130502_215043_578677_76592D19) <1367526288.11375.2.camel@jlt4.sipsolutions.net>
	 <5182D078.4020605@candelatech.com> <518A7AD4.2060100@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-08 at 09:18 -0700, Ben Greear wrote:

> Ok, I reproduced this with yet more debugging printouts in the kernel.
> 
> The symptom is this:
> 
> The sme_state is SME_CONNECTED, so it bails out below before sending the
> 'connected' message to user-space.

Is your system being really really really slow and/or are threads
getting pre-empted a lot? This maybe seem like a bit of a stretch, but
it seems possible that this happens:

ieee80211_sta_rx_queued_mgmt() is running, possibly on one CPU, and is
somewhere between printing "associated" and calling
cfg80211_send_rx_assoc() (or in the call already, before taking the lock
though.)

Then your interface is set down at the same time, possibly on a
different CPU. Here's where the scenario gets stretched, clearly your
interface is getting set down over a minute later, I don't see how you
could have stalled the other thread for that long.

But if you did, then that thread is still processing things while the
interface is going down, cfg80211 didn't know anything about the
association having completed so it won't have disconnected, etc.

So far, I haven't found any other scenario, nor a solution.

johannes

