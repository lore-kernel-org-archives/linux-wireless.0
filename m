Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45933 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbcF3Ox1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 10:53:27 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Maxim Altshul <maxim.altshul@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>, Yaniv Machani <yanivma@ti.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wlcore: Add support for get_expected_throughput opcode
Date: Thu, 30 Jun 2016 17:49:03 +0300
Message-ID: <20160630145534.26052-1-maxim.altshul@ti.com> (sfid-20160630_165356_857494_C1EF09DF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding this opcode, allows the TI wireless driver,
to report throughput directly from FW to mac80211.

This is used mainly for mesh metric calculation.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
Changed the units of returned value.
drv_get_expected_throughput returns units of Kbps 
by definition, and thus we must comply as well.
Mbps * 1000 = Kbps.

 drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 39dec7d..cb1103b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5851,6 +5851,20 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static u32 wlcore_op_get_expected_throughput(struct ieee80211_sta *sta)
+{
+	struct wl1271_station *wl_sta = (struct wl1271_station *)sta->drv_priv;
+	struct wl1271 *wl = wl_sta->wl;
+	u8 hlid = wl_sta->hlid;
+	u32 ret = 0;
+
+	/* return in units of Kbps */
+	if (wl)
+		ret = (wl->links[hlid].fw_rate_mbps * 1000);
+
+	return ret;
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -6051,6 +6065,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.switch_vif_chanctx = wlcore_op_switch_vif_chanctx,
 	.sta_rc_update = wlcore_op_sta_rc_update,
 	.sta_statistics = wlcore_op_sta_statistics,
+	.get_expected_throughput = wlcore_op_get_expected_throughput,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
2.9.0

