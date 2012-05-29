Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50068 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab2E2TTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 15:19:10 -0400
Message-ID: <4FC5212A.8000505@candelatech.com> (sfid-20120529_211924_385014_CE0BD66B)
Date: Tue, 29 May 2012 12:19:06 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <4FC2437C.9090106@candelatech.com> <4FC51418.5000104@candelatech.com> <201205292107.42337.chunkeey@googlemail.com>
In-Reply-To: <201205292107.42337.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 12:07 PM, Christian Lamparter wrote:
> On Tuesday, May 29, 2012 08:23:20 PM Ben Greear wrote:
>> On 05/27/2012 08:08 AM, Ben Greear wrote:
>>> On 05/26/2012 09:39 AM, Sujith Manoharan wrote:
>> We started testing with two AR9380 NICs today (one AP, the other STA).
>> I applied Felix's skb optimization patch, and the ath9k memleak fix patch
>> on top of 3.3.7+.
>>
>> The system has 2GB RAM, but it is 32-bit kernel, so not all
>> is available to the networking code...  That said, the OOM
>> killer kills VNC and such.
>>
>> Anyway, I'll try some memleak debugging to see if
>> I can find any leaks.  It seems to me that we should
>> not actually OOM just by trying to transmit too fast
>> on a station interface :P
> well, there's that:
> http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/8233
>
> It might not fix the bug, but it can save you time to confirm
> that is not related to this particular skb leak.

Ok, I will try this.

The leak this might fix is some ack logic up in mac80211?

Seems like we could also use some atomic counters to keep
track of number of outstanding mac80211-alocated skbs with this
and be worried if this number grows and grows?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

