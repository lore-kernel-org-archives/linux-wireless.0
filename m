Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:61562 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0AWIX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 03:23:26 -0500
Received: by ey-out-2122.google.com with SMTP id d26so490496eyd.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 00:23:25 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<1264186981.2593.10.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 23 Jan 2010 10:23:22 +0200
In-Reply-To: <1264186981.2593.10.camel@johannes.local> (Johannes Berg's message of "Fri\, 22 Jan 2010 20\:03\:01 +0100")
Message-ID: <87y6jpp6v9.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> However, I think it's indicative of a bigger problem. I gave it some
> thought, and came to the conclusion that it previously didn't happen
> because we always won the race. Let me explain.

One more reason why need to receive the beacon is synchronisation to
the beacon for power save. For example wl1251 and wl1271 want to
receive one beacon for synchronisation purposes before some of the
commands are executed. It would be really nice if mac80211 would take
care of that.

> First, we could go back to the original behaviour if we have just one
> virtual interface. 

I think this is good to have. Just to keep it simple for devices like
wl1251 and wl1271.

> But that still leaves us with the race, we might do all three frame
> exchanges within a beacon interval and still miss the beacon, we
> just tend to not do that and get a beacon.
>
> The other solution I see is that we add a new step before or after the
> direct probe step, which would just be "wait for a beacon". This would
> ensure we have both probe and beacon information always ready. It would
> also ensure we have both probe and beacon info for our new userspace
> reporting of that.

I like this. If only the bssid would be provided to the driver before
the association process, both wl1251 and wl1271 would not have to
worry about firmware beacon synchronisation.

-- 
Kalle Valo
