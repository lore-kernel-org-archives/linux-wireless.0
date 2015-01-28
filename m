Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23130 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933289AbbA1Emr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:42:47 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4ciNj028905
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:42:47 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s49ry0gqc-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:42:47 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 1/8] mwifiex: remove redundant nick_name variable
Date: Wed, 28 Jan 2015 15:41:58 +0530
Message-ID: <1422439925-25666-2-git-send-email-patila@marvell.com> (sfid-20150128_054253_592439_2C269E8A)
In-Reply-To: <1422439925-25666-1-git-send-email-patila@marvell.com>
References: <1422439925-25666-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not used anywhere execpt initialization.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 1 -
 drivers/net/wireless/mwifiex/main.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9836df0..99cd360 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -968,7 +968,6 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
-	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
 	memset(priv->mgmt_ie, 0,
 	       sizeof(struct mwifiex_ie) * MAX_MGMT_IE_INDEX);
 	priv->beacon_idx = MWIFIEX_AUTO_IDX_MASK;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 55273ee..99792b8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -553,7 +553,6 @@ struct mwifiex_private {
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dfs_dev_dir;
 #endif
-	u8 nick_name[16];
 	u16 current_key_index;
 	struct semaphore async_sem;
 	struct cfg80211_scan_request *scan_request;
-- 
1.8.1.4

