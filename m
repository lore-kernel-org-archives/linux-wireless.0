Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:10169 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbZJVNgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:36:04 -0400
Message-Id: <20091022133427.825674723@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:31:02 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 19/19] [RFC] libertas: add monitor mode to cfg80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still without packet-injection

BIG WARNING: I don't have a firmware that supports monitor mode, so I did
             *NOT* test this.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c
+++ linux-wl/drivers/net/wireless/libertas/cfg.c
@@ -1431,6 +1431,81 @@
 
 
 /***************************************************************************
+ * Monitor mode
+ */
+
+/* like "struct cmd_ds_802_11_monitor_mode", but with cmd_header. Once we
+ * get rid of WEXT, this should go into host.h */
+struct cmd_monitor_mode {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 mode;
+} __attribute__ ((packed));
+
+static int lbs_enable_monitor_mode(struct lbs_private *priv, int mode)
+{
+	struct cmd_monitor_mode cmd;
+	int ret;
+
+	/* Old firmwares don't support this */
+	if (priv->fwrelease < 0x09000000)
+		return 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/*
+	 * cmd       98 00
+	 * size      0c 00
+	 * sequence  xx xx
+	 * result    00 00
+	 * action    01 00    ACT_SET
+	 * enable    01 00
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.mode = cpu_to_le16(mode);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_MONITOR_MODE, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
+	enum nl80211_iftype type, u32 *flags,
+	struct vif_params *params)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	switch (type) {
+	case NL80211_IFTYPE_MONITOR:
+		ret = lbs_enable_monitor_mode(priv, 1);
+		break;
+
+	case NL80211_IFTYPE_STATION:
+		ret = lbs_enable_monitor_mode(priv, 0);
+		break;
+
+	default:
+		break; /* silence compiler */
+	}
+
+	if (!ret)
+		priv->wdev->iftype = type;
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+
+
+/***************************************************************************
  * Get station
  */
 
@@ -1522,6 +1597,7 @@
 	.set_default_key = lbs_cfg_set_default_key,
 #endif
 	.get_station = lbs_cfg_get_station,
+	.change_virtual_intf = lbs_change_intf,
 };
 
 
@@ -1608,7 +1684,13 @@
 
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	/* TODO: BIT(NL80211_IFTYPE_ADHOC); */
-	/* TODO: BIT(NL80211_IFTYPE_MONITOR); */
+
+	/* While rtap isn't related to mesh, only mesh-enabled
+	 * firmware implements the rtap functionality via
+	 * CMD_802_11_MONITOR_MODE.
+	 */
+	if (priv->mesh_fw_ver == MESH_FW_NEW)
+		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
 
--- linux-wl.orig/drivers/net/wireless/libertas/rx.c
+++ linux-wl/drivers/net/wireless/libertas/rx.c
@@ -3,6 +3,7 @@
   */
 #include <linux/etherdevice.h>
 #include <linux/types.h>
+#include <net/cfg80211.h>
 
 #include "host.h"
 #include "radiotap.h"
@@ -127,6 +128,7 @@
 
 	lbs_deb_leave(LBS_DEB_RX);
 }
+#endif
 
 /**
  *  @brief This function converts Tx/Rx rates from the Marvell WLAN format
@@ -231,12 +233,14 @@
 	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
 	memcpy(pradiotap_hdr, &radiotap_hdr, sizeof(struct rx_radiotap_hdr));
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	lbs_compute_rssi(priv, prxpd);
 
 	/* Take the data rate from the rxpd structure
 	 * only if the rate is auto
 	 */
 	if (priv->enablehwauto)
+#endif
 		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
 
 
@@ -244,7 +248,11 @@
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
+#else
+	skb->protocol = eth_type_trans(skb, priv->dev);
+#endif
 	netif_rx(skb);
 
 	ret = 0;
@@ -253,7 +261,6 @@
 	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
 	return ret;
 }
-#endif
 
 /**
  *  @brief This function processes received packet and forwards it
@@ -281,8 +288,10 @@
 
 #ifdef CONFIG_LIBERTAS_WEXT
 	if (priv->monitormode)
-		return process_rxed_802_11_packet(priv, skb);
+#else
+	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
 #endif
+		return process_rxed_802_11_packet(priv, skb);
 
 	p_rx_pd = (struct rxpd *) skb->data;
 	p_rx_pkt = (struct rxpackethdr *) ((u8 *)p_rx_pd +

-- 
