Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38347 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2GBQNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 12:13:09 -0400
Received: by gglu4 with SMTP id u4so4241566ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 09:13:08 -0700 (PDT)
Message-ID: <4FF1C887.8090009@lwfinger.net> (sfid-20120702_181313_853948_FF7B1165)
Date: Mon, 02 Jul 2012 11:12:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel oops in __netif_schedule() for at76c50x-usb
References: <4FF1BC71.4070002@lwfinger.net>  (sfid-20120702_172127_238924_ED185EFD) <1341243087.19642.20.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341243087.19642.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/02/2012 10:31 AM, Johannes Berg wrote:
> Hi Larry,
>
> Sorry! I had your other email still marked unread but hadn't gotten
> around to it :-(
>
>> Regarding the oops that I reported for PPC architecture that reported "Unable to
>> handle kernel paging request for data at address 0x000004c", I have now repeated
>> it on x86_64 architecture, where the objdump tool is better. The error occurs in
>> the line in __netif_schedule() that says
>>
>>            if (!test_and_set_bit(__QDISC_STATE_SCHED, &q->state))
>>
>> Debug printouts have shown that q is not NULL, and it appears to be in the
>> correct address range. I think q->state is zero; however, q->state cannot be
>> written.
>>
>> Additional testing shows this problem to be another side effect of commit
>> 3a25a8c ("mac80211: add improved HW queue control") for a device with only a
>> single HW queue.
>
> Looking at the code again, it seems pretty obviously wrong ... OUCH!
>
> I'm not sure which fix is correct though. Should we have software QoS
> queues for these drivers, but we'll never use them? Then this would
> work:
> http://p.sipsolutions.net/e015bf7db9a05887.txt
>
> Or we could change the enable code path. Hmm.

That patch does prevent the oops. I was not able to make a connection with the 
device, but I just acquired it, and I'm not sure of its quality, or that of the 
driver. It does scan OK, and I think the patch is OK. I'll do more tests with 
b43legacy later as the machine with that iface is busy. I will also test b43 on 
the PPC using the open-source firmware.

Although you may want to change the enable code path, some patch will be needed 
to prevent a regression in 3.5. If this is the one, you may add a "Tested-by" 
for me.

Larry


