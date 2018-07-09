Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36334 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754214AbeGIJYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 05:24:11 -0400
Subject: Re: [PATCH] mac80211: restrict delayed tailroom needed decrement
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <1531126681-5146-1-git-send-email-mpubbise@codeaurora.org>
 <1531126957.3298.23.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <99231cb4-8977-c9c4-ff11-0c57899e30b7@codeaurora.org> (sfid-20180709_112416_993380_A1F0EB94)
Date: Mon, 9 Jul 2018 14:54:07 +0530
MIME-Version: 1.0
In-Reply-To: <1531126957.3298.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> For example, let's consider the case of a 4-addr client connecting to
>> an AP for which AP_VLAN interface is also created, let the initial
>> value for tailroom_needed on the AP be 1.
>>
>> * 4-addr client connects to the AP (AP: tailroom_needed = 1)
>> * AP will clear old keys, delay decrement of tailroom_needed count
>> * AP_VLAN is created, it takes the tailroom count from master
>>    (AP_VLAN: tailroom_needed = 1, AP: tailroom_needed = 1)
>> * Install new key for the station, assume key is plumbed in the HW,
>>    there won't be any change in tailroom_needed count on AP iface
>> * Delayed decrement of tailroom_needed count on AP
>>    (AP: tailroom_needed = 0, AP_VLAN: tailroom_needed = 1)
>>
>> Because of the delayed decrement on AP iface, tailroom_needed count goes
>> out of sync between AP(master iface) and AP_VLAN(slave iface) and
>> there would be unnecessary tailroom created for the packets going
>> through AP_VLAN iface.
> This describes a scenario where there's *unnecessary* work done, but not
> really one where we have something that's *incorrect*?
>

To me at least doing unnecessary things is incorrect :-D, may be we can 
change the statement.

> Are you saying that you found a problem with this? Did this show up in
> some sort of measurements?

Not really, I have observed in my testing that there were warnings 
whenever a AP_VLAN was brought down; this is done in ieee80211_free_keys.
Warnings show up every time we bring down the AP_VLAN interface(using 
ifconfig); warnings apart but I thought there would be unnecessary 
overhead in the tailroom expansion though the overhead may be trivial.

>> +++ b/net/mac80211/key.c
>> @@ -583,7 +583,8 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
>>   
>>   		ieee80211_debugfs_key_remove(key);
>>   
>> -		if (delay_tailroom) {
>> +		if (delay_tailroom &&
>> +		    sdata->vif.type == NL80211_IFTYPE_STATION) {
>>   			/* see ieee80211_delayed_tailroom_dec */
>>   			sdata->crypto_tx_tailroom_pending_dec++;
>>   			schedule_delayed_work(&sdata->dec_tailroom_needed_wk,
> I think you'd better change the caller, i.e. ieee80211_del_key(), and a
> add a comment there that explains what's going on.

Not really sure what you were trying to tell here.

Manikanta
