Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GBPb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 11:31:28 -0400
Message-ID: <1341243087.19642.20.camel@jlt3.sipsolutions.net> (sfid-20120702_173132_268611_FFAAC1C1)
Subject: Re: Kernel oops in __netif_schedule() for at76c50x-usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Date: Mon, 02 Jul 2012 17:31:27 +0200
In-Reply-To: <4FF1BC71.4070002@lwfinger.net> (sfid-20120702_172127_238924_ED185EFD)
References: <4FF1BC71.4070002@lwfinger.net>
	 (sfid-20120702_172127_238924_ED185EFD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Sorry! I had your other email still marked unread but hadn't gotten
around to it :-(

> Regarding the oops that I reported for PPC architecture that reported "Unable to 
> handle kernel paging request for data at address 0x000004c", I have now repeated 
> it on x86_64 architecture, where the objdump tool is better. The error occurs in 
> the line in __netif_schedule() that says
> 
>           if (!test_and_set_bit(__QDISC_STATE_SCHED, &q->state))
> 
> Debug printouts have shown that q is not NULL, and it appears to be in the 
> correct address range. I think q->state is zero; however, q->state cannot be 
> written.
> 
> Additional testing shows this problem to be another side effect of commit 
> 3a25a8c ("mac80211: add improved HW queue control") for a device with only a 
> single HW queue.

Looking at the code again, it seems pretty obviously wrong ... OUCH!

I'm not sure which fix is correct though. Should we have software QoS
queues for these drivers, but we'll never use them? Then this would
work:
http://p.sipsolutions.net/e015bf7db9a05887.txt

Or we could change the enable code path. Hmm.

johannes

