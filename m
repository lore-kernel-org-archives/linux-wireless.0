Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:58925 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab3G2XdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 19:33:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.11 2/3] mwifiex: fix wrong data rates in P2P client
Date: Mon, 29 Jul 2013 16:32:38 -0700
Message-ID: <1375140759-29767-2-git-send-email-bzhao@marvell.com> (sfid-20130730_013305_651301_C07A6236)
In-Reply-To: <1375140759-29767-1-git-send-email-bzhao@marvell.com>
References: <1375140759-29767-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes an issue wherein adhoc rates were being copied
into association request from P2P client.

Cc: <stable@vger.kernel.org> # 3.10.y
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 988552d..5178c46 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -415,7 +415,8 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 	u32 k = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		switch (adapter->config_bands) {
 		case BAND_B:
 			dev_dbg(adapter->dev, "info: infra band=%d "
-- 
1.8.2.3

