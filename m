Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49604 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0DPFSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 01:18:10 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv2 1/2] mac80211: Determine dynamic PS timeout based on ps-qos network latency
References: <1271228079-27321-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271228079-27321-2-git-send-email-juuso.oikarinen@nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 16 Apr 2010 08:17:57 +0300
In-Reply-To: <1271228079-27321-2-git-send-email-juuso.oikarinen@nokia.com> (Juuso Oikarinen's message of "Wed\, 14 Apr 2010 09\:54\:38 +0300")
Message-ID: <87eiigm0vu.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> Determine the dynamic PS timeout based on the configured ps-qos network
> latency. For backwards wext compatibility, allow the dynamic PS timeout
> configured by the cfg80211 to overrule the automatically determined value.

Thanks. I took a quick look, but I haven't tested this yet myself.

> +		timeout = local->hw.conf.dynamic_ps_forced_timeout;
> +		if (timeout < 0) {
> +			if (latency <= 50000)
> +				timeout = 300;
> +			else if (latency <= 2000000000)
> +				timeout = 100;
> +			else
> +				timeout = 0;
> +		}
> +		local->hw.conf.dynamic_ps_timeout = timeout;

What will be the timeout value when there are no pm_qos requirements
from user space applications? Do you know what will be the default
latency value in that case?

I'm mostly worried about timeout 0 case, for example I suspect ath9k
is broken with that value.

Also does this patch change the default value of dynamic ps timeout?

-- 
Kalle Valo
