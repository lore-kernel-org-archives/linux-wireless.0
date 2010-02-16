Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:48308 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab0BPUFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:05:46 -0500
Received: by pxi3 with SMTP id 3so2844584pxi.28
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 12:05:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100214181819.2b14ff2c@droptest.queued.net>
References: <20100207214837.027dfd3d@mycelium.queued.net> <43e72e891002081032i6e96ab08i345c911e44e95bd2@mail.gmail.com>
	<20100214181819.2b14ff2c@droptest.queued.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 12:05:25 -0800
Message-ID: <43e72e891002161205t100f61bclea94890e45c0ed1d@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
	algorithm
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 3:18 PM, Andres Salomon
<dilinger@collabora.co.uk> wrote:
> On Mon, 8 Feb 2010 10:32:50 -0800
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>
>> On Sun, Feb 7, 2010 at 6:48 PM, Andres Salomon
>> <dilinger@collabora.co.uk> wrote:
>> >
>> > I discovered that if EMBEDDED=y, one can accidentally build a
>> > mac80211 stack w/ no rate control algorithm.  When RC_MINISTREL and
>> > RC_PID are both disabled, the RC_DEFAULT string (which rate.c uses
>> > as the fallback algorithm) will be "".  That'll cause the
>> > rate_control_alloc to fail, which will in turn cause
>> > ieee80211_register_hw to fail.  IOW, no driver will load.
>> >
>> > This will tell kconfig to provide a warning if no rate control
>> > algorithms have been selected.  That'll at least warn the user that
>> > they're about to build a broken wireless stack.
>>
>>
>> Please Cc: stable@kernel.org here as well, I think we've had this for
>> a while.
>>
>> > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
>>
>>   Luis
>
> Here's an updated patch.  I ended up just changing the wording.
>
>
>
>
> Subject: [PATCH] mac80211: give warning if building w/out rate ctrl algorithm
>
> I discovered that if EMBEDDED=y, one can accidentally build a mac80211 stack
> and drivers w/ no rate control algorithm.  For drivers like RTL8187 that don't
> supply their own RC algorithms, this will cause ieee80211_register_hw to
> fail (making the driver unusable).
>
> This will tell kconfig to provide a warning if no rate control algorithms
> have been selected.  That'll at least warn the user; users that know that
> their drivers supply a rate control algorithm can safely ignore the
> warning, and those who don't know (or who expect to be using multiple
> drivers) can select a default RC algorithm.
>
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>

You want to add Cc: stable@kernel.org on the commit log, not on the e-mail.

  Luis
