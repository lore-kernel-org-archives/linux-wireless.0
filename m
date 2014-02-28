Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58954 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaB1Uwh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 15:52:37 -0500
Message-ID: <5310F70E.5030501@openwrt.org> (sfid-20140228_215242_020938_5E16B4BB)
Date: Fri, 28 Feb 2014 21:52:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 1/2] ath9k_hw: toggle weak signal detection in AP mode
 on older chipsets
References: <1393610545-68025-1-git-send-email-nbd@openwrt.org> <21264.55526.187330.480735@gargle.gargle.HOWL>
In-Reply-To: <21264.55526.187330.480735@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-28 19:43, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> -	if (ah->opmode != NL80211_IFTYPE_AP &&
>> -	    aniState->ofdmWeakSigDetect != weak_sig) {
>> -		ath9k_hw_ani_control(ah,
>> -				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
>> -				     entry_ofdm->ofdm_weak_signal_on);
>> -	}
>> +	else if (AR_SREV_9300_20_OR_LATER(ah) &&
>> +		 ah->opmode != NL80211_IFTYPE_STATION)
>> +		weak_sig = true;
>> +
>> +	if (aniState->ofdmWeakSigDetect != weak_sig)
>> +		ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
>> +				     weak_sig);
> 
> Any reason why this has been changed to disregard the WS-DET parameter from
> ofdm_level_table[] ?
It doesn't disregard it - weak_sig is initialized to the value of that
parameter. Comparing aniState->ofdmWeakSigDetect against weak_sig, but
then passing entry_ofdm->ofdm_weak_signal_on is buggy.

- Felix
