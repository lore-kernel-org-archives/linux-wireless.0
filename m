Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22580 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbaDNWdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:33:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/7] mwifiex: change memset to simple assignment for ht_cap.mcs.rx_mask
Date: Mon, 14 Apr 2014 15:32:49 -0700
Message-ID: <1397514775-4777-1-git-send-email-bzhao@marvell.com> (sfid-20140415_003312_391171_BE994CE0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

WARNING: single byte memset is suspicious.
         Swapped 2nd/3rd argument?

This code happens to work because rx_mcs is the first variable
in mcs structure. We should use 'mcs.rx_mcs' here anyway.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 9be6544..3264355 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -175,17 +175,19 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 		switch (GET_RXSTBC(cap_info)) {
 		case MWIFIEX_RX_STBC1:
 			/* HT_CAP 1X1 mode */
-			memset(&bss_cfg->ht_cap.mcs, 0xff, 1);
+			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
 			break;
 		case MWIFIEX_RX_STBC12:	/* fall through */
 		case MWIFIEX_RX_STBC123:
 			/* HT_CAP 2X2 mode */
-			memset(&bss_cfg->ht_cap.mcs, 0xff, 2);
+			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
+			bss_cfg->ht_cap.mcs.rx_mask[1] = 0xff;
 			break;
 		default:
 			dev_warn(priv->adapter->dev,
 				 "Unsupported RX-STBC, default to 2x2\n");
-			memset(&bss_cfg->ht_cap.mcs, 0xff, 2);
+			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
+			bss_cfg->ht_cap.mcs.rx_mask[1] = 0xff;
 			break;
 		}
 		priv->ap_11n_enabled = 1;
-- 
1.8.2.3

