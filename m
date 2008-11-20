Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbYKTBC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 20:02:59 -0500
Date: Wed, 19 Nov 2008 17:02:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m68k: linux-next allmodconfig
Message-Id: <20081119170211.b4029fc4.akpm@linux-foundation.org> (sfid-20081120_020303_530389_BC11426A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


include/net/mac80211.h: In function 'ieee80211_tx_info_clear_status':
include/net/mac80211.h:400: error: size of array 'type name' is negative
include/net/mac80211.h:405: error: size of array 'type name' is negative

due to:

static inline void
ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
{
        int i;

        BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
                     offsetof(struct ieee80211_tx_info, control.rates));
        BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
                     offsetof(struct ieee80211_tx_info, driver_rates));
-->     BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) != 8);
        /* clear the rate counts */
        for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
                info->status.rates[i].count = 0;

-->     BUILD_BUG_ON(
            offsetof(struct ieee80211_tx_info, status.ampdu_ack_len) != 23);
        memset(&info->status.ampdu_ack_len, 0,
               sizeof(struct ieee80211_tx_info) -
               offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
}


