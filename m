Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41803 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3ICOea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:30 -0400
Received: by mail-wi0-f172.google.com with SMTP id c10so3421275wiw.11
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:29 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/12] wlcore: fix unsafe dereference of the wlvif
Date: Tue,  3 Sep 2013 17:34:04 +0300
Message-Id: <1378218848-7853-8-git-send-email-eliad@wizery.com> (sfid-20130903_163433_721162_5FB22825)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
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
index 3c02023..aa11a17 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -405,7 +405,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		is_wep = (cipher == WLAN_CIPHER_SUITE_WEP40) ||
 			 (cipher == WLAN_CIPHER_SUITE_WEP104);
 
-		if (WARN_ON(is_wep && wlvif->default_key != idx)) {
+		if (WARN_ON(is_wep && wlvif && wlvif->default_key != idx)) {
 			ret = wl1271_set_default_wep_key(wl, wlvif, idx);
 			if (ret < 0)
 				return ret;
-- 
1.8.3.rc1.35.g9b79519

