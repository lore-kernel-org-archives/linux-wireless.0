Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44376 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757388Ab2EBCyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 22:54:08 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix coding style issue in mwifiex_deauthenticate
Date: Tue,  1 May 2012 19:53:51 -0700
Message-Id: <1335927231-19465-1-git-send-email-bzhao@marvell.com> (sfid-20120502_045434_561037_6A1E06EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Documentation/CodingStyle says
"Do not unnecessarily use braces where a single statement will do."

Use "switch/case", instead of "if/else_if/else", so that more cases
can be added later.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 8a39098..aeb0b3f 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1377,19 +1377,21 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv, u8 *mac)
  */
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 {
-	int ret = 0;
+	if (!priv->media_connected)
+		return 0;
 
-	if (priv->media_connected) {
-		if (priv->bss_mode == NL80211_IFTYPE_STATION) {
-			ret = mwifiex_deauthenticate_infra(priv, mac);
-		} else if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
-			ret = mwifiex_send_cmd_sync(priv,
-						HostCmd_CMD_802_11_AD_HOC_STOP,
-						HostCmd_ACT_GEN_SET, 0, NULL);
-		}
+	switch (priv->bss_mode) {
+	case NL80211_IFTYPE_STATION:
+		return mwifiex_deauthenticate_infra(priv, mac);
+	case NL80211_IFTYPE_ADHOC:
+		return mwifiex_send_cmd_sync(priv,
+					     HostCmd_CMD_802_11_AD_HOC_STOP,
+					     HostCmd_ACT_GEN_SET, 0, NULL);
+	default:
+		break;
 	}
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_deauthenticate);
 
-- 
1.7.0.2

