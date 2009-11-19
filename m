Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:60065 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292AbZKSWae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 17:30:34 -0500
Message-ID: <4B05C70D.1030703@vanwingerde.net>
Date: Thu, 19 Nov 2009 23:30:37 +0100
From: Gertjan van Wingerde <gertjan@vanwingerde.net>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: request TX status where needed
References: <1258589310.30511.91.camel@johannes.local> <4B05C234.3000908@gmail.com>
In-Reply-To: <4B05C234.3000908@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/09 23:09, Gertjan van Wingerde wrote:
> On 11/19/09 01:08, Johannes Berg wrote:
>> Right now all frames mac80211 hands to the driver
>> have the IEEE80211_TX_CTL_REQ_TX_STATUS flag set to
>> request TX status. This isn't really necessary, only
>> the injected frames need TX status (the latter for
>> hostapd) so move setting this flag.
>>
>> The rate control algorithms also need TX status, but
>> they don't require it.
>>
>> Also, rt2x00 uses that bit for its own purposes and
>> seems to require it being set for all frames, but
>> that can be fixed in rt2x00.
>>
>> This doesn't really change anything for any drivers
>> but in the future drivers using hw-rate control may
>> opt to not report TX status for frames that don't
>> have the IEEE80211_TX_CTL_REQ_TX_STATUS flag set.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> Acked-by: Ivo van Doorn <IvDoorn@gmail.com> [rt2x00 bits]
>> ---
> 
>> @@ -287,12 +288,12 @@ void rt2x00lib_txdone(struct queue_entry
>>  	}
>>  
>>  	/*
>> -	 * Only send the status report to mac80211 when TX status was
>> -	 * requested by it. If this was a extra frame coming through
>> -	 * a mac80211 library call (RTS/CTS) then we should not send the
>> -	 * status report back.
>> +	 * Only send the status report to mac80211 when it's a frame
>> +	 * that originated in mac80211. If this was a extra frame coming
>> +	 * through a mac80211 library call (RTS/CTS) then we should not
>> +	 * send the status report back.
>>  	 */
>> -	if (tx_info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
>> +	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
>>  		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
>>  	else
>>  		dev_kfree_skb_irq(entry->skb);
> 
> I'm slightly confused here. Shouldn't both the tx_info->flags and skbdesc_flags be checked here?
> Now we run in the situation where tx_status is report even if mac80211 didn't ask for it.
> 

Never mind. I missed the change from "requested" to "required" for the IEEE80211_TX_CTL_REQ_TX_STATUS flag.

Everything is alright.

---
Gertjan.
