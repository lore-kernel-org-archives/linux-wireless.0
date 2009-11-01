Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44418 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZKAG4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 01:56:13 -0500
Received: by ewy28 with SMTP id 28so4006875ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 23:56:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de>
	 <200910291431.48388.mb@bu3sch.de>
	 <20091031202156.GA29825@hash.localnet>
	 <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
Date: Sun, 1 Nov 2009 08:56:16 +0200
Message-ID: <40f31dec0910312356t6543461gd23279cf4b6ebef@mail.gmail.com>
Subject: Re: ath5k AP issues
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/1 Nick Kossifidis <mickflemm@gmail.com>:
> 2009/10/31 Bob Copeland <me@bobcopeland.com>:
>> On Thu, Oct 29, 2009 at 02:31:46PM +0100, Michael Buesch wrote:
>>> Ok, to sum up some discussion from IRC:
>>>
>>> The initial packets that fail are not pings, but ARPs. Which are broadcast
>>> frames.  The access point simply fails to notify the station via DTIM for the
>>> pending multicast frames, so it stays in PS. Unicast and the corresponding
>>> TIM bitmap works properly, which also explains why it works once we got a
>>> successful ARP (and it didn't expire, yet).
>>
>> I don't think this fixes everything (I'm still seeing some mishandled
>> PS-poll frames) but this seemed to help pinging the PS client from the AP
>> side.
>>
>> [Although we agreed beacon-sent-gated without a ready time component
>> is the right way to go on the queue configuration, it seems badly
>> broken in practice unless I'm missing some enable bit somewhere.  So
>> this is what ath9k does.]
>>
>
> Well ready time is not disabled right now !
>
> 416                         ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
> 417                                 (AR5K_TUNE_SW_BEACON_RESP -
> 418                                 AR5K_TUNE_DMA_BEACON_RESP) -
> 419                                 AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
> 420                                 AR5K_QCU_RDYTIMECFG_ENABLE,
> 421                                 AR5K_QUEUE_RDYTIMECFG(queue));
>
> notice the AR5K_QCU_RDYTIMECFG_ENABLE. So it's probable that the queue
> starts on time and we miss sync because we wait an extra ready-time
> period.
>

Also i think we must use AR5K_DCU_MISC_ARBLOCK_IGNORE as we do for
beacon frames so that CAB queue gets on top no matter what queues are
pending (it already has the AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
