Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56095 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760407Ab3EXKcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 06:32:48 -0400
Received: from mailout-de.gmx.net ([10.1.76.29]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LqXNf-1U26hi1MLh-00e1PO for
 <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 12:32:47 +0200
Message-ID: <519F41CE.70004@rempel-privat.de> (sfid-20130524_123255_977703_0F69BA43)
Date: Fri, 24 May 2013 12:32:46 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: check for Rx-STBC flag and pass it to ieee80211
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>  <1369390711-992-1-git-send-email-linux@rempel-privat.de>  <1369390711-992-3-git-send-email-linux@rempel-privat.de>  (sfid-20130524_121845_309854_63769133) <1369391399.8290.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369391399.8290.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 24.05.2013 12:29, schrieb Johannes Berg:
> On Fri, 2013-05-24 at 12:18 +0200, Oleksij Rempel wrote:
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> ---
>>   drivers/net/wireless/ath/ath9k/init.c | 9 +++++++--
>>   drivers/net/wireless/ath/ath9k/mac.c  | 5 +++++
>>   drivers/net/wireless/ath/ath9k/mac.h  | 3 ++-
>>   3 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>> index aba4151..7739b05 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -769,8 +769,13 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>>   		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>>   		IEEE80211_HW_SUPPORTS_RC_TABLE;
>>
>> -	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
>> -		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
>> +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
>> +		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
>> +
>> +		if (AR_SREV_9280_20_OR_LATER(ah))
>> +			hw->radiotap_mcs_details |=
>> +				IEEE80211_RADIOTAP_MCS_HAVE_STBC;
>> +	}
>
> Are you sure this is right? It seems that if other devices don't support
> STBC they can report all frames to be w/o STBC. Or do they support STBC
> but don't report it?

They support STBC but don't report it. First device whhic can report it 
is ar9280.


-- 
Regards,
Oleksij
