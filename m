Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51351 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2E2VlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 17:41:04 -0400
Message-ID: <4FC5426D.9000408@candelatech.com> (sfid-20120529_234108_088566_34CE039A)
Date: Tue, 29 May 2012 14:41:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Dave Taht <dave.taht@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Is there no upper limit on mac80211 pending xmit queue size?
References: <4FC53C3A.1080001@candelatech.com> <CAA93jw7TiJLtL8tHNN28bpM4b_btqh4MkuqR6gL2=t2bracb+A@mail.gmail.com>
In-Reply-To: <CAA93jw7TiJLtL8tHNN28bpM4b_btqh4MkuqR6gL2=t2bracb+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 02:37 PM, Dave Taht wrote:
> On Tue, May 29, 2012 at 2:14 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> The tx pending queues doesn't seem to be limitted, allowing
>> run-away memory usage when something like pktgen is
>> sending packets faster than the system can actually
>> send them.
>>
>> [root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
>> 00: 0x00000000/0
>> 01: 0x00000000/0
>> 02: 0x00000001/40076
>> 03: 0x00000000/0
>> [root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
>> 00: 0x00000000/0
>> 01: 0x00000000/0
>> 02: 0x00000001/52649
>> 03: 0x00000000/0
>> [root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
>> 00: 0x00000000/0
>> 01: 0x00000000/0
>> 02: 0x00000001/107939
>> 03: 0x00000000/0
>>
>> I think this is what is causing my OOM issues when sending
>> with (my hacked version of) pktgen.
>>
>> Shouldn't there be an upper limit on the number of pending frames
>> that mac80211 will queue?
>
> something bql-like would help a lot.

Might help more righteous protocols, but I'm not sure it will help
with pktgen.  I'm working on an upper limit implemented as a module
parameter.  Hopefully that will at least keep the system from
going OOM.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

