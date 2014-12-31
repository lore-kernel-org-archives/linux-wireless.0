Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36893 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaLaVKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 16:10:53 -0500
Message-ID: <54A4665A.8090906@lwfinger.net> (sfid-20141231_221104_532529_B167F4F3)
Date: Wed, 31 Dec 2014 15:10:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Eric Biggers <ebiggers3@gmail.com>
CC: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH V3 for 3.19]  rtlwifi: Fix error when accessing unmapped
 memory in skb
References: <1419996787-17395-1-git-send-email-Larry.Finger@lwfinger.net> <20141231050735.GA20639@zzz>
In-Reply-To: <20141231050735.GA20639@zzz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/30/2014 11:07 PM, Eric Biggers wrote:
> On Tue, Dec 30, 2014 at 09:33:07PM -0600, Larry Finger wrote:
>> v3 - Unmap skb before trying to allocate a new one so as to not leak mapping.
>
> Looks good to me, although I'm not sure about the handling of DMA mapping errors
> (perhaps that's something that drivers typically don't even try to handle?).
> Anyway, the skb allocation issue appears to be resolved now.  I am running your
> patch with an extra hack to inject some occasional skb allocation failures, and
> I haven't noticed any problems except dropped packets.

The last time I saw any DMA mapping errors were for some early BCM43xx cards 
that only had 20 bits of DMA addressing space. These Realtek devices have a full 
32 bits of addressing, thus any physical address in the first 4GB of RAM will be 
OK. I suppose that it might be possible to get a physical address outside this 
range for machines with a lot of RAM, but they are unlikely to have wifi interfaces.

Thanks for the testing. The Realtek engineer told me that they are looking at 
this section, and may do a rewrite. I'm waiting to see what happens there before 
considering alternatives. If the number of packets dropped due to skb allocation 
failures is small, then the current code is likely OK.

Larry

