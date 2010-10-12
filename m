Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38504 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267Ab0JLOfp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:35:45 -0400
Message-ID: <4CB472E6.60808@ti.com>
Date: Tue, 12 Oct 2010 16:38:30 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/03] wl1271: BA Initiator support, Add Definitions
References: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>	 <1286456762-17480-2-git-send-email-shahar_levi@ti.com> <1286538676.21349.106.camel@chilepepper>
In-Reply-To: <1286538676.21349.106.camel@chilepepper>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the review.
All will be fix on v2.
Two comments inline.
regards,
Shahar

Luciano Coelho wrote:
> On Thu, 2010-10-07 at 15:06 +0200, ext Shahar Levi wrote:
>> New acx cmd wl1271_acx_ba_session_policy to set BA policy to the FW.
>> Macros to use with BA setting.
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
> 
> You can merge this patch with the next patch, no need to make the
> changes first in the header files and then in the c files, since they go
> very much hand in hand.
> 
> 
>>  drivers/net/wireless/wl12xx/wl1271_acx.h  |   16 ++++++++++++++++
>>  drivers/net/wireless/wl12xx/wl1271_conf.h |    3 +++
>>  2 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
>> index b8da1bc..6c3c7c0 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
>> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
>> @@ -1055,6 +1055,22 @@ struct wl1271_acx_ht_information {
>>  	u8 padding[3];
>>  } __packed;
>>  
>> +/*
>> + * BA sessen interface structure
>> + */
> 
> BA session.  Actually you can get rid of this comment, as it is obvious
> from the name of the structure that this is about BA sessions.
> 
>> +struct wl1271_acx_ba_session_policy {
>> +	struct acx_header header;
>> +	/* Mac address of: SA as receiver / RA as initiator */
>> +	u8 mac_address[ETH_ALEN];
> 
> Is this really SA for receiver and RA for initiator? Not SA and DA? Or
> TA and RA?
yes, as initiator it is the receiver address, as receiver it is source 
address. I change the comment to:
Mac address of the peer: SA as receiver / RA as initiator

> 
> 
>> +	u8 tid;			/* TID */
> 
> Comment here is unnecessary.
> 
>> +	u8 policy;		/* Enable / Disable */
> 
> Could we change policy to enable here? Then the comment can go away too,
> because the name of the element will be clear enough already.
> 
> 
>> +	u16 win_size;		/* windows size in num of packet */
> 
> "number of packets"
> 
> 
>> +	u16 inactivity_timeout;	/* as initiator inactivity timeout
>> +				 * in time units(TU) of 1024us.
>> +				 * as receiver reserved
>> +				 */
> 
> The comment style is wrong.
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
>> index b3e608e..63a0a9a 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_conf.h
>> +++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
>> @@ -94,6 +94,9 @@ enum {
>>  #define HW_BG_RATES_MASK	0xffff
>>  #define HW_HT_RATES_OFFSET	16
>>  
>> +#define BA_RECEIVER_WIN_SIZE 8
move to wl1271_acx.h, not configurable.

>> +#define BA_INACTIVITY_TIMEOUT 10000
> 
> This should be added as a real configuration, like the other stuff in
> the wl1271_conf.h file, which is then used in wl1271_main.c
> default_conf.  Please define a struct conf_ba with win_size and
> inactivity_timeout elements and set the actual values in the main file.
> 
> 

