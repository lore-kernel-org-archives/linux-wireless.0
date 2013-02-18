Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58669 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3BRUK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 15:10:58 -0500
Message-ID: <51228ACF.3060500@lwfinger.net> (sfid-20130218_211113_804457_48B72F51)
Date: Mon, 18 Feb 2013 14:10:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Bastian Bittorf <bittorf@bluebottle.com>,
	Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net> <CACna6rwLgE+o2mcRTemLFAqzdsEoA9Xyx8GyEQTh5qbv1iZ04A@mail.gmail.com>
In-Reply-To: <CACna6rwLgE+o2mcRTemLFAqzdsEoA9Xyx8GyEQTh5qbv1iZ04A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 10:18 AM, Rafał Miłecki wrote:
> 2013/2/18 Larry Finger <Larry.Finger@lwfinger.net>:
>> Bastian Bittorf reported that some of the silent freezes on a Linksys WRT54G
>> were due to overflow of the RX DMA ring buffer, which was created with 64
>> slots. That finding reminded me that I was seeing similar crashed on a netbook,
>> which also has a relatively slow processor. After increasing the number of
>> slots to 128, runs on the netbook that previously failed now worked; however,
>> I found that 109 slots had been used in one test. For that reason, the number
>> of slots is being increased to 256.
>
> So probably ideal solution is to use 128 *and* fix the driver's
> failing on overflow ;)
>
> Did you try it on some old device? Just for sure firmware&DMA will
> handle it correctly.

I tested on BCM4318 (which is pretty old), and two different BCM4312 (14e4:4315) 
units. I think the firmware and DMA can handle it. After all, all the TX rings 
have 256 slots. There is, however, a question of the memory. TX only acquires 
the buffers when needed, but RX has to get them in advance, thus 256 slots there 
will waste a lot of memory.

I agree that there be two patches, depending on Bastian's testing. The slot size 
change can be backported to stable.

Larry

