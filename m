Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:65024 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYIVJpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 05:45:19 -0400
Received: by gxk9 with SMTP id 9so2747339gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 02:45:18 -0700 (PDT)
Message-ID: <43e72e890809220245j77dcf385mb31e505308225ba9@mail.gmail.com> (sfid-20080922_114523_100030_E5EAC9A2)
Date: Mon, 22 Sep 2008 02:45:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Howard Chu" <hyc@symas.com>
Subject: Re: ath9k problems
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <48D760D8.3050501@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48D5CAD0.1080909@symas.com>
	 <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com>
	 <20080922064831.GB19580@tesla> <48D760D8.3050501@symas.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 2:09 AM, Howard Chu <hyc@symas.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Sat, Sep 20, 2008 at 09:22:56PM -0700, Steven Noonan wrote:
>>>
>>> On Sat, Sep 20, 2008 at 9:17 PM, Howard Chu<hyc@symas.com>  wrote:
>
>>>> I tried pulling the wireless-testing branch and found it behaved
>>>> strangely
>>>> as well - within about 30 seconds of idle time it would die. But, it
>>>> would
>>>> usually immediately begin to reconnect (and succeed). My logs were full
>>>> of
>>>> "ForceXPAon: 0" messages which I found were from ath9_hw_reset(), which
>>>> were
>>>> all being called from set_channel, during the scan that took place when
>>>> the
>>>> card was not associated with the AP. It typically occurred every 30-35
>>>> seconds.
>>>
>>> I'm sure the ath9k guys can be more informative about what
>>> 'ForceXPAon: 0' is all about,
>>
>> Its set *all the time* for our newer chipsets and can be safely ignored.
>> Not sure what the register is exactly for but its always set on
>> our newer chipsets upon reset.
>
> Yes, I understood that. But the fact that it was being logged repeatedly
> even after a session was connected, whereas before it always stopped once an
> association was made, was suspicious. And in fact I now see that it gets
> logged repeatedly because the association is repeatedly lost and
> re-established.
>
> For example - I added DPRINTFs to all the places that called ath9_hw_reset()
> to see why the ForceXPAon message was occurring so often, and got the
> attached log. I note that ForceXPAon doesn't occur on every call to
> hw_reset, and sometimes there are repeated identical calls to set the
> channel (e.g. at 22:06:36 in the log).
>
> It associates successfully with my AP on channel 8, but shortly thereafter
> loses the association, scans again, and starts over again, ad nauseam. This
> behavior was made even worse when I upgraded my freeradius server (was
> authenticating with WPA EAP/PEAP) and configured TLS session caching - there
> seems to be a bug in freeradius there so subsequent reassociation attempts
> would always fail until I turned off session caching. (Haven't had time to
> chase that down yet.)

Howard, did you apply the pending group key patch yet?

  Luis
