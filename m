Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41400 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1HJVR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 17:17:58 -0400
Message-ID: <4E42F578.2050308@openwrt.org> (sfid-20110810_231801_309372_1327AB73)
Date: Wed, 10 Aug 2011 15:17:44 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] mac80211: make ieee80211_send_bar available for drivers
References: <1313005527-83182-1-git-send-email-nbd@openwrt.org> <1313006559.4016.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1313006559.4016.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-10 2:02 PM, Johannes Berg wrote:
> On Wed, 2011-08-10 at 13:45 -0600, Felix Fietkau wrote:
>>  To properly maintain the peer's block ack window, the driver needs to be
>>  able to control the new starting sequence number that is sent along with
>>  the BlockAckReq frame.
>
> I guess with the ath9k patch I understand ... I believe iwlwifi
> processes all of the TX status and only sets the BAR flag on the last
> one?
>
>>  +/**
>>  + * ieee80211_send_bar - send a BlockAckReq frame
>>  + *
>>  + * can be used to flush pending frames from the peer's aggregation reorder
>>  + * buffer.
>>  + *
>>  + * @vif:&struct ieee80211_vif pointer from the add_interface callback.
>>  + * @ra: the peer's destination address
>>  + * @tid: the TID of the aggregation session
>>  + * @ssn: the new starting sequence number for the receiver
>>  + */
>>  +void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
>
> You might want to note the locking rules, it's a little strange here
> since it calls right back into the driver's tx(). Though of course the
> same also happens with tx_status(), it might be less expected here,
> especially if you use tx_status_irqsafe() and this doesn't yet have an
> irqsafe version.
I think it's not that important, so if you want to avoid adding a new 
API, I can also make a simple ath9k patch that reduces the number of 
BARs sent.

- Felix

