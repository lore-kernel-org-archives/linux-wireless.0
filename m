Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:54320 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1D1CIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 22:08:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: fix bug in mwifiex_save_curr_bcn()
Date: Wed, 27 Apr 2011 19:13:13 -0700
Message-Id: <1303956793-17982-3-git-send-email-bzhao@marvell.com> (sfid-20110428_040855_440136_1AAD8C9D)
In-Reply-To: <1303956793-17982-1-git-send-email-bzhao@marvell.com>
References: <1303956793-17982-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Since timestamp in beacon buffer keeps changing all the time,
the memcmp check in mwifiex_save_curr_bcn() is redundant.
Remove that memcmp check and also avoid freeing and allocation
of buffer if required beacon buffer size is same as previous one.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index be708ad..31a5295 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2990,32 +2990,28 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 	struct mwifiex_bssdescriptor *curr_bss =
 		&priv->curr_bss_params.bss_descriptor;
 
-	/* save the beacon buffer if it is not saved or updated */
-	if ((priv->curr_bcn_buf == NULL) ||
-	    (priv->curr_bcn_size != curr_bss->beacon_buf_size) ||
-	    (memcmp(priv->curr_bcn_buf, curr_bss->beacon_buf,
-		    curr_bss->beacon_buf_size))) {
-
-		kfree(priv->curr_bcn_buf);
-		priv->curr_bcn_buf = NULL;
+	if (!curr_bss->beacon_buf_size)
+		return;
 
+	/* allocate beacon buffer at 1st time; or if it's size has changed */
+	if (!priv->curr_bcn_buf ||
+			priv->curr_bcn_size != curr_bss->beacon_buf_size) {
 		priv->curr_bcn_size = curr_bss->beacon_buf_size;
-		if (!priv->curr_bcn_size)
-			return;
 
+		kfree(priv->curr_bcn_buf);
 		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
 						GFP_KERNEL);
 		if (!priv->curr_bcn_buf) {
 			dev_err(priv->adapter->dev,
 					"failed to alloc curr_bcn_buf\n");
-		} else {
-			memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
-			       curr_bss->beacon_buf_size);
-			dev_dbg(priv->adapter->dev,
-				"info: current beacon saved %d\n",
-			       priv->curr_bcn_size);
+			return;
 		}
 	}
+
+	memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
+		curr_bss->beacon_buf_size);
+	dev_dbg(priv->adapter->dev, "info: current beacon saved %d\n",
+		priv->curr_bcn_size);
 }
 
 /*
-- 
1.7.0.2

