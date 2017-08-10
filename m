Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32953 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751456AbdHJMqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 08:46:24 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/2] mwifiex: do not use random MAC for pre-association scanning
Date: Thu, 10 Aug 2017 18:11:25 +0530
Message-ID: <1502368886-16539-2-git-send-email-gbhat@marvell.com> (sfid-20170810_144628_013326_0B918513)
In-Reply-To: <1502368886-16539-1-git-send-email-gbhat@marvell.com>
References: <1502368886-16539-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver should use random MAC address only if the scan is
requested by user(provided NL80211_SCAN_FLAG_RANDOM_ADDR
is set in scan request). It should not be used for a scan
performed before association.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index d8e8b85..79b4aff 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2790,7 +2790,6 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	if (!scan_cfg)
 		return -ENOMEM;
 
-	ether_addr_copy(scan_cfg->random_mac, priv->random_mac);
 	scan_cfg->ssid_list = req_ssid;
 	scan_cfg->num_ssids = 1;
 
-- 
1.9.1
