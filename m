Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51616 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbbEaLVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 07:21:47 -0400
Message-ID: <1433071305.2370.14.camel@sipsolutions.net> (sfid-20150531_132151_256785_24DACF35)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL
 messages.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 31 May 2015 13:21:45 +0200
In-Reply-To: <CABPxzY+9FwDPwRcZ4QT4QcfhMqmaQsrs=LT5E8tDKQG2t+wFRA@mail.gmail.com> (sfid-20150531_131751_864869_998A17F8)
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1433061092.2370.1.camel@sipsolutions.net>
	 <CABPxzYK-8TtYdiFeFrX7AVcsXQFaa3oxHREq+jgohHh1tCg5GQ@mail.gmail.com>
	 <1433068947.2370.5.camel@sipsolutions.net>
	 <CABPxzY+9FwDPwRcZ4QT4QcfhMqmaQsrs=LT5E8tDKQG2t+wFRA@mail.gmail.com>
	 (sfid-20150531_131751_864869_998A17F8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-31 at 16:47 +0530, Krishna Chaitanya wrote:

> > Note # of "messages" as you say is actually irrelevant - you should look
> 
> Well with 138 messages the function and each message 3072 bytes
> calls b/w cfg80211 and driver
>        without the patch: would be 276 calls
>        with this patch: would be 138 calls
> Thats a lot of function calls, don't you think?

No, I don't think so. That really should be within the noise, it's all
in the icache already after the first round.

> > at how often the kernel/user boundary is crossed, that's really far more
> > interesting, and your patch makes that MUCH worse when the put size is
> > small (say 100 bytes) because then you're practically doing that twice
> > as often.
> 
> My patch doesn't deteriorate the situation, and not change the kernel to
> user boundary. With/Without the patch 3072 bytes are transported in a
> single message from kernel to user.

*in your case*

In the case that somebody is creating smaller messages it makes things
MUCH worse by allowing only half the data to be carried across the
kernel/userspace boundary each time any data crosses it, so it will
result in many more syscalls in that case. If you're worried about the
overhead of a simple function (pointer) call in the kernel, then surely
you should be far more worried about this.

johannes

