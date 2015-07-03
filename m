Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51318 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbbGCIDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 04:03:08 -0400
Message-ID: <1435910577.2059.17.camel@sipsolutions.net> (sfid-20150703_100315_367435_CB26A890)
Subject: Re: [PATCH] ath9k: export HW random number generator
From: Johannes Berg <johannes@sipsolutions.net>
To: miaoqing@qti.qualcomm.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com
Date: Fri, 03 Jul 2015 10:02:57 +0200
In-Reply-To: <1435908567-28903-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150703_092941_801781_7DEE1A07)
References: <1435908567-28903-1-git-send-email-miaoqing@qca.qualcomm.com>
	 (sfid-20150703_092941_801781_7DEE1A07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-03 at 15:29 +0800, miaoqing@qti.qualcomm.com wrote:
> 
> +config ATH9K_HWRNG
> +	bool "Random number generator support"
> +	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
> +	default n

you don't need to state 'default n'

> +void ath9k_rng_unregister(struct ath_softc *sc);
> +int ath9k_rng_register(struct ath_softc *sc);
> 
unregister before register? not that it matters though.

you're not using the return value, why bother having it?

johannes
