Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56123 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2FLN5W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 09:57:22 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: handle auth failure returned with unmatching auth algo
References: <1339497630-31589-1-git-send-email-eyal@wizery.com>
Date: Tue, 12 Jun 2012 16:57:21 +0300
In-Reply-To: <1339497630-31589-1-git-send-email-eyal@wizery.com> (Eyal
	Shapira's message of "Tue, 12 Jun 2012 13:40:30 +0300")
Message-ID: <87ipew63b2.fsf@purkki.adurom.net> (sfid-20120612_155729_864707_2675C24F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Shapira <eyal@wizery.com> writes:

> Some Netgear APs like WNAP210 have a quirk behavior when
> configured for WEP Shared. They send an auth response with algo
> SHARED and status code NOT_SUPPORTED_AUTH_ALG (13) when being
> sent a request made with auth algo OPEN. Enable such response to
> propagate to userspace instead of discarding it so wpa_s can
> reattempt to auth with SHARED.
>
> Reported-by: Noam Shaked <noams@ti.com>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>

[...]

> -	if (auth_alg != ifmgd->auth_data->algorithm ||
> +	if ((auth_alg != ifmgd->auth_data->algorithm &&
> +	     status_code != WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) ||

I think a small comment in the code would be nice, like
"WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG is a workaround for Netgear
WNAPxxx".

-- 
Kalle Valo
