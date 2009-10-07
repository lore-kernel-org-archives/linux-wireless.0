Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp122.mail.ukl.yahoo.com ([77.238.184.53]:35100 "HELO
	smtp122.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933358AbZJGQ6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 12:58:41 -0400
Message-ID: <4ACCC893.1010402@yahoo.es>
Date: Wed, 07 Oct 2009 18:57:55 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: bcm43xx-dev@lists.berlios.de, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] b43: do not stack-allocate pio rx/tx header and tail
 buffers
References: <200910062252.17565.mb@bu3sch.de> <1254866864-18265-1-git-send-email-albert_herranz@yahoo.es> <4ACCC516.7050002@lwfinger.net>
In-Reply-To: <4ACCC516.7050002@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Albert Herranz wrote:
>> The DMA-API debugging facility complains about b43 mapping memory from
>> stack for SDIO-based cards.
>>
>> Indeed, b43 currently allocates the PIO RX/TX header and tail buffers
>> from stack. The solution here is to use heap-allocated buffers instead.
>>
>> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
>> ---
>> v2
>> - embed buffers into struct b43_wl, and make them depend on CONFIG_B43_PIO
>> - take into account tail buffers for unaligned length transfers
>>
>>  drivers/net/wireless/b43/b43.h  |  168 +++++++++++++++++++++------------------
>>  drivers/net/wireless/b43/pio.c  |   78 +++++++++---------
>>  drivers/net/wireless/b43/xmit.c |    2 +-
>>  3 files changed, 132 insertions(+), 116 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
>> index fa1549a..6607162 100644
>> --- a/drivers/net/wireless/b43/b43.h
>> +++ b/drivers/net/wireless/b43/b43.h
>> @@ -607,82 +607,7 @@ struct b43_qos_params {
>>  	struct ieee80211_tx_queue_params p;
>>  };
>>  
>> -struct b43_wldev;
>> -
>> -/* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
>> -struct b43_wl {
>> -	/* Pointer to the active wireless device on this chip */
>> -	struct b43_wldev *current_dev;
>> -	/* Pointer to the ieee80211 hardware data structure */
>> -	struct ieee80211_hw *hw;
> 
> What is the reason for moving the definition of struct b43_wl?
> 
> Larry
> 
> 

b43_new_kidx_api() (defined in xmit.h) needs struct b43_wldev defined because it dereferences it.
With this patch, struct b43_wl (defined in b43.h) needs struct b43_rxhdr_fw4 and struct b43_txhdr (defined in xmit.h).

So we have b43_wldev -> b43_rxhdr_fw4, b43_txhdr -> b43_wl (at least).

Moving the definition of struct b43_wl after the definition of struct b43_wldev and placing the inclusion of xmit.h between them gets rid of the generated dependencies.

The patch hints too to other possible solution.

>/*
> * Include goes here to avoid a dependency problem.
> * A better fix would be to integrate xmit.h into b43.h.
> */
>#include "xmit.h"

Do you have any other solutions in mind?

Thanks,
Albert

