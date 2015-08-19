Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35850 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbbHSTvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:51:11 -0400
Received: by wicja10 with SMTP id ja10so128545166wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 12:51:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440013262.2089.13.camel@sipsolutions.net>
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
 <1439983495.2089.7.camel@sipsolutions.net> <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
 <1440007745.2089.11.camel@sipsolutions.net> <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com>
 <1440013262.2089.13.camel@sipsolutions.net>
From: Allan Matthew <allanm84@gmail.com>
Date: Wed, 19 Aug 2015 12:50:50 -0700
Message-ID: <CAEnVuW21Ocie0RUGv-UZU1U=n=mTinJ_nJa2uHQqVZz-11AbWA@mail.gmail.com> (sfid-20150819_215115_026053_0B323DB9)
Subject: Re: set channel from radiotap headers during injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regarding the AP clients, could the AP send a power save or sleep
notification telling clients its going away for awhile, then come back
after the specified time?

On Wed, Aug 19, 2015 at 12:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-08-19 at 12:00 -0700, Allan Matthew wrote:
>>
>> I operate an AP on one channel that talks to some set of devices.
>>
>> On another "channel" (maybe just different BW) I use packet injection
>> to send data to and from a separate device.
>>
>> The bitrate to the 2nd device (on the 2nd channel) is much lower than
>> that of the AP, and I'd like to get longer range out of it.  The idea
>> is that I use narrower bandwidth and fixed, low bitrates with control
>> over the retries to get really tight control over that link.
>>
>
> It might be somewhat feasible to set up the second one as a regular
> client/AP link as well, with a different channel context...
>
> However, the clients on the original AP might not be amused - their AP
> would mysteriously disappear every once a while, something they're not
> expecting (unless you restrict it to P2P GO/client operation)
>
> johannes
