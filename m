Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35804 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbbCIN7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 09:59:43 -0400
Received: by iebtr6 with SMTP id tr6so30011287ieb.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 06:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425905568.1928.7.camel@sipsolutions.net>
References: <1425902001-3163-1-git-send-email-eliad@wizery.com>
	<1425905568.1928.7.camel@sipsolutions.net>
Date: Mon, 9 Mar 2015 15:59:43 +0200
Message-ID: <CAB3XZEe71wE+zPR-knwvrFMjecvddJhVsMWJ9YcHkGa9xW-XZQ@mail.gmail.com> (sfid-20150309_145949_903449_CC37A9AC)
Subject: Re: [PATCH] mac80211: handle hw roc cancel vs. expiration race
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 9, 2015 at 2:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-03-09 at 13:53 +0200, Eliad Peller wrote:
>
>> Fix it by cancelling hw_roc_done on roc cancel.
>> Since hw_roc_done takes local->mtx, temporarily
>> release it (before re-acquiring it and starting
>> the next roc if needed).
>
> I can't say I like this, and I'm not even sure it doesn't leave a race?
> After all, the work will not take the RTNL.
>
the other way (cancel while hw_roc_done) is protected, since
ieee80211_cancel_roc() looks for a specific roc cookie.

> Also, I think the whole concept is racy because you acquire "found"
> before the unlock, but use it after the unlock, so if the work actually
> ran (_sync, perhaps it already started) it may have freed the "found"
> pointer.
>
hw_roc_done work bails out in case of no started roc, so i think we're
safe here.

> I think the only way to really fix that is to make the driver return the
> roc pointer or so and then we can either queue a work struct per roc
> struct, or at least mark the roc struct as driver-destroyed and
> double-check that in the work function?
>
that was my initial implementation. but then i thought it will be
nicer to implement it in mac80211 and avoid changing all the drivers
(with the need to save the cookie, etc.)
do you prefer adding such cookie/pointer param?

> Or perhaps we could flush the work before we even take the lock, but
> then it might still race with the driver trying to cancel just after we
> flushed I guess.
right.

Eliad.
