Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59039 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaB1Soa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 13:44:30 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21264.55526.187330.480735@gargle.gargle.HOWL> (sfid-20140228_194433_978245_2927B9DF)
Date: Sat, 1 Mar 2014 00:13:50 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 1/2] ath9k_hw: toggle weak signal detection in AP mode on older chipsets
In-Reply-To: <1393610545-68025-1-git-send-email-nbd@openwrt.org>
References: <1393610545-68025-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> -	if (ah->opmode != NL80211_IFTYPE_AP &&
> -	    aniState->ofdmWeakSigDetect != weak_sig) {
> -		ath9k_hw_ani_control(ah,
> -				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
> -				     entry_ofdm->ofdm_weak_signal_on);
> -	}
> +	else if (AR_SREV_9300_20_OR_LATER(ah) &&
> +		 ah->opmode != NL80211_IFTYPE_STATION)
> +		weak_sig = true;
> +
> +	if (aniState->ofdmWeakSigDetect != weak_sig)
> +		ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
> +				     weak_sig);

Any reason why this has been changed to disregard the WS-DET parameter from
ofdm_level_table[] ?

Sujith
