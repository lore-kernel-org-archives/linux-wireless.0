Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:42918 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405Ab1KJFgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 00:36:46 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.2] mwifiex: fix association issue with AP configured in hidden SSID mode
Date: Wed,  9 Nov 2011 21:36:21 -0800
Message-Id: <1320903381-30462-1-git-send-email-bzhao@marvell.com> (sfid-20111110_063650_762265_AA5A00B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Firmware expects 'max_ssid_length' field in
'struct mwifiex_ie_types_wildcard_ssid_params' to be '0' for
performing SSID specific scan. Currently driver updates it with
an actual SSID length. Hence UUT is not able to find the AP
configured in hidden SSID mode in scan results and association
fails.

max_ssid_length is filled with '0' to fix the issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8a18bcc..b8b9d37 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -819,8 +819,10 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 			wildcard_ssid_tlv->header.len = cpu_to_le16(
 				(u16) (ssid_len + sizeof(wildcard_ssid_tlv->
 							 max_ssid_length)));
-			wildcard_ssid_tlv->max_ssid_length =
-				user_scan_in->ssid_list[ssid_idx].max_len;
+
+			/* max_ssid_length = 0 tells firmware to perform
+			   specific scan for the SSID filled */
+			wildcard_ssid_tlv->max_ssid_length = 0;
 
 			memcpy(wildcard_ssid_tlv->ssid,
 			       user_scan_in->ssid_list[ssid_idx].ssid,
-- 
1.7.0.2

