Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35514 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbEYP7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 11:59:46 -0400
Message-ID: <556346EF.8000804@lwfinger.net> (sfid-20150525_175959_074848_7FA3309D)
Date: Mon, 25 May 2015 10:59:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: 1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net,
	haggai.eran@gmail.com
CC: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>,
	Arek Rusniak <arek.rusi@gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call
 of del_timer_sync()
References: <20150525044250.GA3385@sudip-PC>
In-Reply-To: <20150525044250.GA3385@sudip-PC>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2015 11:42 PM, Sudip Mukherjee wrote:
>> I haven't been using kernel v4.1 so I haven't seen this warning, but looking
>> at the code it seems to originate from the two recent patches to remove
>> _cancel_timer and _cancel_timer_ex. I see that there's another patch in lkml [1]
>> that changes del_timer_sync back to del_timer in more places. Perhaps it
>> could prevent other warnings like this in the future.
>
> _cancel_timer and _cancel_timer_ex both were internally using del_timer,
> and the issue was reported in bugzilla. I have given the reference of the
> bugzilla in my patch in lkml.
> I have changed the reference of del_timer_sync to del_timer in all places
> which were in interrupt context, in some places it was not removed as
> those were not in interrupt context.

Why did you not Cc the maintainers?? That is why file MAINTAINERS exists.

Was your patch sent to Greg?

Larry


