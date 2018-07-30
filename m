Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35086 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbeG3RPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 13:15:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id a3-v6so13383067wrt.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 08:40:12 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH] ath10k: Limit available channels via DT ieee80211-freq-limit
Date: Mon, 30 Jul 2018 17:39:33 +0200
Message-Id: <20180730153933.3771-1-sven.eckelmann@openmesh.com> (sfid-20180730_174017_419144_12088BE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special filters in
the RX and TX path. These filtered channel can in theory still be used by
the hardware but the signal strength is reduced so much that it makes no
sense.

There is already a DT property to limit the available channels but ath10k
has to manually call this functionality to limit the currrently set wiphy
channels further.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 95243b48a179..8ed37ffd320f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -18,6 +18,7 @@
 
 #include "mac.h"
 
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <linux/acpi.h>
@@ -8306,6 +8307,7 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->bands[NL80211_BAND_5GHZ] = band;
 	}
 
+	wiphy_read_of_freq_limits(ar->hw->wiphy);
 	ath10k_mac_setup_ht_vht_cap(ar);
 
 	ar->hw->wiphy->interface_modes =
-- 
2.11.0
