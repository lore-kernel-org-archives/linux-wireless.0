Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0JKBLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 21:11:07 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1403810bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 18:11:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: store info about current channel's type
Date: Mon, 11 Oct 2010 03:11:02 +0200
Message-Id: <1286759463-32221-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1286759463-32221-1-git-send-email-zajec5@gmail.com>
References: <1286759463-32221-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.h |    4 +++-
 drivers/net/wireless/b43/phy_n.c      |   14 ++++++++++----
 drivers/net/wireless/b43/phy_n.h      |    1 -
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index bd480b4..6dcd033 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -2,6 +2,7 @@
 #define LINUX_B43_PHY_COMMON_H_
 
 #include <linux/types.h>
+#include <linux/nl80211.h>
 
 struct b43_wldev;
 
@@ -250,8 +251,9 @@ struct b43_phy {
 	 * check is needed. */
 	unsigned long next_txpwr_check_time;
 
-	/* current channel */
+	/* Current channel */
 	unsigned int channel;
+	enum nl80211_channel_type channel_type;
 
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c596b46..88a4411 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -74,6 +74,13 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
 
+static inline bool b43_channel_type_is_40mhz(
+					enum nl80211_channel_type channel_type)
+{
+	return (channel_type == NL80211_CHAN_HT40MINUS ||
+		channel_type == NL80211_CHAN_HT40PLUS);
+}
+
 static inline bool b43_empty_chanspec(struct b43_chanspec *chanspec)
 {
 	return !chanspec->channel && !chanspec->sideband &&
@@ -3404,10 +3411,9 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 
 	nphy->radio_chanspec.channel = channel->hw_value;
 
-	/*
-	if (chanspec.b_width != nphy->b_width)
-		; TODO: BMAC BW Set (chanspec.b_width)
-	*/
+	if (b43_channel_type_is_40mhz(phy->channel_type) !=
+		b43_channel_type_is_40mhz(channel_type))
+		; /* TODO: BMAC BW Set (channel_type) */
 
 	if (channel_type == NL80211_CHAN_HT40PLUS)
 		b43_phy_set(dev, B43_NPHY_RXCTL,
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 8b6d570..e7acae2 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -984,7 +984,6 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
-	u8 b_width;
 	struct b43_chanspec radio_chanspec;
 
 	bool gain_boost;
-- 
1.7.1

