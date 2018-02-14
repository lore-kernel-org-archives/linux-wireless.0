Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:52751 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754556AbeBNISq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 03:18:46 -0500
Date: Wed, 14 Feb 2018 09:18:43 +0100
In-Reply-To: <40f644f6-ecfa-c31b-ce98-3491c954d6b1@qti.qualcomm.com>
References: <20180202151105.30043-1-toke@toke.dk> <40f644f6-ecfa-c31b-ce98-3491c954d6b1@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH] mac80211: Adjust TSQ pacing shift
To: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "make-wifi-fast@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <41B51538-B1F5-4611-AAB4-923C585FF3DA@toke.dk> (sfid-20180214_091850_869215_3AF22B8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14 February 2018 01:43:25 CET, Ryan Hsu <ryanhsu@qti=2Equalcomm=2Ecom> =
wrote:
>On 02/02/2018 07:11 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> Since we now have the convenient helper to do so, actually adjust the
>> TSQ pacing shift for packets going out over a WiFi interface=2E This
>> significantly improves throughput for locally-originated TCP
>> connections=2E The default pacing shift of 10 corresponds to ~1ms of
>> queued packet data=2E Adjusting this to a shift of 8 (i=2Ee=2E ~4ms)
>improves
>> 1-hop throughput for ath9k by a factor of 3, whereas increasing it
>more
>> has diminishing returns=2E
>>
>> Achieved throughput for different values of sk_pacing_shift (average
>of
>> 5 iterations of 10-sec netperf runs to a host on the other side of
>the
>> WiFi hop):
>>
>> sk_pacing_shift 10:  43=2E21 Mbps (pre-patch)
>> sk_pacing_shift  9:  78=2E17 Mbps
>> sk_pacing_shift  8: 123=2E94 Mbps
>> sk_pacing_shift  7: 128=2E31 Mbps
>>
>> Latency for competing flows increases from ~3 ms to ~10 ms with this
>> change=2E This is about the same magnitude of queueing latency induced
>by
>> flows that are not originated on the WiFi device itself (and so are
>not
>> limited by TSQ)=2E
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=2Edk>
>> ---
>>  net/mac80211/tx=2Ec | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/net/mac80211/tx=2Ec b/net/mac80211/tx=2Ec
>> index 25904af38839=2E=2E69722504e3e1 100644
>> --- a/net/mac80211/tx=2Ec
>> +++ b/net/mac80211/tx=2Ec
>> @@ -3574,6 +3574,14 @@ void __ieee80211_subif_start_xmit(struct
>sk_buff *skb,
>>  	if (!IS_ERR_OR_NULL(sta)) {
>>  		struct ieee80211_fast_tx *fast_tx;
>> =20
>> +		/* We need a bit of data queued to build aggregates properly, so
>> +		 * instruct the TCP stack to allow more than a single ms of data
>> +		 * to be queued in the stack=2E The value is a bit-shift of 1
>> +		 * second, so 8 is ~4ms of queued data=2E Only affects local TCP
>> +		 * sockets=2E
>> +		 */
>> +		sk_pacing_shift_update(skb->sk, 8);
>> +
>>  		fast_tx =3D rcu_dereference(sta->fast_tx);
>> =20
>>  		if (fast_tx &&
>
>I knew increasing the value doesn't help much after 8 for ath9k, but I
>ran a
>testing on ath10k that 6 or 7 is having optimal number=2E
>Since ath10k/11ac device has higher bandwidth than ath9k/11n, can we
>consider
>to use to 6 or 7 to accommodate that effect?
>
>   tx (mbps) cpu usage (%)
>5    404       28=2E5
>6    398       13=2E8
>7    401        8
>8    378        5
>9    230        4=2E5
>10   79=2E6       2

Why does the CPU usage go up >7? Also, what is the latency impact of each =
of those values?

-Toke
