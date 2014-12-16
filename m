Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33350 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaLPTy2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 14:54:28 -0500
Message-ID: <1418759663.1943.7.camel@sipsolutions.net> (sfid-20141216_205431_720719_DD3E2DBE)
Subject: Re: [PATCH] mac80211: notify NSS changed when IBSS and HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Tue, 16 Dec 2014 20:54:23 +0100
In-Reply-To: <1418720165-19810-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141216_095709_865462_C6672725)
References: <1418720165-19810-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20141216_095709_865462_C6672725)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-16 at 09:56 +0100, Janusz Dziedzic wrote:

>  			drv_sta_rc_update(local, sdata, &sta->sta,
>  					  IEEE80211_RC_SUPP_RATES_CHANGED);
> +			/* Force rx_nss recalculation */
> +			sta->sta.rx_nss = 0;
>  			rate_control_rate_init(sta);
> +			if (rx_nss != sta->sta.rx_nss)
> +				drv_sta_rc_update(local, sdata, &sta->sta,
> +						  IEEE80211_RC_NSS_CHANGED);

Seems to me you should consolidate those two drv_sta_rc_update() calls
and just make the flags dependent on the NSS change?

johannes

