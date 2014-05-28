Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9511 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbaE1Eju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 00:39:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: change hscfg gap parameter to avoid potential firmware deadlock
Date: Tue, 27 May 2014 21:39:34 -0700
Message-ID: <1401251974-18738-3-git-send-email-bzhao@marvell.com> (sfid-20140528_063953_468774_CF8F528F)
In-Reply-To: <1401251974-18738-1-git-send-email-bzhao@marvell.com>
References: <1401251974-18738-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If host sleep parameter gap is set to 0xff, firmware will wait
for an ack from host to confirm the success of host wakeup.
This prevents firmware from uploading data packet before host
actually wakes up.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 42eaeda..3175dd0 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -405,7 +405,7 @@ enum P2P_MODES {
 #define HS_CFG_CANCEL			0xffffffff
 #define HS_CFG_COND_DEF			0x00000000
 #define HS_CFG_GPIO_DEF			0xff
-#define HS_CFG_GAP_DEF			0
+#define HS_CFG_GAP_DEF			0xff
 #define HS_CFG_COND_BROADCAST_DATA	0x00000001
 #define HS_CFG_COND_UNICAST_DATA	0x00000002
 #define HS_CFG_COND_MAC_EVENT		0x00000004
-- 
1.8.2.3

