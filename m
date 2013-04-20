Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:50796 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965218Ab3DTAvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 20:51:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Stone Piao <piaoyun@marvell.com>
Subject: [PATCH] mwifiex: configure p2p interface during initialization
Date: Fri, 19 Apr 2013 17:44:41 -0700
Message-ID: <1366418684-6148-1-git-send-email-bzhao@marvell.com> (sfid-20130420_025119_424433_4FF0B2B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send P2P_MODE_CFG cmd to firmware when p2p interface is created.
Without proper p2p configuration firmware may behave incorrectly
while handling commands sent through this interface.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8c468c3..2a604eb 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2152,6 +2152,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_started = 0;
 		priv->bss_num = 0;
 
+		if (mwifiex_cfg80211_init_p2p_client(priv))
+			return ERR_PTR(-EFAULT);
+
 		break;
 	default:
 		wiphy_err(wiphy, "type not supported\n");
-- 
1.7.0.2

