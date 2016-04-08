Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34462 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbcDHKGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2016 06:06:20 -0400
Received: by mail-yw0-f174.google.com with SMTP id d68so128945540ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2016 03:06:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460059666.27154.16.camel@sipsolutions.net>
References: <CABPxzYLaWKgYrwjyjDpiZzWCbCpCzr7mKLorm9mzxspE5n0rHQ@mail.gmail.com>
 <1460059666.27154.16.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 8 Apr 2016 15:35:59 +0530
Message-ID: <CABPxzY+4JbfHxsXEPwfF0FhX027VjE7UW_MfG1vR7z13nbG3LA@mail.gmail.com> (sfid-20160408_120624_406374_73C4DF26)
Subject: Re: RFC: Handling DL only traffic when already in Powersave
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 8, 2016 at 1:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-04-07 at 18:31 +0530, Krishna Chaitanya wrote:
>> Hi,
>>
>> When using HW_PS and running Downlink only traffic like UDP-RX,
>> mac80211 has the mechanism to not to enter power-save (postpone the
>> dynamic ps timer).
>>
>> But if we are already in power-save it continues to stay in PS
>> and retrieves the frames, for large traffic this is not acceptable.
>>
>> The standard doesn't say anything, its left to vendor to implement
>> their own mechanism.
>>
>> I have the below questions
>>
>> 1) Are any other vendors seeing this issue?
>
> No. Nobody else really relies on the mac80211 powersave any more.
>
>> 2) Are they using proprietary algorithms to solve this,
>> implemented in their HW/FW?
>
> Yes. "Proprietary" is such a big word.
>
>> 3) If yes, how are they keeping the mac80211 and FW FSM in sync,
>> as the driver cannot request/indicate the power save state to
>> mac80211.
>> (no feedback path).
>
> No need, don't use the mac80211 implementation! Tell mac80211 you
> implement PS and DYNAMIC_PS, and it will not do anything whatsoever.

I have forgotten abut disabling DYNAMIC_PS flag, thanks, Will try that.

>> IMHO,
>>
>> a) we should implemented a feedback path, where the vendor
>> can implement proprietary mechanism to handle this and inform/request
>> mac80211 for a specific power save state.
>
> No.
>
>> b) mac80211 just conveys the user/system preferences to the driver
>> and driver handles the FSM on when to enter/exit PS? (true HW_PS).
>>
> Done when you have PS and DYNAMIC_PS advertised to mac80211.
>
> The mac80211 powersave code is pretty much beyond salvaging anyway.
>
> What really should happen is that there should be some kind of library
> functionality that drivers that need host powersave management can hook
> into, *per interface*, and then do the right thing.

Agree, this gives devices more control, with common code implemented
by mac80211.

> Then eventually we can remove all the powersave handling code from
> mac80211, it's seriously broken anyway (doesn't support more than one
> virtual interface, has problems like you describe above, etc.)
