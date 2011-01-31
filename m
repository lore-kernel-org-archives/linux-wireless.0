Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:56683 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1AaSsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:12 -0500
Subject: [PATCH 07/22] zd1211rw: support setting BSSID for AP mode
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:48:06 +0200
Message-ID: <20110131184806.10044.25492.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   39 +++++++++++++++++++++++--------
 drivers/net/wireless/zd1211rw/zd_chip.h |    1 +
 drivers/net/wireless/zd1211rw/zd_mac.c  |   25 +++++++++++++++++++-
 drivers/net/wireless/zd1211rw/zd_mac.h  |    1 +
 4 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 447f236..71d3cde 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -370,16 +370,12 @@ error:
 	return r;
 }
 
-/* MAC address: if custom mac addresses are to be used CR_MAC_ADDR_P1 and
- *              CR_MAC_ADDR_P2 must be overwritten
- */
-int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
+static int zd_write_mac_addr_common(struct zd_chip *chip, const u8 *mac_addr,
+				    const struct zd_ioreq32 *in_reqs,
+				    const char *type)
 {
 	int r;
-	struct zd_ioreq32 reqs[2] = {
-		[0] = { .addr = CR_MAC_ADDR_P1 },
-		[1] = { .addr = CR_MAC_ADDR_P2 },
-	};
+	struct zd_ioreq32 reqs[2] = {in_reqs[0], in_reqs[1]};
 
 	if (mac_addr) {
 		reqs[0].value = (mac_addr[3] << 24)
@@ -388,9 +384,9 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 			      |  mac_addr[0];
 		reqs[1].value = (mac_addr[5] <<  8)
 			      |  mac_addr[4];
-		dev_dbg_f(zd_chip_dev(chip), "mac addr %pM\n", mac_addr);
+		dev_dbg_f(zd_chip_dev(chip), "%s addr %pM\n", type, mac_addr);
 	} else {
-		dev_dbg_f(zd_chip_dev(chip), "set NULL mac\n");
+		dev_dbg_f(zd_chip_dev(chip), "set NULL %s\n", type);
 	}
 
 	mutex_lock(&chip->mutex);
@@ -399,6 +395,29 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 	return r;
 }
 
+/* MAC address: if custom mac addresses are to be used CR_MAC_ADDR_P1 and
+ *              CR_MAC_ADDR_P2 must be overwritten
+ */
+int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
+{
+	static const struct zd_ioreq32 reqs[2] = {
+		[0] = { .addr = CR_MAC_ADDR_P1 },
+		[1] = { .addr = CR_MAC_ADDR_P2 },
+	};
+
+	return zd_write_mac_addr_common(chip, mac_addr, reqs, "mac");
+}
+
+int zd_write_bssid(struct zd_chip *chip, const u8 *bssid)
+{
+	static const struct zd_ioreq32 reqs[2] = {
+		[0] = { .addr = CR_BSSID_P1 },
+		[1] = { .addr = CR_BSSID_P2 },
+	};
+
+	return zd_write_mac_addr_common(chip, bssid, reqs, "bssid");
+}
+
 int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain)
 {
 	int r;
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index f8bbf7d..7b0c58c 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -881,6 +881,7 @@ static inline u8 _zd_chip_get_channel(struct zd_chip *chip)
 u8  zd_chip_get_channel(struct zd_chip *chip);
 int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain);
 int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr);
+int zd_write_bssid(struct zd_chip *chip, const u8 *bssid);
 int zd_chip_switch_radio_on(struct zd_chip *chip);
 int zd_chip_switch_radio_off(struct zd_chip *chip);
 int zd_chip_enable_int(struct zd_chip *chip);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 487ed33..ab0d1b9 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -231,6 +231,26 @@ static int set_rx_filter(struct zd_mac *mac)
 	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
+static int set_mac_and_bssid(struct zd_mac *mac)
+{
+	int r;
+
+	if (!mac->vif)
+		return -1;
+
+	r = zd_write_mac_addr(&mac->chip, mac->vif->addr);
+	if (r)
+		return r;
+
+	/* Vendor driver after setting MAC either sets BSSID for AP or
+	 * filter for other modes.
+	 */
+	if (mac->type != NL80211_IFTYPE_AP)
+		return set_rx_filter(mac);
+	else
+		return zd_write_bssid(&mac->chip, mac->vif->addr);
+}
+
 static int set_mc_hash(struct zd_mac *mac)
 {
 	struct zd_mc_hash hash;
@@ -888,7 +908,9 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 	}
 
-	return zd_write_mac_addr(&mac->chip, vif->addr);
+	mac->vif = vif;
+
+	return set_mac_and_bssid(mac);
 }
 
 static void zd_op_remove_interface(struct ieee80211_hw *hw,
@@ -896,6 +918,7 @@ static void zd_op_remove_interface(struct ieee80211_hw *hw,
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->type = NL80211_IFTYPE_UNSPECIFIED;
+	mac->vif = NULL;
 	zd_set_beacon_interval(&mac->chip, 0);
 	zd_write_mac_addr(&mac->chip, NULL);
 }
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index ff7ef30..0ec6bde 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -172,6 +172,7 @@ struct zd_mac {
 	spinlock_t lock;
 	spinlock_t intr_lock;
 	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vif;
 	struct housekeeping housekeeping;
 	struct work_struct set_rts_cts_work;
 	struct work_struct process_intr;

