Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51373 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0K2MzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:55:14 -0500
Message-ID: <4CF3A2BE.8040305@ti.com>
Date: Mon, 29 Nov 2010 14:55:26 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/2] wl12xx: Stop BA session event from device
References: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>	 <1290695964-4208-2-git-send-email-shahar_levi@ti.com> <1291035211.1673.68.camel@powerslave>
In-Reply-To: <1291035211.1673.68.camel@powerslave>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 02:53 PM, Luciano Coelho wrote:
> On Thu, 2010-11-25 at 16:39 +0200, ext Shahar Levi wrote:
>> Adding new event that close RX BA session in case of periodic BT activity
>> limiting WLAN activity.
>>
>> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
>> index 9815b7b..7cbeb2b 100644
>> --- a/drivers/net/wireless/wl12xx/event.c
>> +++ b/drivers/net/wireless/wl12xx/event.c
>> @@ -174,6 +174,25 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
>>   	wl->last_rssi_event = event;
>>   }
>>
>> +static void wl1271_event_ba_rx_constraint(struct wl1271 *wl,
>> +					  struct event_mailbox *mbox)
>> +{
>> +	u8 tid_index = 0;
>> +
>> +	wl1271_debug(DEBUG_EVENT, "BA RX constraint event. ba_allowed = %d",
>> +		     mbox->ba_allowed);
>> +
>> +	wl->ba_allowed = mbox->ba_allowed;
>> +
>> +	if (!wl->ba_rx_bitmap)
>> +		return;
>> +
>> +	for (tid_index = 0; tid_index<  CONF_TX_MAX_TID_COUNT; ++tid_index)
>
> Please use the more classic tid_index++ instead.
OK, will be fix on v2.
Thanks

