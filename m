Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12668 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbcF0Itc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 04:49:32 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/3] mwifiex: clear scan_aborting flag
Date: Mon, 27 Jun 2016 14:16:28 +0530
Message-ID: <1467017189-26917-2-git-send-email-akarwar@marvell.com> (sfid-20160627_104935_942631_9D37ED7F)
In-Reply-To: <1467017189-26917-1-git-send-email-akarwar@marvell.com>
References: <1467017189-26917-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag should be cleaned along with other scan operation variables.
This was missing at some places.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index e331122..96d0d86 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1960,6 +1960,7 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 				    "info: notifying scan done\n");
 			cfg80211_scan_done(priv->scan_request, 0);
 			priv->scan_request = NULL;
+			priv->scan_aborting = false;
 		} else {
 			priv->scan_aborting = false;
 			mwifiex_dbg(adapter, INFO,
@@ -1981,6 +1982,7 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 					    "info: aborting scan\n");
 				cfg80211_scan_done(priv->scan_request, 1);
 				priv->scan_request = NULL;
+				priv->scan_aborting = false;
 			} else {
 				priv->scan_aborting = false;
 				mwifiex_dbg(adapter, INFO,
@@ -2022,6 +2024,7 @@ void mwifiex_cancel_scan(struct mwifiex_adapter *adapter)
 					    "info: aborting scan\n");
 				cfg80211_scan_done(priv->scan_request, 1);
 				priv->scan_request = NULL;
+				priv->scan_aborting = false;
 			}
 		}
 	}
-- 
1.9.1

