Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:38124 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758041AbcCCPLj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:11:39 -0500
Subject: Re: [PATCH v2 1/2] mac80211: add A-MSDU tx support
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
 <1457016860.2044.11.camel@sipsolutions.net>
Cc: egrumbach@gmail.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56D85428.6090705@openwrt.org> (sfid-20160303_161142_673562_17D02421)
Date: Thu, 3 Mar 2016 16:11:36 +0100
MIME-Version: 1.0
In-Reply-To: <1457016860.2044.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-03 15:54, Johannes Berg wrote:
> On Wed, 2016-02-24 at 10:28 +0100, Felix Fietkau wrote:
>> 
>> +	/*
>> +	 * HT A-MPDU limits maximum MPDU size to 4095 bytes. Since aggregation
>> +	 * sessions are started/stopped without txq flush, use the limit here
>> +	 * to avoid having to de-aggregate later.
>> +	 */
>> +	if (skb->len + head->len > 4095 &&
>> +	    !sta->sta.vht_cap.vht_supported)
>> +		goto out;
> 
> I'm not entirely happy with this. You're silently assuming that when
> VHT is supported, HT MCSes will never be used.
> 
> This is (I think) true for minstrel_ht, but at the very least you
> should also document it along with the max_rc_amsdu_len then, which btw
> I was going to reword to:
> 
> + * @IEEE80211_HW_TX_AMSDU: Hardware (or driver) supports software aggregated
> + *     A-MSDU frames. Requires software tx queueing and fast-xmit support.
> + *     When not using minstrel/minstrel_ht rate control, the driver needs to
> + *     limit the maximum A-MSDU size based on the current tx rate by setting
> + *     max_rc_amsdu_len in struct ieee80211_sta to avoid mac80211 building
> + *     A-MSDUs that require too much airtime (are too long for a TXOP.)
> 
> 
> All that said, I'm not sure how much value there really is in
> aggregating that much? I'd think the value of A-MSDU really is more for
> lots of small frames like TCP ACKs, since the PER goes up exponentially
> with the BER for A-MSDU (unlike A-MPDU.)
For my own uses, I'd be perfectly fine with limiting A-MSDU size to HT
limits even when using VHT - in fact I did that in an early RFC patch. I
mainly relaxed the limit for VHT based on Emmanuel's feedback.
I also have doubts about the value of A-MSDU size beyond 4095 bytes.

Just let me know which way you'd like it, and I'll send v3 accordingly.

- Felix
