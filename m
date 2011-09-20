Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37990 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1ITPBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 11:01:00 -0400
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Eliad Peller <eliad@wizery.com>,
	Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<1316450319.5995.33.camel@jlt3.sipsolutions.net>
	<87hb47ip7q.fsf@purkki.adurom.net>
	<CAK=WgbY1cbQ-5k6Hc1O=SmULACmUd32UXXKkGhGggbUFPt8PQA@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 20 Sep 2011 18:00:59 +0300
In-Reply-To: <CAK=WgbY1cbQ-5k6Hc1O=SmULACmUd32UXXKkGhGggbUFPt8PQA@mail.gmail.com> (Ohad Ben-Cohen's message of "Tue\, 20 Sep 2011 11\:59\:23 +0300")
Message-ID: <8762kni7h0.fsf@purkki.adurom.net> (sfid-20110920_170104_987432_DB78CE82)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen <ohad@wizery.com> writes:

> On Tue, Sep 20, 2011 at 11:37 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> One extreme is that wl12xx would set IEEE80211_HW_SUPPORTS_DYNAMIC_PS
>> and reimplement the dynps timer in the driver. That way the driver
>> would have full control how it works and not complicate the mac80211
>> implementation.
>
> That sounds like an awful code duplication just to prevent a small API
> extension.

Heh, that's always relative and actually for me it's the opposite.
What you consider small API update is for me a major change as it
allows the driver control dynps timer parameters, which we haven't
allowed earlier.

And for me adding that dynps timer to a driver isn't that much more
code, basically it's just a simple timer. And I doubt that you even
need to stop the queues when changing the ps state like mac80211 does.
I would not describe it as "an awful lot of code".

Having your own time would allow you to change to the BT coex
implementation of the week your firmware provides and not interferece
with mac80211 and other drivers.

> Yes, adding API complicates the code, but isn't the whole point of
> mac80211 is to prevent egregious code duplication ?

Sure, but there's always a limit for everything. mac80211 is growing
all the time and becoming more complex. I think the "All in" approach
won't work for too long and we need to start considering how to keep
mac80211 still maintainable. Like I have said earlier, the power save
implementation is a good example of this.

-- 
Kalle Valo
