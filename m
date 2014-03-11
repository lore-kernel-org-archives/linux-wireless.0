Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40093 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaCKHgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 03:36:07 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so8197282oag.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 00:36:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394483266.30155.1.camel@jlt4.sipsolutions.net>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	<1394191196-6425-2-git-send-email-michal.kazior@tieto.com>
	<1394483266.30155.1.camel@jlt4.sipsolutions.net>
Date: Tue, 11 Mar 2014 08:36:06 +0100
Message-ID: <CA+BoTQ=9x1mw8+7bBAE7naHOtxAogkeBemNizpLV8DLLcobeig@mail.gmail.com> (sfid-20140311_083611_916260_72238B36)
Subject: Re: [PATCH 2/3] mac80211: include ieee80211_local in chanctx
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2014 21:27, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-07 at 12:19 +0100, Michal Kazior wrote:
>> Channel contexts are implicitly bound to hw
>> already so make it possible to dereference it
>> through the channel context itself.
>>
>> This will make it possible to reduce number of
>> arguments for chanctx-related functions.
>
> I don't really see much point in this, is there ever anything where we
> really get only a channel context and don't already have the local
> pointer?
>
> With interfaces, at least, we need it because we can get an interface
> through e.g. do_stop or do_open, so we don't have an easy way to
> reference local, but here? I don't think our functions have so many
> arguments that it's worth putting a pointer into the struct instead.

It just seems silly to me to pass local+chanctx all the time while
chanctx is already implicitly bound to a single hw.

I'm okay to drop this though. It's not really important.


Michał
