Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:50465 "EHLO
	smtp4.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0L2PU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 10:20:56 -0500
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>,
	linux-wireless@vger.kernel.org, chunkeey@googlemail.com
Subject: [PATCH] p54: fix compiler-warning when no P54_LEDS are configured
Date: Wed, 29 Dec 2010 16:14:39 +0100
Message-Id: <1293635679-9783-1-git-send-email-christoph.paasch@uclouvain.be>
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The priv-variable is unused when compiling without CONFIG_P54_LEDS.

Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
---
 drivers/net/wireless/p54/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 622d27b..a6802f5 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -611,7 +611,9 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 
 int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 {
+#ifdef CONFIG_P54_LEDS
 	struct p54_common *priv = dev->priv;
+#endif /* CONFIG_P54_LEDS */
 	int err;
 
 	err = ieee80211_register_hw(dev);
@@ -653,9 +655,9 @@ EXPORT_SYMBOL_GPL(p54_free_common);
 
 void p54_unregister_common(struct ieee80211_hw *dev)
 {
+#ifdef CONFIG_P54_LEDS
 	struct p54_common *priv = dev->priv;
 
-#ifdef CONFIG_P54_LEDS
 	p54_unregister_leds(priv);
 #endif /* CONFIG_P54_LEDS */
 
-- 
1.7.1

