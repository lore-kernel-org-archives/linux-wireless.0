Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:25000 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbXJFBSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:18:00 -0400
Received: by wx-out-0506.google.com with SMTP id h31so633822wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:17:59 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:19:23 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 3/6] ath5k: Fix a bug which pushed us to enable the
	promiscuous filter
Message-ID: <20071006011923.GC25022@pogo> (sfid-20071006_021804_400056_8BBF1B00)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <20071006011837.GB25022@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071006011837.GB25022@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a bug which pushed us to enable the promiscuous filter
all the time during normal operation. The real problem was caused
becuase we were reseting the bssid to the broadcast during
ath5k_hw_reset(). We now cache the bssid value and set the
bssid again during resets. This gives the driver considerably
more stability.

Known issue: if your DHCP server doesn't ACK your IP via the broadcast but
	instead sends it to the IP it gives you (Cisco seems to do this) you
	may not get the reply. Work is in progress to figure this issue out.
	This issue was present before this patch.

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    4 ++++
 drivers/net/wireless/ath5k/base.c  |   15 ++++++++-------
 drivers/net/wireless/ath5k/hw.c    |   23 ++++++++++-------------
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 445fde8..e3f12b9 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -883,6 +883,10 @@ struct ath_hw {
 	enum ieee80211_if_types	ah_op_mode;
 	enum ath5k_power_mode	ah_power_mode;
 	struct ieee80211_channel ah_current_channel;
+	/* Current BSSID we are trying to assoc to / creating, this
+	 * comes from ieee80211_if_conf. This is passed by mac80211 on
+	 * config_interface() */
+	u8			bssid[ETH_ALEN];
 	bool			ah_turbo;
 	bool			ah_calibration;
 	bool			ah_running;
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index fa591eb..b11a14b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1365,6 +1365,7 @@ static int ath_config_interface(struct ieee80211_hw *hw, int if_id,
 		struct ieee80211_if_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->ah;
 	int ret;
 
 	/* Set to a reasonable value. Note that this will
@@ -1375,8 +1376,13 @@ static int ath_config_interface(struct ieee80211_hw *hw, int if_id,
 		ret = -EIO;
 		goto unlock;
 	}
-	if (conf->bssid)
-		ath5k_hw_set_associd(sc->ah, conf->bssid, 0 /* FIXME: aid */);
+	if (conf->bssid) {
+		/* Cache for later use during resets */
+		memcpy(ah->bssid, conf->bssid, ETH_ALEN);
+		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
+		 * a clean way of letting us retrieve this yet. */
+		ath5k_hw_set_associd(ah, ah->bssid, 0);
+	}
 	mutex_unlock(&sc->lock);
 
 	return ath_reset(hw);
@@ -1459,11 +1465,6 @@ static void ath_configure_filter(struct ieee80211_hw *hw,
 	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
 		sc->opmode == IEEE80211_IF_TYPE_IBSS) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
-		/* Note: AR5212 requires AR5K_RX_FILTER_PROM to receive broadcasts,
-		 * perhaps the flags are off, for now to be safe we'll enable it for
-		 * STA and ADHOC until we have this properly mapped */
-		if (ah->ah_version == AR5K_AR5212)
-			rfilt |= AR5K_RX_FILTER_PROM;
 	}
 
 	/* Set the cached hw filter flags, this will alter actually
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 6ef492c..6a8a278 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -310,15 +310,6 @@ struct ath_hw *ath5k_hw_attach(u16 device,
 
 	hal->ah_phy = AR5K_PHY(0);
 
-	/* Set MAC to bcast: ff:ff:ff:ff:ff:ff, this is using 'mac' as a
-	 * temporary variable for setting our BSSID. Right bellow we update
-	 * it with ath5k_hw_get_lladdr() */
-	memset(mac, 0xff, ETH_ALEN);
-	ath5k_hw_set_associd(hal, mac, 0);
-
-	ath5k_hw_get_lladdr(hal, mac);
-	ath5k_hw_set_opmode(hal);
-
 #ifdef AR5K_DEBUG
 	ath5k_hw_dump_state(hal);
 #endif
@@ -350,6 +341,10 @@ struct ath_hw *ath5k_hw_attach(u16 device,
 	}
 
 	ath5k_hw_set_lladdr(hal, mac);
+	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
+	memset(hal->bssid, 0xff, ETH_ALEN);
+	ath5k_hw_set_associd(hal, hal->bssid, 0);
+	ath5k_hw_set_opmode(hal);
 
 	ath5k_hw_set_rfgain_opt(hal);
 
@@ -547,7 +542,6 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	const struct ath5k_rate_table *rt;
 	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
 	u32 data, noise_floor, s_seq, s_ant, s_led[3];
-	u8 mac[ETH_ALEN];
 	unsigned int i, mode, freq, ee_mode, ant[2];
 	int ret;
 
@@ -865,8 +859,9 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Misc
 	 */
-	memset(mac, 0xff, ETH_ALEN);
-	ath5k_hw_set_associd(hal, mac, 0);
+	/* XXX: add hal->aid once mac80211 gives this to us */
+	ath5k_hw_set_associd(hal, hal->bssid, 0);
+
 	ath5k_hw_set_opmode(hal);
 	/*PISR/SISR Not available on 5210*/
 	if (hal->ah_version != AR5K_AR5210) {
@@ -1062,7 +1057,9 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 	ret = ath5k_hw_register_timeout(hal, AR5K_RESET_CTL, mask, val, false);
 
 	/*
-	 * Reset configuration register (for hw byte-swap)
+	 * Reset configuration register (for hw byte-swap). Note that this
+	 * is only set for big endian. We do the necessary magic in
+	 * AR5K_INIT_CFG.
 	 */
 	if ((val & AR5K_RESET_CTL_PCU) == 0)
 		ath5k_hw_reg_write(hal, AR5K_INIT_CFG, AR5K_CFG);
-- 
1.5.2.5

