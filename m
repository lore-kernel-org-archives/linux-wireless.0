Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12941 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaFGCsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 22:48:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Chin-Ran Lo <crlo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: wowlan: do not disconnect on suspend
Date: Fri, 6 Jun 2014 19:47:44 -0700
Message-ID: <1402109264-7095-3-git-send-email-bzhao@marvell.com> (sfid-20140607_044810_892586_E99473E8)
In-Reply-To: <1402109264-7095-1-git-send-email-bzhao@marvell.com>
References: <1402109264-7095-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For users who do not need wowlan, load mwifiex.ko with
disconnect_on_suspend = 1; or iw phy0 wowlan disable.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 536c14a..2295263 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -26,7 +26,7 @@
 #include "11n.h"
 #include "cfg80211.h"
 
-static int disconnect_on_suspend = 1;
+static int disconnect_on_suspend;
 module_param(disconnect_on_suspend, int, 0644);
 
 /*
-- 
1.8.2.3

