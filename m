Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53140 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab3EDL2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 07:28:17 -0400
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M8npK-1UiT4N3hhk-00C9ex for
 <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 13:28:15 +0200
Message-ID: <5184F0CC.3070208@rempel-privat.de> (sfid-20130504_132831_114543_2AC2F53A)
Date: Sat, 04 May 2013 13:28:12 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de> <5182A9DC.6030203@openwrt.org> <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com> <5184AFC2.8060101@rempel-privat.de> <5184DCCF.9010009@openwrt.org> <5184EC19.9060206@rempel-privat.de> <5184EE0B.1030605@openwrt.org>
In-Reply-To: <5184EE0B.1030605@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 04.05.2013 13:16, schrieb Felix Fietkau:
> On 2013-05-04 1:08 PM, Oleksij Rempel wrote:
>> Am 04.05.2013 12:02, schrieb Felix Fietkau:
>>> On 2013-05-04 8:50 AM, Oleksij Rempel wrote:
>>>> Am 02.05.2013 22:15, schrieb Adrian Chadd:
>>>>> Well, let's dig into the firmware a bit more and tidy up how STBC is handled.
>>>>
>>>> Does it mean, i should change this patch and provide a patch for
>>>> firmware too?
>>>> I still do not think, changing peer caps i a good idea in any case.
>>>> I mena this part of patch:
>>>> +               if (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC)
>>>> +                       caps |= WLAN_RC_TX_STBC_FLAG;
>>>>
>>>>
>>>> Behaviour with this patch will be fallowing:
>>>> - peer provide caps, even if it is RX-STBC12
>>>> - we pass this information to firmware and ratecontroller of FW, do
>>>> right decision based on hardware it has.
>>>>
>>>> You suggestion, if i understand it correctly, is to filter caps:
>>>> - if peer provide more than we can, we should tell firmware the value
>>>> what we can. So, if peer say it can RX-STBC12, we should tell firmware
>>>> that peer is RX-STBC1.
>>>> In my opinion, this kind of filter is a source for hidden errors.
>>> I think the discussion regarding RX-STBC12 vs RX-STBC1 is purely
>>> hypothetical. The hardware that this firmware was designed for only
>>> supports sending STBC for MCS0-7. This will not change.
>>>
>>> Also, there's no reason to tell the firmware about both rx and tx STBC
>>> capabilities, the only thing it needs to know is what tells the rate
>>> control part to enable/disable STBC.
>>
>> As you can see, in version 2 of this path there was no more discussion
>> about it. I just did it.
>>
>>> In addition to that, using the WLAN_RC_* flags is wrong, you need to use
>>> the ATH_RC_* flags, as this is what ath_rate_newassoc_11n checks for in
>>> the firmware.
>>
>> Renamed.
>>
>>> The only STBC related flag that actually gets used (when
>>> passed from the driver) is ATH_RC_RX_STBC_FLAG.
>>
>> Well, may be it is not used at the end. But it is present on some places
>> in the firmware.
>> For example here:
>> void
>> rcSibUpdate_11n(struct ath_softc_tgt *sc, struct ath_node_target *pSib,
>>                   A_UINT32 capflag, A_BOOL keepState, struct
>> ieee80211_rate  *pRateSet)
>> {
>>           rcSibUpdate_ht(sc,
>>                          pSib,
>>                          ((capflag & ATH_RC_DS_FLAG)   ? WLAN_RC_DS_FLAG
>>    : 0) |
>>                          ((capflag & ATH_RC_HT40_SGI_FLAG)  ?
>> WLAN_RC_HT40_SGI_FLAG : 0) |
>>                          ((capflag & ATH_RC_HT_FLAG)   ? WLAN_RC_HT_FLAG
>>    : 0) |
>>                          ((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG
>>    : 0) |
>>                          ((capflag & ATH_RC_TX_STBC_FLAG)   ?
>> WLAN_RC_STBC_FLAG  : 0),
>>                          keepState,
>>                          pRateSet);
>>
>>
>>
>> So, should i remove ATH_RC_TX_STBC_FLAG from my patch?
> I extensively reviewed this part, and it's really crazy. Here's what
> happens:
>
> ath_rate_newassoc_11n takes ATH_RC_* flags, converts them to WLAN_RC_*.
> rcSibUpdate_11n interprets the WLAN_RC_* flags as ATH_RC_* and converts
> them to WLAN_RC_* again. For most flags this is pretty much a no-op
> because the definitions are identical.
> For STBC the result 'accidentally' still contains WLAN_RC_STBC_FLAG, but
> only because ath_rate_newassoc_11n converts ATH_RC_RX_STBC_FLAG to
> WLAN_RC_STBC_FLAG and WLAN_RC_STBC_FLAG overlaps with ATH_RC_TX_STBC_FLAG.
> In the end it doesn't matter anymore, because nothing in the code takes
> the STBC info from the capflags.
>
> STBC is used if ATH_NODE_ATHEROS(an)->stbc is non-zero, and this gets
> set by ath_rate_newassoc_11n before all of those incredibly moronic
> conversions happen.

Ok, thx.

I'll remove it from my patch. And will remove it from firmware.
Even if you wont to remove bigger part of firmware, i thing it wont 
happen this year?


-- 
Regards,
Oleksij
