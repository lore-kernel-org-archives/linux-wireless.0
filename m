Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34899 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258AbaBYM0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 07:26:09 -0500
Date: Tue, 25 Feb 2014 17:42:09 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 2/3 v3] mwl8k: Implement sw_scan start/stop cbs
Message-ID: <20140225121209.GA5643@markyou.marvell.com> (sfid-20140225_132616_108869_B2612068)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement sw_scan start and stop callbacks.
Reset BBP registers for channel, RX busy and
average noise stats which clear on read.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6c002f3..61d5bea 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -81,6 +81,9 @@ MODULE_PARM_DESC(ap_mode_default,
  */
 
 #define	MWL8K_HW_TIMER_REGISTER			0x0000a600
+#define BBU_RXRDY_CNT_REG			0x0000a860
+#define NOK_CCA_CNT_REG				0x0000a6a0
+#define BBU_AVG_NOISE_VAL			0x67
 
 #define MWL8K_A2H_EVENTS	(MWL8K_A2H_INT_DUMMY | \
 				 MWL8K_A2H_INT_CHNL_SWITCHED | \
@@ -289,6 +292,9 @@ struct mwl8k_priv {
 
 	/* bitmap of running BSSes */
 	u32 running_bsses;
+
+	/* ACS related */
+	bool sw_scan_start;
 };
 
 #define MAX_WEP_KEY_LEN         13
@@ -5448,6 +5454,38 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return rc;
 }
 
+static void mwl8k_sw_scan_start(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	u8 tmp;
+
+	if (!priv->ap_fw)
+		return;
+
+	/* clear all stats */
+	ioread32(priv->regs + BBU_RXRDY_CNT_REG);
+	ioread32(priv->regs + NOK_CCA_CNT_REG);
+	mwl8k_cmd_bbp_reg_access(priv->hw, 0, BBU_AVG_NOISE_VAL, &tmp);
+
+	priv->sw_scan_start = true;
+}
+
+static void mwl8k_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	u8 tmp;
+
+	if (!priv->ap_fw)
+		return;
+
+	priv->sw_scan_start = false;
+
+	/* clear all stats */
+	ioread32(priv->regs + BBU_RXRDY_CNT_REG);
+	ioread32(priv->regs + NOK_CCA_CNT_REG);
+	mwl8k_cmd_bbp_reg_access(priv->hw, 0, BBU_AVG_NOISE_VAL, &tmp);
+}
+
 static const struct ieee80211_ops mwl8k_ops = {
 	.tx			= mwl8k_tx,
 	.start			= mwl8k_start,
@@ -5466,6 +5504,8 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.get_stats		= mwl8k_get_stats,
 	.get_survey		= mwl8k_get_survey,
 	.ampdu_action		= mwl8k_ampdu_action,
+	.sw_scan_start		= mwl8k_sw_scan_start,
+	.sw_scan_complete	= mwl8k_sw_scan_complete,
 };
 
 static void mwl8k_finalize_join_worker(struct work_struct *work)
-- 
1.8.3.4

