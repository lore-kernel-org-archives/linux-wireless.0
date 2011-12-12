Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1LLKEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 05:04:54 -0500
Received: by dajs34 with SMTP id s34so1547173daj.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 02:04:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323683521.3442.33.camel@jlt3.sipsolutions.net>
References: <CAMG6FYgLHP2WmcuMFh6fzih-NKO8Brvpbeeb2uunZQydYYmNLw@mail.gmail.com>
	<1323680547.3442.6.camel@jlt3.sipsolutions.net>
	<CAMG6FYjxRK30hTvKEaK=ppofN=KecJkbabTggWzXZQ5b-EN-NA@mail.gmail.com>
	<1323683521.3442.33.camel@jlt3.sipsolutions.net>
Date: Mon, 12 Dec 2011 11:04:54 +0100
Message-ID: <CAMG6FYjMj1pk9eCw=RuEATm+yuCQMWTe18Pt+=OgF=JNY7NpMw@mail.gmail.com> (sfid-20111212_110458_456891_C723C45E)
Subject: Re: [RFC] mac80211: Prevent possible BUG on suspend.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 12, 2011 at 10:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-12-12 at 10:22 +0100, Dmitry Tarnyagin wrote:
>> On Mon, Dec 12, 2011 at 10:02 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Mon, 2011-12-12 at 00:38 +0100, Dmitry Tarnyagin wrote:

>> ... or abort suspend on the driver's level. It's perfectly ok for me. But then
>> driver needs to be at least notified that WLAN is suspending. What do you
>> think about early-suspend driver callback which to be called before any
>> possibly locking operations in mac80211 code?
>
> That's seems reasonable.
>
Ok, I will play with it a bit...

> Well whenever it would have to wait for the mutex, even if it just has
> to wait 1ms for it... That will *certainly* trigger *randomly* on normal
> laptops systems and cause a TON of bug reports from users saying "my
> system randomly refuses to suspend".
>
Oh, yes, true..
