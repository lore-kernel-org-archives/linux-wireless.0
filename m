Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:34175 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab2CJNlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 08:41:53 -0500
Message-ID: <4F5B5A15.1000808@neratec.com> (sfid-20120310_144226_095817_C60D2D9C)
Date: Sat, 10 Mar 2012 14:41:41 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ashok Nagarajan <ashok@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: [PATCH] ath9k: Fix mactime from being clobbered in rx_status
References: <1331340008-1713-1-git-send-email-ashok@cozybit.com> <201203100206.46537.chunkeey@googlemail.com>
In-Reply-To: <201203100206.46537.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the ping.

The patch that is reverted here was meant as pre-work for modifications 
required to generate DFS events with correctly set mactime that are 
still pending. It was obviously not as 'trivial' as claimed, since I 
overlooked the memset() in ath9k_rx_skb_preprocess() that effectively 
set the time to 0 for all fragments.

Therefore full ACK to revert it. Just wondering why it was not noticed 
for nearly 4 months now.

On 10.03.2012 02:06, Christian Lamparter wrote:
> On Saturday 10 March 2012 01:40:08 Ashok Nagarajan wrote:
>> mactime was being overwritten by the function
>> ath9k_rx_skb_preprocess.  Fixed by calling the
>> function before setting the mactime.
>
> This looks rather odd... In essence you're trying to revert
> "ath9k: trivial: reorder rx_tasklet processing"
>
> Anyway, I 'CC'ed the original author Zefir Kurtisi. So if
> there are any open question, now is the time.
>
>> Signed-off-by: Ashok Nagarajan<ashok@cozybit.com>
>> Signed-off-by: Javier Cardona<javier@cozybit.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/recv.c |    5 +++--
>>   1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index 1b1b279..52a0466 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -1841,6 +1841,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>   		if (sc->sc_flags&  SC_OP_RXFLUSH)
>>   			goto requeue_drop_frag;
>>
>> +		retval = ath9k_rx_skb_preprocess(common, hw, hdr,&rs,
>> +						 rxs,&decrypt_error);
>> +
>
> Instead of moving ath9k_rx_skb_preprocess around, you could just
> put the memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
> right here.
>
> [Also, why leave the if (retval) check behind?]
>
>>   		rxs->mactime = (tsf&  ~0xffffffffULL) | rs.rs_tstamp;
>>   		if (rs.rs_tstamp>  tsf_lower&&
>>   		unlikely(rs.rs_tstamp - tsf_lower>  0x10000000))
>> @@ -1850,8 +1853,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>   		    unlikely(tsf_lower - rs.rs_tstamp>  0x10000000))
>>   			rxs->mactime += 0x100000000ULL;
>>
>> -		retval = ath9k_rx_skb_preprocess(common, hw, hdr,&rs,
>> -						 rxs,&decrypt_error);
>>   		if (retval)
>>   			goto requeue_drop_frag;
> 		^^ that one

