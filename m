Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42778 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0PDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:03:50 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ath10k: implement sta_rc_update()
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-3-git-send-email-michal.kazior@tieto.com>
Date: Wed, 27 Nov 2013 17:03:41 +0200
In-Reply-To: <1385474260-22385-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 26 Nov 2013 14:57:39 +0100")
Message-ID: <87li09ga42.fsf@kamboji.qca.qualcomm.com> (sfid-20131127_160354_072838_81C42933)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This should fix possible connectivity issues upon
> changes of channel width, number of streams or
> SMPS on connected stations.
>
> An example trigger would be an action frame with
> operation mode change notification.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Sorry, somehow missed these on my previous review:

> +	if (changed & IEEE80211_RC_BW_CHANGED) {
> +		switch (sta->bandwidth) {
> +		default:
> +			ath10k_warn("unsupported STA BW: %d\n", sta->bandwidth);
> +		case IEEE80211_STA_RX_BW_20:
> +			chwidth = WMI_PEER_CHWIDTH_20MHZ;
> +			break;
> +		case IEEE80211_STA_RX_BW_40:
> +			chwidth = WMI_PEER_CHWIDTH_40MHZ;
> +			break;
> +		case IEEE80211_STA_RX_BW_80:
> +			chwidth = WMI_PEER_CHWIDTH_80MHZ;
> +			break;
> +		}

I assume that the idea here is to use WMI_PEER_CHWIDTH_20MHZ for the
default case. Actually I would prefer to avoid using default case
altogether, that way the compiler will warn if there's an enum value we
don't check. So for example you could add "case IEEE80211_STA_RX_BW_160"
which prints a warning and uses 20 MHz.

> +	if (changed & IEEE80211_RC_SMPS_CHANGED) {
> +		smps = WMI_PEER_SMPS_PS_NONE;
> +
> +		switch (sta->smps_mode) {
> +		case IEEE80211_SMPS_NUM_MODES:
> +			ath10k_warn("invalid smps mode: %d\n", sta->smps_mode);
> +		case IEEE80211_SMPS_AUTOMATIC:
> +		case IEEE80211_SMPS_OFF:
> +			smps = WMI_PEER_SMPS_PS_NONE;
> +			break;
> +		case IEEE80211_SMPS_STATIC:
> +			smps = WMI_PEER_SMPS_STATIC;
> +			break;
> +		case IEEE80211_SMPS_DYNAMIC:
> +			smps = WMI_PEER_SMPS_DYNAMIC;
> +			break;
> +		}

This is better, but I think it would be clearer to have
IEEE80211_SMPS_NUM_MODES last and not "fall through" the cases.

-- 
Kalle Valo
