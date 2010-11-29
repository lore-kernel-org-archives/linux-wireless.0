Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44932 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0K2KRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 05:17:12 -0500
Message-ID: <4CF37DB7.8080209@ti.com>
Date: Mon, 29 Nov 2010 12:17:27 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH ] wl12xx: BA receiver support
References: <1290616392-16532-1-git-send-email-shahar_levi@ti.com> <1291024366.1673.1.camel@powerslave>
In-Reply-To: <1291024366.1673.1.camel@powerslave>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 11:52 AM, Luciano Coelho wrote:
> On Wed, 2010-11-24 at 18:33 +0200, ext Shahar Levi wrote:
>> Add new ampdu_action ops to support receiver BA.
>> The BA initiator session management in FW independently.
>>
>> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
>> index f9146f5..4e053ff 100644
>> --- a/drivers/net/wireless/wl12xx/event.c
>> +++ b/drivers/net/wireless/wl12xx/event.c
>> @@ -241,6 +241,9 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
>>   			wl1271_event_rssi_trigger(wl, mbox);
>>   	}
>>
>> +	if (vector&  BA_SESSION_RX_CONSTRAINT_EVENT_ID)
>> +		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID");
>> +
>>   	if (wl->vif&&  beacon_loss)
>>   		ieee80211_connection_loss(wl->vif);
>>
>> diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
>> index 6cce014..4c697d7 100644
>> --- a/drivers/net/wireless/wl12xx/event.h
>> +++ b/drivers/net/wireless/wl12xx/event.h
>> @@ -67,7 +67,7 @@ enum {
>>   	HEALTH_CHECK_REPLY_EVENT_ID		 = BIT(27),
>>   	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
>>   	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
>> -	BA_SESSION_TEAR_DOWN_EVENT_ID		 = BIT(30),
>> +	BA_SESSION_RX_CONSTRAINT_EVENT_ID	 = BIT(30),
>>   	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
>>   };
>
> BA_SESSION_RX_CONSTRAING_EVENT_ID is not really used in this patch.
> Please move it to the "wl12xx: Stop BA session event from device", where
> it makes more sense.
>
i will move all event code move to the next patch.
Thanks
