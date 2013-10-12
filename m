Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55580 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742Ab3JLBbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 21:31:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.12 2/2] mwifiex: inform cfg80211 about disconnect for P2P client interface
Date: Fri, 11 Oct 2013 18:31:32 -0700
Message-ID: <1381541492-28226-2-git-send-email-bzhao@marvell.com> (sfid-20131012_033212_545838_36F57C2E)
In-Reply-To: <1381541492-28226-1-git-send-email-bzhao@marvell.com>
References: <1381541492-28226-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds missing cfg80211_disconnected event for P2P client
interface upon successful deauthenticate command, deauthenticate
event or disassociate event from FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 8b05752..8c351f7 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -118,7 +118,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	dev_dbg(adapter->dev,
 		"info: successfully disconnected from %pM: reason code %d\n",
 		priv->cfg_bssid, reason_code);
-	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		cfg80211_disconnected(priv->netdev, reason_code, NULL, 0,
 				      GFP_KERNEL);
 	}
-- 
1.8.2.3

