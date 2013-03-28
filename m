Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:34807 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221Ab3C1CNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 22:13:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Sagar Bijwe <bsagar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: change default tx/rx win_size for BA setup
Date: Wed, 27 Mar 2013 19:10:31 -0700
Message-ID: <1364436632-24281-1-git-send-email-bzhao@marvell.com> (sfid-20130328_031310_251908_8D37F498)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes an issue where RX throughput values observed
were substantially lower than TX counterparts for PCIe8897 STA.
PCIe8897 supports larger rx_win_size. After changing these values
we see big improvement for TX and RX throughput values.

Different tx_win_size and rx_win_size are used for AP mode.

All BA setup related initialization has been moved to separate
function.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Sagar Bijwe <bsagar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |   22 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h |    7 +++++--
 drivers/net/wireless/mwifiex/main.h |    1 +
 drivers/net/wireless/mwifiex/wmm.c  |    5 +----
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 45f1971..41e9d25 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -679,3 +679,25 @@ void mwifiex_del_tx_ba_stream_tbl_by_ra(struct mwifiex_private *priv, u8 *ra)
 
 	return;
 }
+
+/* This function initializes the BlockACK setup information for given
+ * mwifiex_private structure.
+ */
+void mwifiex_set_ba_params(struct mwifiex_private *priv)
+{
+	priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		priv->add_ba_param.tx_win_size =
+						MWIFIEX_UAP_AMPDU_DEF_TXWINSIZE;
+		priv->add_ba_param.rx_win_size =
+						MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE;
+	} else {
+		priv->add_ba_param.tx_win_size =
+						MWIFIEX_STA_AMPDU_DEF_TXWINSIZE;
+		priv->add_ba_param.rx_win_size =
+						MWIFIEX_STA_AMPDU_DEF_RXWINSIZE;
+	}
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index e8a569a..2af2c7c 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -41,8 +41,11 @@
 #define MWIFIEX_MAX_TX_BASTREAM_SUPPORTED	2
 #define MWIFIEX_MAX_RX_BASTREAM_SUPPORTED	16
 
-#define MWIFIEX_AMPDU_DEF_TXWINSIZE        32
-#define MWIFIEX_AMPDU_DEF_RXWINSIZE        16
+#define MWIFIEX_STA_AMPDU_DEF_TXWINSIZE        16
+#define MWIFIEX_STA_AMPDU_DEF_RXWINSIZE        32
+#define MWIFIEX_UAP_AMPDU_DEF_TXWINSIZE        32
+#define MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE        16
+
 #define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff
 
 #define MWIFIEX_RATE_BITMAP_MCS0   32
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 535595e..d032998 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -924,6 +924,7 @@ void
 mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct mwifiex_uap_bss_param *bss_cfg,
 		       struct cfg80211_ap_settings *params);
+void mwifiex_set_ba_params(struct mwifiex_private *priv);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 32adc87..3ddae52 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -436,10 +436,7 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 					= priv->aggr_prio_tbl[7].ampdu_user
 					= BA_STREAM_NOT_ALLOWED;
 
-		priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
-		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
-		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
-
+		mwifiex_set_ba_params(priv);
 		mwifiex_reset_11n_rx_seq_num(priv);
 
 		atomic_set(&priv->wmm.tx_pkts_queued, 0);
-- 
1.7.0.2

