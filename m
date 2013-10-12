Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55635 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab3JLBcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 21:32:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.12 1/2] mwifiex: inform cfg80211 about disconnect if device is removed
Date: Fri, 11 Oct 2013 18:31:31 -0700
Message-ID: <1381541492-28226-1-git-send-email-bzhao@marvell.com> (sfid-20131012_033214_088222_98DD3C0B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

If device is surprise removed, commands sent to FW including
deauthenticate command fail as bus writes fail.
We update our media_connected status to false and inform cfg80211
about disconnection only when command is successful. Since cfg80211
assumes device is still connected, it results into following
WARN_ON during unload:

WARNING: CPU: 0 PID: 18245 at net/wireless/core.c:937
         cfg80211_netdev_notifier_call+0x175/0x4d0 [cfg80211]()

Avoid this by emitting cfg80211_disconnected event even if the
deauthenticate command fails.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 717fbe2..4e4686e 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1422,13 +1422,19 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv, u8 *mac)
  */
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 {
+	int ret = 0;
+
 	if (!priv->media_connected)
 		return 0;
 
 	switch (priv->bss_mode) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-		return mwifiex_deauthenticate_infra(priv, mac);
+		ret = mwifiex_deauthenticate_infra(priv, mac);
+		if (ret)
+			cfg80211_disconnected(priv->netdev, 0, NULL, 0,
+					      GFP_KERNEL);
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		return mwifiex_send_cmd_sync(priv,
 					     HostCmd_CMD_802_11_AD_HOC_STOP,
@@ -1440,7 +1446,7 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_deauthenticate);
 
-- 
1.8.2.3

