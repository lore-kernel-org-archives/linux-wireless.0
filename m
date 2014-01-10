Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20337 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302AbaAJWbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 17:31:00 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13] mwifiex: add missing endian conversion for fw_tsf
Date: Fri, 10 Jan 2014 14:30:41 -0800
Message-ID: <1389393041-23606-1-git-send-email-bzhao@marvell.com> (sfid-20140110_233108_916468_0F9F00C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It is u64 data received from firmware. Little endian to cpu
conversion is required here.

Cc: <stable@vger.kernel.org> # 3.5+
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 0ed0664..0a8a26e 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1681,7 +1681,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		const u8 *ie_buf;
 		size_t ie_len;
 		u16 channel = 0;
-		u64 fw_tsf = 0;
+		__le64 fw_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
 		u32 freq;
@@ -1815,7 +1815,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
 				bss_priv->band = band;
-				bss_priv->fw_tsf = fw_tsf;
+				bss_priv->fw_tsf = le64_to_cpu(fw_tsf);
 				if (priv->media_connected &&
 				    !memcmp(bssid,
 					    priv->curr_bss_params.bss_descriptor
-- 
1.8.2.3

