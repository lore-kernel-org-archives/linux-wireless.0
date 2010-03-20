Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50083 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0CTUC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 16:02:27 -0400
Received: by fxm5 with SMTP id 5so329609fxm.29
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 13:02:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201003201207.11218.randolf.bruno@gmail.com>
References: <4BA24A12.4030208@gmail.com>
	 <a0b9368788449213d36b75dccd97c6a6@localhost>
	 <201003201144.24471.randolf.bruno@gmail.com>
	 <201003201207.11218.randolf.bruno@gmail.com>
Date: Sat, 20 Mar 2010 21:02:25 +0100
Message-ID: <f74418681003201302g3ed2902bp230a1ce93d165831@mail.gmail.com>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in
	ieee80211_local data structure
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	randolf.bruno@googlemail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Saturday 20 March 2010 11:44:24 Bruno Randolf wrote:
>> i think i'm hitting the same bug, but not sure (i will try to check next
>> week). this is easy to reproduce, but you need 4 (at least 3) machines:
>>
>> setup 2 wireless cards, talking to each other (i use IBSS) on different
>> machines. then setup routing like this:
>>
>> [1] - [WL1] - [WL2] - [2]
>>
>> now send more UDP traffic than the wireless link can handle (iperf -u -b
>> 50M for example) between [1] and [2]. watch the free memory get less and
>> less at [WL1] until it chrashes.
>
> forgot to add: [1] and [2] are connected by ethernet to [WL1/2]...
> (obviously?)
>
> bruno
>

Hi,

I tested the same network configuration used by bruno:

PC1<--ethernet cable-->Device1<--wireless link-->Device2<--ethernet cable-->PC2

but I injected packets using a VAP in monitor mode on both wireless devices.
I used UDP iperf traffic (50Mbps) from PC1 to PC2 as data stream. I
agree with bruno,
I think the main aspect of the test is to transmit a traffic steam
that the wireless link is not
able to handle. In order to trigger the crash, if the device is EDCA
capable, I suggest to use the
Best Effort hardware queue (skb->priority=3, AC_queue=2 in the
ieee80211_select_queue()) for all
data packets.

Regards

Lorenzo
