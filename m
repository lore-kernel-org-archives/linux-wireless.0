Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50136 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934021AbeAXQLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 11:11:48 -0500
Subject: Re: [PATCH 8/8] mt76: validate rx CCMP PN
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
References: <20180124151917.70962-1-nbd@nbd.name>
 <20180124151917.70962-8-nbd@nbd.name>
 <1516809416.2508.44.camel@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <7a022b57-af4a-78ee-aa8f-d0cd9eb17685@nbd.name> (sfid-20180124_171152_622366_5064171B)
Date: Wed, 24 Jan 2018 17:11:45 +0100
MIME-Version: 1.0
In-Reply-To: <1516809416.2508.44.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-24 16:56, Johannes Berg wrote:
> On Wed, 2018-01-24 at 16:19 +0100, Felix Fietkau wrote:
>> Apparently hardware does not perform CCMP PN validation in hardware, so
>> we need to take care of this in the driver. This is important for
>> protecting against replay attacks
>> 
>> +static int
>> +mt76_check_ccmp_pn(struct sk_buff *skb)
>> +{
>> +	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
>> +	struct mt76_wcid *wcid = status->wcid;
>> +	int ret;
>> +
>> +	if (!(status->flag & RX_FLAG_DECRYPTED))
>> +		return 0;
>> +
>> +	if (!wcid || !wcid->rx_check_pn)
>> +		return 0;
>> +
>> +	BUILD_BUG_ON(sizeof(status->iv) != sizeof(wcid->rx_key_pn[0]));
>> +	ret = memcmp(status->iv, wcid->rx_key_pn[status->tid],
>> +		     sizeof(status->iv));
>> +	if (ret <= 0)
>> +		return -EINVAL; /* replay */
>> +
>> +	memcpy(wcid->rx_key_pn[status->tid], status->iv, sizeof(status->iv));
>> +	status->flag |= RX_FLAG_PN_VALIDATED;
> 
> You shouldn't do this, try to somehow make it rely on mac80211 instead.
> 
> Otherwise, you really have to handle CCMP vs. fragmentation.
I guess I will have to look into fragmentation. I have a second driver
pending that only reports the CCMP PN outside of the packet, and for
performance reasons I really don't want to translate it and move it to a
place where mac80211 can parse it.
I'm also looking into doing parallel rx in software to see if I can get
more performance that way. I think for that I would also need CCMP PN
validation in the driver.

- Felix
