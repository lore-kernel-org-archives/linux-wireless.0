Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51463 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbbEaKm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 06:42:29 -0400
Message-ID: <1433068947.2370.5.camel@sipsolutions.net> (sfid-20150531_124237_222723_29C11A0D)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL
 messages.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 31 May 2015 12:42:27 +0200
In-Reply-To: <CABPxzYK-8TtYdiFeFrX7AVcsXQFaa3oxHREq+jgohHh1tCg5GQ@mail.gmail.com> (sfid-20150531_120147_714239_14809F2C)
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1433061092.2370.1.camel@sipsolutions.net>
	 <CABPxzYK-8TtYdiFeFrX7AVcsXQFaa3oxHREq+jgohHh1tCg5GQ@mail.gmail.com>
	 (sfid-20150531_120147_714239_14809F2C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-31 at 15:31 +0530, Krishna Chaitanya wrote:

> In our case the data size is 411KB, and each message carries around 3072
> bytes, so total messages would be 138. The first message we get, we
> retrieve the data, and for subsequent messages we just fill the skb,
> we are not interacting with the hardware.
> 
> Without this patch, heres the sequence:
> genl->cfg80211->retrieve the dump from HW, skb_put: 3072
>          cfg80211->skb_put, fail
> genl->cfg80211->skb_put: 3072.
> 
> With this patch:
> 
> genl->cfg80211->retrive the dump from HW, skb_put: 3072
> genl->cfg80211->skb_put: 3072.

You've failed to explain why this is so much of a problem that you're
trying to "fix" it. I suspect the "fail" part inside your driver is
needlessly expensive, I don't think the function call can be expensive
enough to worry anyone.

Note # of "messages" as you say is actually irrelevant - you should look
at how often the kernel/user boundary is crossed, that's really far more
interesting, and your patch makes that MUCH worse when the put size is
small (say 100 bytes) because then you're practically doing that twice
as often.

Anyway - I stand by your patch being a terrible idea. End of story.

johannes

