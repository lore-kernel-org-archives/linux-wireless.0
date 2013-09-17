Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:41241 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3IQPln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 11:41:43 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so2847794ead.30
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 08:41:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 06/11] wlcore: fix unsafe dereference of the wlvif
Date: Tue, 17 Sep 2013 18:41:25 +0300
Message-Id: <1379432490-22157-6-git-send-email-eliad@wizery.com> (sfid-20130917_174152_730730_1DBF9270)
In-Reply-To: <1379432490-22157-1-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

wlvif could be passed as NULL from the wlcore_tx_work_locked()
to the wl1271_prepare_tx_frame() and to wl1271_skb_queue_head()
functions. This may lead to a Kernel panic, fix this by
validating that wlvif != NULL.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 03249da..87cd707 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -401,7 +401,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		is_wep = (cipher == WLAN_CIPHER_SUITE_WEP40) ||
 			 (cipher == WLAN_CIPHER_SUITE_WEP104);
 
-		if (WARN_ON(is_wep && wlvif->default_key != idx)) {
+		if (WARN_ON(is_wep && wlvif && wlvif->default_key != idx)) {
 			ret = wl1271_set_default_wep_key(wl, wlvif, idx);
 			if (ret < 0)
 				return ret;
-- 
1.8.3.rc1.35.g9b79519

