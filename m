Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40927 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759925Ab0JIAjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 20:39:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: lrodriguez@atheros.com, br1@einfach.org
Subject: [PATCH 2/3] ath9k: add compile time checking for the size of the channel list
Date: Sat,  9 Oct 2010 02:39:30 +0200
Message-Id: <1286584771-76663-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286584771-76663-1-git-send-email-nbd@openwrt.org>
References: <1286584771-76663-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents random memory corruption if the number of channels ever gets
changed without an update to the internal channel array size.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.h   |    4 +++-
 drivers/net/wireless/ath/ath9k/init.c |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7f696c8..6b92334 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -61,6 +61,8 @@
 
 #define ATH9K_RSSI_BAD			-128
 
+#define ATH9K_NUM_CHANNELS	38
+
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
 	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
@@ -618,7 +620,7 @@ struct ath_hw {
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
 	struct ath9k_hw_capabilities caps;
-	struct ath9k_channel channels[38];
+	struct ath9k_channel channels[ATH9K_NUM_CHANNELS];
 	struct ath9k_channel *curchan;
 
 	union {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d76003c..a4c5ed4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -481,6 +481,10 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 {
 	void *channels;
 
+	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
+		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
+		     ATH9K_NUM_CHANNELS);
+
 	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
 		channels = kmemdup(ath9k_2ghz_chantable,
 			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
-- 
1.7.2.2

