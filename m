Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8581 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbbAMGJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:09:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0D64xG0022625
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:15 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rv520k6bh-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:15 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/8] mwifiex: remove redundant nick_name variable
Date: Tue, 13 Jan 2015 17:08:43 +0530
Message-ID: <1421149130-5889-2-git-send-email-patila@marvell.com> (sfid-20150113_070919_650676_66E61DD2)
In-Reply-To: <1421149130-5889-1-git-send-email-patila@marvell.com>
References: <1421149130-5889-1-git-send-email-patila@marvell.com>
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
index a16c293..c7158e8 100644
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
index dd55bc1..149ef7d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -554,7 +554,6 @@ struct mwifiex_private {
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dfs_dev_dir;
 #endif
-	u8 nick_name[16];
 	u16 current_key_index;
 	struct semaphore async_sem;
 	struct cfg80211_scan_request *scan_request;
-- 
1.8.1.4

