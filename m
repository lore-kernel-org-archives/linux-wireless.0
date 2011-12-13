Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:41124 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753918Ab1LMD5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 22:57:17 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: do not advertise custom regulatory domain capability
Date: Mon, 12 Dec 2011 19:56:58 -0800
Message-Id: <1323748618-29736-1-git-send-email-bzhao@marvell.com> (sfid-20111213_045739_675384_D596A84E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

mwifiex driver no longer supports it's own custom regulatory rules,
but custom regulatory domain capability is still advertised during
wiphy registration by the driver.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f02f305..d4310a4 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1396,9 +1396,6 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	memcpy(wdev->wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-	/* We are using custom domains */
-	wdev->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-
 	/* Reserve space for bss band information */
 	wdev->wiphy->bss_priv_size = sizeof(u8);
 
-- 
1.7.0.2

