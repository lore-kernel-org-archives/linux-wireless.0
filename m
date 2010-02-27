Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 31.mail-out.ovh.net ([213.186.62.10]:33070 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030853Ab0B0VFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 16:05:13 -0500
Message-ID: <4B898773.1060202@free.fr>
Date: Sat, 27 Feb 2010 21:58:27 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: Fix TX/RX padding for all frames
References: <1267275518-24240-1-git-send-email-benoit.papillault@free.fr> <20100227171259.GA14892@hash.localnet>
In-Reply-To: <20100227171259.GA14892@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland a écrit :
> On Sat, Feb 27, 2010 at 01:58:38PM +0100, Benoit Papillault wrote:
>   
>> Currently, the padding position is based on
>> ieee80211_get_hdrlen_from_skb(). This is not correct since the HW does
>> padding on RX (and expect the same padding to be present on TX) at the
>> following position :
>>
>> - management : 24 + 6 if 4-addr format
>> - control    : 24 + 6 if 4-addr format
>> - data       : 24 + 6 if 4-addr format + 2 if QoS
>> - invalid    : 24 + 6 if 4-addr format
>>
>> whereas ieee80211_get_hdrlen_from_skb() is :
>>
>> - management : 24
>> - control    : 16 except for ACK/CTS where it is 10
>> - data       : 24 + 6 if 4-addr format + 2 if QoS + 2 if QoS & order
>> - invalid    : 24
>>
>>     
>
> I still don't get it - if ieee80211_get_header_len_from_skb() returns
> the wrong thing for 4-addr frames, wouldn't it be better to fix that?
>   
No. Both functions serve different purpose :
- ieee80211_get_hdrlen_from_skb() is the header length as defined by the 
IEEE 802.11 specification and AFAIK is correct.
- the padding position is what the HW expects, as determined by my own 
tests.
> The whole problem is the hardware wants the payload 4-byte aligned
> for the crypto hardware.
>
> Anyway, I think the implementation could be simpler.
>
>   
>> +static int ath5k_cmn_padpos(struct sk_buff *skb)
>>     
>
> This needs a better name (common? compute?) 
>   
let's say : ath5k_common_padpos ? I just mimic the name used in ath9k.
>
>   
>> -		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
>> -		padsize = ath5k_pad_size(hdrlen);
>> -		if (padsize) {
>> -			memmove(skb->data + padsize, skb->data, hdrlen);
>> +		padpos = ath5k_cmn_padpos(skb);
>> +		padsize = padpos & 3;
>> +		if (padsize && skb->len>=padpos+padsize) {
>> +			memmove(skb->data + padsize, skb->data, padpos);
>>     
>
> Better would be putting this all in a function and then:
>
>                 ath5k_remove_padding(skb);
>   
OK.
>   
>> +		/*
>> +		 * Remove MAC header padding before giving the frame
>> +		 * back to mac80211.
>> +		 */
>>     
>
> You get to use the new function you just created here...
>
>   
>> @@ -2680,8 +2711,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
>>  	struct ath5k_softc *sc = hw->priv;
>>  	struct ath5k_buf *bf;
>>  	unsigned long flags;
>> -	int hdrlen;
>> -	int padsize;
>> +	int padpos, padsize;
>>     
>
>   
>>  		if (skb_headroom(skb) < padsize) {
>>  			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
>> -				  " headroom to pad %d\n", hdrlen, padsize);
>> +				  " headroom to pad %d\n", padpos, padsize);
>>  			goto drop_packet;
>>  		}
>>  		skb_push(skb, padsize);
>> -		memmove(skb->data, skb->data+padsize, hdrlen);
>> +		memmove(skb->data, skb->data+padsize, padpos);
>> +	} else {
>> +		padsize = 0;
>>  	}
>>     
>
> ath5k_add_padding()
>   
OK.
>
>   
>> @@ -71,7 +72,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
>>  	/* Verify and set frame length */
>>  
>>  	/* remove padding we might have added before */
>> -	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;
>> +	frame_len = pkt_len - padsize + FCS_LEN;
>>     
>
> Hrm... I think I added this originally, and I think it is wrong.  I have some
> old docs which say padding doesn't count in txdesc.  That simplifies things.
>
>
>   
So, you are saying it should be : frame_len = pkt_len + FCS_LEN only?
I can test on AR5212, but IIRC, this was affecting the FCS computed by 
the HW (ie the frame content received on the other side is fined, except 
the FCS is wrong since it is computed using the more bytes than expected).

Regards,
Benoit
