Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21699 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbcBCGKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u136A61r012757
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:06 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 20svyv7n1b-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:06 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/8] mwifiex: display right transmit packet delay
Date: Tue, 2 Feb 2016 22:05:02 -0800
Message-ID: <1454479509-27129-2-git-send-email-akarwar@marvell.com> (sfid-20160203_071012_062199_5B127161)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

drv_pkt_delay_max should be assigned non-zero value, so that
packet delay can be accumulate in the right way.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h | 1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 89a1576..0433977 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -298,6 +298,7 @@ struct mwifiex_tid_tbl {
 #define WMM_HIGHEST_PRIORITY		7
 #define HIGH_PRIO_TID				7
 #define LOW_PRIO_TID				0
+#define MWIFIEX_WMM_DRV_DELAY_MAX 510
 
 struct mwifiex_wmm_desc {
 	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 499e5a7..0eb2465 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -438,6 +438,7 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 		mwifiex_set_ba_params(priv);
 		mwifiex_reset_11n_rx_seq_num(priv);
 
+		priv->wmm.drv_pkt_delay_max = MWIFIEX_WMM_DRV_DELAY_MAX;
 		atomic_set(&priv->wmm.tx_pkts_queued, 0);
 		atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
 	}
-- 
1.8.1.4

