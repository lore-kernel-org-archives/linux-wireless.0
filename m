Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53890 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZEWTL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 15:11:26 -0400
Received: by ewy24 with SMTP id 24so2408265ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 23 May 2009 12:11:26 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: rt2x00: Remove last usage of beacon_int from ieee80211_config
Date: Sat, 23 May 2009 21:09:28 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905232109.29202.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the last usage of beacon_int inside the iee80211_config
structure from rt2x00. The attempt is a bit hackish, and subject to
change in the future when the entire rt2x00_dev structure is
cleaned up and restructured.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00config.c |    3 +++
 drivers/net/wireless/rt2x00/rt61pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |    2 +-
 7 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0197531..435f945 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -520,7 +520,7 @@ static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_SLEEP) {
 		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
 		rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
-				   (libconf->conf->beacon_int - 20) * 16);
+				   (rt2x00dev->beacon_int - 20) * 16);
 		rt2x00_set_field32(&reg, CSR20_TBCN_BEFORE_WAKEUP,
 				   libconf->conf->listen_interval - 1);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index f95cb64..08b30d0 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -569,7 +569,7 @@ static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_SLEEP) {
 		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
 		rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
-				   (libconf->conf->beacon_int - 20) * 16);
+				   (rt2x00dev->beacon_int - 20) * 16);
 		rt2x00_set_field32(&reg, CSR20_TBCN_BEFORE_WAKEUP,
 				   libconf->conf->listen_interval - 1);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 69f966f..66daf68 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -647,7 +647,7 @@ static void rt2500usb_config_ps(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_SLEEP) {
 		rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
 		rt2x00_set_field16(&reg, MAC_CSR18_DELAY_AFTER_BEACON,
-				   libconf->conf->beacon_int - 20);
+				   rt2x00dev->beacon_int - 20);
 		rt2x00_set_field16(&reg, MAC_CSR18_BEACONS_BEFORE_WAKEUP,
 				   libconf->conf->listen_interval - 1);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d1faa4f..509ab90 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -808,6 +808,11 @@ struct rt2x00_dev {
 	u8 calibration[2];
 
 	/*
+	 * Beacon interval.
+	 */
+	u16 beacon_int;
+
+	/*
 	 * Low level statistics which will have
 	 * to be kept up to date while device is running.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index c5bbf0b..3e019a1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -108,6 +108,9 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	erp.basic_rates = bss_conf->basic_rates;
 	erp.beacon_int = bss_conf->beacon_int;
 
+	/* Update global beacon interval time, this is needed for PS support */
+	rt2x00dev->beacon_int = bss_conf->beacon_int;
+
 	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a8bf5c4..49b29ff 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -956,7 +956,7 @@ static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_SLEEP) {
 		rt2x00pci_register_read(rt2x00dev, MAC_CSR11, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN,
-				   libconf->conf->beacon_int - 10);
+				   rt2x00dev->beacon_int - 10);
 		rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP,
 				   libconf->conf->listen_interval - 1);
 		rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 5);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 211a3d6..c188488 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -852,7 +852,7 @@ static void rt73usb_config_ps(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_SLEEP) {
 		rt2x00usb_register_read(rt2x00dev, MAC_CSR11, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN,
-				   libconf->conf->beacon_int - 10);
+				   rt2x00dev->beacon_int - 10);
 		rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP,
 				   libconf->conf->listen_interval - 1);
 		rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 5);
-- 
1.6.3

