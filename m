Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:52723 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756129Ab2GLBbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 21:31:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	"3.2.y, 3.3.y, 3.4.y" <stable@vger.kernel.org>
Subject: [PATCH 3.5] mwifiex: correction in mcs index check
Date: Wed, 11 Jul 2012 18:12:57 -0700
Message-Id: <1342055577-21328-1-git-send-email-bzhao@marvell.com> (sfid-20120712_033234_270271_3C829ECE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

mwifiex driver supports 2x2 chips as well. Hence valid mcs values
are 0 to 15. The check for mcs index is corrected in this patch.

For example: if 40MHz is enabled and mcs index is 11, "iw link"
command would show "tx bitrate: 108.0 MBit/s" without this patch.
Now it shows "tx bitrate: 108.0 MBit/s MCS 11 40Mhz" with the patch.

Cc: "3.2.y, 3.3.y, 3.4.y" <stable@vger.kernel.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6c57e83..c2a31d1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -652,9 +652,9 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 
 	/*
 	 * Bit 0 in tx_htinfo indicates that current Tx rate is 11n rate. Valid
-	 * MCS index values for us are 0 to 7.
+	 * MCS index values for us are 0 to 15.
 	 */
-	if ((priv->tx_htinfo & BIT(0)) && (priv->tx_rate < 8)) {
+	if ((priv->tx_htinfo & BIT(0)) && (priv->tx_rate < 16)) {
 		sinfo->txrate.mcs = priv->tx_rate;
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
 		/* 40MHz rate */
-- 
1.7.0.2

