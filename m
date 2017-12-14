Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17927 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753524AbdLNQx1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 11:53:27 -0500
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 6/9] wil6210: add support for headroom configuration
Date: Thu, 14 Dec 2017 18:53:10 +0200
Message-Id: <1513270393-919-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171214_175331_429996_81E2AE88)
In-Reply-To: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

Add module parameter for configuring the headroom size
in the skb allocation.

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 62c04f0..89967ce 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -41,6 +41,32 @@
 module_param(rx_large_buf, bool, 0444);
 MODULE_PARM_DESC(rx_large_buf, " allocate 8KB RX buffers, default - no");
 
+#define WIL6210_MAX_HEADROOM_SIZE	(256)
+
+static ushort headroom_size; /* = 0; */
+static int headroom_size_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	ret = param_set_uint(val, kp);
+	if (ret)
+		return ret;
+
+	if (headroom_size > WIL6210_MAX_HEADROOM_SIZE)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const struct kernel_param_ops headroom_ops = {
+	.set = headroom_size_set,
+	.get = param_get_ushort,
+};
+
+module_param_cb(headroom_size, &headroom_ops, &headroom_size, 0644);
+MODULE_PARM_DESC(headroom_size,
+		 " headroom size for rx skb allocation, default - 0");
+
 static inline uint wil_rx_snaplen(void)
 {
 	return rx_align_2 ? 6 : 0;
@@ -630,7 +656,7 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 	u32 next_tail;
 	int rc = 0;
 	int headroom = ndev->type == ARPHRD_IEEE80211_RADIOTAP ?
-			WIL6210_RTAP_SIZE : 0;
+			WIL6210_RTAP_SIZE : headroom_size;
 
 	for (; next_tail = wil_vring_next_tail(v),
 			(next_tail != v->swhead) && (count-- > 0);
-- 
1.9.1
