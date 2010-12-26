Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:38509 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab0LZLYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 06:24:39 -0500
Subject: [RFC PATCH 3/6] zd1211rw: let zd_set_beacon_interval() set
	dtim_period and add AP-beacon flag
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sun, 26 Dec 2010 13:24:33 +0200
Message-ID: <20101226112433.31775.89617.stgit@fate.lan>
In-Reply-To: <20101226112404.31775.77854.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   11 ++++++-----
 drivers/net/wireless/zd1211rw/zd_chip.h |    3 ++-
 drivers/net/wireless/zd1211rw/zd_mac.c  |   22 +++++++++++++---------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 91bf8bc..fdbf6ea 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -888,7 +888,8 @@ static int set_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 }
 
 
-static int set_beacon_interval(struct zd_chip *chip, u32 interval)
+static int set_beacon_interval(struct zd_chip *chip, u32 interval,
+			       u16 dtim_period)
 {
 	int r;
 	struct aw_pt_bi s;
@@ -897,16 +898,16 @@ static int set_beacon_interval(struct zd_chip *chip, u32 interval)
 	r = get_aw_pt_bi(chip, &s);
 	if (r)
 		return r;
-	s.beacon_interval = interval;
+	s.beacon_interval = interval | (dtim_period << 16);
 	return set_aw_pt_bi(chip, &s);
 }
 
-int zd_set_beacon_interval(struct zd_chip *chip, u32 interval)
+int zd_set_beacon_interval(struct zd_chip *chip, u32 interval, u16 dtim_period)
 {
 	int r;
 
 	mutex_lock(&chip->mutex);
-	r = set_beacon_interval(chip, interval);
+	r = set_beacon_interval(chip, interval, dtim_period);
 	mutex_unlock(&chip->mutex);
 	return r;
 }
@@ -925,7 +926,7 @@ static int hw_init(struct zd_chip *chip)
 	if (r)
 		return r;
 
-	return set_beacon_interval(chip, 100);
+	return set_beacon_interval(chip, 100, 0);
 }
 
 static zd_addr_t fw_reg_addr(struct zd_chip *chip, u16 offset)
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 7b0c58c..1e791ba 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -546,6 +546,7 @@ enum {
 #define RX_FILTER_CTRL (RX_FILTER_RTS | RX_FILTER_CTS | \
 	RX_FILTER_CFEND | RX_FILTER_CFACK)
 
+#define BCN_MODE_AP			0x1000000
 #define BCN_MODE_IBSS			0x2000000
 
 /* Monitor mode sets filter to 0xfffff */
@@ -921,7 +922,7 @@ enum led_status {
 
 int zd_chip_control_leds(struct zd_chip *chip, enum led_status status);
 
-int zd_set_beacon_interval(struct zd_chip *chip, u32 interval);
+int zd_set_beacon_interval(struct zd_chip *chip, u32 interval, u16 dtim_period);
 
 static inline int zd_get_beacon_interval(struct zd_chip *chip, u32 *interval)
 {
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index d3f454b..71a7576 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -919,7 +919,7 @@ static void zd_op_remove_interface(struct ieee80211_hw *hw,
 	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->type = NL80211_IFTYPE_UNSPECIFIED;
 	mac->vif = NULL;
-	zd_set_beacon_interval(&mac->chip, 0);
+	zd_set_beacon_interval(&mac->chip, 0, 0);
 	zd_write_mac_addr(&mac->chip, NULL);
 }
 
@@ -1081,15 +1081,19 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 
 		if (changes & BSS_CHANGED_BEACON_ENABLED) {
-			u32 interval;
-
-			if (bss_conf->enable_beacon)
-				interval = BCN_MODE_IBSS |
-						bss_conf->beacon_int;
-			else
-				interval = 0;
+			u32 interval = 0;
+			u16 period = 0;
+
+			if (bss_conf->enable_beacon) {
+				period = bss_conf->dtim_period;
+				interval = bss_conf->beacon_int;
+				if (mac->type == NL80211_IFTYPE_AP)
+					interval |= BCN_MODE_AP;
+				else
+					interval |= BCN_MODE_IBSS;
+			}
 
-			zd_set_beacon_interval(&mac->chip, interval);
+			zd_set_beacon_interval(&mac->chip, interval, period);
 		}
 	} else
 		associated = is_valid_ether_addr(bss_conf->bssid);

