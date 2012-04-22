Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61292 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2DVTuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 15:50:46 -0400
Received: by mail-we0-f174.google.com with SMTP id x9so7059353wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 12:50:45 -0700 (PDT)
From: Zefir Kurtisi <zefir.kurtisi@gmail.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/4] ath9k: set PHYRADAR in RX filter when on DFS channel
Date: Sun, 22 Apr 2012 21:50:21 +0200
Message-Id: <1335124223-15439-3-git-send-email-zefir.kurtisi@gmail.com> (sfid-20120422_215051_156325_68E18358)
In-Reply-To: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f4ae3ba..ef45c0c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -17,6 +17,7 @@
 #include <linux/dma-mapping.h>
 #include "ath9k.h"
 #include "ar9003_mac.h"
+#include "dfs.h"
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
@@ -467,6 +468,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
 
+	if (sc->sc_ah->curchan->chan->flags & IEEE80211_CHAN_RADAR)
+		rfilt |= ATH9K_RX_FILTER_PHYRADAR;
+	else
+		rfilt &= ~ATH9K_RX_FILTER_PHYRADAR;
+
 	return rfilt;
 
 }
-- 
1.7.4.1

