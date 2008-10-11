Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:29353 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbYJKWbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 18:31:43 -0400
Received: by wr-out-0506.google.com with SMTP id 69so695998wri.5
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 15:31:42 -0700 (PDT)
Message-ID: <43e72e890810111531t72af210fuc0074f691c1cb809@mail.gmail.com> (sfid-20081012_003151_589388_5DF112E5)
Date: Sat, 11 Oct 2008 18:31:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] ath9k: remove nasty FAIL macro from ath9k_hw_reset()
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1223683491.29811.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
	 <1223667649.3748.38.camel@johannes.berg>
	 <43e72e890810101359n529f932fw8cd47822b27b4685@mail.gmail.com>
	 <1223683491.29811.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 8:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-10 at 13:59 -0700, Luis R. Rodriguez wrote:
>> On Fri, Oct 10, 2008 at 12:40 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Fri, 2008-10-10 at 05:22 -0700, Luis R. Rodriguez wrote:
>> >
>> >>       ecode = ath9k_hw_process_ini(ah, chan, macmode);
>> >> -     if (ecode != 0)
>> >> +     if (ecode != 0) {
>> >> +             ecode = -EINVAL;
>> >>               goto bad;
>> >
>> > didn't this actually want to pass up ecode?
>>
>> Fuck yeah,
>>
>> bad:
>>         if (status)
>>                 *status = ecode;
>>         return false;
>
> What I meant was that it's overwriting the return value from process_ini
> now, was that intentional?

Ah no, if its already applied I'll send a follow up, thanks for reviewing.

  Luis
