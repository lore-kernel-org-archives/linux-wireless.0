Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:45186 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1AaSsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:31 -0500
Subject: [PATCH 09/22] zd1211rw: let zd_set_beacon_interval() set dtim_period
	and add AP-beacon flag
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:48:25 +0200
Message-ID: <20110131184825.10044.55218.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for AP-mode beacon. Also disable beacon when interface is set
down as otherwise hw will keep flooding NEXT_BCN interrupts.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   33 ++++++++++++++++++++++++++-----
 drivers/net/wireless/zd1211rw/zd_chip.h |    4 +++-
 drivers/net/wireless/zd1211rw/zd_mac.c  |   17 ++++++++--------
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 71d3cde..d8dc927 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -888,14 +888,36 @@ static int set_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 }
 
 
-static int set_beacon_interval(struct zd_chip *chip, u32 interval)
+static int set_beacon_interval(struct zd_chip *chip, u16 interval,
+			       u8 dtim_period, int type)
 {
 	int r;
 	struct aw_pt_bi s;
+	u32 b_interval, mode_flag;
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
 
-	r = zd_iowrite32_locked(chip, interval, CR_BCN_INTERVAL);
+	if (interval > 0) {
+		switch (type) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
+			mode_flag = BCN_MODE_IBSS;
+			break;
+		case NL80211_IFTYPE_AP:
+			mode_flag = BCN_MODE_AP;
+			break;
+		default:
+			mode_flag = 0;
+			break;
+		}
+	} else {
+		dtim_period = 0;
+		mode_flag = 0;
+	}
+
+	b_interval = mode_flag | (dtim_period << 16) | interval;
+
+	r = zd_iowrite32_locked(chip, b_interval, CR_BCN_INTERVAL);
 	if (r)
 		return r;
 	r = get_aw_pt_bi(chip, &s);
@@ -904,12 +926,13 @@ static int set_beacon_interval(struct zd_chip *chip, u32 interval)
 	return set_aw_pt_bi(chip, &s);
 }
 
-int zd_set_beacon_interval(struct zd_chip *chip, u32 interval)
+int zd_set_beacon_interval(struct zd_chip *chip, u16 interval, u8 dtim_period,
+			   int type)
 {
 	int r;
 
 	mutex_lock(&chip->mutex);
-	r = set_beacon_interval(chip, interval);
+	r = set_beacon_interval(chip, interval, dtim_period, type);
 	mutex_unlock(&chip->mutex);
 	return r;
 }
@@ -928,7 +951,7 @@ static int hw_init(struct zd_chip *chip)
 	if (r)
 		return r;
 
-	return set_beacon_interval(chip, 100);
+	return set_beacon_interval(chip, 100, 0, NL80211_IFTYPE_UNSPECIFIED);
 }
 
 static zd_addr_t fw_reg_addr(struct zd_chip *chip, u16 offset)
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 7b0c58c..14e4402 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -546,6 +546,7 @@ enum {
 #define RX_FILTER_CTRL (RX_FILTER_RTS | RX_FILTER_CTS | \
 	RX_FILTER_CFEND | RX_FILTER_CFACK)
 
+#define BCN_MODE_AP			0x1000000
 #define BCN_MODE_IBSS			0x2000000
 
 /* Monitor mode sets filter to 0xfffff */
@@ -921,7 +922,8 @@ enum led_status {
 
 int zd_chip_control_leds(struct zd_chip *chip, enum led_status status);
 
-int zd_set_beacon_interval(struct zd_chip *chip, u32 interval);
+int zd_set_beacon_interval(struct zd_chip *chip, u16 interval, u8 dtim_period,
+			   int type);
 
 static inline int zd_get_beacon_interval(struct zd_chip *chip, u32 *interval)
 {
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 84ac95e..1bd275b 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -926,7 +926,7 @@ static void zd_op_remove_interface(struct ieee80211_hw *hw,
 	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->type = NL80211_IFTYPE_UNSPECIFIED;
 	mac->vif = NULL;
-	zd_set_beacon_interval(&mac->chip, 0);
+	zd_set_beacon_interval(&mac->chip, 0, 0, NL80211_IFTYPE_UNSPECIFIED);
 	zd_write_mac_addr(&mac->chip, NULL);
 }
 
@@ -1058,15 +1058,16 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 
 		if (changes & BSS_CHANGED_BEACON_ENABLED) {
-			u32 interval;
+			u16 interval = 0;
+			u8 period = 0;
 
-			if (bss_conf->enable_beacon)
-				interval = BCN_MODE_IBSS |
-						bss_conf->beacon_int;
-			else
-				interval = 0;
+			if (bss_conf->enable_beacon) {
+				period = bss_conf->dtim_period;
+				interval = bss_conf->beacon_int;
+			}
 
-			zd_set_beacon_interval(&mac->chip, interval);
+			zd_set_beacon_interval(&mac->chip, interval, period,
+					       mac->type);
 		}
 	} else
 		associated = is_valid_ether_addr(bss_conf->bssid);

