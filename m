Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42692 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYKSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 05:18:42 -0500
Message-ID: <5474577D.5070002@openwrt.org> (sfid-20141125_111850_416822_DABD5749)
Date: Tue, 25 Nov 2014 11:18:37 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>, greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: re-config ht_caps when chainmask is modified.
References: <1411576506-11815-1-git-send-email-greearb@candelatech.com>	<1411576506-11815-2-git-send-email-greearb@candelatech.com>	<87ioi47vvd.fsf@kamboji.qca.qualcomm.com> <87egss7tv3.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87egss7tv3.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-24 11:53, Kalle Valo wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
> 
>>> @@ -2537,6 +2560,17 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
>>>  	ar->cfg_tx_chainmask = tx_ant;
>>>  	ar->cfg_rx_chainmask = rx_ant;
>>>  
>>> +	ht_cap = ath10k_get_ht_cap(ar, true);
>>> +	vht_cap = ath10k_create_vht_cap(ar, true);
>>> +
>>> +	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY)
>>> +		ar->mac.sbands[IEEE80211_BAND_2GHZ].ht_cap = ht_cap;
>>> +
>>> +	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
>>> +		ar->mac.sbands[IEEE80211_BAND_5GHZ].ht_cap = ht_cap;
>>> +		ar->mac.sbands[IEEE80211_BAND_5GHZ].vht_cap = vht_cap;
>>> +	}
>>
>> So this modifies stryct wiphy::bands after we have called
>> ieee80211_register_hw(). Is this something which both cfg80211 and
>> mac80211 support? I didn't find the documentation mentioning anything
>> about this so I got a bit worried.
> 
> Johannes mentioned me that this is not supported so I am reluctant to
> take these. Unless I'm missing something, of course.
FWIW, ath9k has been doing the same for a long time now. Antenna
settings can only be changed while the device is stopped, so it should
be safe.

- Felix
