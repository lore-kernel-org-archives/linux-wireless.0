Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22072 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBENmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 08:42:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] mac80211: move VHT related RX_FLAG to another variable
References: <1391597333-6398-1-git-send-email-emmanuel.grumbach@intel.com>
	<1391597333-6398-2-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 5 Feb 2014 15:41:57 +0200
In-Reply-To: <1391597333-6398-2-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Wed, 5 Feb 2014 12:48:52 +0200")
Message-ID: <8738jxllqy.fsf@kamboji.qca.qualcomm.com> (sfid-20140205_144217_324036_50EDEA61)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> ieee80211_rx_status.flags is full. Define a new vht_flag
> variable to be able to set more VHT related flags and make
> room in flags.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[...]

> @@ -866,9 +863,6 @@ enum mac80211_rx_flags {
>  	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
>  	RX_FLAG_MACTIME_END		= BIT(21),
>  	RX_FLAG_VHT			= BIT(22),
> -	RX_FLAG_80MHZ			= BIT(23),
> -	RX_FLAG_80P80MHZ		= BIT(24),
> -	RX_FLAG_160MHZ			= BIT(25),

Doesn't this break ath10k?

-- 
Kalle Valo
