Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXIAEhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:18 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id E7A69618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:17 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 32/35] Massive cleanup of dump functions
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:17 -0400
Message-ID: <20070901043717.2498.87983.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  195 ++++++++++++++++-----------------------
 1 files changed, 79 insertions(+), 116 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 89eca8d..dc56bf4 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1029,24 +1029,22 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 }
 #endif
 
-static int at76_dump_mib_mac_addr(struct at76_priv *priv)
+static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 {
 	int i;
-	int ret = 0;
-	struct mib_mac_addr *m =
-	    kmalloc(sizeof(struct mib_mac_addr), GFP_KERNEL);
+	int ret;
+	struct mib_mac_addr *m = kmalloc(sizeof(struct mib_mac_addr),
+					 GFP_KERNEL);
 
-	if (!m) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!m)
+		return;
 
-	ret = at76_get_mib(priv->udev, MIB_MAC_ADDR,
-			   m, sizeof(struct mib_mac_addr));
+	ret = at76_get_mib(priv->udev, MIB_MAC_ADDR, m,
+			   sizeof(struct mib_mac_addr));
 	if (ret < 0) {
 		err("%s: at76_get_mib (MAC_ADDR) failed: %d",
 		    priv->netdev->name, ret);
-		goto error;
+		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: mac_addr %s res 0x%x 0x%x",
@@ -1056,71 +1054,64 @@ static int at76_dump_mib_mac_addr(struct at76_priv *priv)
 		at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: group addr %d: %s, "
 			 "status %d", priv->netdev->name, i,
 			 mac2str(m->group_addr[i]), m->group_addr_status[i]);
-
-error:
-	kfree(m);
 exit:
-	return ret;
+	kfree(m);
 }
 
-static int at76_dump_mib_mac_wep(struct at76_priv *priv)
+static void at76_dump_mib_mac_wep(struct at76_priv *priv)
 {
-	int ret = 0;
-	char *defkey;
+	int i;
+	int ret;
+	int key_len;
 	struct mib_mac_wep *m = kmalloc(sizeof(struct mib_mac_wep), GFP_KERNEL);
 
-	if (!m) {
-		ret = -ENOMEM;
-		goto exit;
-	}
-	ret =
-	    at76_get_mib(priv->udev, MIB_MAC_WEP, m,
-			 sizeof(struct mib_mac_wep));
+	if (!m)
+		return;
+
+	ret = at76_get_mib(priv->udev, MIB_MAC_WEP, m,
+			   sizeof(struct mib_mac_wep));
 	if (ret < 0) {
 		err("%s: at76_get_mib (MAC_WEP) failed: %d", priv->netdev->name,
 		    ret);
-		goto error;
+		goto exit;
 	}
 
-	if (m->wep_default_key_id < 4)
-		defkey =
-		    hex2str(m->
-			    wep_default_keyvalue[m->wep_default_key_id],
-			    m->encryption_level == 2 ? 13 : 5);
-	else
-		defkey = "<invalid key id>";
-
 	at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: priv_invoked %u def_key_id %u "
 		 "key_len %u excl_unencr %u wep_icv_err %u wep_excluded %u "
-		 "encr_level %u key %d: %s", priv->netdev->name,
+		 "encr_level %u key %d", priv->netdev->name,
 		 m->privacy_invoked, m->wep_default_key_id,
 		 m->wep_key_mapping_len, m->exclude_unencrypted,
 		 le32_to_cpu(m->wep_icv_error_count),
 		 le32_to_cpu(m->wep_excluded_count), m->encryption_level,
-		 m->wep_default_key_id, defkey);
+		 m->wep_default_key_id);
 
-error:
-	kfree(m);
+	key_len = (m->encryption_level == 1) ?
+	    WEP_SMALL_KEY_LEN : WEP_LARGE_KEY_LEN;
+
+	for (i = 0; i < WEP_KEYS; i++)
+		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %s",
+			 priv->netdev->name, i,
+			 hex2str(m->wep_default_keyvalue[i], key_len));
 exit:
-	return ret;
+	kfree(m);
 }
 
-static int at76_dump_mib_mac_mgmt(struct at76_priv *priv)
+static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 {
-	int ret = 0;
-	struct mib_mac_mgmt *m =
-	    kmalloc(sizeof(struct mib_mac_mgmt), GFP_KERNEL);
+	int ret;
+	struct mib_mac_mgmt *m = kmalloc(sizeof(struct mib_mac_mgmt),
+					 GFP_KERNEL);
 	char country_string[4];
 
-	if (!m) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!m)
+		return;
+
 	ret = at76_get_mib(priv->udev, MIB_MAC_MGMT, m,
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
-		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
-		goto error;
+		err("%s: at76_get_mib (MAC_MGMT) failed: %d",
+		    priv->netdev->name, ret);
+		goto exit;
 	}
 
 	memcpy(&country_string, m->country_string, 3);
@@ -1143,26 +1134,23 @@ static int at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
 		 m->res, m->multi_domain_capability_implemented,
 		 m->multi_domain_capability_enabled, country_string);
-error:
-	kfree(m);
 exit:
-	return ret;
+	kfree(m);
 }
 
-static int at76_dump_mib_mac(struct at76_priv *priv)
+static void at76_dump_mib_mac(struct at76_priv *priv)
 {
-	int ret = 0;
+	int ret;
 	struct mib_mac *m = kmalloc(sizeof(struct mib_mac), GFP_KERNEL);
 
-	if (!m) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!m)
+		return;
 
 	ret = at76_get_mib(priv->udev, MIB_MAC, m, sizeof(struct mib_mac));
 	if (ret < 0) {
-		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
-		goto error;
+		err("%s: at76_get_mib (MAC) failed: %d", priv->netdev->name,
+		    ret);
+		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB MAC: max_tx_msdu_lifetime %d "
@@ -1182,26 +1170,23 @@ static int at76_dump_mib_mac(struct at76_priv *priv)
 		 le16_to_cpu(m->listen_interval),
 		 hex2str(m->desired_ssid, IW_ESSID_MAX_SIZE),
 		 mac2str(m->desired_bssid), m->desired_bsstype);
-error:
-	kfree(m);
 exit:
-	return ret;
+	kfree(m);
 }
 
-static int at76_dump_mib_phy(struct at76_priv *priv)
+static void at76_dump_mib_phy(struct at76_priv *priv)
 {
-	int ret = 0;
+	int ret;
 	struct mib_phy *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
 
-	if (!m) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!m)
+		return;
 
 	ret = at76_get_mib(priv->udev, MIB_PHY, m, sizeof(struct mib_phy));
 	if (ret < 0) {
-		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
-		goto error;
+		err("%s: at76_get_mib (PHY) failed: %d", priv->netdev->name,
+		    ret);
+		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB PHY: ed_threshold %d slot_time %d "
@@ -1218,81 +1203,59 @@ static int at76_dump_mib_phy(struct at76_priv *priv)
 		 m->operation_rate_set[1], m->operation_rate_set[2],
 		 m->operation_rate_set[3], m->channel_id, m->current_cca_mode,
 		 m->phy_type, m->current_reg_domain);
-error:
-	kfree(m);
 exit:
-	return ret;
+	kfree(m);
 }
 
-static int at76_dump_mib_local(struct at76_priv *priv)
+static void at76_dump_mib_local(struct at76_priv *priv)
 {
-	int ret = 0;
+	int ret;
 	struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
 
-	if (!m) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!m)
+		return;
 
 	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(struct mib_local));
 	if (ret < 0) {
-		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
-		goto error;
+		err("%s: at76_get_mib (LOCAL) failed: %d", priv->netdev->name,
+		    ret);
+		goto exit;
 	}
 
-	at76_dbg(DBG_MIB, "%s: MIB PHY: beacon_enable %d "
+	at76_dbg(DBG_MIB, "%s: MIB LOCAL: beacon_enable %d "
 		 "txautorate_fallback %d ssid_size %d promiscuous_mode %d "
 		 "preamble_type %d", priv->netdev->name, m->beacon_enable,
 		 m->txautorate_fallback, m->ssid_size, m->promiscuous_mode,
 		 m->preamble_type);
-error:
-	kfree(m);
-exit:
-	return ret;
-}
-
-static int at76_get_mib_mdomain(struct at76_priv *priv, struct mib_mdomain *val)
-{
-	int ret = 0;
-	struct mib_mdomain *mdomain =
-	    kmalloc(sizeof(struct mib_mdomain), GFP_KERNEL);
-
-	if (!mdomain) {
-		ret = -ENOMEM;
-		goto exit;
-	}
-
-	ret = at76_get_mib(priv->udev, MIB_MDOMAIN, mdomain,
-			   sizeof(struct mib_mdomain));
-	if (ret < 0)
-		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
-	else
-		memcpy(val, mdomain, sizeof(*val));
-
-	kfree(mdomain);
-
 exit:
-	return ret;
+	kfree(m);
 }
 
 static void at76_dump_mib_mdomain(struct at76_priv *priv)
 {
 	int ret;
-	struct mib_mdomain mdomain;
+	struct mib_mdomain *m = kmalloc(sizeof(struct mib_mdomain), GFP_KERNEL);
 
-	ret = at76_get_mib_mdomain(priv, &mdomain);
-	if (ret < 0) {
-		err("%s: at76_get_mib_mdomain returned %d", __func__, ret);
+	if (!m)
 		return;
+
+	ret = at76_get_mib(priv->udev, MIB_MDOMAIN, m,
+			   sizeof(struct mib_mdomain));
+	if (ret < 0) {
+		err("%s: at76_get_mib (MDOMAIN) failed: %d", priv->netdev->name,
+		    ret);
+		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %s",
 		 priv->netdev->name,
-		 hex2str(mdomain.channel_list, sizeof(mdomain.channel_list)));
+		 hex2str(m->channel_list, sizeof(m->channel_list)));
 
 	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %s",
 		 priv->netdev->name,
-		 hex2str(mdomain.tx_powerlevel, sizeof(mdomain.tx_powerlevel)));
+		 hex2str(m->tx_powerlevel, sizeof(m->tx_powerlevel)));
+exit:
+	kfree(m);
 }
 
 static int at76_get_current_bssid(struct at76_priv *priv)
