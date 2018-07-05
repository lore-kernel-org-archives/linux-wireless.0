Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41008 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbeGEM76 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 08:59:58 -0400
Received: by mail-pf0-f196.google.com with SMTP id c21-v6so754106pfn.8
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 05:59:58 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sajay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 4/4] rsi: optimize virtual interfaces
Date: Thu,  5 Jul 2018 18:08:22 +0530
Message-Id: <1530794302-8833-5-git-send-email-sushant2k1513@gmail.com> (sfid-20180705_150001_747648_3C472AA3)
In-Reply-To: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
References: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Due to multiple calls of add interface routine, vif is getting duplicated
and at certain instance, we are out of vifs, causing the driver to behave
abnormal.

Fix: Every vif has a unique mac-id, when we got a vif with same mac-id as
the previous id's, we will override the respective vif.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 2ca7464..4e510cb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -416,7 +416,8 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 
 	/* Get free vap index */
 	for (i = 0; i < RSI_MAX_VIFS; i++) {
-		if (!adapter->vifs[i]) {
+		if (!adapter->vifs[i] ||
+		    !memcmp(vif->addr, adapter->vifs[i]->addr, ETH_ALEN)) {
 			vap_idx = i;
 			break;
 		}
-- 
2.5.5
