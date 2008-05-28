Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4497 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYE1N6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 09:58:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Colin Lai <colin_sh@163.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: avoid NULL dereference in max2820_rf_set_channel
Date: Wed, 28 May 2008 09:49:07 -0400
Message-Id: <1211982547-8577-1-git-send-email-linville@tuxdriver.com> (sfid-20080528_155828_873600_99C05015)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The static function max2820_rf_set_channel is called with conf == NULL
within its compilation unit.  Originally this defaulted to b/g channel
1, but "cfg80211 API for channels/bitrates, mac80211 and driver
conversion" (commit 8318d78a44d49ac1edf2bdec7299de3617c4232e) mistakenly
dropped this check.  This patch minimally restores the expected
behavior.

Reported-by: Colin Lai <colin_sh@163.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl8180_max2820.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_max2820.c b/drivers/net/wireless/rtl8180_max2820.c
index a34dfd3..a140c80 100644
--- a/drivers/net/wireless/rtl8180_max2820.c
+++ b/drivers/net/wireless/rtl8180_max2820.c
@@ -78,7 +78,8 @@ static void max2820_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel = conf ?
+		ieee80211_frequency_to_channel(conf->channel->center_freq) : 1;
 	unsigned int chan_idx = channel - 1;
 	u32 txpw = priv->channels[chan_idx].hw_value & 0xFF;
 	u32 chan = max2820_chan[chan_idx];
-- 
1.5.4.5

