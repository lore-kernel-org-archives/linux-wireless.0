Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:54673 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbLIQnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 11:43:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	nico@linaro.org
Subject: [PATCH] iwlegacy: mark il_adjust_beacon_interval as noinline
Date: Wed, 09 Dec 2015 17:42:41 +0100
Message-ID: <36263581.L8412YxJjp@wuerfel> (sfid-20151209_174338_807269_EC8F99AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new optimized do_div() code, some versions of gcc
produce obviously incorrect code that leads to a link error
in iwlegacy/common.o:

drivers/built-in.o: In function `il_send_rxon_timing':
:(.text+0xa6b4d4): undefined reference to `____ilog2_NaN'
:(.text+0xa6b4f0): undefined reference to `__aeabi_uldivmod'

In a few thousand randconfig builds, I have seen this problem
a couple of times in this file, but never anywhere else in the
kernel, so we can try to work around this in the only file
that shows the behavior, by marking the il_adjust_beacon_interval
function as noinline, which convinces gcc to use the unoptimized
do_div() all the time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 887114582583..6308bb217454 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -3602,7 +3602,7 @@ il_is_ht40_tx_allowed(struct il_priv *il, struct ieee80211_sta_ht_cap *ht_cap)
 }
 EXPORT_SYMBOL(il_is_ht40_tx_allowed);
 
-static u16
+static u16 noinline
 il_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 {
 	u16 new_val;

