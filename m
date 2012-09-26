Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:41059 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab2IZD3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:29:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/15] mwifiex: process remain on channel expired event
Date: Tue, 25 Sep 2012 20:23:37 -0700
Message-Id: <1348629825-12001-8-git-send-email-bzhao@marvell.com> (sfid-20120926_052919_864771_FB4D423C)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Process remain on channel expired event, and notify cfg80211.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        |    1 +
 drivers/net/wireless/mwifiex/sta_event.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9818cae..b8a07ad 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -392,6 +392,7 @@ enum ENH_PS_MODES {
 #define EVENT_BW_CHANGE                 0x00000048
 #define EVENT_UAP_MIC_COUNTERMEASURES   0x0000004c
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
+#define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 
 #define EVENT_ID_MASK                   0xffff
 #define BSS_NUM_MASK                    0xf
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index dff51d5..aafde30 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -410,6 +410,18 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: HOSTWAKE_STAIE %d\n", eventcause);
 		break;
 
+	case EVENT_REMAIN_ON_CHAN_EXPIRED:
+		dev_dbg(adapter->dev, "event: Remain on channel expired\n");
+		cfg80211_remain_on_channel_expired(priv->wdev,
+						   priv->roc_cfg.cookie,
+						   &priv->roc_cfg.chan,
+						   priv->roc_cfg.chan_type,
+						   GFP_ATOMIC);
+
+		memset(&priv->roc_cfg, 0x00, sizeof(struct mwifiex_roc_cfg));
+
+		break;
+
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
-- 
1.7.0.2

