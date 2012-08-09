Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:43128 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab2HICY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 22:24:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: notify cfg80211 about MIC failures
Date: Wed,  8 Aug 2012 19:02:56 -0700
Message-Id: <1344477776-15874-1-git-send-email-bzhao@marvell.com> (sfid-20120809_042522_393661_4DD55336)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Call cfg80211_michael_mic_failure() handler when there is a MIC error
event from firmware.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 4758d30..dff51d5 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -278,10 +278,16 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_MIC_ERR_UNICAST:
 		dev_dbg(adapter->dev, "event: UNICAST MIC ERROR\n");
+		cfg80211_michael_mic_failure(priv->netdev, priv->cfg_bssid,
+					     NL80211_KEYTYPE_PAIRWISE,
+					     -1, NULL, GFP_KERNEL);
 		break;
 
 	case EVENT_MIC_ERR_MULTICAST:
 		dev_dbg(adapter->dev, "event: MULTICAST MIC ERROR\n");
+		cfg80211_michael_mic_failure(priv->netdev, priv->cfg_bssid,
+					     NL80211_KEYTYPE_GROUP,
+					     -1, NULL, GFP_KERNEL);
 		break;
 	case EVENT_MIB_CHANGED:
 	case EVENT_INIT_DONE:
-- 
1.7.0.2

