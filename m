Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:61484 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZBPJ3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:29:54 -0500
Received: by gxk22 with SMTP id 22so2834002gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:29:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234776145.4219.113.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-6-git-send-email-lrodriguez@atheros.com>
	 <1234695593.4219.47.camel@johannes.local>
	 <43e72e890902160014k11ba609lbe1340750771b6c0@mail.gmail.com>
	 <1234774211.4219.102.camel@johannes.local>
	 <43e72e890902160117yd3a3b09o45ada7bc0aa0fbd7@mail.gmail.com>
	 <1234776145.4219.113.camel@johannes.local>
Date: Mon, 16 Feb 2009 01:29:53 -0800
Message-ID: <43e72e890902160129y1c43b845he7ffd6b2e0d1b987@mail.gmail.com> (sfid-20090216_102959_040561_AA10B24D)
Subject: Re: [PATCH 05/10] cfg80211: add regulatory_hint_core() to separate
	the core reg hint
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 1:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 01:17 -0800, Luis R. Rodriguez wrote:
>
>> >> > So before you documented that cfg80211_mutex is used to protect this
>> >> > variable, but it's not used here.
>> >>
>> >> This is only used during initialization, have any better ideas?
>> >
>> > If regulatory is initialised before netlink that is probably fine, is
>> > it?
>>
>> Yeah I was hoping that would be the case but then I realized that we
>> also end up creating a udev event to call crda and we need nl80211
>> initialized in order to process these hints so technically we have a
>> race between regulatory_init() finishing and nl80211_init() get done
>> before we can let nl80211 process the first CORE call to crda so it
>> may be dropped -- unless we are sure udev will do some sort of
>> retries.
>>
>> An alternative is to add the regulatory_request() for core to the
>> queue and then call a reg_post_init() on core.c  that would just
>> schedule the reg workqueue after nl80211_init().
>>
>> Thoughts?
>
> Can't you just do the proper locking and initialise regulatory after
> nl80211?

Yes if we figure out a way to not do a mutex_lock() from the module's
init, we cannot call a mutex_lock() from cfg80211_init(). I think
sending core's request to the workqueue is one way -- we'd then have
to schedule the queue towards the end of regulatory_init().

  Luis
