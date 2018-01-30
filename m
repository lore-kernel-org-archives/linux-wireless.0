Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57290 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752888AbeA3RcZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 12:32:25 -0500
Subject: Re: ath9k will not tx packets sometimes.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com>
 <87a7wzv43j.fsf@toke.dk>
 <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com>
 <87d11stk0i.fsf@toke.dk>
 <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com>
 <871si81eev.fsf@toke.dk> <5A6FA79B.1080206@candelatech.com>
 <87h8r335yz.fsf@toke.dk>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <712ee959-4e41-f4fd-e765-523d024fa7fc@candelatech.com> (sfid-20180130_183229_281883_DE7FA913)
Date: Tue, 30 Jan 2018 09:32:22 -0800
MIME-Version: 1.0
In-Reply-To: <87h8r335yz.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2018 04:07 AM, Toke Høiland-Jørgensen wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> Maybe there is some way for the scheduler to get stuck and not
>> schedule anything?
>
> It would appear so, yeah. Do you do anything special other than
> associate a whole bunch of stations to trigger this? I can try to see if
> I can script something that works equivalently on my setup.

Ok, and I'll give you my user-space software package to easily set up
this test case if you want to test with that.  Contact me off-list if
you want help setting this up.

>
> I'm actually working on reworking that whole scheduler logic, and move
> some of it into mac80211. Could you test this (WiP) patch and see if
> that has the same problem?

It had some serious conflicts in ath10k, due to my local changes, so
I did not actually test this.

But, a revert of the atf patches (a6e56d749 and 63fefa050) appear to have resolved the
issue.  I'll test more with these reverted, and maybe will have time to
work more on actually fixing upstream code next time I move to a newer
kernel (and/or after your pending changes get in).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
