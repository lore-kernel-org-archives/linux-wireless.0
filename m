Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZGOPfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 11:35:14 -0400
Subject: [PATCH] wireless: remove print_mac uses
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 17:21:41 +0200
Message-Id: <1247671301.10754.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use %pM instead, and also remove stray variables
declared with DECLARE_MAC_BUF.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ar9170/main.c    |    1 -
 drivers/net/wireless/b43/main.c           |    4 +---
 drivers/net/wireless/libertas/assoc.c     |   10 +++-------
 drivers/net/wireless/mac80211_hwsim.c     |    2 --
 drivers/net/wireless/mwl8k.c              |    6 ++----
 drivers/net/wireless/rt2x00/rt2800usb.c   |    4 +---
 drivers/net/wireless/wl12xx/wl1251_main.c |    5 ++---
 7 files changed, 9 insertions(+), 23 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-07-15 17:05:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-07-15 17:05:39.000000000 +0200
@@ -938,7 +938,6 @@ static void b43_clear_keys(struct b43_wl
 static void b43_dump_keymemory(struct b43_wldev *dev)
 {
 	unsigned int i, index, offset;
-	DECLARE_MAC_BUF(macbuf);
 	u8 mac[ETH_ALEN];
 	u16 algo;
 	u32 rcmta0;
@@ -973,8 +972,7 @@ static void b43_dump_keymemory(struct b4
 						((index - 4) * 2) + 1);
 			*((__le32 *)(&mac[0])) = cpu_to_le32(rcmta0);
 			*((__le16 *)(&mac[4])) = cpu_to_le16(rcmta1);
-			printk("   MAC: %s",
-			       print_mac(macbuf, mac));
+			printk("   MAC: %pM", mac);
 		} else
 			printk("   DEFAULT KEY");
 		printk("\n");
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2009-07-15 17:05:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2009-07-15 17:10:10.000000000 +0200
@@ -129,7 +129,6 @@ static int lbs_set_authentication(struct
 {
 	struct cmd_ds_802_11_authenticate cmd;
 	int ret = -1;
-	DECLARE_MAC_BUF(mac);
 
 	lbs_deb_enter(LBS_DEB_JOIN);
 
@@ -138,8 +137,7 @@ static int lbs_set_authentication(struct
 
 	cmd.authtype = iw_auth_to_ieee_auth(auth);
 
-	lbs_deb_join("AUTH_CMD: BSSID %s, auth 0x%x\n",
-		print_mac(mac, bssid), cmd.authtype);
+	lbs_deb_join("AUTH_CMD: BSSID %pM, auth 0x%x\n", bssid, cmd.authtype);
 
 	ret = lbs_cmd_with_response(priv, CMD_802_11_AUTHENTICATE, &cmd);
 
@@ -342,8 +340,6 @@ static int lbs_associate(struct lbs_priv
 
 	/* Firmware v9+ indicate authentication suites as a TLV */
 	if (priv->fwrelease >= 0x09000000) {
-		DECLARE_MAC_BUF(mac);
-
 		auth = (struct mrvl_ie_auth_type *) pos;
 		auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
 		auth->header.len = cpu_to_le16(2);
@@ -351,8 +347,8 @@ static int lbs_associate(struct lbs_priv
 		auth->auth = cpu_to_le16(tmpauth);
 		pos += sizeof(auth->header) + 2;
 
-		lbs_deb_join("AUTH_CMD: BSSID %s, auth 0x%x\n",
-			print_mac(mac, bss->bssid), priv->secinfo.auth_mode);
+		lbs_deb_join("AUTH_CMD: BSSID %pM, auth 0x%x\n",
+			bss->bssid, priv->secinfo.auth_mode);
 	}
 
 	/* WPA/WPA2 IEs */
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-07-15 17:05:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-07-15 17:09:59.000000000 +0200
@@ -2271,7 +2271,6 @@ static int mwl8k_cmd_update_sta_db(struc
 	struct mwl8k_cmd_update_sta_db *cmd;
 	struct peer_capability_info *peer_info;
 	struct ieee80211_rate *bitrates = mv_vif->legacy_rates;
-	DECLARE_MAC_BUF(mac);
 	int rc;
 	__u8 count, *rates;
 
@@ -3480,7 +3479,6 @@ static int __devinit mwl8k_probe(struct 
 {
 	struct ieee80211_hw *hw;
 	struct mwl8k_priv *priv;
-	DECLARE_MAC_BUF(mac);
 	int rc;
 	int i;
 	u8 *fw;
@@ -3669,8 +3667,8 @@ static int __devinit mwl8k_probe(struct 
 		MWL8K_DESC);
 	printk(KERN_INFO "%s: Driver Ver:%s  Firmware Ver:%u.%u.%u.%u\n",
 		priv->name, MWL8K_VERSION, fw[3], fw[2], fw[1], fw[0]);
-	printk(KERN_INFO "%s: MAC Address: %s\n", priv->name,
-	       print_mac(mac, hw->wiphy->perm_addr));
+	printk(KERN_INFO "%s: MAC Address: %pM\n", priv->name,
+		hw->wiphy->perm_addr);
 
 	return 0;
 
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800usb.c	2009-07-15 17:05:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c	2009-07-15 17:05:39.000000000 +0200
@@ -2220,10 +2220,8 @@ static int rt2800usb_validate_eeprom(str
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
 	if (!is_valid_ether_addr(mac)) {
-		DECLARE_MAC_BUF(macbuf);
-
 		random_ether_addr(mac);
-		EEPROM(rt2x00dev, "MAC: %s\n", print_mac(macbuf, mac));
+		EEPROM(rt2x00dev, "MAC: %pM\n", mac);
 	}
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2009-07-15 17:05:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2009-07-15 17:05:39.000000000 +0200
@@ -435,11 +435,10 @@ static int wl1251_op_add_interface(struc
 				   struct ieee80211_if_init_conf *conf)
 {
 	struct wl1251 *wl = hw->priv;
-	DECLARE_MAC_BUF(mac);
 	int ret = 0;
 
-	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
-		     conf->type, print_mac(mac, conf->mac_addr));
+	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
+		     conf->type, conf->mac_addr);
 
 	mutex_lock(&wl->mutex);
 
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-07-15 17:10:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-07-15 17:10:24.000000000 +0200
@@ -2087,7 +2087,6 @@ static int ar9170_read_eeprom(struct ar9
 {
 #define RW	8	/* number of words to read at once */
 #define RB	(sizeof(u32) * RW)
-	DECLARE_MAC_BUF(mbuf);
 	u8 *eeprom = (void *)&ar->eeprom;
 	u8 *addr = ar->eeprom.mac_address;
 	__le32 offsets[RW];
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-15 17:08:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-15 17:08:54.000000000 +0200
@@ -838,7 +838,6 @@ static void hwsim_send_ps_poll(void *dat
 {
 	struct mac80211_hwsim_data *data = dat;
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
-	DECLARE_MAC_BUF(buf);
 	struct sk_buff *skb;
 	struct ieee80211_pspoll *pspoll;
 
@@ -868,7 +867,6 @@ static void hwsim_send_nullfunc(struct m
 				struct ieee80211_vif *vif, int ps)
 {
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
-	DECLARE_MAC_BUF(buf);
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 


