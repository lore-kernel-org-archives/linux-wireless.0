Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36089 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1EGIUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 04:20:02 -0400
Received: by qwk3 with SMTP id 3so2332393qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 01:20:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC49386.6070503@candelatech.com>
References: <BANLkTik3TtCcy2cJkMbRTpsn4x4XE9=naQ@mail.gmail.com>
	<4DC49386.6070503@candelatech.com>
Date: Sat, 7 May 2011 10:20:01 +0200
Message-ID: <BANLkTinndpZc8fBNdjBJxz3hGd-xdg-YAw@mail.gmail.com> (sfid-20110507_102008_930902_FB039CF6)
Subject: Re: Biescting between mainline and wireless-testing
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 7 maja 2011 02:34 użytkownik Ben Greear
<greearb@candelatech.com> napisał:
> On 05/06/2011 04:51 PM, Rafał Miłecki wrote:
>>
>> I suspect we have some ugly (hard trackable) regression between
>> mainline and wireless-testing. It sounds impossible, but this seems to
>> affect Broadcom cards and looks like not related to ssb or b43.
>>
>> Today I've compiled 2.6.38 and 2.6.39-rc6, both work GOOD.
>> I've compiled wireless-testing and it failed, BAD.
>> I've reverted all recent ssb patches from top and it still fails BAD.
>>
>> What would be the easiest way to try bisecting? I can see
>> wireless-testing merges mainline quite often. Can I use some trick on
>> checkouted wireless-testing? Do I have to checkout mainline and merge
>> wireless-testing into it? Something even different?
>>
>
> git bisect can handle it...I've spent some quality time finding
> bugs in ath9k with that lately...

Sure it can ;) But what should I match as GOOD for first bisect?
wireless-testing merges mainline all the time. So there are
wireless-testing specific commits between John's merge of 2.6.39-rc5
and 2.6.39-rc6. I can not match Linus's 2.6.39-rc6 as GOOD, because I
won't test wireless-testing specific changes done earlier (these that
didn't go info mainline).

Maybe I should call GOOD a commit that wireless-testing is based on?
Which one would it be?

Or maybe I could rebase wireless-testing on mainline and then I could
use 2.6.39-rc6 as GOOD?

-- 
Rafał
