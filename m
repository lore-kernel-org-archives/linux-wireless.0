Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44320 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbZKRPgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:36:44 -0500
Message-ID: <4B04148E.6010202@openwrt.org>
Date: Wed, 18 Nov 2009 16:36:46 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH v2 1/2] ath9k: properly use the mac80211 rate control
 api
References: <4B037881.8020509@openwrt.org> <20091118152909.GC2911@tuxdriver.com>
In-Reply-To: <20091118152909.GC2911@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Nov 18, 2009 at 05:30:57AM +0100, Felix Fietkau wrote:
>> This patch changes ath9k to pass proper MCS indexes and flags
>> between the RC and the rest of the driver code.
>> sc->cur_rate_table remains, as it's used by the RC code internally,
>> but the rest of the driver code no longer uses it, so a potential
>> new RC for ath9k would not have to update it.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>> - replaces sc->hw usage with common->hw
>> - initializes unused tx status rates to -1 for minstrel compatibility
>> - split up for easier review
>> - tested in ap mode with minstrel against a legacy STA
>> - v2: fix bisectability
> 
>   CC [M]  drivers/net/wireless/ath/ath9k/rc.o
> drivers/net/wireless/ath/ath9k/rc.c: In function ‘ath_tx_status’:
> drivers/net/wireless/ath/ath9k/rc.c:1272: warning: passing argument 2 of ‘ath_debug_stat_rc’ makes pointer from integer without a cast
> drivers/net/wireless/ath/ath9k/debug.h:173: note: expected ‘struct sk_buff *’ but argument is of type ‘int’
Sorry, I must have lost a patch chunk there. Will fix it later.

- Felix
