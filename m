Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60850 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1AGCsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:48:50 -0500
Message-ID: <4D267F0D.6030508@candelatech.com>
Date: Thu, 06 Jan 2011 18:48:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for debugfs.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-3-git-send-email-greearb@candelatech.com> <4D267E47.6050408@openwrt.org>
In-Reply-To: <4D267E47.6050408@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2011 06:45 PM, Felix Fietkau wrote:
> On 2011-01-06 5:46 PM, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> The stations hold the ath_node, which holds the tid
>> and other xmit logic structures. In order to debug
>> stuck xmit logic, we need a way to print out the tid
>> state for the stations.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
> I really don't like the array with the hardcoded size. How about just adding a struct list_head to the ath_node struct and tracking that?

I can do that..would probably want a pointer back from the ath_node to it's STA struct
as well.

I'll re-work the patch to use a list.

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
