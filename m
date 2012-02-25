Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59696 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751206Ab2BYFim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 00:38:42 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.3] mwifiex: reset encryption mode flag before association
Date: Fri, 24 Feb 2012 21:35:35 -0800
Message-Id: <1330148136-28867-1-git-send-email-bzhao@marvell.com> (sfid-20120225_063844_420689_B44A0B0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Recent commit
"mwifiex: clear previous security setting during association"
fixes association failure problems observed in some corner cases
by clearing previous security setting before each association.

We should reset encryption mode flag as well. This patch takes care
of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8d8ee63..e4e6d7d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -872,6 +872,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	priv->sec_info.wpa_enabled = false;
 	priv->sec_info.wpa2_enabled = false;
 	priv->wep_key_curr_index = 0;
+	priv->sec_info.encryption_mode = 0;
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
-- 
1.7.0.2

