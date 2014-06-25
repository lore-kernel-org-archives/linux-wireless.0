Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65348 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaFYUPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:25 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so8660474wiv.8
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/17] staging: vt6656: mac80211 conversion: add channel bands
Date: Wed, 25 Jun 2014 21:14:26 +0100
Message-Id: <1403727278-6666-6-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221631_058128_D02902AC)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rates and channels according to rf type for vnt_init_bands which is
a mac80211 replacement for CHvInitChannelTable.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/channel.c  | 139 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/vt6656/channel.h  |   2 +
 drivers/staging/vt6656/main_usb.c |   2 +
 3 files changed, 143 insertions(+)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 5a4fa0e..29c2ed3 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -36,6 +36,8 @@
 
 #include <linux/kernel.h>
 #include "country.h"
+#include "device.h"
+#include "datarate.h"
 #include "channel.h"
 #include "rf.h"
 
@@ -471,3 +473,140 @@ void CHvInitChannelTable(struct vnt_private *pDevice)
         }*/
     }
 }
+
+static struct ieee80211_rate vnt_rates_bg[] = {
+	{ .bitrate = 10,  .hw_value = RATE_1M },
+	{ .bitrate = 20,  .hw_value = RATE_2M },
+	{ .bitrate = 55,  .hw_value = RATE_5M },
+	{ .bitrate = 110, .hw_value = RATE_11M },
+	{ .bitrate = 60,  .hw_value = RATE_6M },
+	{ .bitrate = 90,  .hw_value = RATE_9M },
+	{ .bitrate = 120, .hw_value = RATE_12M },
+	{ .bitrate = 180, .hw_value = RATE_18M },
+	{ .bitrate = 240, .hw_value = RATE_24M },
+	{ .bitrate = 360, .hw_value = RATE_36M },
+	{ .bitrate = 480, .hw_value = RATE_48M },
+	{ .bitrate = 540, .hw_value = RATE_54M },
+};
+
+static struct ieee80211_rate vnt_rates_a[] = {
+	{ .bitrate = 60,  .hw_value = RATE_6M },
+	{ .bitrate = 90,  .hw_value = RATE_9M },
+	{ .bitrate = 120, .hw_value = RATE_12M },
+	{ .bitrate = 180, .hw_value = RATE_18M },
+	{ .bitrate = 240, .hw_value = RATE_24M },
+	{ .bitrate = 360, .hw_value = RATE_36M },
+	{ .bitrate = 480, .hw_value = RATE_48M },
+	{ .bitrate = 540, .hw_value = RATE_54M },
+};
+
+static struct ieee80211_channel vnt_channels_2ghz[] = {
+	{ .center_freq = 2412, .hw_value = 1 },
+	{ .center_freq = 2417, .hw_value = 2 },
+	{ .center_freq = 2422, .hw_value = 3 },
+	{ .center_freq = 2427, .hw_value = 4 },
+	{ .center_freq = 2432, .hw_value = 5 },
+	{ .center_freq = 2437, .hw_value = 6 },
+	{ .center_freq = 2442, .hw_value = 7 },
+	{ .center_freq = 2447, .hw_value = 8 },
+	{ .center_freq = 2452, .hw_value = 9 },
+	{ .center_freq = 2457, .hw_value = 10 },
+	{ .center_freq = 2462, .hw_value = 11 },
+	{ .center_freq = 2467, .hw_value = 12 },
+	{ .center_freq = 2472, .hw_value = 13 },
+	{ .center_freq = 2484, .hw_value = 14 }
+};
+
+static struct ieee80211_channel vnt_channels_5ghz[] = {
+	{ .center_freq = 4915, .hw_value = 15 },
+	{ .center_freq = 4920, .hw_value = 16 },
+	{ .center_freq = 4925, .hw_value = 17 },
+	{ .center_freq = 4935, .hw_value = 18 },
+	{ .center_freq = 4940, .hw_value = 19 },
+	{ .center_freq = 4945, .hw_value = 20 },
+	{ .center_freq = 4960, .hw_value = 21 },
+	{ .center_freq = 4980, .hw_value = 22 },
+	{ .center_freq = 5035, .hw_value = 23 },
+	{ .center_freq = 5040, .hw_value = 24 },
+	{ .center_freq = 5045, .hw_value = 25 },
+	{ .center_freq = 5055, .hw_value = 26 },
+	{ .center_freq = 5060, .hw_value = 27 },
+	{ .center_freq = 5080, .hw_value = 28 },
+	{ .center_freq = 5170, .hw_value = 29 },
+	{ .center_freq = 5180, .hw_value = 30 },
+	{ .center_freq = 5190, .hw_value = 31 },
+	{ .center_freq = 5200, .hw_value = 32 },
+	{ .center_freq = 5210, .hw_value = 33 },
+	{ .center_freq = 5220, .hw_value = 34 },
+	{ .center_freq = 5230, .hw_value = 35 },
+	{ .center_freq = 5240, .hw_value = 36 },
+	{ .center_freq = 5260, .hw_value = 37 },
+	{ .center_freq = 5280, .hw_value = 38 },
+	{ .center_freq = 5300, .hw_value = 39 },
+	{ .center_freq = 5320, .hw_value = 40 },
+	{ .center_freq = 5500, .hw_value = 41 },
+	{ .center_freq = 5520, .hw_value = 42 },
+	{ .center_freq = 5540, .hw_value = 43 },
+	{ .center_freq = 5560, .hw_value = 44 },
+	{ .center_freq = 5580, .hw_value = 45 },
+	{ .center_freq = 5600, .hw_value = 46 },
+	{ .center_freq = 5620, .hw_value = 47 },
+	{ .center_freq = 5640, .hw_value = 48 },
+	{ .center_freq = 5660, .hw_value = 49 },
+	{ .center_freq = 5680, .hw_value = 50 },
+	{ .center_freq = 5700, .hw_value = 51 },
+	{ .center_freq = 5745, .hw_value = 52 },
+	{ .center_freq = 5765, .hw_value = 53 },
+	{ .center_freq = 5785, .hw_value = 54 },
+	{ .center_freq = 5805, .hw_value = 55 },
+	{ .center_freq = 5825, .hw_value = 56 }
+};
+
+static struct ieee80211_supported_band vnt_supported_2ghz_band = {
+	.channels = vnt_channels_2ghz,
+	.n_channels = ARRAY_SIZE(vnt_channels_2ghz),
+	.bitrates = vnt_rates_bg,
+	.n_bitrates = ARRAY_SIZE(vnt_rates_bg),
+};
+
+static struct ieee80211_supported_band vnt_supported_5ghz_band = {
+	.channels = vnt_channels_5ghz,
+	.n_channels = ARRAY_SIZE(vnt_channels_5ghz),
+	.bitrates = vnt_rates_a,
+	.n_bitrates = ARRAY_SIZE(vnt_rates_a),
+};
+
+void vnt_init_bands(struct vnt_private *priv)
+{
+	struct ieee80211_channel *ch;
+	int i;
+
+	switch (priv->byRFType) {
+	case RF_AIROHA7230:
+	case RF_VT3342A0:
+		ch = vnt_channels_5ghz;
+
+		for (i = 0; i < ARRAY_SIZE(vnt_channels_5ghz); i++) {
+			ch[i].max_power = VNT_RF_MAX_POWER;
+			ch[i].flags = IEEE80211_CHAN_NO_HT40;
+		}
+
+		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+						&vnt_supported_5ghz_band;
+	/* fallthrough */
+	case RF_AL2230:
+	case RF_AL2230S:
+	case RF_VT3226:
+	case RF_VT3226D0:
+		ch = vnt_channels_2ghz;
+
+		for (i = 0; i < ARRAY_SIZE(vnt_channels_2ghz); i++) {
+			ch[i].max_power = VNT_RF_MAX_POWER;
+			ch[i].flags = IEEE80211_CHAN_NO_HT40;
+		}
+
+		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+						&vnt_supported_2ghz_band;
+		break;
+	}
+}
diff --git a/drivers/staging/vt6656/channel.h b/drivers/staging/vt6656/channel.h
index 95701e0..0d52225 100644
--- a/drivers/staging/vt6656/channel.h
+++ b/drivers/staging/vt6656/channel.h
@@ -41,4 +41,6 @@ typedef struct tagSChannelTblElement {
 bool    ChannelValid(unsigned int CountryCode, unsigned int ChannelNum);
 void    CHvInitChannelTable(struct vnt_private *pDevice);
 
+void vnt_init_bands(struct vnt_private *);
+
 #endif  /* _CHANNEL_H_ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 6f66b86..663ea0c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1378,6 +1378,8 @@ int vnt_init(struct vnt_private *priv)
 
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyPermanentNetAddr);
 
+	vnt_init_bands(priv);
+
 	if (ieee80211_register_hw(priv->hw))
 		return -ENODEV;
 
-- 
1.9.1

