Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35846 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbEYALo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2015 20:11:44 -0400
Message-ID: <556268BC.5050807@lwfinger.net> (sfid-20150525_021154_383145_56F0A28E)
Date: Sun, 24 May 2015 19:11:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Haggai Eran <haggai.eran@gmail.com>
CC: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>,
	Sudip Mukherjee <sudip@vectorindia.org>,
	Arek Rusniak <arek.rusi@gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call
 of del_timer_sync()
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net> <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com>
In-Reply-To: <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2015 02:03 PM, Haggai Eran wrote:
> On 24 May 2015 at 00:16, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> The driver is reporting a warning at kernel/time/timer.c:1096 due to calling
>> del_timer_sync() while in interrupt mode. Such warnings are fixed by calling
>> del_timer() instead.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>> Cc: Haggi Eran <haggai.eran@gmail.com>
>
> Hi,
>
> I haven't been using kernel v4.1 so I haven't seen this warning, but looking
> at the code it seems to originate from the two recent patches to remove
> _cancel_timer and _cancel_timer_ex. I see that there's another patch in lkml [1]
> that changes del_timer_sync back to del_timer in more places. Perhaps it
> could prevent other warnings like this in the future.
>
> Regards,
> Haggai
>
> [1] https://lkml.org/lkml/2015/5/15/226

Yes, the script kiddies make changes they do not understand and screw everything 
up. Unfortunately, I did not catch these in review. I think I will submit V2 and 
blast the contributor.

Larry


