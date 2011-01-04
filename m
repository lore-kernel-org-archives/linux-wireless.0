Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:56179 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab1ADXt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:49:57 -0500
Subject: [RFC PATCH 15/17] zd1211rw: collect driver settings and add function
	to restore theim
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:49:52 +0200
Message-ID: <20110104234952.25309.81382.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need HW hard reset later in patchset to reset device after TX-stall.
Collect all settings that we have set to driver for later reset and
add restore function.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   69 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/zd1211rw/zd_mac.h |    1 
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index bee3e21..4c3e92a 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -141,6 +141,9 @@ static void housekeeping_disable(struct zd_mac *mac);
 static void beacon_init(struct zd_mac *mac);
 static void beacon_enable(struct zd_mac *mac);
 static void beacon_disable(struct zd_mac *mac);
+static void set_rts_cts(struct zd_mac *mac, unsigned int short_preamble);
+static int zd_mac_config_beacon(struct ieee80211_hw *hw,
+				struct sk_buff *beacon);
 
 static int zd_reg2alpha2(u8 regdomain, char *alpha2)
 {
@@ -339,6 +342,68 @@ static void zd_op_stop(struct ieee80211_hw *hw)
 		dev_kfree_skb_any(skb);
 }
 
+static int zd_restore_settings(struct zd_mac *mac)
+{
+	struct sk_buff *beacon;
+	struct zd_mc_hash multicast_hash;
+	unsigned int short_preamble;
+	int r, beacon_interval, beacon_period;
+	u8 channel;
+
+	dev_dbg_f(zd_mac_dev(mac), "\n");
+
+	spin_lock_irq(&mac->lock);
+	multicast_hash = mac->multicast_hash;
+	short_preamble = mac->short_preamble;
+	beacon_interval = mac->beacon.interval;
+	beacon_period = mac->beacon.period;
+	channel = mac->channel;
+	spin_unlock_irq(&mac->lock);
+
+	r = set_mac_and_bssid(mac);
+	if (r < 0) {
+		dev_dbg_f(zd_mac_dev(mac), "set_mac_and_bssid failed, %d\n", r);
+		return r;
+	}
+
+	r = zd_chip_set_channel(&mac->chip, channel);
+	if (r < 0) {
+		dev_dbg_f(zd_mac_dev(mac), "zd_chip_set_channel failed, %d\n",
+			  r);
+		return r;
+	}
+
+	set_rts_cts(mac, short_preamble);
+
+	r = zd_chip_set_multicast_hash(&mac->chip, &multicast_hash);
+	if (r < 0) {
+		dev_dbg_f(zd_mac_dev(mac),
+			  "zd_chip_set_multicast_hash failed, %d\n", r);
+		return r;
+	}
+
+	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
+	    mac->type == NL80211_IFTYPE_ADHOC ||
+	    mac->type == NL80211_IFTYPE_AP) {
+		if (mac->vif != NULL) {
+			beacon = ieee80211_beacon_get(mac->hw, mac->vif);
+			if (beacon) {
+				zd_mac_config_beacon(mac->hw, beacon);
+				kfree_skb(beacon);
+			}
+		}
+
+		zd_set_beacon_interval(&mac->chip, beacon_interval,
+					beacon_period, mac->type);
+
+		spin_lock_irq(&mac->lock);
+		mac->beacon.last_update = jiffies;
+		spin_unlock_irq(&mac->lock);
+	}
+
+	return 0;
+}
+
 /**
  * zd_mac_tx_status - reports tx status of a packet if required
  * @hw - a &struct ieee80211_hw pointer
@@ -1008,6 +1073,10 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct ieee80211_conf *conf = &hw->conf;
 
+	spin_lock_irq(&mac->lock);
+	mac->channel = conf->channel->hw_value;
+	spin_unlock_irq(&mac->lock);
+
 	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
 }
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 4b1edb2..155d4b8 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -192,6 +192,7 @@ struct zd_mac {
 	u8 intr_buffer[USB_MAX_EP_INT_BUFFER];
 	u8 regdomain;
 	u8 default_regdomain;
+	u8 channel;
 	int type;
 	int associated;
 	unsigned long flags;

