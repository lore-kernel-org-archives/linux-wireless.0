Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2550 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab3KUTJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 14:09:15 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13] mwifiex: fix memory leak issue for ibss join
Date: Thu, 21 Nov 2013 11:08:56 -0800
Message-ID: <1385060936-18833-1-git-send-email-bzhao@marvell.com> (sfid-20131121_200918_204354_26280364)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

For IBSS join if the requested SSID matches current SSID,
it returns without freeing the allocated beacon IE buffer.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index c8e029d..a09398f 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -319,8 +319,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		if (bss_desc && bss_desc->ssid.ssid_len &&
 		    (!mwifiex_ssid_cmp(&priv->curr_bss_params.bss_descriptor.
 				       ssid, &bss_desc->ssid))) {
-			kfree(bss_desc);
-			return 0;
+			ret = 0;
+			goto done;
 		}
 
 		/* Exit Adhoc mode first */
-- 
1.8.2.3

