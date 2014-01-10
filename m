Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f47.google.com ([209.85.128.47]:35353 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaAJUVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 15:21:24 -0500
Received: by mail-qe0-f47.google.com with SMTP id 5so4838084qeb.6
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jan 2014 12:21:23 -0800 (PST)
From: Alex Gal <a.gal@motsai.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Alex Gal <a.gal@motsai.com>
Subject: [PATCH v5] wl12xx: fix tx power setting
Date: Fri, 10 Jan 2014 15:21:13 -0500
Message-Id: <1389385273-1322-1-git-send-email-a.gal@motsai.com> (sfid-20140110_212129_433831_3BAD5CCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver ignores BSS_CHANGED_TXPOWER changes.
Fix this by calling ACX_TX_POWER when appropriate.

Signed-off-by: Alex Gal <a.gal@motsai.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e9da47c..89d2310 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4457,6 +4457,16 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if ((changed & BSS_CHANGED_TXPOWER) &&
+	    bss_conf->txpower != wlvif->power_level) {
+
+		ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
+		if (ret < 0)
+			goto out;
+
+		wlvif->power_level = bss_conf->txpower;
+	}
+
 	if (is_ap)
 		wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
 	else
-- 
1.8.5.2

