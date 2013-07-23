Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:47421 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab3GWCSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Stone Piao <piaoyun@marvell.com>
Subject: [PATCH 08/21] mwifiex: support to send deauth for P2P client
Date: Mon, 22 Jul 2013 19:17:45 -0700
Message-ID: <1374545878-15683-9-git-send-email-bzhao@marvell.com> (sfid-20130723_041904_713433_2566F1EA)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

During P2P handshake, P2P client needs to send deauth after EAPOL
FAILURE to GO. We need add bss mode for P2P client when handle deauth
request.

Without this change, deauth can not be sent out from P2P client side.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 1c8a771..ba043ca 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1425,6 +1425,7 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 
 	switch (priv->bss_mode) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		return mwifiex_deauthenticate_infra(priv, mac);
 	case NL80211_IFTYPE_ADHOC:
 		return mwifiex_send_cmd_sync(priv,
-- 
1.8.2.3

