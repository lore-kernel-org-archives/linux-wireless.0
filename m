Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60763 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbeICOd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 10:33:28 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v2] ath10k: report tx rate using ieee80211_tx_status()
In-Reply-To: <ebb12dc92de318b8d88eb607d9182ead@codeaurora.org>
References: <1524291786-30850-1-git-send-email-akolli@codeaurora.org> <87k1o6d8hw.fsf@kamboji.qca.qualcomm.com> <87zhx21uqc.fsf@toke.dk> <ebb12dc92de318b8d88eb607d9182ead@codeaurora.org>
Date: Mon, 03 Sep 2018 12:13:57 +0200
Message-ID: <87r2ia28ii.fsf@toke.dk> (sfid-20180903_121404_412879_236A9BE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> On 2018-08-31 19:52, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>=20
>>> Anilkumar Kolli <akolli@codeaurora.org> writes:
>>>=20
>>>> Mesh path metric needs txrate information from ieee80211_tx_status()
>>>> call but in ath10k there is no mechanism to report tx rate=20
>>>> information
>>>> via ieee80211_tx_status(), the rate is only accessible via
>>>> sta_statiscs() op.
>>>>=20
>>>> Per peer stats has tx rate info available, this patch stores per peer
>>>> last tx rate and updates the tx rate info structures in tx=20
>>>> completition.
>>>> The rate updated in ieee80211_tx_status() is not exactly for the last
>>>> transmitted frame instead the rate is from one of the previous=20
>>>> frames.
>>>>=20
>>>> Per peer txrate information is updated through per peer statistics
>>>> and is available for QCA9888/QCA9984/QCA4019/QCA998X only
>>>>=20
>>>> Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
>>>> Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036
>>>>=20
>>>> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
>>>=20
>>> This is a patch from last March, full patch here:
>>>=20
>>> https://patchwork.kernel.org/patch/10267693/
>>>=20
>>>> @@ -119,6 +122,18 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
>>>>  			info->flags &=3D ~IEEE80211_TX_STAT_ACK;
>>>>  	}
>>>>=20
>>>> +	if (sta) {
>>>> +		spin_lock_bh(&ar->data_lock);
>>>> +		arsta =3D (struct ath10k_sta *)sta->drv_priv;
>>>> +		info->status.rates[0].idx =3D
>>>> +			arsta->tx_info.status.rates[0].idx;
>>>> +		info->status.rates[0].count =3D
>>>> +			arsta->tx_info.status.rates[0].count;
>>>> +		info->status.rates[0].flags =3D
>>> <> +			arsta->tx_info.status.rates[0].flags;
>>>> +		spin_unlock_bh(&ar->data_lock);
>>>> +	}
>>>> +
>>>>  	ieee80211_tx_status(htt->ar->hw, msdu);
>>>>  	/* we do not own the msdu anymore */
>>>=20
>>> "is not exactly" is IMHO an understatement. What it means that with=20
>>> this
>>> patch ath10k reports the rate information from another frame instead=20
>>> of
>>> the current skb, because the firmware provides the rate information=20
>>> "out
>>> of band". A simple example to clarify:
>>>=20
>>>    Let's say ath10k transmits frames A, B and C. Then ath10k calls
>>>    ieee80211_tx_status() for frame C the rate information could be for
>>>    frame A, or it could be the other around for frame A status the=20
>>> rate
>>>    information is from frame C.
>>>=20
>>> In other words, there's no guarantee from what frame the rate
>>> information is from.
>>>=20
>>> Too me this feels like a bad idea but I'm not familiar enough with
>>> mac80211 to really comment on this. What kind of implications does=20
>>> this
>>> have for Mesh or ATF, for example? Adding Johannes and Toke to hear
>>> about their opinion about this.
>>=20
>> I was under the impression that the values gathered (at least for
>> airtime) would be cumulative values? If it's just the airtime of a
>> single random frame, which is what I understand from your example, it's
>> not going to be terribly useful to provide ATF at least...
>>=20
>> -Toke
>
> The design:
> Whenever radio transmits packet, firmware will record numbers of bytes=20
> sent, MSDU=E2=80=99s sent, TX duration, AMPDU information, ACK fail, BA f=
ail,=20
> Rate at which packet is sent. This is recorded for 4 frames sent on that=
=20
> peer. Once 4 frames are sent for that peer, TX packet event is sent to=20
> ath10k driver with the recorded values. These rate values are updated to=
=20
> mac80211 using ieee80211_tx_status().

So the values reported are the sums for all four packets? But the latest
value for rate information?

-Toke
