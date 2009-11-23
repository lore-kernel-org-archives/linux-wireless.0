Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64202 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbZKWUvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 15:51:00 -0500
Received: by ewy19 with SMTP id 19so2279989ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 12:51:05 -0800 (PST)
Message-ID: <4B0AF5B6.40102@gmail.com>
Date: Mon, 23 Nov 2009 21:51:02 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/6] rt2x00: Properly request tx headroom for alignment
 operations.
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-5-git-send-email-gwingerde@gmail.com> <1258960565-26736-6-git-send-email-gwingerde@gmail.com> <200911231933.04875.IvDoorn@gmail.com>
In-Reply-To: <200911231933.04875.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/09 19:33, Ivo van Doorn wrote:
> On Monday 23 November 2009, Gertjan van Wingerde wrote:
>> Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
>> small" error message when a frame needs to be properly aligned before
>> transmitting it.
>> This is because the space needed to ensure proper alignment isn't
>> requested from mac80211.
>> Fix this by adding sufficient amount of alignment space to the amount
>> of headroom requested for TX frames.
>>
>> Reported-by: David Ellingsworth <david@identd.dyndns.org>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> Tested-by: David Ellingsworth <david@identd.dyndns.org>
>> ---
>>  drivers/net/wireless/rt2x00/rt2400pci.c   |   30 +++++++++++++++-------------
>>  drivers/net/wireless/rt2x00/rt2500pci.c   |   30 +++++++++++++++-------------
>>  drivers/net/wireless/rt2x00/rt2500usb.c   |   29 ++++++++++++++-------------
>>  drivers/net/wireless/rt2x00/rt2800lib.c   |    7 +----
>>  drivers/net/wireless/rt2x00/rt2800pci.c   |   31 +++++++++++++++--------------
>>  drivers/net/wireless/rt2x00/rt2800usb.c   |   25 ++++++++++++-----------
>>  drivers/net/wireless/rt2x00/rt2x00.h      |    7 ++++++
>>  drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++--
>>  drivers/net/wireless/rt2x00/rt61pci.c     |   28 ++++++++++++++------------
>>  drivers/net/wireless/rt2x00/rt73usb.c     |   27 +++++++++++++------------
>>  10 files changed, 117 insertions(+), 103 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
>> index 6e68bc7..f534d70 100644
>> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
>> @@ -1432,7 +1432,8 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>>  			       IEEE80211_HW_SIGNAL_DBM |
>>  			       IEEE80211_HW_SUPPORTS_PS |
>>  			       IEEE80211_HW_PS_NULLFUNC_STACK;
>> -	rt2x00dev->hw->extra_tx_headroom = 0;
>> +	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
>> +	    					RT2X00_ALIGN_SIZE;
> 
> Can't rt2x00lib initialize rt2x00dev->hw->extra_tx_headroom?
> The drivers aren't performing the aligning, so it is logical that rt2x00lib
> adds the required bytes rather than the drivers. The driver already sets
> the value in ops->extra_tx_headroom, so it can rely on rt2x00lib to do the rest.
> 

I guess that that can be done as an extra cleanup. Will do in a revision.

>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index b809c49..de358b5 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -2030,11 +2030,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>>  	    IEEE80211_HW_SUPPORTS_PS |
>>  	    IEEE80211_HW_PS_NULLFUNC_STACK;
>>  
>> -	if (rt2x00_intf_is_usb(rt2x00dev))
>> -		rt2x00dev->hw->extra_tx_headroom =
>> -			TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
>> -	else if (rt2x00_intf_is_pci(rt2x00dev))
>> -		rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
>> +	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
>> +	    					RT2X00_L2PAD_SIZE;
> 
> In this case we don't use RT2X00_ALIGN_SIZE, but the driver does set a flag to tell
> rt2x00lib that L2padding should be used rather then aligning. So this case would still
> hold when it is moved to rt2x00lib.
> 

Yep, will do in a revision.

>>  /*
>> + * Constants for extra TX headroom for alignment purposes.
>> + */
>> +#define RT2X00_ALIGN_SIZE	4
>> +#define RT2X00_L2PAD_SIZE	8
> 
> #define RT2X00_L2PAD_SIZE		RT2X00_ALIGN_SIZE + 4
> 
> Would probably better indicate why you are using 8.
> 

I'll add some comments on what these values represent. Don't think that defining RT2X00_L2PAD_SIZE
in your proposed way would help explaining, but some proper comments will.

---
Gertjan.
