Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54894 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161114Ab2CPDwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 23:52:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] mwifiex: update signal strength in mBm units
Date: Thu, 15 Mar 2012 20:51:47 -0700
Message-Id: <1331869911-10624-2-git-send-email-bzhao@marvell.com> (sfid-20120316_045225_449495_6E281EC1)
In-Reply-To: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
References: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

During wiphy registration signal_type is initialized to
CFG80211_SIGNAL_TYPE_MBM. So convert signal strength from dBm to
mBm. Also, the value is absolute. Make it negative before
sending to cfg80211.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index aff9cd7..0c4ea5b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1667,8 +1667,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 		memcpy(bssid, bcn_param->bssid, ETH_ALEN);
 
-		rssi = (s32) (bcn_param->rssi);
-		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%02X\n", rssi);
+		rssi = (s32) bcn_param->rssi;
+		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
+		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
 
 		beacon_period = le16_to_cpu(bcn_param->beacon_period);
 
-- 
1.7.0.2

