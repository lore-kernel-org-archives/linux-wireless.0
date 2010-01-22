Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:60445 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0AVTUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 14:20:53 -0500
Received: by pxi12 with SMTP id 12so1182878pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 11:20:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264186981.2593.10.camel@johannes.local>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<1264186981.2593.10.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 11:20:33 -0800
Message-ID: <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org, j@w1.fi
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> [adding Jouni]
>
> On Thu, 2010-01-21 at 13:39 -0800, wey-yi.w.guy@intel.com wrote:
>> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>>
>> In current implementation, mac80211 send dtim_period update to driver
>> during association, but if no NetworkManager or similar application
>> perform scan operation, plus tim_ie is not part of probe response; mac80211 will
>> not get beacon with dtim information later, then  mac80211 will not pass the
>> information to driver for update.
>>
>> Call ieee80211_hw_config() with IEEE80211_CONF_CHANGE_PS flag set to
>> allow driver make correct dtim adjustment if dtim_period change
>> detected. Also perform recalc_ps operation if needed.
>
> This seems fine.
>
> However, I think it's indicative of a bigger problem. I gave it some
> thought, and came to the conclusion that it previously didn't happen
> because we always won the race. Let me explain.
>
> Previously, we would switch the channel completely to the new operating
> channel before even probing the AP. That way, we would virtually always
> receive a beacon from the new AP between the time we started the
> association process (probe,auth,assoc) and configuring the driver.
>
> Now with the new changes that use the off-channel work, we may return to
> the old "operating" channel, which may be no particular channel, between
> all these steps. Thus, if there's no beacon between any of probe
> request/response, auth "request"/"response", assoc request/response, we
> never get one, and this situation happens.
>
> I see two solutions, apart from this special-case patch fixing
>
> First, we could go back to the original behaviour if we have just one
> virtual interface. But that still leaves us with the race, we might do
> all three frame exchanges within a beacon interval and still miss the
> beacon, we just tend to not do that and get a beacon.

Curious, what symptoms were seen when the dtim was not propagated
prior to association, did the STA just not wake up for the right dtim
interval when in PS mode? Wouldn't we get the dtim interval on
eventual beacons later or do we disregard all that information after
associated? If so what if the AP changes the dtim interval?

I take it this can easily be reproduced with a long beacon interval?

> The other solution I see is that we add a new step before or after the
> direct probe step, which would just be "wait for a beacon". This would
> ensure we have both probe and beacon information always ready. It would
> also ensure we have both probe and beacon info for our new userspace
> reporting of that.

This seems cleaner.

  Luis
