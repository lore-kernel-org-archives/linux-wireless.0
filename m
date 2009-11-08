Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50063 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZKHX6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 18:58:05 -0500
Received: by yxe17 with SMTP id 17so2171891yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 15:58:09 -0800 (PST)
Subject: [PATCH] at76c50x-usb: Remove mac2str and replace with %pM format
 specifier.
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Nov 2009 18:58:01 -0500
Message-ID: <1257724681.21194.921.camel@rainbow>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at76c50x-usb: Remove mac2str and replace with %pM format specifier.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index e559dc9..d9f2c52 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -524,20 +524,6 @@ static char *hex2str(void *buf, int len)
 	return ret;
 }
 
-#define MAC2STR_BUFFERS 4
-
-static inline char *mac2str(u8 *mac)
-{
-	static atomic_t a = ATOMIC_INIT(0);
-	static char bufs[MAC2STR_BUFFERS][6 * 3];
-	char *str;
-
-	str = bufs[atomic_inc_return(&a) & (MAC2STR_BUFFERS - 1)];
-	sprintf(str, "%02x:%02x:%02x:%02x:%02x:%02x",
-		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
-	return str;
-}
-
 /* LED trigger */
 static int tx_activity;
 static void at76_ledtrig_tx_timerfunc(unsigned long data);
@@ -973,13 +959,13 @@ static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 		goto exit;
 	}
 
-	at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: mac_addr %s res 0x%x 0x%x",
+	at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: mac_addr %pM res 0x%x 0x%x",
 		 wiphy_name(priv->hw->wiphy),
-		 mac2str(m->mac_addr), m->res[0], m->res[1]);
+		 m->mac_addr, m->res[0], m->res[1]);
 	for (i = 0; i < ARRAY_SIZE(m->group_addr); i++)
-		at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: group addr %d: %s, "
+		at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: group addr %d: %pM, "
 			 "status %d", wiphy_name(priv->hw->wiphy), i,
-			 mac2str(m->group_addr[i]), m->group_addr_status[i]);
+			 m->group_addr[i], m->group_addr_status[i]);
 exit:
 	kfree(m);
 }
@@ -1042,7 +1028,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 	at76_dbg(DBG_MIB, "%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration "
 		 "%d medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
 		 "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
-		 "current_bssid %s current_essid %s current_bss_type %d "
+		 "current_bssid %pM current_essid %s current_bss_type %d "
 		 "pm_mode %d ibss_change %d res %d "
 		 "multi_domain_capability_implemented %d "
 		 "international_roaming %d country_string %.3s",
@@ -1051,7 +1037,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		 le16_to_cpu(m->medium_occupancy_limit),
 		 le16_to_cpu(m->station_id), le16_to_cpu(m->ATIM_window),
 		 m->CFP_mode, m->privacy_option_implemented, m->DTIM_period,
-		 m->CFP_period, mac2str(m->current_bssid),
+		 m->CFP_period, m->current_bssid,
 		 hex2str(m->current_essid, IW_ESSID_MAX_SIZE),
 		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
 		 m->res, m->multi_domain_capability_implemented,
@@ -1080,7 +1066,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 		 "cwmin %d cwmax %d short_retry_time %d long_retry_time %d "
 		 "scan_type %d scan_channel %d probe_delay %u "
 		 "min_channel_time %d max_channel_time %d listen_int %d "
-		 "desired_ssid %s desired_bssid %s desired_bsstype %d",
+		 "desired_ssid %s desired_bssid %pM desired_bsstype %d",
 		 wiphy_name(priv->hw->wiphy),
 		 le32_to_cpu(m->max_tx_msdu_lifetime),
 		 le32_to_cpu(m->max_rx_lifetime),
@@ -1092,7 +1078,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 		 le16_to_cpu(m->max_channel_time),
 		 le16_to_cpu(m->listen_interval),
 		 hex2str(m->desired_ssid, IW_ESSID_MAX_SIZE),
-		 mac2str(m->desired_bssid), m->desired_bsstype);
+		 m->desired_bssid, m->desired_bsstype);
 exit:
 	kfree(m);
 }
@@ -2284,9 +2270,9 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	priv->mac80211_registered = 1;
 
-	printk(KERN_INFO "%s: USB %s, MAC %s, firmware %d.%d.%d-%d\n",
+	printk(KERN_INFO "%s: USB %s, MAC %pM, firmware %d.%d.%d-%d\n",
 	       wiphy_name(priv->hw->wiphy),
-	       dev_name(&interface->dev), mac2str(priv->mac_addr),
+	       dev_name(&interface->dev), priv->mac_addr,
 	       priv->fw_version.major, priv->fw_version.minor,
 	       priv->fw_version.patch, priv->fw_version.build);
 	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n",

