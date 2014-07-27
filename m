Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43736 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0Vkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 17:40:39 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so6323849wgh.21
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 14:40:38 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCHv3 3/6] p54: extend p54_set_coverage_class signature
Date: Sun, 27 Jul 2014 23:40:34 +0200
Message-Id: <1406497234-25666-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_234042_157489_ABDE8140)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize set_coverage_class routine signature with mac80211 function
pointer. Function pointer prototype has been changed to activate ath9k ACK
timeout estimation algorithm (dynack).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/p54/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 7be3a48..97aeff0 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -696,7 +696,8 @@ static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 	WARN(total, "tx flush timeout, unresponsive firmware");
 }
 
-static void p54_set_coverage_class(struct ieee80211_hw *dev, u8 coverage_class)
+static void p54_set_coverage_class(struct ieee80211_hw *dev,
+				   s16 coverage_class)
 {
 	struct p54_common *priv = dev->priv;
 
-- 
1.9.1

