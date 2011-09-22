Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:34981 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750804Ab1IVEnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 00:43:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: fix 5GHz association issue
Date: Wed, 21 Sep 2011 21:43:22 -0700
Message-Id: <1316666605-30954-1-git-send-email-bzhao@marvell.com> (sfid-20110922_064312_496431_ECB5C1CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Sometimes association in 5GHz doesn't work. Dmesg log shows
"Can not find requested SSID xyz" error message. Currently
while preparing scan channel list for firmware Null entries
are created for disabled channels. The routine which retrieves
this list ignores channels after Null entry. Hence sometimes
driver doesn't scan the channel of requested AP and association
fails. The issue is fixed by avoiding those NULL entries.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8d8588d..ecebff6 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -532,7 +532,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 
 		sband = priv->wdev->wiphy->bands[band];
 
-		for (i = 0; (i < sband->n_channels) ; i++, chan_idx++) {
+		for (i = 0; (i < sband->n_channels) ; i++) {
 			ch = &sband->channels[i];
 			if (ch->flags & IEEE80211_CHAN_DISABLED)
 				continue;
@@ -563,6 +563,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_DISABLE_CHAN_FILT;
 			}
+			chan_idx++;
 		}
 
 	}
-- 
1.7.0.2

