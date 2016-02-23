Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38588 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbcBWMMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 07:12:54 -0500
Subject: Re: [PATCH 1/2] mac80211: add A-MSDU tx support
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1455820762-22876-1-git-send-email-nbd@openwrt.org>
 <1456226757.2041.35.camel@sipsolutions.net>
Cc: egrumbach@gmail.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56CC4CAC.4080501@openwrt.org> (sfid-20160223_131259_714666_C88735D6)
Date: Tue, 23 Feb 2016 13:12:28 +0100
MIME-Version: 1.0
In-Reply-To: <1456226757.2041.35.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-23 12:25, Johannes Berg wrote:
> On Thu, 2016-02-18 at 19:39 +0100, Felix Fietkau wrote:
>> Requires software tx queueing support. frag_list support (for zero-
>> copy) is optional.
> 
> "optional" ;-)
> 
>> @@ -1751,6 +1754,7 @@ struct ieee80211_sta {
>>  	bool mfp;
>>  	u8 max_amsdu_subframes;
>>  	u16 max_amsdu_len;
>> +	u16 max_rc_amsdu_len;
> 
> I may have missed this, but I didn't see you initialize this to
> something. I think that's probably a bad idea, since you've now created
> a situation in which a driver wanting to use txq support needs to also
> use minstrel or update this field...
It's initialized to 0 by default, in which case it does not limit the
A-MSDU size. The driver does not need to set it, but it really should.

> Apart from that, I'm not sure that having a field here that works like
> this is a good idea at all - all the other fields in the vicinity kinda
> go from mac80211 to the driver, where here you have something that
> potentially goes from the driver to mac80211. Perhaps we can find a
> better way of doing this?
Didn't find a better place to put it. Got any ideas?

>> + * @IEEE80211_HW_TX_AMSDU: Hardware (or driver) supports software
>> aggregated
>> + *	A-MSDU frames. Requires software tx queueing support.
> 
> Or at least document that it also requires integration with the
> max_rc_amsdu_len thing.
Will do.

>> + * @max_tx_fragments: maximum fragments per (A-)MSDU.
> 
> "fragments" is a bit unclear - I guess this should refer to fraglist
> length only? Or is it meant to apply as a limit to the sum of pieces in
> the fraglist? I think that should be clarified.
Sum of 1 (head) + n_frags for each skb in the fraglist.

>> +	txq = sta->sta.txq[tid];
>> +	if (!amsdu && txq)
>> +		set_bit(IEEE80211_TXQ_NO_AMSDU, &to_txq_info(txq)-
>> >flags);
> 
> Did you intentionally not clear this on aggregation stop?
Yes. If A-MSDU in A-MPDU is not supported, dealing with starting and
stopping of A-MPDU sessions leaves all kinds of nasty corner cases
(since the txq is not flushed between sessions). In that case it's
better to just leave it disabled from that point on.

>> +	if (skb_headroom(skb) < sizeof(amsdu_hdr) ||
>> skb_tailroom(skb) < 3) {
>> +		I802_DEBUG_INC(local->tx_expand_skb_head);
>> +
>> +		if (pskb_expand_head(skb, sizeof(amsdu_hdr), 3,
>> GFP_ATOMIC)) {
> 
> You should be able to precalculate the amount of padding needed based
> on the length of the skb, so why statically use 3 here?
I guess I forgot to change that after I got the code working.

>> +	if (skb_headroom(skb) < 8 || skb_tailroom(skb) < 3) {
>> +		I802_DEBUG_INC(local->tx_expand_skb_head);
>> +
>> +		if (pskb_expand_head(skb, 8, 3, GFP_ATOMIC)) {
> 
> similarly here? Where does the 8 come from?
rfc1042_header + A-MSDU length field.

>> @@ -2820,6 +2983,10 @@ static bool ieee80211_xmit_fast(struct
>> ieee80211_sub_if_data *sdata,
>>  
>>  	ieee80211_tx_stats(dev, skb->len + extra_head);
>>  
>> +	if ((hdr->frame_control &
>> cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) &&
>> +	    ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb))
>> +		return true;
> 
> Only on xmit_fast?
Yes. I'm relying on fast_tx fields to simplify dealing with headers and
to avoid adding extra checks for all kinds of stuff like no software
crypto, which ieee80211_check_fast_xmit already handles.

- Felix
