Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48212 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYKTBQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 20:16:12 -0500
Date: Wed, 19 Nov 2008 20:03:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: m68k: linux-next allmodconfig
Message-ID: <20081120010318.GA13464@tuxdriver.com> (sfid-20081120_021616_295028_B7907D51)
References: <20081119170211.b4029fc4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081119170211.b4029fc4.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 05:02:11PM -0800, Andrew Morton wrote:
> 
> include/net/mac80211.h: In function 'ieee80211_tx_info_clear_status':
> include/net/mac80211.h:400: error: size of array 'type name' is negative
> include/net/mac80211.h:405: error: size of array 'type name' is negative
> 
> due to:
> 
> static inline void
> ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
> {
>         int i;
> 
>         BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
>                      offsetof(struct ieee80211_tx_info, control.rates));
>         BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
>                      offsetof(struct ieee80211_tx_info, driver_rates));
> -->     BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) != 8);
>         /* clear the rate counts */
>         for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
>                 info->status.rates[i].count = 0;
> 
> -->     BUILD_BUG_ON(
>             offsetof(struct ieee80211_tx_info, status.ampdu_ack_len) != 23);
>         memset(&info->status.ampdu_ack_len, 0,
>                sizeof(struct ieee80211_tx_info) -
>                offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
> }

I just sent a pull request yesterday that contains a patch to correct this.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
