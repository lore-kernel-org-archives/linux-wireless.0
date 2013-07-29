Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:50438 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab3G2Xcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 19:32:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.11 3/3] mwifiex: fix command 0x2c timeout during p2p_find or p2p_connect
Date: Mon, 29 Jul 2013 16:32:39 -0700
Message-ID: <1375140759-29767-3-git-send-email-bzhao@marvell.com> (sfid-20130730_013258_091665_D9D11E2C)
In-Reply-To: <1375140759-29767-1-git-send-email-bzhao@marvell.com>
References: <1375140759-29767-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

We missed bss_mode check for P2P client.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index c071ce9..f084412 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -257,10 +257,10 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 			goto done;
 	}
 
-	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		u8 config_bands;
 
-		/* Infra mode */
 		ret = mwifiex_deauthenticate(priv, NULL);
 		if (ret)
 			goto done;
-- 
1.8.2.3

