Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:56616 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab2IUDY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 23:24:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: disconnect the device before entering suspend state
Date: Thu, 20 Sep 2012 20:23:17 -0700
Message-Id: <1348197798-977-1-git-send-email-bzhao@marvell.com> (sfid-20120921_052430_841318_E37BE59D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

By default, device is disconnected before entering suspend state.
User can keep the connection alive by using module parameter
"disconect_on_suspend=0".

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index d7ad2d4..731562f 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -26,6 +26,9 @@
 #include "11n.h"
 #include "cfg80211.h"
 
+static int disconnect_on_suspend = 1;
+module_param(disconnect_on_suspend, int, 0644);
+
 /*
  * Copies the multicast address list from device to driver.
  *
@@ -448,6 +451,16 @@ EXPORT_SYMBOL_GPL(mwifiex_cancel_hs);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_ds_hs_cfg hscfg;
+	struct mwifiex_private *priv;
+	int i;
+
+	if (disconnect_on_suspend) {
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (priv)
+				mwifiex_deauthenticate(priv, NULL);
+		}
+	}
 
 	if (adapter->hs_activated) {
 		dev_dbg(adapter->dev, "cmd: HS Already actived\n");
-- 
1.7.0.2

