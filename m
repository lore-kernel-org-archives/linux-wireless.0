Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:44182 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0AVXpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:45:52 -0500
Received: by qyk32 with SMTP id 32so941653qyk.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 15:45:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<1264186981.2593.10.camel@johannes.local> <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	<1264189560.2593.14.camel@johannes.local> <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 15:45:32 -0800
Message-ID: <43e72e891001221545h5d0b295xfacd59bb65322d5a@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 3:44 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Jan 22, 2010 at 11:46 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Fri, 2010-01-22 at 11:20 -0800, Luis R. Rodriguez wrote:
>>
>>> > Previously, we would switch the channel completely to the new operating
>>> > channel before even probing the AP. That way, we would virtually always
>>> > receive a beacon from the new AP between the time we started the
>>> > association process (probe,auth,assoc) and configuring the driver.
>>> >
>>> > Now with the new changes that use the off-channel work, we may return to
>>> > the old "operating" channel, which may be no particular channel, between
>>> > all these steps. Thus, if there's no beacon between any of probe
>>> > request/response, auth "request"/"response", assoc request/response, we
>>> > never get one, and this situation happens.
>>> >
>>> > I see two solutions, apart from this special-case patch fixing
>>> >
>>> > First, we could go back to the original behaviour if we have just one
>>> > virtual interface. But that still leaves us with the race, we might do
>>> > all three frame exchanges within a beacon interval and still miss the
>>> > beacon, we just tend to not do that and get a beacon.
>>>
>>> Curious, what symptoms were seen when the dtim was not propagated
>>> prior to association, did the STA just not wake up for the right dtim
>>> interval when in PS mode?
>>
>> Yes, I don't really know exactly what happens,
>
> OK -- Wey, can you elaborate a little as to how you found this and
> what you were seeing? Does the device not go into PS mode at all?
>

BTW I ask more details because I'm trying to determine if this would
be a stable fix or not.

  Luis
