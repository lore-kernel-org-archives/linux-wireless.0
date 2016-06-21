Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43260 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbcFUOQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 10:16:32 -0400
Message-ID: <57694AD4.3020101@candelatech.com> (sfid-20160621_161657_303813_464EDC4F)
Date: Tue, 21 Jun 2016 07:10:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: Re: Bug with: ath10k: enable parsing per station rx duration for
 10.4?
References: <5768770C.5050305@candelatech.com> <20160621051829.GA20604@atheros-ThinkPad-T61>
In-Reply-To: <20160621051829.GA20604@atheros-ThinkPad-T61>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/20/2016 10:18 PM, Mohammed Shafi Shajakhan wrote:
> Hi Ben,
>
> thanks for reporting ...
>
> On Mon, Jun 20, 2016 at 04:06:52PM -0700, Ben Greear wrote:
>> I'm working on bringing up my hacked up version of 4.7 ath10k and 10.4 firmware, and I think
>> I may have found a regression.
>
> [shafi] let me know what is the issue.. some steps to recreate the issue.

ethtool -S wlan0
or similar should reproduce it.

You would see stats timeout messages in dmesg, and with a bit more debugging,
you notice that the driver is basically busy-spinning trying to get stats over
WMI and/or it is giving errors because skb pull fails because there actually is
not extd stats struct.

>>
>> My 10.4.3-ish firmware source has a bunch of:
>>
>> if (stats_id == WMI_REQUEST_PEER_STAT)
>> logic in it.  In other words, it is not using that id as a bitfield.
>
> [shafi] will check this.

I fixed my firmware to treat it as a bitfield, and to specifically un-set the EXTD stats
bit, and now it works with my 4.7.  Firmware fix should be backwards compatible.


>> Now, I can fix the firmware, but I am guessing that at least some stock
>> 10.4 firmware has this same issue, and of course any older firmware
>> that does not have this change will still be broken.
>>
>> So, do you want to back out this patch below, at least the part where it sends
>> in 0x9 as the stats_id?
>
> [shafi] request if you can check this please, there was some misunderstanding
> in the design when this feature got enabled in 10.4, we fixed it in
> https://patchwork.kernel.org/patch/9149357/

That might have fixed it, but it is not in 4.7, so I didn't have it
in my tree when testing yesterday.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
