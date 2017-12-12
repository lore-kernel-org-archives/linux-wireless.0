Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:59744 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdLLTES (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 14:04:18 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 7/9] wil6210: configurable broadcast TX MCS
Date: Tue, 12 Dec 2017 21:04:00 +0200
Message-Id: <1513105442-28041-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171212_200424_601408_FA25C2F9)
In-Reply-To: <1513105442-28041-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513105442-28041-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add 2 module parameters that control broadcast/multicast
TX packets:
1. bcast_mcs0_limit - specify the maximum packet size
that will be sent with MCS 0.
2. bcast_mcs - specify the MCS index to use when sending
packets larger than above limit.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 59 +++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 89967ce..4fc05f7 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -67,6 +67,60 @@ static int headroom_size_set(const char *val, const struct kernel_param *kp)
 MODULE_PARM_DESC(headroom_size,
 		 " headroom size for rx skb allocation, default - 0");
 
+static uint bcast_mcs0_limit = WIL_BCAST_MCS0_LIMIT;
+static int bcast_mcs0_limit_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	uint saved = bcast_mcs0_limit;
+
+	ret = param_set_uint(val, kp);
+	if (ret)
+		return ret;
+
+	if (bcast_mcs0_limit > WIL_BCAST_MCS0_LIMIT) {
+		bcast_mcs0_limit = saved;
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct kernel_param_ops bcast_mcs0_limit_ops = {
+	.set = bcast_mcs0_limit_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(bcast_mcs0_limit_set, &bcast_mcs0_limit_ops,
+		&bcast_mcs0_limit, 0644);
+MODULE_PARM_DESC(bcast_mcs0_limit,
+		 " max broadcast packet size with MCS0, default - 1024 bytes");
+
+static uint bcast_mcs = 1;
+static int bcast_mcs_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	uint saved = bcast_mcs;
+
+	ret = param_set_uint(val, kp);
+	if (ret)
+		return ret;
+
+	if (bcast_mcs > WIL_MCS_MAX || bcast_mcs == 0) {
+		bcast_mcs = saved;
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct kernel_param_ops bcast_mcs_ops = {
+	.set = bcast_mcs_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(bcast_mcs, &bcast_mcs_ops, &bcast_mcs, 0644);
+MODULE_PARM_DESC(bcast_mcs, " MCS index for large bcast TX, default - 1");
+
 static inline uint wil_rx_snaplen(void)
 {
 	return rx_align_2 ? 6 : 0;
@@ -1783,8 +1837,9 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_tx_desc_map(d, pa, len, vring_index);
 	if (unlikely(mcast)) {
 		d->mac.d[0] |= BIT(MAC_CFG_DESC_TX_0_MCS_EN_POS); /* MCS 0 */
-		if (unlikely(len > WIL_BCAST_MCS0_LIMIT)) /* set MCS 1 */
-			d->mac.d[0] |= (1 << MAC_CFG_DESC_TX_0_MCS_INDEX_POS);
+		if (unlikely(len > bcast_mcs0_limit)) /* use bcast_mcs */
+			d->mac.d[0] |= (bcast_mcs <<
+					MAC_CFG_DESC_TX_0_MCS_INDEX_POS);
 	}
 	/* Process TCP/UDP checksum offloading */
 	if (unlikely(wil_tx_desc_offload_setup(d, skb))) {
-- 
1.9.1
