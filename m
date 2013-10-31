Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63736 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3JaGIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 02:08:30 -0400
Received: by mail-pa0-f47.google.com with SMTP id lf10so2030112pab.34
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 23:08:29 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: k.eugene.e@gmail.com, linville@tuxdriver.com,
	wcn36xx@lists.infradead.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH] wcn36xx: enable beacon change using BSS_CHANGED_BEACON
Date: Thu, 31 Oct 2013 14:07:45 +0800
Message-Id: <1383199665-18377-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131031_070832_864288_7715049B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the beacon changed using BSS_CHANGED_BEACON. This is
especially useful for mesh mode.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 7839b31..e64a678 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -641,7 +641,8 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 		dev_kfree_skb(skb);
 	}
 
-	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+	if (changed & BSS_CHANGED_BEACON_ENABLED ||
+	    changed & BSS_CHANGED_BEACON) {
 		wcn36xx_dbg(WCN36XX_DBG_MAC,
 			    "mac bss changed beacon enabled %d\n",
 			    bss_conf->enable_beacon);
-- 
1.7.9.5

