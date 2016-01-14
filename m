Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42894 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbcANMr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 07:47:59 -0500
Subject: Re: [RFC/RFT v3] mac80211: Add NEED_ALIGNED4_SKBS hw flag
To: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1451999161-7286-1-git-send-email-janusz.dziedzic@tieto.com>
 <1452774738.2444.22.camel@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <569798F7.3050409@openwrt.org> (sfid-20160114_134804_629815_FC05FD60)
Date: Thu, 14 Jan 2016 13:47:51 +0100
MIME-Version: 1.0
In-Reply-To: <1452774738.2444.22.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-14 13:32, Johannes Berg wrote:
> On Tue, 2016-01-05 at 14:06 +0100, Janusz Dziedzic wrote:
>>  	struct net_device *prev_dev = NULL;
>> +	unsigned int padsize, hdrlen;
>>  	int rtap_len;
>>  
>> +	/* Remove padding if was added */
>> +	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS)) {
>> +		hdrlen = ieee80211_hdrlen(hdr->frame_control);
>> +		padsize = hdrlen & 3;
>> +
>> +		if (padsize && skb->len > hdrlen + padsize) {
>> +			memmove(skb->data + padsize, skb->data,
>> hdrlen);
>> +			skb_pull(skb, padsize);
>> +		}
>> +	}
> 
> But perhaps this should just be done by the driver?
I think it's better to do it here, because the driver can't know if a
frame will end up on a (cooked) monitor interface.

>> +	/* Check if aligned skb required */
>> +	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
>> +		build.hdr_len += build.hdr_len & 3;
> 
> Pretty sure you need to increase the reserved space in the fast-xmit
> struct?
Is the round_up he added not enough?

- Felix
