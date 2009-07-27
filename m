Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:29841 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZG0WCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 18:02:25 -0400
Received: by an-out-0708.google.com with SMTP id d40so4825771and.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 15:02:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910907271322x6c6ea95cr1cd1d310bf0ebe9b@mail.gmail.com>
References: <1248721179-16079-1-git-send-email-lrodriguez@atheros.com>
	<1248721724.32365.1.camel@johannes.local> <43e72e890907271241m7ccf386aj97097bb715e32658@mail.gmail.com>
	<69e28c910907271322x6c6ea95cr1cd1d310bf0ebe9b@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 27 Jul 2009 15:02:05 -0700
Message-ID: <43e72e890907271502m1e54b648v6be373d586093e08@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: redefine usage of the mac80211 workqueue
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/27 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Mon, Jul 27, 2009 at 9:41 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
>> On Mon, Jul 27, 2009 at 12:08 PM, Johannes
>> Berg<johannes@sipsolutions.net> wrote:
>>> On Mon, 2009-07-27 at 11:59 -0700, Luis R. Rodriguez wrote:
>>>
>>>> +EXPORT_SYMBOL_GPL(ieee80211_queue_work);
>>>
>>> Do we really want to allow these as _GPL only? Most things are not _GPL
>>> but usable by anyone, which of course isn't too useful since mac80211
>>> changes all the time :)
>>
>> Well I don't see why not.
>>
>>  Luis
>
> Do we want to prevent non-GPL

You mean non-GPL-compatible.

> drivers from using mac80211?

This wouldn't prevent it -- this is just for stuffing work into the
mac80211 workqueue. The way I was seeing this is we want to ensure
suspend works properly, if we allow non-GPL-compatible drivers stuff
work into the mac80211 workqueue suspend issues may pop up and the
issues may be driver related, not mac80211 related. But I guess its
better to see if crap vendor drivers are not following the APIs
properly, I'll remove this.

> That's
> actually counter-productive, as it reduces the chance of a
> manufacturer ever releasing a useful, kernel-includable driver. (Most
> manufacturers initially develop non-GPL drivers, which hopefully end
> up getting released under the GPL after community persuasion.

In my experience so far vendors tend to not write mac80211 drivers at
all unless they are open, all known vendor drivers I know of use wext
crap.

> If we
> make mac80211 GPL-only, that prevents any internal driver based on
> mac80211 from getting written.)

I'll remove this GPL_COMPATIBLE_ONLY thingy.

  Luis
