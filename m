Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51759 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3BUBGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 20:06:16 -0500
Message-ID: <51257304.10109@candelatech.com> (sfid-20130221_020619_907481_72CCE586)
Date: Wed, 20 Feb 2013 17:06:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL> <511BC243.8010409@candelatech.com> <20770.57339.20017.225929@gargle.gargle.HOWL> <51255360.6060603@candelatech.com>
In-Reply-To: <51255360.6060603@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 02:51 PM, Ben Greear wrote:
> On 02/18/2013 06:14 PM, Sujith Manoharan wrote:
>> Ben Greear wrote:
>>> On 02/11/2013 04:11 PM, Sujith Manoharan wrote:
>>>> Ben Greear wrote:
>>>>> axq-qnum:                    2          3         1         0
>>>>> axq-depth:                   0          0         0         0
>>>>> axq-ampdu_depth:             0          0         0         0
>>>>> axq-stopped                  1          0         0         0
>>>>> tx-in-progress               0          0         0         0
>>>>> pending-frames             125          0         0         0
>>>>
>>>> The frames appear to be stuck in the pending queue.
>>>
>>> Any ideas on what code to go poking at?
>>
>> xmit.c would be a good place. Can you also post the kernel log with some
>> debugging information ? debug=0x8f49 would be good.

I was 2/2 hitting the problem without debug set, but
had two clean runs with debugging enabled.  Either I'm
unlucky, or enabling debugging messes with things enough
to make the problem go away :P

Maybe looking at the xmit number can give some info?

> axq-qnum:                    2          3         1         0
> axq-depth:                   0          0         0         0
> axq-ampdu_depth:             0          0         0         0
> axq-stopped                  1          0         0         0
> tx-in-progress               0          0         0         0
> pending-frames             123          0         0         0
> txq_headidx:                 7          0         0         6
> txq_tailidx:                 7          0         0         6

For instance, in this case, why do we have pending frames, the axq-stopped,
and no axq depth?  Is that an invalid state to begin with?  Once
it gets in the hung state, those numbers never change.  I'd assume
something should be poking more packets out of the pending frames
down into the axq logic?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

