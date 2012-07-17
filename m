Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2GQJwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 05:52:38 -0400
Message-ID: <1342518733.7427.16.camel@jlt3.sipsolutions.net> (sfid-20120717_115241_457952_F46F930D)
Subject: Re: [PATCH] cfg80211: fix set_regdom() to cancel requests with
 same alpha2
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
In-Reply-To: <20120712123358.22054.62538.stgit@localhost6.localdomain6> (sfid-20120712_143407_357227_CA39EE4B)
References: <20120712123358.22054.62538.stgit@localhost6.localdomain6>
	 (sfid-20120712_143407_357227_CA39EE4B)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jul 2012 11:52:13 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 15:33 +0300, Kalle Valo wrote:
> While adding regulatory support to ath6kl I noticed that I easily
> got the regulatory code confused. The way to reproduce the bug was:
> 
> 1. iw reg set FI (in userspace)
> 2. cfg80211 calls ath6kl_reg_notify(FI)
> 3. ath6kl sets regdomain in firmware
> 4. firmware sends regdomain event to notify about the new regdomain (FI)
> 5. ath6kl calls regulatory_hint(FI)
> 
> And this (from FI to FI transition) confuses cfg80211 and after that I
> only get "Pending regulatory request, waiting for it to be
> processed...." messages and regdomain changes won't work anymore.
> 
> The reason why ath6kl calls regulatory_hint() is that firmware can change
> the regulatory domain by it's own, for example due to 11d IEs. I could
> of course workaround this in ath6kl but I think it's better to handle
> the case in cfg80211.
> 
> The fix is pretty simple, use a different error code if the regdomain is
> same and then just set the request processed so that it doesn't block new
> requests.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Should this go to 3.5 and maybe be Cc: stable?

If so, John please pick it up, fwiw:

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Otherwise I'll pick it up after Kalle decides :)

johannes

