Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48174 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755017Ab2CHDhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 22:37:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: correction in number of bitrates
Date: Wed,  7 Mar 2012 19:36:07 -0800
Message-Id: <1331177767-23005-1-git-send-email-bzhao@marvell.com> (sfid-20120308_043756_812508_E3C9DED5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In recent commit "mwifiex: correct bitrates advertised..", we have
removed 22Mbps and 72Mbps bitrates from supported bitrate array.
It means number of bitrates has reduced from 14 to 12.

Initialize ".n_bitrates" to array size instead of hardcoding it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b4890a0..84508b0 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -646,7 +646,7 @@ static struct ieee80211_supported_band mwifiex_band_2ghz = {
 	.channels = mwifiex_channels_2ghz,
 	.n_channels = ARRAY_SIZE(mwifiex_channels_2ghz),
 	.bitrates = mwifiex_rates,
-	.n_bitrates = 14,
+	.n_bitrates = ARRAY_SIZE(mwifiex_rates),
 };
 
 static struct ieee80211_channel mwifiex_channels_5ghz[] = {
-- 
1.7.0.2

