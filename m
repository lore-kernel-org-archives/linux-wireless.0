Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:46871 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab2H1Dfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 23:35:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH 4/4] mwifiex: make use of is_zero_ether_addr()
Date: Mon, 27 Aug 2012 20:32:54 -0700
Message-Id: <1346124774-17701-4-git-send-email-bzhao@marvell.com> (sfid-20120828_054602_988040_5C3206F6)
In-Reply-To: <1346124774-17701-1-git-send-email-bzhao@marvell.com>
References: <1346124774-17701-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use is_zero_ether_addr() instead of directly using memcmp() to
determine if the ethernet address is all zeros.

Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 215d07e..9e077e5 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -726,7 +726,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
 	struct mwifiex_ie_types_rates_param_set *rates_tlv;
-	const u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 	u8 *tlv_pos;
 	u32 num_probes;
 	u32 ssid_len;
@@ -840,8 +839,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		 *  or BSSID filter applied to the scan results in the firmware.
 		 */
 		if ((i && ssid_filter) ||
-		    memcmp(scan_cfg_out->specific_bssid, &zero_mac,
-			   sizeof(zero_mac)))
+		    !is_zero_ether_addr(scan_cfg_out->specific_bssid))
 			*filtered_scan = true;
 	} else {
 		scan_cfg_out->bss_mode = (u8) adapter->scan_mode;
-- 
1.7.0.2

