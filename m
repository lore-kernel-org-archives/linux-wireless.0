Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46905 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1JYGQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 02:16:12 -0400
To: Guy Eilam <guy@wizery.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 25 Oct 2011 09:16:10 +0300
In-Reply-To: <1319313081-28722-1-git-send-email-guy@wizery.com> (Guy Eilam's message of "Sat\, 22 Oct 2011 21\:51\:21 +0200")
Message-ID: <87zkgpbnpx.fsf@purkki.adurom.net> (sfid-20111025_081620_210154_70CEACF9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Eilam <guy@wizery.com> writes:

> Notify the userspace of the probe response offloading
> support by the driver.

[...]

> +enum nl80211_probe_resp_offload_support_attr {
> +	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC =	1<<0,
> +	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC2 =	1<<1,
> +	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P =	1<<2,
> +};

Maybe BIT() macro (like below) would be better for consistency?

> @@ -1690,6 +1690,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_AP_UAPSD			= BIT(14),
>  	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
>  	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
> +	WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD	= BIT(17),
>  };

-- 
Kalle Valo
