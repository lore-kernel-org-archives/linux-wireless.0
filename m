Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:54364 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbcFTNAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 09:00:03 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <johannes@sipsolutions.net>, <kvalo@codeaurora.org>
CC: <eliad@wizery.com>, <yanivma@ti.com>, <guym@ti.com>,
	<arik@wizery.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <davem@davemloft.net>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 2/3] wlcore: Add support for get_expected_throughput opcode
Date: Mon, 20 Jun 2016 16:00:21 +0300
Message-ID: <1466427622-5953-3-git-send-email-maxim.altshul@ti.com> (sfid-20160620_150153_102522_3EAAD534)
In-Reply-To: <1466427622-5953-2-git-send-email-maxim.altshul@ti.com>
References: <1466427622-5953-1-git-send-email-maxim.altshul@ti.com>
 <1466427622-5953-2-git-send-email-maxim.altshul@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding this opcode, allows the TI wireless driver,
to report throughput directly from FW to mac80211.

This is used mainly for mesh metric calculation.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 39dec7d..cf4c6af 100644
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
+	/* return in units of 100kbps */
+	if (wl)
+		ret = (wl->links[hlid].fw_rate_mbps * 10);
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
2.7.2

