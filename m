Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2585 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab1I1NSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 09:18:00 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: at76c50x: fix multithread access to hex2str
Date: Wed, 28 Sep 2011 16:17:31 +0300
Message-Id: <21514bff06a915d2edd0a83c74ac512eb8b80b3f.1317215809.git.andriy.shevchenko@linux.intel.com> (sfid-20110928_151805_726111_D84E36A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original hex2str uses finite array of buffers to keep output data. It's a wrong approach, because we can't say at compile time how many threads will be used.

This patch introduces one buffer and global mutex to access this function. All
calls of it are wrapped by locking this mutex. It saves some memory as a side
effect.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
 drivers/net/wireless/at76c50x-usb.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 39322d4..af043f6 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -498,15 +498,14 @@ exit:
 	return ret;
 }
 
-#define HEX2STR_BUFFERS 4
 #define HEX2STR_MAX_LEN 64
 
+static DEFINE_MUTEX(hex2str_mutex);
+
 /* Convert binary data into hex string */
 static char *hex2str(void *buf, size_t len)
 {
-	static atomic_t a = ATOMIC_INIT(0);
-	static char bufs[HEX2STR_BUFFERS][3 * HEX2STR_MAX_LEN + 1];
-	char *ret = bufs[atomic_inc_return(&a) & (HEX2STR_BUFFERS - 1)];
+	static char ret[3 * HEX2STR_MAX_LEN + 1];
 	char *obuf = ret;
 	u8 *ibuf = buf;
 
@@ -1003,10 +1002,13 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
 	key_len = (m->encryption_level == 1) ?
 	    WEP_SMALL_KEY_LEN : WEP_LARGE_KEY_LEN;
 
+	mutex_lock(&hex2str_mutex);
 	for (i = 0; i < WEP_KEYS; i++)
 		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %s",
 			 wiphy_name(priv->hw->wiphy), i,
 			 hex2str(m->wep_default_keyvalue[i], key_len));
+	mutex_unlock(&hex2str_mutex);
+
 exit:
 	kfree(m);
 }
@@ -1028,6 +1030,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		goto exit;
 	}
 
+	mutex_lock(&hex2str_mutex);
 	at76_dbg(DBG_MIB, "%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration "
 		 "%d medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
 		 "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
@@ -1045,6 +1048,8 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
 		 m->res, m->multi_domain_capability_implemented,
 		 m->multi_domain_capability_enabled, m->country_string);
+	mutex_unlock(&hex2str_mutex);
+
 exit:
 	kfree(m);
 }
@@ -1064,6 +1069,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 		goto exit;
 	}
 
+	mutex_lock(&hex2str_mutex);
 	at76_dbg(DBG_MIB, "%s: MIB MAC: max_tx_msdu_lifetime %d "
 		 "max_rx_lifetime %d frag_threshold %d rts_threshold %d "
 		 "cwmin %d cwmax %d short_retry_time %d long_retry_time %d "
@@ -1082,6 +1088,8 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 		 le16_to_cpu(m->listen_interval),
 		 hex2str(m->desired_ssid, IW_ESSID_MAX_SIZE),
 		 m->desired_bssid, m->desired_bsstype);
+	mutex_unlock(&hex2str_mutex);
+
 exit:
 	kfree(m);
 }
@@ -1160,6 +1168,8 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
 		goto exit;
 	}
 
+	mutex_lock(&hex2str_mutex);
+
 	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %s",
 		 wiphy_name(priv->hw->wiphy),
 		 hex2str(m->channel_list, sizeof(m->channel_list)));
@@ -1167,6 +1177,8 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
 	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %s",
 		 wiphy_name(priv->hw->wiphy),
 		 hex2str(m->tx_powerlevel, sizeof(m->tx_powerlevel)));
+
+	mutex_unlock(&hex2str_mutex);
 exit:
 	kfree(m);
 }
@@ -1368,6 +1380,7 @@ static int at76_startup_device(struct at76_priv *priv)
 	struct at76_card_config *ccfg = &priv->card_config;
 	int ret;
 
+	mutex_lock(&hex2str_mutex);
 	at76_dbg(DBG_PARAMS,
 		 "%s param: ssid %.*s (%s) mode %s ch %d wep %s key %d "
 		 "keylen %d", wiphy_name(priv->hw->wiphy), priv->essid_size,
@@ -1375,6 +1388,8 @@ static int at76_startup_device(struct at76_priv *priv)
 		 priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
 		 priv->channel, priv->wep_enabled ? "enabled" : "disabled",
 		 priv->wep_key_id, priv->wep_keys_len[priv->wep_key_id]);
+	mutex_unlock(&hex2str_mutex);
+
 	at76_dbg(DBG_PARAMS,
 		 "%s param: preamble %s rts %d retry %d frag %d "
 		 "txrate %s auth_mode %d", wiphy_name(priv->hw->wiphy),
-- 
1.7.6.3

