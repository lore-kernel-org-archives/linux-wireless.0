Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:40562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbeDDPsb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 11:48:31 -0400
Date: Wed, 04 Apr 2018 11:48:29 -0400 (EDT)
Message-Id: <20180404.114829.1490990729428858199.davem@davemloft.net> (sfid-20180404_174854_068380_E3A7EB88)
To: standby24x7@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix bad line warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180404115333.1563-1-standby24x7@gmail.com>
References: <20180404115333.1563-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masanari Iida <standby24x7@gmail.com>
Date: Wed,  4 Apr 2018 20:53:33 +0900

> After 03fe2debbb2771fb90881e merged during 4.17 marge window,
> I start to see following warning during "make xmldocs"
> 
> ./include/net/mac80211.h:2083: warning: bad line:  >
> 
> Replace ">" with "*" fix the issue.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Adding linux-wireless to CC:

> ---
>  include/net/mac80211.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d2279b2d61aa..b2f3a0c018e7 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2080,7 +2080,7 @@ struct ieee80211_txq {
>   *	virtual interface might not be given air time for the transmission of
>   *	the frame, as it is not synced with the AP/P2P GO yet, and thus the
>   *	deauthentication frame might not be transmitted.
> - >
> + *
>   * @IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP: The driver (or firmware) doesn't
>   *	support QoS NDP for AP probing - that's most likely a driver bug.
>   *
> -- 
> 2.17.0.rc2.3.gc2a499e6c31e
> 
