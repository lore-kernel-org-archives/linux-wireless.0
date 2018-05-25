Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.161]:12236 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967518AbeEYSXR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 14:23:17 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id F37D3112F5
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 13:23:12 -0500 (CDT)
Date: Fri, 25 May 2018 13:23:11 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] ath6kl: mark expected switch fall-throughs
Message-ID: <20180525182311.GA3000@embeddedor.com> (sfid-20180525_202333_341012_8EA4094E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Place code comments on a line of their own.

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2ba8cf3..a16ee5d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3899,16 +3899,19 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	switch (ar->hw.cap) {
 	case WMI_11AN_CAP:
 		ht = true;
+		/* fall through */
 	case WMI_11A_CAP:
 		band_5gig = true;
 		break;
 	case WMI_11GN_CAP:
 		ht = true;
+		/* fall through */
 	case WMI_11G_CAP:
 		band_2gig = true;
 		break;
 	case WMI_11AGN_CAP:
 		ht = true;
+		/* fall through */
 	case WMI_11AG_CAP:
 		band_2gig = true;
 		band_5gig = true;
-- 
2.7.4
