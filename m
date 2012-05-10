Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2EJJOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:51 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:50 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/78] wl18xx: create per-chip-family private storage
Date: Thu, 10 May 2012 12:13:14 +0300
Message-Id: <1336641263-5761-10-git-send-email-arik@wizery.com> (sfid-20120510_111455_303925_83D1F57E)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of the wlcore provided private storage in the 18xx low-level
driver.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 6a487c8..b298e01 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -313,8 +313,9 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
 	struct ieee80211_hw *hw;
+	struct wl18xx_priv *priv;
 
-	hw = wlcore_alloc_hw(0);
+	hw = wlcore_alloc_hw(sizeof(*priv));
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
 		return PTR_ERR(hw);
-- 
1.7.9.5

