Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLZTFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 14:05:45 -0500
Received: by mail-ob0-f174.google.com with SMTP id nt9so38869598obb.5
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 11:05:44 -0800 (PST)
Message-ID: <549DB187.3090003@lwfinger.net> (sfid-20141226_200548_474551_DB1AA44F)
Date: Fri, 26 Dec 2014 13:05:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	Christopher Chavez <chrischavez@gmx.us>
CC: linux-wireless@vger.kernel.org
Subject: Re: p54usb kernel panic on recent mainline kernels
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <549CCAD8.70704@lwfinger.net> <loom.20141226T052138-41@post.gmane.org> <2868661.A1AiatZ287@debian64>
In-Reply-To: <2868661.A1AiatZ287@debian64>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/26/2014 08:35 AM, Christian Lamparter wrote:
> On Friday, December 26, 2014 04:23:21 AM Christopher Chavez wrote:
>> Larry Finger <Larry.Finger@...> writes:
>>> In any case, file a bug report at bugzilla.kernel.org, mark it as a regression,
>>> and post the bug number here. If you are able to finish the bisection, that
>>> would be helpful.
>>
>> Reported.
>> https://bugzilla.kernel.org/show_bug.cgi?id=90331
>
> According to what Larry wrote, this bug should disappear, if
> the hw crypto offloading is disabled.
>
> Christopher, can you please load the p54common kernel module
> with the module parameter "nohwcrypt=1" and report back?

Christian,

I can confirm that the skb panic goes away if hardware encryption is disabled.

My bisection led to a branch commit d17ec4d as the "bad" commit. Rather than 
finding out where the bisection went bad, I added code to check skb->tail, 
skb->end, and the length to be added. At the time of the call that panics, there 
are 6 bytes between tail and end with 8 bytes needed.

I will be looking for the place where the driver calculates how large the skb 
should be.

Larry

