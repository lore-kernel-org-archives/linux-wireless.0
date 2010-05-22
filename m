Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58409 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab0EVOGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 10:06:16 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] cfg80211: Fix user-space crda query stall
References: <1274438539-11259-1-git-send-email-juuso.oikarinen@nokia.com>
	<1274438539-11259-2-git-send-email-juuso.oikarinen@nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 22 May 2010 17:06:14 +0300
In-Reply-To: <1274438539-11259-2-git-send-email-juuso.oikarinen@nokia.com> (Juuso Oikarinen's message of "Fri\, 21 May 2010 13\:42\:19 +0300")
Message-ID: <87eih4hvzd.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moi Juuso,

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> The userspace crda utility can fail to respond to kernel requests in (at least)
> two scenarios: it is not runnable for any reason, or it is invoked with a
> country code not in its database.
>

[...]

> +	printk(KERN_INFO "cfg80211: Call crda daemon timed out for country: "
> +	       "%c%c\n", last_request->alpha2[0], last_request->alpha2[1]);

I would prefer to mention in the print that kernel will revert back to
world domain. Nicer for the users.

-- 
Kalle Valo
