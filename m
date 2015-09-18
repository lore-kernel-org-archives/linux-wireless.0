Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50615 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbbIRNcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:32:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDPaF0031584
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:54 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eq2-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:54 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 04/16] mwifiex: fix driver init failure under memory pressure
Date: Fri, 18 Sep 2015 06:32:06 -0700
Message-ID: <1442583138-2979-5-git-send-email-akarwar@marvell.com> (sfid-20150918_153257_281253_4C3A86ED)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

64k Tx and Rx buffers are allocated during driver initialization
for SDIO level data aggregations. When host is under memory
pressure situation, kzalloc() request for 64k may fail.

We will try allocating 32k buffers and disable our rx single port
aggreagation feature in this situation.

If the allocation still fails, we will disable our sdio multport
aggregation feature as well. In this way, we will transmit and
receive packets one by one, thus reduce the demand for big
memory.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h    |  2 ++
 drivers/net/wireless/mwifiex/sdio.c    | 22 ++++++++++++++++------
 drivers/net/wireless/mwifiex/sta_cmd.c |  3 ++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f4159ed..8f5c3da 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -861,6 +861,8 @@ struct mwifiex_adapter {
 	u8 more_task_flag;
 	u16 tx_buf_size;
 	u16 curr_tx_buf_size;
+	/* sdio single port rx aggregation capability */
+	bool host_disable_sdio_rx_aggr;
 	bool sdio_rx_aggr_enable;
 	u16 sdio_rx_block_size;
 	u32 ioport;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d35210c..78a8474 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2058,16 +2058,26 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
 					     card->mp_tx_agg_buf_size,
 					     card->mp_rx_agg_buf_size);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "failed to alloc sdio mp-a buffers\n");
-		kfree(card->mp_regs);
-		return -1;
+
+	/* Allocate 32k MPA Tx/Rx buffers if 64k memory allocation fails */
+	if (ret && (card->mp_tx_agg_buf_size == MWIFIEX_MP_AGGR_BUF_SIZE_MAX ||
+		    card->mp_rx_agg_buf_size == MWIFIEX_MP_AGGR_BUF_SIZE_MAX)) {
+		/* Disable rx single port aggregation */
+		adapter->host_disable_sdio_rx_aggr = true;
+
+		ret = mwifiex_alloc_sdio_mpa_buffers
+			(adapter, MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+			 MWIFIEX_MP_AGGR_BUF_SIZE_32K);
+		if (ret) {
+			/* Disable multi port aggregation */
+			card->mpa_tx.enabled = 0;
+			card->mpa_rx.enabled = 0;
+		}
 	}
 
 	adapter->auto_tdls = card->can_auto_tdls;
 	adapter->ext_scan = card->can_ext_scan;
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index fd7bf94..e486867 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -2156,7 +2156,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 
 		/** Set SDIO Single Port RX Aggr Info */
 		if (priv->adapter->iface_type == MWIFIEX_SDIO &&
-		    ISSUPP_SDIO_SPA_ENABLED(priv->adapter->fw_cap_info)) {
+		    ISSUPP_SDIO_SPA_ENABLED(priv->adapter->fw_cap_info) &&
+		    !priv->adapter->host_disable_sdio_rx_aggr) {
 			sdio_sp_rx_aggr_enable = true;
 			ret = mwifiex_send_cmd(priv,
 					       HostCmd_CMD_SDIO_SP_RX_AGGR_CFG,
-- 
1.8.1.4

