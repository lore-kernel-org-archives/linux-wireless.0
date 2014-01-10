Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toroondcmxomta02.srvr.bell.ca ([67.69.168.81]:37657 "EHLO
	toroondcmxzomta02-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbaAKDpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 22:45:52 -0500
Received: from toroondcocmrk06.srvr.bell.ca ([67.69.240.183])
          by toroondcmxzomta03-srv.bellnexxia.net
          (InterMail vM.8.01.05.13 201-2260-151-135-20130320) with ESMTP
          id <20140110195315.DTFR17063.toroondcmxzomta03-srv.bellnexxia.net@toroondcocmrk06.srvr.bell.ca>
          for <linux-wireless@vger.kernel.org>;
          Fri, 10 Jan 2014 14:53:15 -0500
From: Alex Gal <a.gal@motsai.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi,
	Alex Gal <a.gal@motsai.com>
Subject: [PATCH v5] wl12xx: fix tx power setting
Date: Fri, 10 Jan 2014 14:52:52 -0500
Message-Id: <1389383572-1112-1-git-send-email-a.gal@motsai.com> (sfid-20140111_044619_766631_A654E6E8)
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

