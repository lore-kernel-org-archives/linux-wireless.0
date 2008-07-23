Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:38021 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYGWQkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:40:08 -0400
Message-ID: <48875EE5.3060303@monom.org> (sfid-20080723_184015_621731_5BBEC84A)
Date: Wed, 23 Jul 2008 18:40:05 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00mac: In error case stop netdev queue, free skb
 and return NETDEV_TX_OK
References: <1216805279-19149-1-git-send-email-wagi@monom.org> <200807231822.04895.IvDoorn@gmail.com>
In-Reply-To: <200807231822.04895.IvDoorn@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Wednesday 23 July 2008, Daniel Wagner wrote:
>> It is not allowed to use NETDEV_TX_BUSY in tx path anymore.
> 
> If not, then why is mac80211 checking and handling the return value
> and is tx() still a function returning an int. mac80211 is actually requeueing
> the frame when the hardware fails to send it, so why should that be completely blocked?

Well, I might be completely wrong here. I got this idea from following mail on netdev:
http://marc.info/?l=linux-wireless&m=121025252321824&w=2

>> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
>> @@ -46,7 +46,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
>>  	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
>>  	if (!skb) {
>>  		WARNING(rt2x00dev, "Failed to create RTS/CTS frame.\n");
>> -		return NETDEV_TX_BUSY;
>> +		return -1;
> 
> I am kind of missing the point here, this patch seems to come down to:
> 	We can't return TX_BUSY so we return a random other value

Unfortunately yes. The last return in this function is still NETDEV_TX_OK. My idea
was to return 0 on success in error -1. Is this not the expected normal
'typeless' return behavior of a function, no? 

daniel

