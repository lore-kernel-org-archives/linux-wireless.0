Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54969 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbYJVSj4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:39:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 11:39:56 -0700
Date: Wed, 22 Oct 2008 04:39:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: remove struct regdom hinting
Message-ID: <20081022113950.GE6190@tesla> (sfid-20081022_204009_835871_27674866)
References: <1224585042.5521.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224585042.5521.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 03:30:42AM -0700, Johannes Berg wrote:
> --- everything.orig/net/wireless/reg.h  2008-10-21 11:16:54.000000000 +0200
> +++ everything/net/wireless/reg.h       2008-10-21 11:43:18.000000000 +0200
> @@ -11,30 +11,21 @@ int set_regdom(const struct ieee80211_re
> 
>  /**
>   * __regulatory_hint - hint to the wireless core a regulatory domain
> - * @wiphy: if a driver is providing the hint this is the driver's very
> - *     own &struct wiphy
> + * @wiphy: if the hint comes from country information from an AP, this
> + *     is required to be set to the wiphy that received the information
>   * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
> - *     should be in. If @rd is set this should be NULL
> - * @rd: a complete regulatory domain, if passed the caller need not worry
> - *     about freeing it
> + *     should be in. If @rd is set this should be NULL
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

That can be removed from kdoc as @rd is gone now. Also can you
please update Documentation/networking/regulatory.txt to reflect the
new changes for mortals?

  Luis
