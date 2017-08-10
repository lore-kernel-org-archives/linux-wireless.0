Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32977 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751456AbdHJMra (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 08:47:30 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/2] mwifiex: check for NL80211_SCAN_FLAG_RANDOM_ADDR during hidden SSID scan
Date: Thu, 10 Aug 2017 18:11:26 +0530
Message-ID: <1502368886-16539-3-git-send-email-gbhat@marvell.com> (sfid-20170810_144732_724713_8AD7D792)
In-Reply-To: <1502368886-16539-1-git-send-email-gbhat@marvell.com>
References: <1502368886-16539-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the end of user scan request, driver will perform an active
scan for hidden SSIDs in passive channels. While doing this,
driver unconditionally adding random_mac in scan command, which
is no expected. It should add random_mac only if scan_request
has NL80211_SCAN_FLAG_RANDOM_ADDR flag set.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 79b4aff..c9d41ed 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1947,7 +1947,8 @@ static void mwifiex_complete_scan(struct mwifiex_private *priv)
 	}
 
 	adapter->active_scan_triggered = true;
-	ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
+	if (priv->scan_request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
+		ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
 	user_scan_cfg->num_ssids = priv->scan_request->n_ssids;
 	user_scan_cfg->ssid_list = priv->scan_request->ssids;
 
-- 
1.9.1
