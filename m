Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38633 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbaDBO7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 10:59:36 -0400
Message-ID: <533C25BB.7080803@candelatech.com> (sfid-20140402_165939_406953_9E3EDB08)
Date: Wed, 02 Apr 2014 07:59:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: remove not needed warning when peer unmap
References: <1396340628-4570-1-git-send-email-janusz.dziedzic@tieto.com> <877g78rxv0.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877g78rxv0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2014 12:31 AM, Kalle Valo wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Remove not needed warning when get peer unmap
>> event from the firmware. This is not critical
>> message. Instead print this as a debug message.
>
> I don't agree with that statement. If that would be true, we could
> remove a lot of warnings from ath10k. We have these warnings to catch
> problems early, which again improves the quality of the driver.

I see this message all the time, by the way...  I have been ignoring
it so far, but if it's  real issue then I can pay more attention.

Thanks,
Ben

>
> Your commit log was again missing the "why?" part. I assume the reason
> for this patch is the problem of seeing the warning "unknown peer id 2"
> when putting the interface is down, which again is a spurious event from
> the firmware? You should document that in the commit log as well as add
> a short comment to the code explaining why we only print a debug message
> when that happens.
>
> Other idea I had would be to keep the warning message but add a new test
> to detect this problematic case, but I guess for that we would need to
> add a new state "stopping" to catch that? For example, something like
> this:
>
> if state == stopping and event->id == 2
>          dbg("foo")
> else
>          warn("bar")
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

