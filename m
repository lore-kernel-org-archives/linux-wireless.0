Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60175 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbYJJU7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 16:59:55 -0400
Received: by gxk9 with SMTP id 9so1352114gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 13:59:54 -0700 (PDT)
Message-ID: <43e72e890810101359n529f932fw8cd47822b27b4685@mail.gmail.com> (sfid-20081010_230000_959162_FB5CFD2C)
Date: Fri, 10 Oct 2008 13:59:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] ath9k: remove nasty FAIL macro from ath9k_hw_reset()
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1223667649.3748.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
	 <1223667649.3748.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 12:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-10 at 05:22 -0700, Luis R. Rodriguez wrote:
>
>>       ecode = ath9k_hw_process_ini(ah, chan, macmode);
>> -     if (ecode != 0)
>> +     if (ecode != 0) {
>> +             ecode = -EINVAL;
>>               goto bad;
>
> didn't this actually want to pass up ecode?

Fuck yeah,

bad:
        if (status)
                *status = ecode;
        return false;

  Luis
