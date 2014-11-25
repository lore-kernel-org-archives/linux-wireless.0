Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14338 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaKYOof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:35 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/5] mwifiex: fix scan problem on big endian platforms
Date: Tue, 25 Nov 2014 06:43:03 -0800
Message-ID: <1416926586-19286-3-git-send-email-akarwar@marvell.com> (sfid-20141125_154438_415126_1D238058)
In-Reply-To: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
References: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds missing endian conversion for beacon size while
processing scan response.

Reported-by: Daniel Mosquera <daniel.mosquera@ctag.com>
Tested-by: Daniel Mosquera <daniel.mosquera@ctag.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 3a17821..984a7a4 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1623,7 +1623,7 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 
 	if (*bytes_left >= sizeof(beacon_size)) {
 		/* Extract & convert beacon size from command buffer */
-		memcpy(&beacon_size, *bss_info, sizeof(beacon_size));
+		beacon_size = le16_to_cpu(*(__le16 *)(*bss_info));
 		*bytes_left -= sizeof(beacon_size);
 		*bss_info += sizeof(beacon_size);
 	}
-- 
1.8.1.4

