Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45991 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0IUSGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 14:06:08 -0400
Message-ID: <4C98F409.9030905@openwrt.org>
Date: Tue, 21 Sep 2010 20:06:01 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org> <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org> <4C98EAA1.7050908@candelatech.com> <4C98F2D8.8020602@openwrt.org> <4C98F3AB.20206@candelatech.com>
In-Reply-To: <4C98F3AB.20206@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-21 8:04 PM, Ben Greear wrote:
> On 09/21/2010 11:00 AM, Felix Fietkau wrote:
>> On 2010-09-21 7:25 PM, Ben Greear wrote:
>>> On 09/21/2010 05:19 AM, Felix Fietkau wrote:
>>>> On 2010-09-21 2:08 PM, Ben Greear wrote:
>>>
>>>>> If you have any more details on this, please let me know.  I'm going to
>>>>> attempt to fix it...I certainly have a good test case :)
>>>> ath_tx_complete_aggr completes an A-MPDU frame, which typically triggers
>>>> the release of the next A-MPDU to the hw queue.
>>>> To keep track of the Block ACK window, it needs to look up the TID, for
>>>> which it needs a STA pointer. At that level, the driver typically
>>>> doesn't have access to the vif.
>>>>
>>>> It might be possible to fix this by adding another sta lookup helper
>>>> function in mac80211 that takes another address argument for the BSSID,
>>>> so that it can get the sta entry for the correct vif. I don't know if
>>>> Johannes wants something like that though.
>>>
>>> Could we just poke a pointer to the STA into the ath_buf structure?
>> No, that doesn't work because of RCU.
> 
> Would it also be bad to use skb->dev to find an STA?
It would be bad to keep a STA pointer around anywhere in the skb or the
ath_buf. You can only use it within a rcu_read_lock()/rcu_read_unlock()
pair.

- Felix
