Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:15390 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLCCly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:41:54 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1360583ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:41:52 -0800 (PST)
Message-ID: <43e72e890812021841w3ca3152q430a5344382b752e@mail.gmail.com> (sfid-20081203_034158_421097_DB37367C)
Date: Tue, 2 Dec 2008 18:41:52 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [PATCH] ath9k: Use GFP_ATOMIC when allocating private area
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
In-Reply-To: <43e72e890812021826w1820004chae7c245a8999c22f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18741.12999.753996.233483@gargle.gargle.HOWL>
	 <43e72e890812021614i103235few3a19721c6ca1d0cc@mail.gmail.com>
	 <18741.59362.77483.600612@localhost.localdomain>
	 <43e72e890812021809h3bc371d0t23e1c14d79a36617@mail.gmail.com>
	 <18741.60148.86455.854634@localhost.localdomain>
	 <43e72e890812021826w1820004chae7c245a8999c22f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 6:26 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Dec 2, 2008 at 6:12 PM, Sujith <m.sujith@gmail.com> wrote:
>> Luis R. Rodriguez wrote:
>>> Interesting, I hadn't thought about stopping the queues, when would
>>> they be resumed then though, or rather who? I'll a rework of this
>>> ontop of more DMA fun, let me know what you think. I just tested this.
>>>
>>
>> In TX completion, when we see that a queue is stopped, we wake up that queue
>> if the depth is less than a threshold.
>
> Ah yeah I see that now, so this will wake it up but only if we're
> processing the txq on completion. So technically speaking if we ran
> out of memory on the first attempted skb, wouldn't we never resume it?

OK I think I have a way to handle this too. Let me know what you think.

  Luis
