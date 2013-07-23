Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58140 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab3GWCSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Stone Piao <piaoyun@marvell.com>
Subject: [PATCH 06/21] mwifiex: discard deauth and disassoc event during WPS session
Date: Mon, 22 Jul 2013 19:17:43 -0700
Message-ID: <1374545878-15683-7-git-send-email-bzhao@marvell.com> (sfid-20130723_041901_737468_69DE4704)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Some GO will send deauth or disassoc packet at the end of WPS
handshake, which causes P2P connecion failure due to the race
condition between event path and data path.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index ea265ec..8b05752 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -201,6 +201,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_DEAUTHENTICATED:
 		dev_dbg(adapter->dev, "event: Deauthenticated\n");
+		if (priv->wps.session_enable) {
+			dev_dbg(adapter->dev,
+				"info: receive deauth event in wps session\n");
+			break;
+		}
 		adapter->dbg.num_event_deauth++;
 		if (priv->media_connected) {
 			reason_code =
@@ -211,6 +216,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_DISASSOCIATED:
 		dev_dbg(adapter->dev, "event: Disassociated\n");
+		if (priv->wps.session_enable) {
+			dev_dbg(adapter->dev,
+				"info: receive disassoc event in wps session\n");
+			break;
+		}
 		adapter->dbg.num_event_disassoc++;
 		if (priv->media_connected) {
 			reason_code =
-- 
1.8.2.3

