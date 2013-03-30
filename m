Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:55134 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381Ab3C3CV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 22:21:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9] mwifiex: limit channel number not to overflow memory
Date: Fri, 29 Mar 2013 19:21:21 -0700
Message-ID: <1364610081-29210-1-git-send-email-bzhao@marvell.com> (sfid-20130330_032139_724162_4AD58C7B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Limit the channel number in scan request, or the driver scan
config structure memory will be overflowed.

Cc: <stable@vger.kernel.org> # 3.5+
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8f161e1..4701294 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1904,7 +1904,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		}
 	}
 
-	for (i = 0; i < request->n_channels; i++) {
+	for (i = 0; i < min_t(u32, request->n_channels,
+			      MWIFIEX_USER_SCAN_CHAN_MAX); i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
-- 
1.7.0.2

