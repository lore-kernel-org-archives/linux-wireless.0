Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34949 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKXKxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 05:53:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: re-config ht_caps when chainmask is modified.
References: <1411576506-11815-1-git-send-email-greearb@candelatech.com>
	<1411576506-11815-2-git-send-email-greearb@candelatech.com>
	<87ioi47vvd.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 24 Nov 2014 12:53:04 +0200
In-Reply-To: <87ioi47vvd.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 24 Nov 2014 12:09:42 +0200")
Message-ID: <87egss7tv3.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_115314_733881_BD836E6F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> @@ -2537,6 +2560,17 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
>>  	ar->cfg_tx_chainmask = tx_ant;
>>  	ar->cfg_rx_chainmask = rx_ant;
>>  
>> +	ht_cap = ath10k_get_ht_cap(ar, true);
>> +	vht_cap = ath10k_create_vht_cap(ar, true);
>> +
>> +	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY)
>> +		ar->mac.sbands[IEEE80211_BAND_2GHZ].ht_cap = ht_cap;
>> +
>> +	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
>> +		ar->mac.sbands[IEEE80211_BAND_5GHZ].ht_cap = ht_cap;
>> +		ar->mac.sbands[IEEE80211_BAND_5GHZ].vht_cap = vht_cap;
>> +	}
>
> So this modifies stryct wiphy::bands after we have called
> ieee80211_register_hw(). Is this something which both cfg80211 and
> mac80211 support? I didn't find the documentation mentioning anything
> about this so I got a bit worried.

Johannes mentioned me that this is not supported so I am reluctant to
take these. Unless I'm missing something, of course.

-- 
Kalle Valo
