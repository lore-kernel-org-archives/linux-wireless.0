Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43146 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbYHGDd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 23:33:56 -0400
Message-ID: <489A6D1F.1040409@lwfinger.net> (sfid-20080807_053359_497400_F0A7D852)
Date: Wed, 06 Aug 2008 22:33:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
References: <4897714b.z7H23Rca9Z4lOo4Q%Larry.Finger@lwfinger.net> <200808070057.01952.chunkeey@web.de>
In-Reply-To: <200808070057.01952.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Monday 04 August 2008 23:14:51 Larry Finger wrote:
>> In commit b19fa1fa91845234961c64dbd564671aa7c0fd27, the configuration
>> parameter NETDEVICES_MULTIQUEUE was eliminated making multiple TX queues
>> the normal behavior. For p54usb, enabling multiple queues broke the driver.
>>
>> The real failure is not known, but a temporary hack that forces only one
>> queue is presented here.
>>
> 
> The real problem seems to be that skb_get_queue_mapping doesn't
> work the way it should when we process the firmwares callback. It's
> always "0" and unfortunately also when it should be something else like
> queue 1, 2 or 3..... problem solved? 
> 
> However someone should really take a closer look at the multiqueue thing,
> especially why it has to BLOCK/SPIN (uninterruptible?) when a queue is stopped 
> and tx returns therefore NETDEV_BUSY. 
> The is assumption that "a queue is in any case going to become free again" is
> well-intentioned, but as my devices are crashing left & right on a daily basis 
> it's even dangerous for my RAID ;-).
>  
> (BTW: patch is diffed against 2.6.27-rc2)
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> 

These changes fix the problem on my system. If it is made into a proper patch, 
I'll ACK it.

Larry

