Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46064 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbaILJL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:11:28 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 11/16] mwifiex: remove restriction of single channel scan when connected
Date: Fri, 12 Sep 2014 20:08:55 +0530
Message-ID: <1410532740-3173-12-git-send-email-patila@marvell.com> (sfid-20140912_111229_062763_2CCF600C)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With scan channel gap in place, FW comes back to connected channel
after each scan; so we dont need to restrict FW to scan
single channel while connected.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 6fd69af..7c85f61 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1067,12 +1067,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 							    *filtered_scan);
 	}
 
-	/*
-	 * In associated state we will reduce the number of channels scanned per
-	 * scan command to 1 to avoid any traffic delay/loss.
-	 */
-	if (priv->media_connected)
-			*max_chan_per_scan = 1;
 }
 
 /*
-- 
1.8.1.4

