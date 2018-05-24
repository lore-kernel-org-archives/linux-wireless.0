Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.107]:47424 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965089AbeEXXNX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 19:13:23 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id E8EC2798B4F
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 18:13:22 -0500 (CDT)
Date: Thu, 24 May 2018 18:13:22 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ath6kl: mark expected switch fall-throughs
Message-ID: <20180524231322.GA22704@embeddedor.com> (sfid-20180525_011431_395647_31B71F07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2ba8cf3..29e32cd 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3898,17 +3898,17 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
 	switch (ar->hw.cap) {
 	case WMI_11AN_CAP:
-		ht = true;
+		ht = true; /* fall through */
 	case WMI_11A_CAP:
 		band_5gig = true;
 		break;
 	case WMI_11GN_CAP:
-		ht = true;
+		ht = true; /* fall through */
 	case WMI_11G_CAP:
 		band_2gig = true;
 		break;
 	case WMI_11AGN_CAP:
-		ht = true;
+		ht = true; /* fall through */
 	case WMI_11AG_CAP:
 		band_2gig = true;
 		band_5gig = true;
-- 
2.7.4
