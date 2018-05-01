Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35827 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbeEAIeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 04:34:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id o78so18070750wmg.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2018 01:34:03 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: remove unnecessary break in mt76x2_mac_process_tx_rate()
Date: Tue,  1 May 2018 10:33:54 +0200
Message-Id: <20180501083354.1252-1-lorenzo.bianconi@redhat.com> (sfid-20180501_103411_756617_50DA40E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary break statement in the default case of bw switch
block in mt76x2_mac_process_tx_rate routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index d18315652583..dab713756004 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -410,7 +410,6 @@ mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	if (rate & MT_RXWI_RATE_SGI)
-- 
2.16.3
