Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:30621 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752711Ab0BBAIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 19:08:25 -0500
Date: Tue, 2 Feb 2010 01:09:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Holger Schurig <holgerschurig@googlemail.com>
Subject: [PATCH] libertas: cfg80211 support
Message-ID: <20100202000934.GA19847@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Holger Schurig <holgerschurig@googlemail.com>

We can get rid of the libertas wext, assoc and scan code.
The cfg80211 support is almost complete, the main missing feature being mesh
support. There are also a few cfg80211_ops handlers missing (tx_power,
bss_change for example).
Monitor and STA mode are supported  and the latter have been tested on open,
WEP, WPA and WPA2 links. At connection time, the cfg80211 bss list has to be
populated with the BSS we're trying to join.
Also, passive and active (broadcast and directed) scanning have been tested
(on a specific channel and on the whole band).

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
v1: scanning
v2: + WEP, WPA, WPA2
v3: + disconnect & MIC events, 11D region hint to cfg80211, auth_type TLV
v4: + IBSS
    + monitor mode
v5: + Search the cfg80211 bss list for the right BSSID when connecting.
    + Removed carrier off toggling when scanning.
    + Slightly changed the scanning state machine: The scan worker is
scheduled from the scan response handler, and we're checking for scan_channel
to know if a scan is currently running.
    + Implemented RTS and fragmentation threshold.
    + Use the recently exported cfg80211_find_ie() routine.

In my opinion, the only missing feature (besides some small wext settings) is
mesh, but I think this patch is ready for wireless-testing.
---
 drivers/net/wireless/libertas/Makefile  |    3 -
 drivers/net/wireless/libertas/assoc.c   | 2243 -----------------------------
 drivers/net/wireless/libertas/assoc.h   |  155 --
 drivers/net/wireless/libertas/cfg.c     | 1939 +++++++++++++++++++++++++-
 drivers/net/wireless/libertas/cfg.h     |   16 +-
 drivers/net/wireless/libertas/cmd.c     |   22 +-
 drivers/net/wireless/libertas/cmdresp.c |   28 +-
 drivers/net/wireless/libertas/debugfs.c |   53 +-
 drivers/net/wireless/libertas/decl.h    |    3 +
 drivers/net/wireless/libertas/dev.h     |   59 +-
 drivers/net/wireless/libertas/ethtool.c |    5 -
 drivers/net/wireless/libertas/main.c    |  221 +---
 drivers/net/wireless/libertas/rx.c      |  122 +--
 drivers/net/wireless/libertas/scan.c    | 1353 ------------------
 drivers/net/wireless/libertas/scan.h    |   63 -
 drivers/net/wireless/libertas/tx.c      |   12 +-
 drivers/net/wireless/libertas/wext.c    | 2348 -------------------------------
 drivers/net/wireless/libertas/wext.h    |   17 -
 18 files changed, 1977 insertions(+), 6685 deletions(-)
 delete mode 100644 drivers/net/wireless/libertas/assoc.c
 delete mode 100644 drivers/net/wireless/libertas/assoc.h
 delete mode 100644 drivers/net/wireless/libertas/scan.c
 delete mode 100644 drivers/net/wireless/libertas/scan.h
 delete mode 100644 drivers/net/wireless/libertas/wext.c
 delete mode 100644 drivers/net/wireless/libertas/wext.h

diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index 45e870e..f7d01bf 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -1,4 +1,3 @@
-libertas-y += assoc.o
 libertas-y += cfg.o
 libertas-y += cmd.o
 libertas-y += cmdresp.o
@@ -6,9 +5,7 @@ libertas-y += debugfs.o
 libertas-y += ethtool.o
 libertas-y += main.o
 libertas-y += rx.o
-libertas-y += scan.o
 libertas-y += tx.o
-libertas-y += wext.o
 libertas-$(CONFIG_LIBERTAS_MESH) += mesh.o
 
 usb8xxx-objs += if_usb.o
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
deleted file mode 100644
index f03d5e4..0000000
--- a/drivers/net/wireless/libertas/assoc.c
+++ /dev/null
@@ -1,2243 +0,0 @@
-/* Copyright (C) 2006, Red Hat, Inc. */
-
-#include <linux/types.h>
-#include <linux/etherdevice.h>
-#include <linux/ieee80211.h>
-#include <linux/if_arp.h>
-#include <net/lib80211.h>
-
-#include "assoc.h"
-#include "decl.h"
-#include "host.h"
-#include "scan.h"
-#include "cmd.h"
-
-static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
-	{ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
-	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
-
-/* The firmware needs the following bits masked out of the beacon-derived
- * capability field when associating/joining to a BSS:
- *  9 (QoS), 11 (APSD), 12 (unused), 14 (unused), 15 (unused)
- */
-#define CAPINFO_MASK	(~(0xda00))
-
-/**
- * 802.11b/g supported bitrates (in 500Kb/s units)
- */
-u8 lbs_bg_rates[MAX_RATES] =
-    { 0x02, 0x04, 0x0b, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6c,
-0x00, 0x00 };
-
-
-/**
- *  @brief This function finds common rates between rates and card rates.
- *
- * It will fill common rates in rates as output if found.
- *
- * NOTE: Setting the MSB of the basic rates need to be taken
- *   care, either before or after calling this function
- *
- *  @param priv     A pointer to struct lbs_private structure
- *  @param rates       the buffer which keeps input and output
- *  @param rates_size  the size of rates buffer; new size of buffer on return,
- *                     which will be less than or equal to original rates_size
- *
- *  @return            0 on success, or -1 on error
- */
-static int get_common_rates(struct lbs_private *priv,
-	u8 *rates,
-	u16 *rates_size)
-{
-	int i, j;
-	u8 intersection[MAX_RATES];
-	u16 intersection_size;
-	u16 num_rates = 0;
-
-	intersection_size = min_t(u16, *rates_size, ARRAY_SIZE(intersection));
-
-	/* Allow each rate from 'rates' that is supported by the hardware */
-	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && lbs_bg_rates[i]; i++) {
-		for (j = 0; j < intersection_size && rates[j]; j++) {
-			if (rates[j] == lbs_bg_rates[i])
-				intersection[num_rates++] = rates[j];
-		}
-	}
-
-	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", lbs_bg_rates,
-			ARRAY_SIZE(lbs_bg_rates));
-	lbs_deb_hex(LBS_DEB_JOIN, "common rates", intersection, num_rates);
-	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
-
-	if (!priv->enablehwauto) {
-		for (i = 0; i < num_rates; i++) {
-			if (intersection[i] == priv->cur_rate)
-				goto done;
-		}
-		lbs_pr_alert("Previously set fixed data rate %#x isn't "
-		       "compatible with the network.\n", priv->cur_rate);
-		return -1;
-	}
-
-done:
-	memset(rates, 0, *rates_size);
-	*rates_size = num_rates;
-	memcpy(rates, intersection, num_rates);
-	return 0;
-}
-
-
-/**
- *  @brief Sets the MSB on basic rates as the firmware requires
- *
- * Scan through an array and set the MSB for basic data rates.
- *
- *  @param rates     buffer of data rates
- *  @param len       size of buffer
- */
-static void lbs_set_basic_rate_flags(u8 *rates, size_t len)
-{
-	int i;
-
-	for (i = 0; i < len; i++) {
-		if (rates[i] == 0x02 || rates[i] == 0x04 ||
-		    rates[i] == 0x0b || rates[i] == 0x16)
-			rates[i] |= 0x80;
-	}
-}
-
-
-static u8 iw_auth_to_ieee_auth(u8 auth)
-{
-	if (auth == IW_AUTH_ALG_OPEN_SYSTEM)
-		return 0x00;
-	else if (auth == IW_AUTH_ALG_SHARED_KEY)
-		return 0x01;
-	else if (auth == IW_AUTH_ALG_LEAP)
-		return 0x80;
-
-	lbs_deb_join("%s: invalid auth alg 0x%X\n", __func__, auth);
-	return 0;
-}
-
-/**
- *  @brief This function prepares the authenticate command.  AUTHENTICATE only
- *  sets the authentication suite for future associations, as the firmware
- *  handles authentication internally during the ASSOCIATE command.
- *
- *  @param priv      A pointer to struct lbs_private structure
- *  @param bssid     The peer BSSID with which to authenticate
- *  @param auth      The authentication mode to use (from wireless.h)
- *
- *  @return         0 or -1
- */
-static int lbs_set_authentication(struct lbs_private *priv, u8 bssid[6], u8 auth)
-{
-	struct cmd_ds_802_11_authenticate cmd;
-	int ret = -1;
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	memcpy(cmd.bssid, bssid, ETH_ALEN);
-
-	cmd.authtype = iw_auth_to_ieee_auth(auth);
-
-	lbs_deb_join("AUTH_CMD: BSSID %pM, auth 0x%x\n", bssid, cmd.authtype);
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_AUTHENTICATE, &cmd);
-
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
-	return ret;
-}
-
-
-int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
-			   struct assoc_request *assoc)
-{
-	struct cmd_ds_802_11_set_wep cmd;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_ADD) {
-		int i;
-
-		/* default tx key index */
-		cmd.keyindex = cpu_to_le16(assoc->wep_tx_keyidx &
-					   CMD_WEP_KEY_INDEX_MASK);
-
-		/* Copy key types and material to host command structure */
-		for (i = 0; i < 4; i++) {
-			struct enc_key *pkey = &assoc->wep_keys[i];
-
-			switch (pkey->len) {
-			case KEY_LEN_WEP_40:
-				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
-				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
-				lbs_deb_cmd("SET_WEP: add key %d (40 bit)\n", i);
-				break;
-			case KEY_LEN_WEP_104:
-				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
-				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
-				lbs_deb_cmd("SET_WEP: add key %d (104 bit)\n", i);
-				break;
-			case 0:
-				break;
-			default:
-				lbs_deb_cmd("SET_WEP: invalid key %d, length %d\n",
-					    i, pkey->len);
-				ret = -1;
-				goto done;
-				break;
-			}
-		}
-	} else if (cmd_action == CMD_ACT_REMOVE) {
-		/* ACT_REMOVE clears _all_ WEP keys */
-
-		/* default tx key index */
-		cmd.keyindex = cpu_to_le16(priv->wep_tx_keyidx &
-					   CMD_WEP_KEY_INDEX_MASK);
-		lbs_deb_cmd("SET_WEP: remove key %d\n", priv->wep_tx_keyidx);
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
-done:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
-			      uint16_t *enable)
-{
-	struct cmd_ds_802_11_enable_rsn cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_GET)
-		cmd.enable = 0;
-	else {
-		if (*enable)
-			cmd.enable = cpu_to_le16(CMD_ENABLE_RSN);
-		else
-			cmd.enable = cpu_to_le16(CMD_DISABLE_RSN);
-		lbs_deb_cmd("ENABLE_RSN: %d\n", *enable);
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET)
-		*enable = le16_to_cpu(cmd.enable);
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-static void set_one_wpa_key(struct MrvlIEtype_keyParamSet *keyparam,
-		struct enc_key *key)
-{
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (key->flags & KEY_INFO_WPA_ENABLED)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_ENABLED);
-	if (key->flags & KEY_INFO_WPA_UNICAST)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_UNICAST);
-	if (key->flags & KEY_INFO_WPA_MCAST)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_MCAST);
-
-	keyparam->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
-	keyparam->keytypeid = cpu_to_le16(key->type);
-	keyparam->keylen = cpu_to_le16(key->len);
-	memcpy(keyparam->key, key->key, key->len);
-
-	/* Length field doesn't include the {type,length} header */
-	keyparam->length = cpu_to_le16(sizeof(*keyparam) - 4);
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
-int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
-				struct assoc_request *assoc)
-{
-	struct cmd_ds_802_11_key_material cmd;
-	int ret = 0;
-	int index = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.action = cpu_to_le16(cmd_action);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	if (cmd_action == CMD_ACT_GET) {
-		cmd.hdr.size = cpu_to_le16(sizeof(struct cmd_header) + 2);
-	} else {
-		memset(cmd.keyParamSet, 0, sizeof(cmd.keyParamSet));
-
-		if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc->flags)) {
-			set_one_wpa_key(&cmd.keyParamSet[index],
-					&assoc->wpa_unicast_key);
-			index++;
-		}
-
-		if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc->flags)) {
-			set_one_wpa_key(&cmd.keyParamSet[index],
-					&assoc->wpa_mcast_key);
-			index++;
-		}
-
-		/* The common header and as many keys as we included */
-		cmd.hdr.size = cpu_to_le16(offsetof(typeof(cmd),
-						    keyParamSet[index]));
-	}
-	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
-	/* Copy the returned key to driver private data */
-	if (!ret && cmd_action == CMD_ACT_GET) {
-		void *buf_ptr = cmd.keyParamSet;
-		void *resp_end = &(&cmd)[1];
-
-		while (buf_ptr < resp_end) {
-			struct MrvlIEtype_keyParamSet *keyparam = buf_ptr;
-			struct enc_key *key;
-			uint16_t param_set_len = le16_to_cpu(keyparam->length);
-			uint16_t key_len = le16_to_cpu(keyparam->keylen);
-			uint16_t key_flags = le16_to_cpu(keyparam->keyinfo);
-			uint16_t key_type = le16_to_cpu(keyparam->keytypeid);
-			void *end;
-
-			end = (void *)keyparam + sizeof(keyparam->type)
-				+ sizeof(keyparam->length) + param_set_len;
-
-			/* Make sure we don't access past the end of the IEs */
-			if (end > resp_end)
-				break;
-
-			if (key_flags & KEY_INFO_WPA_UNICAST)
-				key = &priv->wpa_unicast_key;
-			else if (key_flags & KEY_INFO_WPA_MCAST)
-				key = &priv->wpa_mcast_key;
-			else
-				break;
-
-			/* Copy returned key into driver */
-			memset(key, 0, sizeof(struct enc_key));
-			if (key_len > sizeof(key->key))
-				break;
-			key->type = key_type;
-			key->flags = key_flags;
-			key->len = key_len;
-			memcpy(key->key, keyparam->key, key->len);
-
-			buf_ptr = end + 1;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-static __le16 lbs_rate_to_fw_bitmap(int rate, int lower_rates_ok)
-{
-/*		Bit  	Rate
-*		15:13 Reserved
-*		12    54 Mbps
-*		11    48 Mbps
-*		10    36 Mbps
-*		9     24 Mbps
-*		8     18 Mbps
-*		7     12 Mbps
-*		6     9 Mbps
-*		5     6 Mbps
-*		4     Reserved
-*		3     11 Mbps
-*		2     5.5 Mbps
-*		1     2 Mbps
-*		0     1 Mbps
-**/
-
-	uint16_t ratemask;
-	int i = lbs_data_rate_to_fw_index(rate);
-	if (lower_rates_ok)
-		ratemask = (0x1fef >> (12 - i));
-	else
-		ratemask = (1 << i);
-	return cpu_to_le16(ratemask);
-}
-
-int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
-				      uint16_t cmd_action)
-{
-	struct cmd_ds_802_11_rate_adapt_rateset cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (!priv->cur_rate && !priv->enablehwauto)
-		return -EINVAL;
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.action = cpu_to_le16(cmd_action);
-	cmd.enablehwauto = cpu_to_le16(priv->enablehwauto);
-	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET)
-		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Set the data rate
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param rate  	The desired data rate, or 0 to clear a locked rate
- *
- *  @return 	   	0 on success, error on failure
- */
-int lbs_set_data_rate(struct lbs_private *priv, u8 rate)
-{
-	struct cmd_ds_802_11_data_rate cmd;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	if (rate > 0) {
-		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_FIX_RATE);
-		cmd.rates[0] = lbs_data_rate_to_fw_index(rate);
-		if (cmd.rates[0] == 0) {
-			lbs_deb_cmd("DATA_RATE: invalid requested rate of"
-				" 0x%02X\n", rate);
-			ret = 0;
-			goto out;
-		}
-		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n", cmd.rates[0]);
-	} else {
-		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_AUTO);
-		lbs_deb_cmd("DATA_RATE: setting auto\n");
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
-	if (ret)
-		goto out;
-
-	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof(cmd));
-
-	/* FIXME: get actual rates FW can do if this command actually returns
-	 * all data rates supported.
-	 */
-	priv->cur_rate = lbs_fw_index_to_data_rate(cmd.rates[0]);
-	lbs_deb_cmd("DATA_RATE: current rate is 0x%02x\n", priv->cur_rate);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-
-int lbs_cmd_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *cmd)
-{
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) +
-		sizeof(struct cmd_header));
-	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
-
-	/* reset Beacon SNR/NF/RSSI values */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = 0;
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->NF[TYPE_BEACON][TYPE_AVG] = 0;
-	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
-int lbs_ret_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/* store the non average value */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->SNR);
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] =
-		get_unaligned_le16(&rssirsp->noisefloor);
-
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgSNR);
-	priv->NF[TYPE_BEACON][TYPE_AVG] =
-		get_unaligned_le16(&rssirsp->avgnoisefloor);
-
-	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
-		     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-
-	priv->RSSI[TYPE_BEACON][TYPE_AVG] =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
-		     priv->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
-
-	lbs_deb_cmd("RSSI: beacon %d, avg %d\n",
-	       priv->RSSI[TYPE_BEACON][TYPE_NOAVG],
-	       priv->RSSI[TYPE_BEACON][TYPE_AVG]);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
-
-int lbs_cmd_bcn_ctrl(struct lbs_private *priv,
-				struct cmd_ds_command *cmd,
-				u16 cmd_action)
-{
-	struct cmd_ds_802_11_beacon_control
-		*bcn_ctrl = &cmd->params.bcn_ctrl;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_beacon_control)
-			     + sizeof(struct cmd_header));
-	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
-
-	bcn_ctrl->action = cpu_to_le16(cmd_action);
-	bcn_ctrl->beacon_enable = cpu_to_le16(priv->beacon_enable);
-	bcn_ctrl->beacon_period = cpu_to_le16(priv->beacon_period);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
-int lbs_ret_802_11_bcn_ctrl(struct lbs_private *priv,
-					struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_beacon_control *bcn_ctrl =
-	    &resp->params.bcn_ctrl;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (bcn_ctrl->action == CMD_ACT_GET) {
-		priv->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
-		priv->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
-	}
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
-
-
-static int lbs_assoc_post(struct lbs_private *priv,
-			  struct cmd_ds_802_11_associate_response *resp)
-{
-	int ret = 0;
-	union iwreq_data wrqu;
-	struct bss_descriptor *bss;
-	u16 status_code;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	if (!priv->in_progress_assoc_req) {
-		lbs_deb_assoc("ASSOC_RESP: no in-progress assoc request\n");
-		ret = -1;
-		goto done;
-	}
-	bss = &priv->in_progress_assoc_req->bss;
-
-	/*
-	 * Older FW versions map the IEEE 802.11 Status Code in the association
-	 * response to the following values returned in resp->statuscode:
-	 *
-	 *    IEEE Status Code                Marvell Status Code
-	 *    0                       ->      0x0000 ASSOC_RESULT_SUCCESS
-	 *    13                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    14                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    15                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    16                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    others                  ->      0x0003 ASSOC_RESULT_REFUSED
-	 *
-	 * Other response codes:
-	 *    0x0001 -> ASSOC_RESULT_INVALID_PARAMETERS (unused)
-	 *    0x0002 -> ASSOC_RESULT_TIMEOUT (internal timer expired waiting for
-	 *                                    association response from the AP)
-	 */
-
-	status_code = le16_to_cpu(resp->statuscode);
-	if (priv->fwrelease < 0x09000000) {
-		switch (status_code) {
-		case 0x00:
-			break;
-		case 0x01:
-			lbs_deb_assoc("ASSOC_RESP: invalid parameters\n");
-			break;
-		case 0x02:
-			lbs_deb_assoc("ASSOC_RESP: internal timer "
-				"expired while waiting for the AP\n");
-			break;
-		case 0x03:
-			lbs_deb_assoc("ASSOC_RESP: association "
-				"refused by AP\n");
-			break;
-		case 0x04:
-			lbs_deb_assoc("ASSOC_RESP: authentication "
-				"refused by AP\n");
-			break;
-		default:
-			lbs_deb_assoc("ASSOC_RESP: failure reason 0x%02x "
-				" unknown\n", status_code);
-			break;
-		}
-	} else {
-		/* v9+ returns the AP's association response */
-		lbs_deb_assoc("ASSOC_RESP: failure reason 0x%02x\n", status_code);
-	}
-
-	if (status_code) {
-		lbs_mac_event_disconnected(priv);
-		ret = -1;
-		goto done;
-	}
-
-	lbs_deb_hex(LBS_DEB_ASSOC, "ASSOC_RESP",
-		    (void *) (resp + sizeof (resp->hdr)),
-		    le16_to_cpu(resp->hdr.size) - sizeof (resp->hdr));
-
-	/* Send a Media Connected event, according to the Spec */
-	priv->connect_status = LBS_CONNECTED;
-
-	/* Update current SSID and BSSID */
-	memcpy(&priv->curbssparams.ssid, &bss->ssid, IEEE80211_MAX_SSID_LEN);
-	priv->curbssparams.ssid_len = bss->ssid_len;
-	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
-
-	priv->SNR[TYPE_RXPD][TYPE_AVG] = 0;
-	priv->NF[TYPE_RXPD][TYPE_AVG] = 0;
-
-	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
-	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
-	priv->nextSNRNF = 0;
-	priv->numSNRNF = 0;
-
-	netif_carrier_on(priv->dev);
-	if (!priv->tx_pending_len)
-		netif_wake_queue(priv->dev);
-
-	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief This function prepares an association-class command.
- *
- *  @param priv      A pointer to struct lbs_private structure
- *  @param assoc_req The association request describing the BSS to associate
- *                   or reassociate with
- *  @param command   The actual command, either CMD_802_11_ASSOCIATE or
- *                   CMD_802_11_REASSOCIATE
- *
- *  @return         0 or -1
- */
-static int lbs_associate(struct lbs_private *priv,
-			 struct assoc_request *assoc_req,
-			 u16 command)
-{
-	struct cmd_ds_802_11_associate cmd;
-	int ret = 0;
-	struct bss_descriptor *bss = &assoc_req->bss;
-	u8 *pos = &(cmd.iebuf[0]);
-	u16 tmpcap, tmplen, tmpauth;
-	struct mrvl_ie_ssid_param_set *ssid;
-	struct mrvl_ie_ds_param_set *ds;
-	struct mrvl_ie_cf_param_set *cf;
-	struct mrvl_ie_rates_param_set *rates;
-	struct mrvl_ie_rsn_param_set *rsn;
-	struct mrvl_ie_auth_type *auth;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	BUG_ON((command != CMD_802_11_ASSOCIATE) &&
-		(command != CMD_802_11_REASSOCIATE));
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.command = cpu_to_le16(command);
-
-	/* Fill in static fields */
-	memcpy(cmd.bssid, bss->bssid, ETH_ALEN);
-	cmd.listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
-
-	/* Capability info */
-	tmpcap = (bss->capability & CAPINFO_MASK);
-	if (bss->mode == IW_MODE_INFRA)
-		tmpcap |= WLAN_CAPABILITY_ESS;
-	cmd.capability = cpu_to_le16(tmpcap);
-	lbs_deb_assoc("ASSOC_CMD: capability 0x%04x\n", tmpcap);
-
-	/* SSID */
-	ssid = (struct mrvl_ie_ssid_param_set *) pos;
-	ssid->header.type = cpu_to_le16(TLV_TYPE_SSID);
-	tmplen = bss->ssid_len;
-	ssid->header.len = cpu_to_le16(tmplen);
-	memcpy(ssid->ssid, bss->ssid, tmplen);
-	pos += sizeof(ssid->header) + tmplen;
-
-	ds = (struct mrvl_ie_ds_param_set *) pos;
-	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
-	ds->header.len = cpu_to_le16(1);
-	ds->channel = bss->phy.ds.channel;
-	pos += sizeof(ds->header) + 1;
-
-	cf = (struct mrvl_ie_cf_param_set *) pos;
-	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
-	tmplen = sizeof(*cf) - sizeof (cf->header);
-	cf->header.len = cpu_to_le16(tmplen);
-	/* IE payload should be zeroed, firmware fills it in for us */
-	pos += sizeof(*cf);
-
-	rates = (struct mrvl_ie_rates_param_set *) pos;
-	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
-	tmplen = min_t(u16, ARRAY_SIZE(bss->rates), MAX_RATES);
-	memcpy(&rates->rates, &bss->rates, tmplen);
-	if (get_common_rates(priv, rates->rates, &tmplen)) {
-		ret = -1;
-		goto done;
-	}
-	pos += sizeof(rates->header) + tmplen;
-	rates->header.len = cpu_to_le16(tmplen);
-	lbs_deb_assoc("ASSOC_CMD: num rates %u\n", tmplen);
-
-	/* Copy the infra. association rates into Current BSS state structure */
-	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
-	memcpy(&priv->curbssparams.rates, &rates->rates, tmplen);
-
-	/* Set MSB on basic rates as the firmware requires, but _after_
-	 * copying to current bss rates.
-	 */
-	lbs_set_basic_rate_flags(rates->rates, tmplen);
-
-	/* Firmware v9+ indicate authentication suites as a TLV */
-	if (priv->fwrelease >= 0x09000000) {
-		auth = (struct mrvl_ie_auth_type *) pos;
-		auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
-		auth->header.len = cpu_to_le16(2);
-		tmpauth = iw_auth_to_ieee_auth(priv->secinfo.auth_mode);
-		auth->auth = cpu_to_le16(tmpauth);
-		pos += sizeof(auth->header) + 2;
-
-		lbs_deb_join("AUTH_CMD: BSSID %pM, auth 0x%x\n",
-			bss->bssid, priv->secinfo.auth_mode);
-	}
-
-	/* WPA/WPA2 IEs */
-	if (assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled) {
-		rsn = (struct mrvl_ie_rsn_param_set *) pos;
-		/* WPA_IE or WPA2_IE */
-		rsn->header.type = cpu_to_le16((u16) assoc_req->wpa_ie[0]);
-		tmplen = (u16) assoc_req->wpa_ie[1];
-		rsn->header.len = cpu_to_le16(tmplen);
-		memcpy(rsn->rsnie, &assoc_req->wpa_ie[2], tmplen);
-		lbs_deb_hex(LBS_DEB_JOIN, "ASSOC_CMD: WPA/RSN IE", (u8 *) rsn,
-			sizeof(rsn->header) + tmplen);
-		pos += sizeof(rsn->header) + tmplen;
-	}
-
-	cmd.hdr.size = cpu_to_le16((sizeof(cmd) - sizeof(cmd.iebuf)) +
-				   (u16)(pos - (u8 *) &cmd.iebuf));
-
-	/* update curbssparams */
-	priv->channel = bss->phy.ds.channel;
-
-	ret = lbs_cmd_with_response(priv, command, &cmd);
-	if (ret == 0) {
-		ret = lbs_assoc_post(priv,
-			(struct cmd_ds_802_11_associate_response *) &cmd);
-	}
-
-done:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Associate to a specific BSS discovered in a scan
- *
- *  @param priv      A pointer to struct lbs_private structure
- *  @param assoc_req The association request describing the BSS to associate with
- *
- *  @return          0-success, otherwise fail
- */
-static int lbs_try_associate(struct lbs_private *priv,
-	struct assoc_request *assoc_req)
-{
-	int ret;
-	u8 preamble = RADIO_PREAMBLE_LONG;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	/* FW v9 and higher indicate authentication suites as a TLV in the
-	 * association command, not as a separate authentication command.
-	 */
-	if (priv->fwrelease < 0x09000000) {
-		ret = lbs_set_authentication(priv, assoc_req->bss.bssid,
-					     priv->secinfo.auth_mode);
-		if (ret)
-			goto out;
-	}
-
-	/* Use short preamble only when both the BSS and firmware support it */
-	if (assoc_req->bss.capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-		preamble = RADIO_PREAMBLE_SHORT;
-
-	ret = lbs_set_radio(priv, preamble, 1);
-	if (ret)
-		goto out;
-
-	ret = lbs_associate(priv, assoc_req, CMD_802_11_ASSOCIATE);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_adhoc_post(struct lbs_private *priv,
-			  struct cmd_ds_802_11_ad_hoc_result *resp)
-{
-	int ret = 0;
-	u16 command = le16_to_cpu(resp->hdr.command);
-	u16 result = le16_to_cpu(resp->hdr.result);
-	union iwreq_data wrqu;
-	struct bss_descriptor *bss;
-	DECLARE_SSID_BUF(ssid);
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	if (!priv->in_progress_assoc_req) {
-		lbs_deb_join("ADHOC_RESP: no in-progress association "
-			"request\n");
-		ret = -1;
-		goto done;
-	}
-	bss = &priv->in_progress_assoc_req->bss;
-
-	/*
-	 * Join result code 0 --> SUCCESS
-	 */
-	if (result) {
-		lbs_deb_join("ADHOC_RESP: failed (result 0x%X)\n", result);
-		if (priv->connect_status == LBS_CONNECTED)
-			lbs_mac_event_disconnected(priv);
-		ret = -1;
-		goto done;
-	}
-
-	/* Send a Media Connected event, according to the Spec */
-	priv->connect_status = LBS_CONNECTED;
-
-	if (command == CMD_RET(CMD_802_11_AD_HOC_START)) {
-		/* Update the created network descriptor with the new BSSID */
-		memcpy(bss->bssid, resp->bssid, ETH_ALEN);
-	}
-
-	/* Set the BSSID from the joined/started descriptor */
-	memcpy(&priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
-
-	/* Set the new SSID to current SSID */
-	memcpy(&priv->curbssparams.ssid, &bss->ssid, IEEE80211_MAX_SSID_LEN);
-	priv->curbssparams.ssid_len = bss->ssid_len;
-
-	netif_carrier_on(priv->dev);
-	if (!priv->tx_pending_len)
-		netif_wake_queue(priv->dev);
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
-	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %pM, channel %d\n",
-		     print_ssid(ssid, bss->ssid, bss->ssid_len),
-		     priv->curbssparams.bssid,
-		     priv->channel);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Join an adhoc network found in a previous scan
- *
- *  @param priv         A pointer to struct lbs_private structure
- *  @param assoc_req    The association request describing the BSS to join
- *
- *  @return             0 on success, error on failure
- */
-static int lbs_adhoc_join(struct lbs_private *priv,
-	struct assoc_request *assoc_req)
-{
-	struct cmd_ds_802_11_ad_hoc_join cmd;
-	struct bss_descriptor *bss = &assoc_req->bss;
-	u8 preamble = RADIO_PREAMBLE_LONG;
-	DECLARE_SSID_BUF(ssid);
-	u16 ratesize = 0;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	lbs_deb_join("current SSID '%s', ssid length %u\n",
-		print_ssid(ssid, priv->curbssparams.ssid,
-		priv->curbssparams.ssid_len),
-		priv->curbssparams.ssid_len);
-	lbs_deb_join("requested ssid '%s', ssid length %u\n",
-		print_ssid(ssid, bss->ssid, bss->ssid_len),
-		bss->ssid_len);
-
-	/* check if the requested SSID is already joined */
-	if (priv->curbssparams.ssid_len &&
-	    !lbs_ssid_cmp(priv->curbssparams.ssid,
-			priv->curbssparams.ssid_len,
-			bss->ssid, bss->ssid_len) &&
-	    (priv->mode == IW_MODE_ADHOC) &&
-	    (priv->connect_status == LBS_CONNECTED)) {
-		union iwreq_data wrqu;
-
-		lbs_deb_join("ADHOC_J_CMD: New ad-hoc SSID is the same as "
-			"current, not attempting to re-join");
-
-		/* Send the re-association event though, because the association
-		 * request really was successful, even if just a null-op.
-		 */
-		memset(&wrqu, 0, sizeof(wrqu));
-		memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid,
-		       ETH_ALEN);
-		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-		wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-		goto out;
-	}
-
-	/* Use short preamble only when both the BSS and firmware support it */
-	if (bss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
-		lbs_deb_join("AdhocJoin: Short preamble\n");
-		preamble = RADIO_PREAMBLE_SHORT;
-	}
-
-	ret = lbs_set_radio(priv, preamble, 1);
-	if (ret)
-		goto out;
-
-	lbs_deb_join("AdhocJoin: channel = %d\n", assoc_req->channel);
-	lbs_deb_join("AdhocJoin: band = %c\n", assoc_req->band);
-
-	priv->adhoccreate = 0;
-	priv->channel = bss->channel;
-
-	/* Build the join command */
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.bss.type = CMD_BSS_TYPE_IBSS;
-	cmd.bss.beaconperiod = cpu_to_le16(bss->beaconperiod);
-
-	memcpy(&cmd.bss.bssid, &bss->bssid, ETH_ALEN);
-	memcpy(&cmd.bss.ssid, &bss->ssid, bss->ssid_len);
-
-	memcpy(&cmd.bss.ds, &bss->phy.ds, sizeof(struct ieee_ie_ds_param_set));
-
-	memcpy(&cmd.bss.ibss, &bss->ss.ibss,
-	       sizeof(struct ieee_ie_ibss_param_set));
-
-	cmd.bss.capability = cpu_to_le16(bss->capability & CAPINFO_MASK);
-	lbs_deb_join("ADHOC_J_CMD: tmpcap=%4X CAPINFO_MASK=%4X\n",
-	       bss->capability, CAPINFO_MASK);
-
-	/* information on BSSID descriptor passed to FW */
-	lbs_deb_join("ADHOC_J_CMD: BSSID = %pM, SSID = '%s'\n",
-			cmd.bss.bssid, cmd.bss.ssid);
-
-	/* Only v8 and below support setting these */
-	if (priv->fwrelease < 0x09000000) {
-		/* failtimeout */
-		cmd.failtimeout = cpu_to_le16(MRVDRV_ASSOCIATION_TIME_OUT);
-		/* probedelay */
-		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
-	}
-
-	/* Copy Data rates from the rates recorded in scan response */
-	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), ARRAY_SIZE (bss->rates));
-	memcpy(cmd.bss.rates, bss->rates, ratesize);
-	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
-		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
-		ret = -1;
-		goto out;
-	}
-
-	/* Copy the ad-hoc creation rates into Current BSS state structure */
-	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
-	memcpy(&priv->curbssparams.rates, cmd.bss.rates, ratesize);
-
-	/* Set MSB on basic rates as the firmware requires, but _after_
-	 * copying to current bss rates.
-	 */
-	lbs_set_basic_rate_flags(cmd.bss.rates, ratesize);
-
-	cmd.bss.ibss.atimwindow = bss->atimwindow;
-
-	if (assoc_req->secinfo.wep_enabled) {
-		u16 tmp = le16_to_cpu(cmd.bss.capability);
-		tmp |= WLAN_CAPABILITY_PRIVACY;
-		cmd.bss.capability = cpu_to_le16(tmp);
-	}
-
-	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
-		__le32 local_ps_mode = cpu_to_le32(LBS802_11POWERMODECAM);
-
-		/* wake up first */
-		ret = lbs_prepare_and_send_command(priv, CMD_802_11_PS_MODE,
-						   CMD_ACT_SET, 0, 0,
-						   &local_ps_mode);
-		if (ret) {
-			ret = -1;
-			goto out;
-		}
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_JOIN, &cmd);
-	if (ret == 0) {
-		ret = lbs_adhoc_post(priv,
-				     (struct cmd_ds_802_11_ad_hoc_result *)&cmd);
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Start an Adhoc Network
- *
- *  @param priv         A pointer to struct lbs_private structure
- *  @param assoc_req    The association request describing the BSS to start
- *
- *  @return             0 on success, error on failure
- */
-static int lbs_adhoc_start(struct lbs_private *priv,
-	struct assoc_request *assoc_req)
-{
-	struct cmd_ds_802_11_ad_hoc_start cmd;
-	u8 preamble = RADIO_PREAMBLE_SHORT;
-	size_t ratesize = 0;
-	u16 tmpcap = 0;
-	int ret = 0;
-	DECLARE_SSID_BUF(ssid);
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	ret = lbs_set_radio(priv, preamble, 1);
-	if (ret)
-		goto out;
-
-	/* Build the start command */
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	memcpy(cmd.ssid, assoc_req->ssid, assoc_req->ssid_len);
-
-	lbs_deb_join("ADHOC_START: SSID '%s', ssid length %u\n",
-		print_ssid(ssid, assoc_req->ssid, assoc_req->ssid_len),
-		assoc_req->ssid_len);
-
-	cmd.bsstype = CMD_BSS_TYPE_IBSS;
-
-	if (priv->beacon_period == 0)
-		priv->beacon_period = MRVDRV_BEACON_INTERVAL;
-	cmd.beaconperiod = cpu_to_le16(priv->beacon_period);
-
-	WARN_ON(!assoc_req->channel);
-
-	/* set Physical parameter set */
-	cmd.ds.header.id = WLAN_EID_DS_PARAMS;
-	cmd.ds.header.len = 1;
-	cmd.ds.channel = assoc_req->channel;
-
-	/* set IBSS parameter set */
-	cmd.ibss.header.id = WLAN_EID_IBSS_PARAMS;
-	cmd.ibss.header.len = 2;
-	cmd.ibss.atimwindow = cpu_to_le16(0);
-
-	/* set capability info */
-	tmpcap = WLAN_CAPABILITY_IBSS;
-	if (assoc_req->secinfo.wep_enabled ||
-	    assoc_req->secinfo.WPAenabled ||
-	    assoc_req->secinfo.WPA2enabled) {
-		lbs_deb_join("ADHOC_START: WEP/WPA enabled, privacy on\n");
-		tmpcap |= WLAN_CAPABILITY_PRIVACY;
-	} else
-		lbs_deb_join("ADHOC_START: WEP disabled, privacy off\n");
-
-	cmd.capability = cpu_to_le16(tmpcap);
-
-	/* Only v8 and below support setting probe delay */
-	if (priv->fwrelease < 0x09000000)
-		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
-
-	ratesize = min(sizeof(cmd.rates), sizeof(lbs_bg_rates));
-	memcpy(cmd.rates, lbs_bg_rates, ratesize);
-
-	/* Copy the ad-hoc creating rates into Current BSS state structure */
-	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
-	memcpy(&priv->curbssparams.rates, &cmd.rates, ratesize);
-
-	/* Set MSB on basic rates as the firmware requires, but _after_
-	 * copying to current bss rates.
-	 */
-	lbs_set_basic_rate_flags(cmd.rates, ratesize);
-
-	lbs_deb_join("ADHOC_START: rates=%02x %02x %02x %02x\n",
-	       cmd.rates[0], cmd.rates[1], cmd.rates[2], cmd.rates[3]);
-
-	lbs_deb_join("ADHOC_START: Starting Ad-Hoc BSS on channel %d, band %d\n",
-		     assoc_req->channel, assoc_req->band);
-
-	priv->adhoccreate = 1;
-	priv->mode = IW_MODE_ADHOC;
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_START, &cmd);
-	if (ret == 0)
-		ret = lbs_adhoc_post(priv,
-				     (struct cmd_ds_802_11_ad_hoc_result *)&cmd);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Stop and Ad-Hoc network and exit Ad-Hoc mode
- *
- *  @param priv         A pointer to struct lbs_private structure
- *  @return             0 on success, or an error
- */
-int lbs_adhoc_stop(struct lbs_private *priv)
-{
-	struct cmd_ds_802_11_ad_hoc_stop cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	memset(&cmd, 0, sizeof (cmd));
-	cmd.hdr.size = cpu_to_le16 (sizeof (cmd));
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_STOP, &cmd);
-
-	/* Clean up everything even if there was an error */
-	lbs_mac_event_disconnected(priv);
-
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
-					struct bss_descriptor *match_bss)
-{
-	if (!secinfo->wep_enabled &&
-	    !secinfo->WPAenabled && !secinfo->WPA2enabled &&
-	    match_bss->wpa_ie[0] != WLAN_EID_GENERIC &&
-	    match_bss->rsn_ie[0] != WLAN_EID_RSN &&
-	    !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
-		return 1;
-	else
-		return 0;
-}
-
-static inline int match_bss_static_wep(struct lbs_802_11_security *secinfo,
-				       struct bss_descriptor *match_bss)
-{
-	if (secinfo->wep_enabled &&
-	    !secinfo->WPAenabled && !secinfo->WPA2enabled &&
-	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
-		return 1;
-	else
-		return 0;
-}
-
-static inline int match_bss_wpa(struct lbs_802_11_security *secinfo,
-				struct bss_descriptor *match_bss)
-{
-	if (!secinfo->wep_enabled && secinfo->WPAenabled &&
-	    (match_bss->wpa_ie[0] == WLAN_EID_GENERIC)
-	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
-	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
-	   )
-		return 1;
-	else
-		return 0;
-}
-
-static inline int match_bss_wpa2(struct lbs_802_11_security *secinfo,
-				 struct bss_descriptor *match_bss)
-{
-	if (!secinfo->wep_enabled && secinfo->WPA2enabled &&
-	    (match_bss->rsn_ie[0] == WLAN_EID_RSN)
-	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
-	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
-	   )
-		return 1;
-	else
-		return 0;
-}
-
-static inline int match_bss_dynamic_wep(struct lbs_802_11_security *secinfo,
-					struct bss_descriptor *match_bss)
-{
-	if (!secinfo->wep_enabled &&
-	    !secinfo->WPAenabled && !secinfo->WPA2enabled &&
-	    (match_bss->wpa_ie[0] != WLAN_EID_GENERIC) &&
-	    (match_bss->rsn_ie[0] != WLAN_EID_RSN) &&
-	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
-		return 1;
-	else
-		return 0;
-}
-
-/**
- *  @brief Check if a scanned network compatible with the driver settings
- *
- *   WEP     WPA     WPA2    ad-hoc  encrypt                      Network
- * enabled enabled  enabled   AES     mode   privacy  WPA  WPA2  Compatible
- *    0       0        0       0      NONE      0      0    0   yes No security
- *    1       0        0       0      NONE      1      0    0   yes Static WEP
- *    0       1        0       0       x        1x     1    x   yes WPA
- *    0       0        1       0       x        1x     x    1   yes WPA2
- *    0       0        0       1      NONE      1      0    0   yes Ad-hoc AES
- *    0       0        0       0     !=NONE     1      0    0   yes Dynamic WEP
- *
- *
- *  @param priv A pointer to struct lbs_private
- *  @param index   Index in scantable to check against current driver settings
- *  @param mode    Network mode: Infrastructure or IBSS
- *
- *  @return        Index in scantable, or error code if negative
- */
-static int is_network_compatible(struct lbs_private *priv,
-				 struct bss_descriptor *bss, uint8_t mode)
-{
-	int matched = 0;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	if (bss->mode != mode)
-		goto done;
-
-	matched = match_bss_no_security(&priv->secinfo, bss);
-	if (matched)
-		goto done;
-	matched = match_bss_static_wep(&priv->secinfo, bss);
-	if (matched)
-		goto done;
-	matched = match_bss_wpa(&priv->secinfo, bss);
-	if (matched) {
-		lbs_deb_scan("is_network_compatible() WPA: wpa_ie 0x%x "
-			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
-			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
-			     priv->secinfo.wep_enabled ? "e" : "d",
-			     priv->secinfo.WPAenabled ? "e" : "d",
-			     priv->secinfo.WPA2enabled ? "e" : "d",
-			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
-		goto done;
-	}
-	matched = match_bss_wpa2(&priv->secinfo, bss);
-	if (matched) {
-		lbs_deb_scan("is_network_compatible() WPA2: wpa_ie 0x%x "
-			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
-			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
-			     priv->secinfo.wep_enabled ? "e" : "d",
-			     priv->secinfo.WPAenabled ? "e" : "d",
-			     priv->secinfo.WPA2enabled ? "e" : "d",
-			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
-		goto done;
-	}
-	matched = match_bss_dynamic_wep(&priv->secinfo, bss);
-	if (matched) {
-		lbs_deb_scan("is_network_compatible() dynamic WEP: "
-			     "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
-			     bss->wpa_ie[0], bss->rsn_ie[0],
-			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
-		goto done;
-	}
-
-	/* bss security settings don't match those configured on card */
-	lbs_deb_scan("is_network_compatible() FAILED: wpa_ie 0x%x "
-		     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
-		     bss->wpa_ie[0], bss->rsn_ie[0],
-		     priv->secinfo.wep_enabled ? "e" : "d",
-		     priv->secinfo.WPAenabled ? "e" : "d",
-		     priv->secinfo.WPA2enabled ? "e" : "d",
-		     (bss->capability & WLAN_CAPABILITY_PRIVACY));
-
-done:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "matched: %d", matched);
-	return matched;
-}
-
-/**
- *  @brief This function finds a specific compatible BSSID in the scan list
- *
- *  Used in association code
- *
- *  @param priv  A pointer to struct lbs_private
- *  @param bssid    BSSID to find in the scan list
- *  @param mode     Network mode: Infrastructure or IBSS
- *
- *  @return         index in BSSID list, or error return code (< 0)
- */
-static struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
-					      uint8_t *bssid, uint8_t mode)
-{
-	struct bss_descriptor *iter_bss;
-	struct bss_descriptor *found_bss = NULL;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	if (!bssid)
-		goto out;
-
-	lbs_deb_hex(LBS_DEB_SCAN, "looking for", bssid, ETH_ALEN);
-
-	/* Look through the scan table for a compatible match.  The loop will
-	 *   continue past a matched bssid that is not compatible in case there
-	 *   is an AP with multiple SSIDs assigned to the same BSSID
-	 */
-	mutex_lock(&priv->lock);
-	list_for_each_entry(iter_bss, &priv->network_list, list) {
-		if (compare_ether_addr(iter_bss->bssid, bssid))
-			continue; /* bssid doesn't match */
-		switch (mode) {
-		case IW_MODE_INFRA:
-		case IW_MODE_ADHOC:
-			if (!is_network_compatible(priv, iter_bss, mode))
-				break;
-			found_bss = iter_bss;
-			break;
-		default:
-			found_bss = iter_bss;
-			break;
-		}
-	}
-	mutex_unlock(&priv->lock);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
-	return found_bss;
-}
-
-/**
- *  @brief This function finds ssid in ssid list.
- *
- *  Used in association code
- *
- *  @param priv  A pointer to struct lbs_private
- *  @param ssid     SSID to find in the list
- *  @param bssid    BSSID to qualify the SSID selection (if provided)
- *  @param mode     Network mode: Infrastructure or IBSS
- *
- *  @return         index in BSSID list
- */
-static struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
-					     uint8_t *ssid, uint8_t ssid_len,
-					     uint8_t *bssid, uint8_t mode,
-					     int channel)
-{
-	u32 bestrssi = 0;
-	struct bss_descriptor *iter_bss = NULL;
-	struct bss_descriptor *found_bss = NULL;
-	struct bss_descriptor *tmp_oldest = NULL;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	mutex_lock(&priv->lock);
-
-	list_for_each_entry(iter_bss, &priv->network_list, list) {
-		if (!tmp_oldest ||
-		    (iter_bss->last_scanned < tmp_oldest->last_scanned))
-			tmp_oldest = iter_bss;
-
-		if (lbs_ssid_cmp(iter_bss->ssid, iter_bss->ssid_len,
-				 ssid, ssid_len) != 0)
-			continue; /* ssid doesn't match */
-		if (bssid && compare_ether_addr(iter_bss->bssid, bssid) != 0)
-			continue; /* bssid doesn't match */
-		if ((channel > 0) && (iter_bss->channel != channel))
-			continue; /* channel doesn't match */
-
-		switch (mode) {
-		case IW_MODE_INFRA:
-		case IW_MODE_ADHOC:
-			if (!is_network_compatible(priv, iter_bss, mode))
-				break;
-
-			if (bssid) {
-				/* Found requested BSSID */
-				found_bss = iter_bss;
-				goto out;
-			}
-
-			if (SCAN_RSSI(iter_bss->rssi) > bestrssi) {
-				bestrssi = SCAN_RSSI(iter_bss->rssi);
-				found_bss = iter_bss;
-			}
-			break;
-		case IW_MODE_AUTO:
-		default:
-			if (SCAN_RSSI(iter_bss->rssi) > bestrssi) {
-				bestrssi = SCAN_RSSI(iter_bss->rssi);
-				found_bss = iter_bss;
-			}
-			break;
-		}
-	}
-
-out:
-	mutex_unlock(&priv->lock);
-	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
-	return found_bss;
-}
-
-static int assoc_helper_essid(struct lbs_private *priv,
-                              struct assoc_request * assoc_req)
-{
-	int ret = 0;
-	struct bss_descriptor * bss;
-	int channel = -1;
-	DECLARE_SSID_BUF(ssid);
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	/* FIXME: take channel into account when picking SSIDs if a channel
-	 * is set.
-	 */
-
-	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags))
-		channel = assoc_req->channel;
-
-	lbs_deb_assoc("SSID '%s' requested\n",
-	              print_ssid(ssid, assoc_req->ssid, assoc_req->ssid_len));
-	if (assoc_req->mode == IW_MODE_INFRA) {
-		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
-			assoc_req->ssid_len);
-
-		bss = lbs_find_ssid_in_list(priv, assoc_req->ssid,
-				assoc_req->ssid_len, NULL, IW_MODE_INFRA, channel);
-		if (bss != NULL) {
-			memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
-			ret = lbs_try_associate(priv, assoc_req);
-		} else {
-			lbs_deb_assoc("SSID not found; cannot associate\n");
-		}
-	} else if (assoc_req->mode == IW_MODE_ADHOC) {
-		/* Scan for the network, do not save previous results.  Stale
-		 *   scan data will cause us to join a non-existant adhoc network
-		 */
-		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
-			assoc_req->ssid_len);
-
-		/* Search for the requested SSID in the scan table */
-		bss = lbs_find_ssid_in_list(priv, assoc_req->ssid,
-				assoc_req->ssid_len, NULL, IW_MODE_ADHOC, channel);
-		if (bss != NULL) {
-			lbs_deb_assoc("SSID found, will join\n");
-			memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
-			lbs_adhoc_join(priv, assoc_req);
-		} else {
-			/* else send START command */
-			lbs_deb_assoc("SSID not found, creating adhoc network\n");
-			memcpy(&assoc_req->bss.ssid, &assoc_req->ssid,
-				IEEE80211_MAX_SSID_LEN);
-			assoc_req->bss.ssid_len = assoc_req->ssid_len;
-			lbs_adhoc_start(priv, assoc_req);
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int assoc_helper_bssid(struct lbs_private *priv,
-                              struct assoc_request * assoc_req)
-{
-	int ret = 0;
-	struct bss_descriptor * bss;
-
-	lbs_deb_enter_args(LBS_DEB_ASSOC, "BSSID %pM", assoc_req->bssid);
-
-	/* Search for index position in list for requested MAC */
-	bss = lbs_find_bssid_in_list(priv, assoc_req->bssid,
-			    assoc_req->mode);
-	if (bss == NULL) {
-		lbs_deb_assoc("ASSOC: WAP: BSSID %pM not found, "
-			"cannot associate.\n", assoc_req->bssid);
-		goto out;
-	}
-
-	memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
-	if (assoc_req->mode == IW_MODE_INFRA) {
-		ret = lbs_try_associate(priv, assoc_req);
-		lbs_deb_assoc("ASSOC: lbs_try_associate(bssid) returned %d\n",
-			      ret);
-	} else if (assoc_req->mode == IW_MODE_ADHOC) {
-		lbs_adhoc_join(priv, assoc_req);
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int assoc_helper_associate(struct lbs_private *priv,
-                                  struct assoc_request * assoc_req)
-{
-	int ret = 0, done = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	/* If we're given and 'any' BSSID, try associating based on SSID */
-
-	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		if (compare_ether_addr(bssid_any, assoc_req->bssid) &&
-		    compare_ether_addr(bssid_off, assoc_req->bssid)) {
-			ret = assoc_helper_bssid(priv, assoc_req);
-			done = 1;
-		}
-	}
-
-	if (!done && test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
-		ret = assoc_helper_essid(priv, assoc_req);
-	}
-
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int assoc_helper_mode(struct lbs_private *priv,
-                             struct assoc_request * assoc_req)
-{
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	if (assoc_req->mode == priv->mode)
-		goto done;
-
-	if (assoc_req->mode == IW_MODE_INFRA) {
-		if (priv->psstate != PS_STATE_FULL_POWER)
-			lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
-		priv->psmode = LBS802_11POWERMODECAM;
-	}
-
-	priv->mode = assoc_req->mode;
-	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE,
-		assoc_req->mode == IW_MODE_ADHOC ? 2 : 1);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-static int assoc_helper_channel(struct lbs_private *priv,
-                                struct assoc_request * assoc_req)
-{
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	ret = lbs_update_channel(priv);
-	if (ret) {
-		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
-		goto done;
-	}
-
-	if (assoc_req->channel == priv->channel)
-		goto done;
-
-	if (priv->mesh_dev) {
-		/* Change mesh channel first; 21.p21 firmware won't let
-		   you change channel otherwise (even though it'll return
-		   an error to this */
-		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP,
-				assoc_req->channel);
-	}
-
-	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
-		      priv->channel, assoc_req->channel);
-
-	ret = lbs_set_channel(priv, assoc_req->channel);
-	if (ret < 0)
-		lbs_deb_assoc("ASSOC: channel: error setting channel.\n");
-
-	/* FIXME: shouldn't need to grab the channel _again_ after setting
-	 * it since the firmware is supposed to return the new channel, but
-	 * whatever... */
-	ret = lbs_update_channel(priv);
-	if (ret) {
-		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
-		goto done;
-	}
-
-	if (assoc_req->channel != priv->channel) {
-		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d\n",
-		              assoc_req->channel);
-		goto restore_mesh;
-	}
-
-	if (assoc_req->secinfo.wep_enabled &&
-	    (assoc_req->wep_keys[0].len || assoc_req->wep_keys[1].len ||
-	     assoc_req->wep_keys[2].len || assoc_req->wep_keys[3].len)) {
-		/* Make sure WEP keys are re-sent to firmware */
-		set_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags);
-	}
-
-	/* Must restart/rejoin adhoc networks after channel change */
- 	set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
-
- restore_mesh:
-	if (priv->mesh_dev)
-		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				priv->channel);
-
- done:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int assoc_helper_wep_keys(struct lbs_private *priv,
-				 struct assoc_request *assoc_req)
-{
-	int i;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	/* Set or remove WEP keys */
-	if (assoc_req->wep_keys[0].len || assoc_req->wep_keys[1].len ||
-	    assoc_req->wep_keys[2].len || assoc_req->wep_keys[3].len)
-		ret = lbs_cmd_802_11_set_wep(priv, CMD_ACT_ADD, assoc_req);
-	else
-		ret = lbs_cmd_802_11_set_wep(priv, CMD_ACT_REMOVE, assoc_req);
-
-	if (ret)
-		goto out;
-
-	/* enable/disable the MAC's WEP packet filter */
-	if (assoc_req->secinfo.wep_enabled)
-		priv->mac_control |= CMD_ACT_MAC_WEP_ENABLE;
-	else
-		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
-
-	lbs_set_mac_control(priv);
-
-	mutex_lock(&priv->lock);
-
-	/* Copy WEP keys into priv wep key fields */
-	for (i = 0; i < 4; i++) {
-		memcpy(&priv->wep_keys[i], &assoc_req->wep_keys[i],
-		       sizeof(struct enc_key));
-	}
-	priv->wep_tx_keyidx = assoc_req->wep_tx_keyidx;
-
-	mutex_unlock(&priv->lock);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-static int assoc_helper_secinfo(struct lbs_private *priv,
-                                struct assoc_request * assoc_req)
-{
-	int ret = 0;
-	uint16_t do_wpa;
-	uint16_t rsn = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	memcpy(&priv->secinfo, &assoc_req->secinfo,
-		sizeof(struct lbs_802_11_security));
-
-	lbs_set_mac_control(priv);
-
-	/* If RSN is already enabled, don't try to enable it again, since
-	 * ENABLE_RSN resets internal state machines and will clobber the
-	 * 4-way WPA handshake.
-	 */
-
-	/* Get RSN enabled/disabled */
-	ret = lbs_cmd_802_11_enable_rsn(priv, CMD_ACT_GET, &rsn);
-	if (ret) {
-		lbs_deb_assoc("Failed to get RSN status: %d\n", ret);
-		goto out;
-	}
-
-	/* Don't re-enable RSN if it's already enabled */
-	do_wpa = assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled;
-	if (do_wpa == rsn)
-		goto out;
-
-	/* Set RSN enabled/disabled */
-	ret = lbs_cmd_802_11_enable_rsn(priv, CMD_ACT_SET, &do_wpa);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int assoc_helper_wpa_keys(struct lbs_private *priv,
-                                 struct assoc_request * assoc_req)
-{
-	int ret = 0;
-	unsigned int flags = assoc_req->flags;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	/* Work around older firmware bug where WPA unicast and multicast
-	 * keys must be set independently.  Seen in SDIO parts with firmware
-	 * version 5.0.11p0.
-	 */
-
-	if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
-		clear_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags);
-		ret = lbs_cmd_802_11_key_material(priv, CMD_ACT_SET, assoc_req);
-		assoc_req->flags = flags;
-	}
-
-	if (ret)
-		goto out;
-
-	memcpy(&priv->wpa_unicast_key, &assoc_req->wpa_unicast_key,
-			sizeof(struct enc_key));
-
-	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
-		clear_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
-
-		ret = lbs_cmd_802_11_key_material(priv, CMD_ACT_SET, assoc_req);
-		assoc_req->flags = flags;
-
-		memcpy(&priv->wpa_mcast_key, &assoc_req->wpa_mcast_key,
-				sizeof(struct enc_key));
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int assoc_helper_wpa_ie(struct lbs_private *priv,
-                               struct assoc_request * assoc_req)
-{
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	if (assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled) {
-		memcpy(&priv->wpa_ie, &assoc_req->wpa_ie, assoc_req->wpa_ie_len);
-		priv->wpa_ie_len = assoc_req->wpa_ie_len;
-	} else {
-		memset(&priv->wpa_ie, 0, MAX_WPA_IE_LEN);
-		priv->wpa_ie_len = 0;
-	}
-
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int should_deauth_infrastructure(struct lbs_private *priv,
-                                        struct assoc_request * assoc_req)
-{
-	int ret = 0;
-
-	if (priv->connect_status != LBS_CONNECTED)
-		return 0;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
-		lbs_deb_assoc("Deauthenticating due to new SSID\n");
-		ret = 1;
-		goto out;
-	}
-
-	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
-		if (priv->secinfo.auth_mode != assoc_req->secinfo.auth_mode) {
-			lbs_deb_assoc("Deauthenticating due to new security\n");
-			ret = 1;
-			goto out;
-		}
-	}
-
-	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		lbs_deb_assoc("Deauthenticating due to new BSSID\n");
-		ret = 1;
-		goto out;
-	}
-
-	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
-		lbs_deb_assoc("Deauthenticating due to channel switch\n");
-		ret = 1;
-		goto out;
-	}
-
-	/* FIXME: deal with 'auto' mode somehow */
-	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
-		if (assoc_req->mode != IW_MODE_INFRA) {
-			lbs_deb_assoc("Deauthenticating due to leaving "
-				"infra mode\n");
-			ret = 1;
-			goto out;
-		}
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-
-static int should_stop_adhoc(struct lbs_private *priv,
-                             struct assoc_request * assoc_req)
-{
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	if (priv->connect_status != LBS_CONNECTED)
-		return 0;
-
-	if (lbs_ssid_cmp(priv->curbssparams.ssid,
-	                      priv->curbssparams.ssid_len,
-	                      assoc_req->ssid, assoc_req->ssid_len) != 0)
-		return 1;
-
-	/* FIXME: deal with 'auto' mode somehow */
-	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
-		if (assoc_req->mode != IW_MODE_ADHOC)
-			return 1;
-	}
-
-	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
-		if (assoc_req->channel != priv->channel)
-			return 1;
-	}
-
-	lbs_deb_leave(LBS_DEB_ASSOC);
-	return 0;
-}
-
-
-/**
- *  @brief This function finds the best SSID in the Scan List
- *
- *  Search the scan table for the best SSID that also matches the current
- *   adapter network preference (infrastructure or adhoc)
- *
- *  @param priv  A pointer to struct lbs_private
- *
- *  @return         index in BSSID list
- */
-static struct bss_descriptor *lbs_find_best_ssid_in_list(
-	struct lbs_private *priv, uint8_t mode)
-{
-	uint8_t bestrssi = 0;
-	struct bss_descriptor *iter_bss;
-	struct bss_descriptor *best_bss = NULL;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	mutex_lock(&priv->lock);
-
-	list_for_each_entry(iter_bss, &priv->network_list, list) {
-		switch (mode) {
-		case IW_MODE_INFRA:
-		case IW_MODE_ADHOC:
-			if (!is_network_compatible(priv, iter_bss, mode))
-				break;
-			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
-				break;
-			bestrssi = SCAN_RSSI(iter_bss->rssi);
-			best_bss = iter_bss;
-			break;
-		case IW_MODE_AUTO:
-		default:
-			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
-				break;
-			bestrssi = SCAN_RSSI(iter_bss->rssi);
-			best_bss = iter_bss;
-			break;
-		}
-	}
-
-	mutex_unlock(&priv->lock);
-	lbs_deb_leave_args(LBS_DEB_SCAN, "best_bss %p", best_bss);
-	return best_bss;
-}
-
-/**
- *  @brief Find the best AP
- *
- *  Used from association worker.
- *
- *  @param priv         A pointer to struct lbs_private structure
- *  @param pSSID        A pointer to AP's ssid
- *
- *  @return             0--success, otherwise--fail
- */
-static int lbs_find_best_network_ssid(struct lbs_private *priv,
-	uint8_t *out_ssid, uint8_t *out_ssid_len, uint8_t preferred_mode,
-	uint8_t *out_mode)
-{
-	int ret = -1;
-	struct bss_descriptor *found;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	priv->scan_ssid_len = 0;
-	lbs_scan_networks(priv, 1);
-	if (priv->surpriseremoved)
-		goto out;
-
-	found = lbs_find_best_ssid_in_list(priv, preferred_mode);
-	if (found && (found->ssid_len > 0)) {
-		memcpy(out_ssid, &found->ssid, IEEE80211_MAX_SSID_LEN);
-		*out_ssid_len = found->ssid_len;
-		*out_mode = found->mode;
-		ret = 0;
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-	return ret;
-}
-
-
-void lbs_association_worker(struct work_struct *work)
-{
-	struct lbs_private *priv = container_of(work, struct lbs_private,
-		assoc_work.work);
-	struct assoc_request * assoc_req = NULL;
-	int ret = 0;
-	int find_any_ssid = 0;
-	DECLARE_SSID_BUF(ssid);
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	mutex_lock(&priv->lock);
-	assoc_req = priv->pending_assoc_req;
-	priv->pending_assoc_req = NULL;
-	priv->in_progress_assoc_req = assoc_req;
-	mutex_unlock(&priv->lock);
-
-	if (!assoc_req)
-		goto done;
-
-	lbs_deb_assoc(
-		"Association Request:\n"
-		"    flags:     0x%08lx\n"
-		"    SSID:      '%s'\n"
-		"    chann:     %d\n"
-		"    band:      %d\n"
-		"    mode:      %d\n"
-		"    BSSID:     %pM\n"
-		"    secinfo:  %s%s%s\n"
-		"    auth_mode: %d\n",
-		assoc_req->flags,
-		print_ssid(ssid, assoc_req->ssid, assoc_req->ssid_len),
-		assoc_req->channel, assoc_req->band, assoc_req->mode,
-		assoc_req->bssid,
-		assoc_req->secinfo.WPAenabled ? " WPA" : "",
-		assoc_req->secinfo.WPA2enabled ? " WPA2" : "",
-		assoc_req->secinfo.wep_enabled ? " WEP" : "",
-		assoc_req->secinfo.auth_mode);
-
-	/* If 'any' SSID was specified, find an SSID to associate with */
-	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags) &&
-	    !assoc_req->ssid_len)
-		find_any_ssid = 1;
-
-	/* But don't use 'any' SSID if there's a valid locked BSSID to use */
-	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		if (compare_ether_addr(assoc_req->bssid, bssid_any) &&
-		    compare_ether_addr(assoc_req->bssid, bssid_off))
-			find_any_ssid = 0;
-	}
-
-	if (find_any_ssid) {
-		u8 new_mode = assoc_req->mode;
-
-		ret = lbs_find_best_network_ssid(priv, assoc_req->ssid,
-				&assoc_req->ssid_len, assoc_req->mode, &new_mode);
-		if (ret) {
-			lbs_deb_assoc("Could not find best network\n");
-			ret = -ENETUNREACH;
-			goto out;
-		}
-
-		/* Ensure we switch to the mode of the AP */
-		if (assoc_req->mode == IW_MODE_AUTO) {
-			set_bit(ASSOC_FLAG_MODE, &assoc_req->flags);
-			assoc_req->mode = new_mode;
-		}
-	}
-
-	/*
-	 * Check if the attributes being changing require deauthentication
-	 * from the currently associated infrastructure access point.
-	 */
-	if (priv->mode == IW_MODE_INFRA) {
-		if (should_deauth_infrastructure(priv, assoc_req)) {
-			ret = lbs_cmd_80211_deauthenticate(priv,
-							   priv->curbssparams.bssid,
-							   WLAN_REASON_DEAUTH_LEAVING);
-			if (ret) {
-				lbs_deb_assoc("Deauthentication due to new "
-					"configuration request failed: %d\n",
-					ret);
-			}
-		}
-	} else if (priv->mode == IW_MODE_ADHOC) {
-		if (should_stop_adhoc(priv, assoc_req)) {
-			ret = lbs_adhoc_stop(priv);
-			if (ret) {
-				lbs_deb_assoc("Teardown of AdHoc network due to "
-					"new configuration request failed: %d\n",
-					ret);
-			}
-
-		}
-	}
-
-	/* Send the various configuration bits to the firmware */
-	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
-		ret = assoc_helper_mode(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
-	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
-		ret = assoc_helper_channel(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
-	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
-		ret = assoc_helper_secinfo(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
-	if (test_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags)) {
-		ret = assoc_helper_wpa_ie(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
-	/*
-	 * v10 FW wants WPA keys to be set/cleared before WEP key operations,
-	 * otherwise it will fail to correctly associate to WEP networks.
-	 * Other firmware versions don't appear to care.
-	 */
-	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags) ||
-	    test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
-		ret = assoc_helper_wpa_keys(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
-	if (test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags) ||
-	    test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
-		ret = assoc_helper_wep_keys(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
-
-	/* SSID/BSSID should be the _last_ config option set, because they
-	 * trigger the association attempt.
-	 */
-	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags) ||
-	    test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
-		int success = 1;
-
-		ret = assoc_helper_associate(priv, assoc_req);
-		if (ret) {
-			lbs_deb_assoc("ASSOC: association unsuccessful: %d\n",
-				ret);
-			success = 0;
-		}
-
-		if (priv->connect_status != LBS_CONNECTED) {
-			lbs_deb_assoc("ASSOC: association unsuccessful, "
-				"not connected\n");
-			success = 0;
-		}
-
-		if (success) {
-			lbs_deb_assoc("associated to %pM\n",
-				priv->curbssparams.bssid);
-			lbs_prepare_and_send_command(priv,
-				CMD_802_11_RSSI,
-				0, CMD_OPTION_WAITFORRSP, 0, NULL);
-		} else {
-			ret = -1;
-		}
-	}
-
-out:
-	if (ret) {
-		lbs_deb_assoc("ASSOC: reconfiguration attempt unsuccessful: %d\n",
-			ret);
-	}
-
-	mutex_lock(&priv->lock);
-	priv->in_progress_assoc_req = NULL;
-	mutex_unlock(&priv->lock);
-	kfree(assoc_req);
-
-done:
-	lbs_deb_leave(LBS_DEB_ASSOC);
-}
-
-
-/*
- * Caller MUST hold any necessary locks
- */
-struct assoc_request *lbs_get_association_request(struct lbs_private *priv)
-{
-	struct assoc_request * assoc_req;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-	if (!priv->pending_assoc_req) {
-		priv->pending_assoc_req = kzalloc(sizeof(struct assoc_request),
-		                                     GFP_KERNEL);
-		if (!priv->pending_assoc_req) {
-			lbs_pr_info("Not enough memory to allocate association"
-				" request!\n");
-			return NULL;
-		}
-	}
-
-	/* Copy current configuration attributes to the association request,
-	 * but don't overwrite any that are already set.
-	 */
-	assoc_req = priv->pending_assoc_req;
-	if (!test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
-		memcpy(&assoc_req->ssid, &priv->curbssparams.ssid,
-		       IEEE80211_MAX_SSID_LEN);
-		assoc_req->ssid_len = priv->curbssparams.ssid_len;
-	}
-
-	if (!test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags))
-		assoc_req->channel = priv->channel;
-
-	if (!test_bit(ASSOC_FLAG_BAND, &assoc_req->flags))
-		assoc_req->band = priv->curbssparams.band;
-
-	if (!test_bit(ASSOC_FLAG_MODE, &assoc_req->flags))
-		assoc_req->mode = priv->mode;
-
-	if (!test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		memcpy(&assoc_req->bssid, priv->curbssparams.bssid,
-			ETH_ALEN);
-	}
-
-	if (!test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)) {
-		int i;
-		for (i = 0; i < 4; i++) {
-			memcpy(&assoc_req->wep_keys[i], &priv->wep_keys[i],
-				sizeof(struct enc_key));
-		}
-	}
-
-	if (!test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags))
-		assoc_req->wep_tx_keyidx = priv->wep_tx_keyidx;
-
-	if (!test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
-		memcpy(&assoc_req->wpa_mcast_key, &priv->wpa_mcast_key,
-			sizeof(struct enc_key));
-	}
-
-	if (!test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
-		memcpy(&assoc_req->wpa_unicast_key, &priv->wpa_unicast_key,
-			sizeof(struct enc_key));
-	}
-
-	if (!test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
-		memcpy(&assoc_req->secinfo, &priv->secinfo,
-			sizeof(struct lbs_802_11_security));
-	}
-
-	if (!test_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags)) {
-		memcpy(&assoc_req->wpa_ie, &priv->wpa_ie,
-			MAX_WPA_IE_LEN);
-		assoc_req->wpa_ie_len = priv->wpa_ie_len;
-	}
-
-	lbs_deb_leave(LBS_DEB_ASSOC);
-	return assoc_req;
-}
-
-
-/**
- *  @brief Deauthenticate from a specific BSS
- *
- *  @param priv        A pointer to struct lbs_private structure
- *  @param bssid       The specific BSS to deauthenticate from
- *  @param reason      The 802.11 sec. 7.3.1.7 Reason Code for deauthenticating
- *
- *  @return            0 on success, error on failure
- */
-int lbs_cmd_80211_deauthenticate(struct lbs_private *priv, u8 bssid[ETH_ALEN],
-				 u16 reason)
-{
-	struct cmd_ds_802_11_deauthenticate cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	memcpy(cmd.macaddr, &bssid[0], ETH_ALEN);
-	cmd.reasoncode = cpu_to_le16(reason);
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DEAUTHENTICATE, &cmd);
-
-	/* Clean up everything even if there was an error; can't assume that
-	 * we're still authenticated to the AP after trying to deauth.
-	 */
-	lbs_mac_event_disconnected(priv);
-
-	lbs_deb_leave(LBS_DEB_JOIN);
-	return ret;
-}
-
diff --git a/drivers/net/wireless/libertas/assoc.h b/drivers/net/wireless/libertas/assoc.h
deleted file mode 100644
index 40621b7..0000000
--- a/drivers/net/wireless/libertas/assoc.h
+++ /dev/null
@@ -1,155 +0,0 @@
-/* Copyright (C) 2006, Red Hat, Inc. */
-
-#ifndef _LBS_ASSOC_H_
-#define _LBS_ASSOC_H_
-
-
-#include "defs.h"
-#include "host.h"
-
-
-struct lbs_private;
-
-/*
- * In theory, the IE is limited to the IE length, 255,
- * but in practice 64 bytes are enough.
- */
-#define MAX_WPA_IE_LEN 64
-
-
-
-struct lbs_802_11_security {
-	u8 WPAenabled;
-	u8 WPA2enabled;
-	u8 wep_enabled;
-	u8 auth_mode;
-	u32 key_mgmt;
-};
-
-/** Current Basic Service Set State Structure */
-struct current_bss_params {
-	/** bssid */
-	u8 bssid[ETH_ALEN];
-	/** ssid */
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
-
-	/** band */
-	u8 band;
-	/** channel is directly in priv->channel */
-	/** zero-terminated array of supported data rates */
-	u8 rates[MAX_RATES + 1];
-};
-
-/**
- *  @brief Structure used to store information for each beacon/probe response
- */
-struct bss_descriptor {
-	u8 bssid[ETH_ALEN];
-
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
-
-	u16 capability;
-	u32 rssi;
-	u32 channel;
-	u16 beaconperiod;
-	__le16 atimwindow;
-
-	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
-	u8 mode;
-
-	/* zero-terminated array of supported data rates */
-	u8 rates[MAX_RATES + 1];
-
-	unsigned long last_scanned;
-
-	union ieee_phy_param_set phy;
-	union ieee_ss_param_set ss;
-
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	size_t wpa_ie_len;
-	u8 rsn_ie[MAX_WPA_IE_LEN];
-	size_t rsn_ie_len;
-
-	u8 mesh;
-
-	struct list_head list;
-};
-
-/** Association request
- *
- * Encapsulates all the options that describe a specific assocation request
- * or configuration of the wireless card's radio, mode, and security settings.
- */
-struct assoc_request {
-#define ASSOC_FLAG_SSID			1
-#define ASSOC_FLAG_CHANNEL		2
-#define ASSOC_FLAG_BAND			3
-#define ASSOC_FLAG_MODE			4
-#define ASSOC_FLAG_BSSID		5
-#define ASSOC_FLAG_WEP_KEYS		6
-#define ASSOC_FLAG_WEP_TX_KEYIDX	7
-#define ASSOC_FLAG_WPA_MCAST_KEY	8
-#define ASSOC_FLAG_WPA_UCAST_KEY	9
-#define ASSOC_FLAG_SECINFO		10
-#define ASSOC_FLAG_WPA_IE		11
-	unsigned long flags;
-
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
-	u8 channel;
-	u8 band;
-	u8 mode;
-	u8 bssid[ETH_ALEN] __attribute__ ((aligned (2)));
-
-	/** WEP keys */
-	struct enc_key wep_keys[4];
-	u16 wep_tx_keyidx;
-
-	/** WPA keys */
-	struct enc_key wpa_mcast_key;
-	struct enc_key wpa_unicast_key;
-
-	struct lbs_802_11_security secinfo;
-
-	/** WPA Information Elements*/
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
-
-	/* BSS to associate with for infrastructure of Ad-Hoc join */
-	struct bss_descriptor bss;
-};
-
-
-extern u8 lbs_bg_rates[MAX_RATES];
-
-void lbs_association_worker(struct work_struct *work);
-struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
-
-int lbs_adhoc_stop(struct lbs_private *priv);
-
-int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
-				 u8 bssid[ETH_ALEN], u16 reason);
-
-int lbs_cmd_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *cmd);
-int lbs_ret_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *resp);
-
-int lbs_cmd_bcn_ctrl(struct lbs_private *priv,
-				struct cmd_ds_command *cmd,
-				u16 cmd_action);
-int lbs_ret_802_11_bcn_ctrl(struct lbs_private *priv,
-					struct cmd_ds_command *resp);
-
-int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
-			   struct assoc_request *assoc);
-
-int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
-			      uint16_t *enable);
-
-int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
-				struct assoc_request *assoc);
-
-#endif /* _LBS_ASSOC_H */
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 4396dcc..c52057a 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -6,8 +6,11 @@
  *
  */
 
+#include <linux/if_arp.h>
 #include <net/cfg80211.h>
+#include <asm/unaligned.h>
 
+#include "decl.h"
 #include "cfg.h"
 #include "cmd.h"
 
@@ -38,26 +41,27 @@ static struct ieee80211_channel lbs_2ghz_channels[] = {
 	CHAN2G(14, 2484, 0),
 };
 
-#define RATETAB_ENT(_rate, _rateid, _flags) { \
-	.bitrate  = (_rate),                  \
-	.hw_value = (_rateid),                \
-	.flags    = (_flags),                 \
+#define RATETAB_ENT(_rate, _hw_value, _flags) { \
+	.bitrate  = (_rate),                    \
+	.hw_value = (_hw_value),                \
+	.flags    = (_flags),                   \
 }
 
 
+/* Table 6 in section 3.2.1.1 */
 static struct ieee80211_rate lbs_rates[] = {
-	RATETAB_ENT(10,  0x1,   0),
-	RATETAB_ENT(20,  0x2,   0),
-	RATETAB_ENT(55,  0x4,   0),
-	RATETAB_ENT(110, 0x8,   0),
-	RATETAB_ENT(60,  0x10,  0),
-	RATETAB_ENT(90,  0x20,  0),
-	RATETAB_ENT(120, 0x40,  0),
-	RATETAB_ENT(180, 0x80,  0),
-	RATETAB_ENT(240, 0x100, 0),
-	RATETAB_ENT(360, 0x200, 0),
-	RATETAB_ENT(480, 0x400, 0),
-	RATETAB_ENT(540, 0x800, 0),
+	RATETAB_ENT(10,  0,  0),
+	RATETAB_ENT(20,  1,  0),
+	RATETAB_ENT(55,  2,  0),
+	RATETAB_ENT(110, 3,  0),
+	RATETAB_ENT(60,  9,  0),
+	RATETAB_ENT(90,  6,  0),
+	RATETAB_ENT(120, 7,  0),
+	RATETAB_ENT(180, 8,  0),
+	RATETAB_ENT(240, 9,  0),
+	RATETAB_ENT(360, 10, 0),
+	RATETAB_ENT(480, 11, 0),
+	RATETAB_ENT(540, 12, 0),
 };
 
 static struct ieee80211_supported_band lbs_band_2ghz = {
@@ -75,32 +79,1880 @@ static const u32 cipher_suites[] = {
 	WLAN_CIPHER_SUITE_CCMP,
 };
 
+/* Time to stay on the channel */
+#define LBS_DWELL_PASSIVE 100
+#define LBS_DWELL_ACTIVE  40
 
 
+
+/***************************************************************************
+ * Misc utility functions
+ *
+ * TLVs are Marvell specific. They are very similar to IEs, they have the
+ * same structure: type, length, data*. The only difference: for IEs, the
+ * type and length are u8, but for TLVs they're __le16.
+ */
+
+/*
+ * Convert NL80211's auth_type to the one from Libertas, see chapter 5.9.1
+ * in the firmware spec
+ */
+static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
+{
+	int ret = -ENOTSUPP;
+
+	switch (auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		ret = auth_type;
+		break;
+	case NL80211_AUTHTYPE_AUTOMATIC:
+		ret = NL80211_AUTHTYPE_OPEN_SYSTEM;
+		break;
+	case NL80211_AUTHTYPE_NETWORK_EAP:
+		ret = 0x80;
+		break;
+	default:
+		/* silence compiler */
+		break;
+	}
+	return ret;
+}
+
+
+/* Various firmware commands need the list of supported rates, but with
+   the hight-bit set for basic rates */
+static int lbs_add_rates(u8 *rates)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
+		u8 rate = lbs_rates[i].bitrate / 5;
+		if (rate == 0x02 || rate == 0x04 ||
+		    rate == 0x0b || rate == 0x16)
+			rate |= 0x80;
+		rates[i] = rate;
+	}
+	return ARRAY_SIZE(lbs_rates);
+}
+
+
+/***************************************************************************
+ * TLV utility functions
+ *
+ * TLVs are Marvell specific. They are very similar to IEs, they have the
+ * same structure: type, length, data*. The only difference: for IEs, the
+ * type and length are u8, but for TLVs they're __le16.
+ */
+
+
+/*
+ * Add ssid TLV
+ */
+#define LBS_MAX_SSID_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + IEEE80211_MAX_SSID_LEN)
+
+static int lbs_add_ssid_tlv(u8 *tlv, const u8 *ssid, int ssid_len)
+{
+	struct mrvl_ie_ssid_param_set *ssid_tlv = (void *)tlv;
+
+	/*
+	 * TLV-ID SSID  00 00
+	 * length       06 00
+	 * ssid         4d 4e 54 45 53 54
+	 */
+	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
+	ssid_tlv->header.len = cpu_to_le16(ssid_len);
+	memcpy(ssid_tlv->ssid, ssid, ssid_len);
+	return sizeof(ssid_tlv->header) + ssid_len;
+}
+
+
+/*
+ * Add channel list TLV (section 8.4.2)
+ *
+ * Actual channel data comes from priv->wdev->wiphy->channels.
+ */
+#define LBS_MAX_CHANNEL_LIST_TLV_SIZE					\
+	(sizeof(struct mrvl_ie_header)					\
+	 + (LBS_SCAN_BEFORE_NAP * sizeof(struct chanscanparamset)))
+
+static int lbs_add_channel_list_tlv(struct lbs_private *priv, u8 *tlv,
+				    int last_channel, int active_scan)
+{
+	int chanscanparamsize = sizeof(struct chanscanparamset) *
+		(last_channel - priv->scan_channel);
+
+	struct mrvl_ie_header *header = (void *) tlv;
+
+	/*
+	 * TLV-ID CHANLIST  01 01
+	 * length           0e 00
+	 * channel          00 01 00 00 00 64 00
+	 *   radio type     00
+	 *   channel           01
+	 *   scan type            00
+	 *   min scan time           00 00
+	 *   max scan time                 64 00
+	 * channel 2        00 02 00 00 00 64 00
+	 *
+	 */
+
+	header->type = cpu_to_le16(TLV_TYPE_CHANLIST);
+	header->len  = cpu_to_le16(chanscanparamsize);
+	tlv += sizeof(struct mrvl_ie_header);
+
+	/* lbs_deb_scan("scan: channels %d to %d\n", priv->scan_channel,
+		     last_channel); */
+	memset(tlv, 0, chanscanparamsize);
+
+	while (priv->scan_channel < last_channel) {
+		struct chanscanparamset *param = (void *) tlv;
+
+		param->radiotype = CMD_SCAN_RADIO_TYPE_BG;
+		param->channumber =
+			priv->scan_req->channels[priv->scan_channel]->hw_value;
+		if (active_scan) {
+			param->maxscantime = cpu_to_le16(LBS_DWELL_ACTIVE);
+		} else {
+			param->chanscanmode.passivescan = 1;
+			param->maxscantime = cpu_to_le16(LBS_DWELL_PASSIVE);
+		}
+		tlv += sizeof(struct chanscanparamset);
+		priv->scan_channel++;
+	}
+	return sizeof(struct mrvl_ie_header) + chanscanparamsize;
+}
+
+
+/*
+ * Add rates TLV
+ *
+ * The rates are in lbs_bg_rates[], but for the 802.11b
+ * rates the high bit is set. We add this TLV only because
+ * there's a firmware which otherwise doesn't report all
+ * APs in range.
+ */
+#define LBS_MAX_RATES_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + (ARRAY_SIZE(lbs_rates)))
+
+/* Adds a TLV with all rates the hardware supports */
+static int lbs_add_supported_rates_tlv(u8 *tlv)
+{
+	size_t i;
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
+
+	/*
+	 * TLV-ID RATES  01 00
+	 * length        0e 00
+	 * rates         82 84 8b 96 0c 12 18 24 30 48 60 6c
+	 */
+	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	tlv += sizeof(rate_tlv->header);
+	i = lbs_add_rates(tlv);
+	tlv += i;
+	rate_tlv->header.len = cpu_to_le16(i);
+	return sizeof(rate_tlv->header) + i;
+}
+
+
+/*
+ * Adds a TLV with all rates the hardware *and* BSS supports.
+ */
+static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
+{
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
+	const u8 *rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+	int n;
+
+	/*
+	 * 01 00                   TLV_TYPE_RATES
+	 * 04 00                   len
+	 * 82 84 8b 96             rates
+	 */
+	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	tlv += sizeof(rate_tlv->header);
+
+	if (!rates_eid) {
+		/* Fallback: add basic 802.11b rates */
+		*tlv++ = 0x82;
+		*tlv++ = 0x84;
+		*tlv++ = 0x8b;
+		*tlv++ = 0x96;
+		n = 4;
+	} else {
+		int hw, ap;
+		u8 ap_max = rates_eid[1];
+		n = 0;
+		for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
+			u8 hw_rate = lbs_rates[hw].bitrate / 5;
+			for (ap = 0; ap < ap_max; ap++) {
+				if (hw_rate == (rates_eid[ap+2] & 0x7f)) {
+					*tlv++ = rates_eid[ap+2];
+					n++;
+				}
+			}
+		}
+	}
+
+	rate_tlv->header.len = cpu_to_le16(n);
+	return sizeof(rate_tlv->header) + n;
+}
+
+
+/*
+ * Add auth type TLV.
+ *
+ * This is only needed for newer firmware (V9 and up).
+ */
+#define LBS_MAX_AUTH_TYPE_TLV_SIZE \
+	sizeof(struct mrvl_ie_auth_type)
+
+static int lbs_add_auth_type_tlv(u8 *tlv, enum nl80211_auth_type auth_type)
+{
+	struct mrvl_ie_auth_type *auth = (void *) tlv;
+
+	/*
+	 * 1f 01  TLV_TYPE_AUTH_TYPE
+	 * 01 00  len
+	 * 01     auth type
+	 */
+	auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+	auth->header.len = cpu_to_le16(sizeof(*auth)-sizeof(auth->header));
+	auth->auth = cpu_to_le16(lbs_auth_to_authtype(auth_type));
+	return sizeof(*auth);
+}
+
+
+/*
+ * Add channel (phy ds) TLV
+ */
+#define LBS_MAX_CHANNEL_TLV_SIZE \
+	sizeof(struct mrvl_ie_header)
+
+static int lbs_add_channel_tlv(u8 *tlv, u8 channel)
+{
+	struct mrvl_ie_ds_param_set *ds = (void *) tlv;
+
+	/*
+	 * 03 00  TLV_TYPE_PHY_DS
+	 * 01 00  len
+	 * 06     channel
+	 */
+	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
+	ds->header.len = cpu_to_le16(sizeof(*ds)-sizeof(ds->header));
+	ds->channel = channel;
+	return sizeof(*ds);
+}
+
+
+/*
+ * Add (empty) CF param TLV of the form:
+ */
+#define LBS_MAX_CF_PARAM_TLV_SIZE		\
+	sizeof(struct mrvl_ie_header)
+
+static int lbs_add_cf_param_tlv(u8 *tlv)
+{
+	struct mrvl_ie_cf_param_set *cf = (void *)tlv;
+
+	/*
+	 * 04 00  TLV_TYPE_CF
+	 * 06 00  len
+	 * 00     cfpcnt
+	 * 00     cfpperiod
+	 * 00 00  cfpmaxduration
+	 * 00 00  cfpdurationremaining
+	 */
+	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
+	cf->header.len = cpu_to_le16(sizeof(*cf)-sizeof(cf->header));
+	return sizeof(*cf);
+}
+
+/*
+ * Add WPA TLV
+ */
+#define LBS_MAX_WPA_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + 128 /* TODO: I guessed the size */)
+
+static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
+{
+	size_t tlv_len;
+
+	/*
+	 * We need just convert an IE to an TLV. IEs use u8 for the header,
+	 *   u8      type
+	 *   u8      len
+	 *   u8[]    data
+	 * but TLVs use __le16 instead:
+	 *   __le16  type
+	 *   __le16  len
+	 *   u8[]    data
+	 */
+	*tlv++ = *ie++;
+	*tlv++ = 0;
+	tlv_len = *tlv++ = *ie++;
+	*tlv++ = 0;
+	while (tlv_len--)
+		*tlv++ = *ie++;
+	/* the TLV is two bytes larger than the IE */
+	return ie_len + 2;
+}
+
+
+
+/***************************************************************************
+ * Set Channel
+ */
+
 static int lbs_cfg_set_channel(struct wiphy *wiphy,
-	struct ieee80211_channel *chan,
+	struct ieee80211_channel *channel,
 	enum nl80211_channel_type channel_type)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = -ENOTSUPP;
 
-	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d", chan->center_freq, channel_type);
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d",
+			   channel->center_freq, channel_type);
 
 	if (channel_type != NL80211_CHAN_NO_HT)
 		goto out;
 
-	ret = lbs_set_channel(priv, chan->hw_value);
+	ret = lbs_set_channel(priv, channel->hw_value);
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+/***************************************************************************
+ * Scanning
+ */
+
+/*
+ * When scanning, the firmware doesn't send a nul packet with the power-safe
+ * bit to the AP. So we cannot stay away from our current channel too long,
+ * otherwise we loose data. So take a "nap" while scanning every other
+ * while.
+ */
+#define LBS_SCAN_BEFORE_NAP 4
+
+
+/*
+ * When the firmware reports back a scan-result, it gives us an "u8 rssi",
+ * which isn't really an RSSI, as it becomes larger when moving away from
+ * the AP. Anyway, we need to convert that into mBm.
+ */
+#define LBS_SCAN_RSSI_TO_MBM(rssi) \
+	((-(int)rssi + 3)*100)
+
+static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
+	struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
+	int bsssize;
+	const u8 *pos;
+	u16 nr_sets;
+	const u8 *tsfdesc;
+	int tsfsize;
+	int i;
+	int ret = -EILSEQ;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
+	nr_sets = le16_to_cpu(resp->size);
+
+	/*
+	 * The general layout of the scan response is described in chapter
+	 * 5.7.1. Basically we have a common part, then any number of BSS
+	 * descriptor sections. Finally we have section with the same number
+	 * of TSFs.
+	 *
+	 * cmd_ds_802_11_scan_rsp
+	 *   cmd_header
+	 *   pos_size
+	 *   nr_sets
+	 *   bssdesc 1
+	 *     bssid
+	 *     rssi
+	 *     timestamp
+	 *     intvl
+	 *     capa
+	 *     IEs
+	 *   bssdesc 2
+	 *   bssdesc n
+	 *   MrvlIEtypes_TsfFimestamp_t
+	 *     TSF for BSS 1
+	 *     TSF for BSS 2
+	 *     TSF for BSS n
+	 */
+
+	pos = scanresp->bssdesc_and_tlvbuffer;
+
+	tsfdesc = pos + bsssize;
+	tsfsize = 4 + 8 * scanresp->nr_sets;
+
+	/* Validity check: we expect a Marvell-Local TLV */
+	i = get_unaligned_le16(tsfdesc);
+	tsfdesc += 2;
+	if (i != TLV_TYPE_TSFTIMESTAMP)
+		goto done;
+	/* Validity check: the TLV holds TSF values with 8 bytes each, so
+	 * the size in the TLV must match the nr_sets value */
+	i = get_unaligned_le16(tsfdesc);
+	tsfdesc += 2;
+	if (i / 8 != scanresp->nr_sets)
+		goto done;
+
+	for (i = 0; i < scanresp->nr_sets; i++) {
+		struct wiphy *wiphy;
+		int freq;
+		struct ieee80211_channel *channel;
+		const u8 *bssid, *ie, *chan_no_ie = NULL, *ssid = NULL;
+		int ie_len, rssi, chan_no;
+		u16 intvl, capa;
+		u8 ssid_len = 0;
+		DECLARE_SSID_BUF(ssid_buf);
+
+		int len = get_unaligned_le16(pos);
+		pos += 2;
+		ie_len = len;
+
+		/* BSSID */
+		bssid = pos;
+		pos += ETH_ALEN;
+		ie_len -= ETH_ALEN;
+		/* RSSI */
+		rssi = *pos++;
+		ie_len -= 1;
+		/* Packet time stamp */
+		pos += 8;
+		ie_len -= 8;
+		/* Beacon interval */
+		intvl = get_unaligned_le16(pos);
+		pos += 2;
+		ie_len -= 2;
+		/* Capabilities */
+		capa = get_unaligned_le16(pos);
+		pos += 2;
+		ie_len -= 2;
+
+		ie = pos;
+		ssid = cfg80211_find_ie(WLAN_EID_SSID, ie, ie_len);
+		if (!ssid)
+			goto done;
+		ssid_len = ssid[1];
+		ssid += 2;
+
+		chan_no_ie = cfg80211_find_ie(WLAN_EID_DS_PARAMS, ie, ie_len);
+		if (!chan_no_ie)
+			goto done;
+		chan_no = chan_no_ie[2];
+
+		pos += ie_len;
+
+		wiphy = priv->wdev->wiphy;
+		freq = ieee80211_channel_to_frequency(chan_no);
+		channel = ieee80211_get_channel(wiphy, freq);
+
+		lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %s, "
+			     "%d dBm\n",
+			     bssid, capa, chan_no,
+			     print_ssid(ssid_buf, ssid, ssid_len),
+			     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
+
+		if (channel &&
+		    !(channel->flags & IEEE80211_CHAN_DISABLED))
+			cfg80211_inform_bss(wiphy, channel,
+					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
+					capa, intvl, ie, ie_len,
+					LBS_SCAN_RSSI_TO_MBM(rssi),
+					GFP_KERNEL);
+
+		tsfdesc += 8;
+	}
+
+	ret = 0;
+
+ done:
+	if (priv->scan_channel < priv->scan_req->n_channels) {
+		/*
+		 * We are not done yet with the current scan request.
+		 * Since the AP doesnt know we're scanning, we delay
+		 * the scan work in order to minimize our data loss.
+		 */
+		queue_delayed_work(priv->work_thread, &priv->scan_work,
+			msecs_to_jiffies(300));
+	} else {
+		/* Mark scan done */
+		cfg80211_scan_done(priv->scan_req, false);
+		priv->scan_channel = 0;
+		priv->scan_req = NULL;
+	}
+
+	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Our scan command contains a TLV, consting of a SSID TLV, a channel list
+ * TLV and a rates TLV. Determine the maximum size of them:
+ */
+#define LBS_SCAN_MAX_CMD_SIZE			\
+	(sizeof(struct cmd_ds_802_11_scan)	\
+	 + LBS_MAX_SSID_TLV_SIZE		\
+	 + LBS_MAX_CHANNEL_LIST_TLV_SIZE	\
+	 + LBS_MAX_RATES_TLV_SIZE)
+
+/*
+ * Assumes priv->scan_req is initialized and valid
+ * Assumes priv->scan_channel is initialized
+ */
+static void lbs_scan_worker(struct work_struct *work)
+{
+	struct lbs_private *priv =
+		container_of(work, struct lbs_private, scan_work.work);
+	struct cmd_ds_802_11_scan *scan_cmd;
+	u8 *tlv; /* pointer into our current, growing TLV storage area */
+	int last_channel;
+	int running;
+
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	scan_cmd = kzalloc(LBS_SCAN_MAX_CMD_SIZE, GFP_KERNEL);
+	if (scan_cmd == NULL)
+		goto out_no_scan_cmd;
+
+	/* prepare fixed part of scan command */
+	scan_cmd->bsstype = CMD_BSS_TYPE_ANY;
+
+	/* stop network while we're away from our main channel */
+	running = !netif_queue_stopped(priv->dev);
+	if (running)
+		netif_stop_queue(priv->dev);
+
+	/* prepare fixed part of scan command */
+	tlv = scan_cmd->tlvbuffer;
+
+	/* add SSID TLV */
+	if (priv->scan_req->n_ssids)
+		tlv += lbs_add_ssid_tlv(tlv,
+					priv->scan_req->ssids[0].ssid,
+					priv->scan_req->ssids[0].ssid_len);
+
+	/* add channel TLVs */
+	last_channel = priv->scan_channel + LBS_SCAN_BEFORE_NAP;
+	if (last_channel > priv->scan_req->n_channels)
+		last_channel = priv->scan_req->n_channels;
+	tlv += lbs_add_channel_list_tlv(priv, tlv, last_channel,
+		priv->scan_req->n_ssids);
+
+	/* add rates TLV */
+	tlv += lbs_add_supported_rates_tlv(tlv);
+
+	/* This is the final data we are about to send */
+	scan_cmd->hdr.size = cpu_to_le16(tlv - (u8 *)scan_cmd);
+	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_CMD", (void *)scan_cmd,
+		    sizeof(*scan_cmd));
+	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_TLV", scan_cmd->tlvbuffer,
+		    tlv - scan_cmd->tlvbuffer);
+
+	__lbs_cmd(priv, CMD_802_11_SCAN, &scan_cmd->hdr,
+		le16_to_cpu(scan_cmd->hdr.size),
+		lbs_ret_scan, 0);
+
+	/* Restart network */
+	if (running && !priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	kfree(scan_cmd);
+
+ out_no_scan_cmd:
+	lbs_deb_leave(LBS_DEB_SCAN);
+}
+
+
+static int lbs_cfg_scan(struct wiphy *wiphy,
+	struct net_device *dev,
+	struct cfg80211_scan_request *request)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (priv->scan_channel) {
+		/* Last scan request not done yet */
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	lbs_deb_scan("scan: ssids %d, channels %d, ie_len %d\n",
+		request->n_ssids, request->n_channels, request->ie_len);
+
+	priv->scan_req = request;
+
+	queue_delayed_work(priv->work_thread, &priv->scan_work, 0);
+
+	if (priv->surpriseremoved)
+		ret = -EIO;
 
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
 }
 
+static int lbs_cfg_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		/* min rts value is 0 */
+		if (wiphy->rts_threshold > MRVDRV_RTS_MAX_VALUE) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD,
+				       (u16) wiphy->rts_threshold);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		if (wiphy->frag_threshold < MRVDRV_FRAG_MIN_VALUE ||
+		    wiphy->frag_threshold > MRVDRV_FRAG_MAX_VALUE) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD,
+				       (u16) wiphy->frag_threshold);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
 
 
+/***************************************************************************
+ * Events
+ */
+
+void lbs_send_disconnect_notification(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	cfg80211_disconnected(priv->dev,
+		0,
+		NULL, 0,
+		GFP_KERNEL);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
+
+void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	cfg80211_michael_mic_failure(priv->dev,
+		priv->assoc_bss,
+		event == MACREG_INT_CODE_MIC_ERR_MULTICAST ?
+			NL80211_KEYTYPE_GROUP :
+			NL80211_KEYTYPE_PAIRWISE,
+		-1,
+		NULL,
+		GFP_KERNEL);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
+
+
+
+
+/***************************************************************************
+ * Connect/disconnect
+ */
+
+
+/*
+ * This removes all WEP keys
+ */
+static int lbs_remove_wep_keys(struct lbs_private *priv)
+{
+	struct cmd_ds_802_11_set_wep cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.keyindex = cpu_to_le16(priv->wep_tx_key);
+	cmd.action = cpu_to_le16(CMD_ACT_REMOVE);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+/*
+ * Set WEP keys
+ */
+static int lbs_set_wep_keys(struct lbs_private *priv)
+{
+	struct cmd_ds_802_11_set_wep cmd;
+	int i;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/*
+	 * command         13 00
+	 * size            50 00
+	 * sequence        xx xx
+	 * result          00 00
+	 * action          02 00     ACT_ADD
+	 * transmit key    00 00
+	 * type for key 1  01        WEP40
+	 * type for key 2  00
+	 * type for key 3  00
+	 * type for key 4  00
+	 * key 1           39 39 39 39 39 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * key 2           00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * key 3           00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * key 4           00 00 00 00 00 00 00 00
+	 */
+	if (priv->wep_key_len[0] || priv->wep_key_len[1] ||
+	    priv->wep_key_len[2] || priv->wep_key_len[3]) {
+		/* Only set wep keys if we have at least one of them */
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+		cmd.keyindex = cpu_to_le16(priv->wep_tx_key);
+		cmd.action = cpu_to_le16(CMD_ACT_ADD);
+
+		for (i = 0; i < 4; i++) {
+			switch (priv->wep_key_len[i]) {
+			case WLAN_KEY_LEN_WEP40:
+				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
+				break;
+			case WLAN_KEY_LEN_WEP104:
+				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
+				break;
+			default:
+				cmd.keytype[i] = 0;
+				break;
+			}
+			memcpy(cmd.keymaterial[i], priv->wep_key[i],
+			       priv->wep_key_len[i]);
+		}
+
+		ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
+	} else {
+		/* Otherwise remove all wep keys */
+		ret = lbs_remove_wep_keys(priv);
+	}
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+/*
+ * Enable/Disable RSN status
+ */
+static int lbs_enable_rsn(struct lbs_private *priv, int enable)
+{
+	struct cmd_ds_802_11_enable_rsn cmd;
+	int ret;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", enable);
+
+	/*
+	 * cmd       2f 00
+	 * size      0c 00
+	 * sequence  xx xx
+	 * result    00 00
+	 * action    01 00    ACT_SET
+	 * enable    01 00
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.enable = cpu_to_le16(enable);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+/*
+ * Set WPA/WPA key material
+ */
+
+/* like "struct cmd_ds_802_11_key_material", but with cmd_header. Once we
+ * get rid of WEXT, this should go into host.h */
+
+struct cmd_key_material {
+	struct cmd_header hdr;
+
+	__le16 action;
+	struct MrvlIEtype_keyParamSet param;
+} __attribute__ ((packed));
+
+static int lbs_set_key_material(struct lbs_private *priv,
+				int key_type,
+				int key_info,
+				u8 *key, u16 key_len)
+{
+	struct cmd_key_material cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/*
+	 * Example for WPA (TKIP):
+	 *
+	 * cmd       5e 00
+	 * size      34 00
+	 * sequence  xx xx
+	 * result    00 00
+	 * action    01 00
+	 * TLV type  00 01    key param
+	 * length    00 26
+	 * key type  01 00    TKIP
+	 * key info  06 00    UNICAST | ENABLED
+	 * key len   20 00
+	 * key       32 bytes
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.param.type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+	cmd.param.length = cpu_to_le16(sizeof(cmd.param) - 4);
+	cmd.param.keytypeid = cpu_to_le16(key_type);
+	cmd.param.keyinfo = cpu_to_le16(key_info);
+	cmd.param.keylen = cpu_to_le16(key_len);
+	if (key && key_len)
+		memcpy(cmd.param.key, key, key_len);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+/*
+ * Sets the auth type (open, shared, etc) in the firmware. That
+ * we use CMD_802_11_AUTHENTICATE is misleading, this firmware
+ * command doesn't send an authentication frame at all, it just
+ * stores the auth_type.
+ */
+static int lbs_set_authtype(struct lbs_private *priv,
+			    struct cfg80211_connect_params *sme)
+{
+	struct cmd_ds_802_11_authenticate cmd;
+	int ret;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", sme->auth_type);
+
+	/*
+	 * cmd        11 00
+	 * size       19 00
+	 * sequence   xx xx
+	 * result     00 00
+	 * BSS id     00 13 19 80 da 30
+	 * auth type  00
+	 * reserved   00 00 00 00 00 00 00 00 00 00
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	if (sme->bssid)
+		memcpy(cmd.bssid, sme->bssid, ETH_ALEN);
+	/* convert auth_type */
+	ret = lbs_auth_to_authtype(sme->auth_type);
+	if (ret < 0)
+		goto done;
+
+	cmd.authtype = ret;
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AUTHENTICATE, &cmd);
+
+ done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Create association request
+ */
+#define LBS_ASSOC_MAX_CMD_SIZE                     \
+	(sizeof(struct cmd_ds_802_11_associate)    \
+	 - 512 /* cmd_ds_802_11_associate.iebuf */ \
+	 + LBS_MAX_SSID_TLV_SIZE                   \
+	 + LBS_MAX_CHANNEL_TLV_SIZE                \
+	 + LBS_MAX_CF_PARAM_TLV_SIZE               \
+	 + LBS_MAX_AUTH_TYPE_TLV_SIZE              \
+	 + LBS_MAX_WPA_TLV_SIZE)
+
+static int lbs_associate(struct lbs_private *priv,
+		struct cfg80211_bss *bss,
+		struct cfg80211_connect_params *sme)
+{
+	struct cmd_ds_802_11_associate_response *resp;
+	struct cmd_ds_802_11_associate *cmd = kzalloc(LBS_ASSOC_MAX_CMD_SIZE,
+						      GFP_KERNEL);
+	const u8 *ssid_eid;
+	size_t len, resp_ie_len;
+	int status;
+	int ret;
+	u8 *pos = &(cmd->iebuf[0]);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	/*
+	 * cmd              50 00
+	 * length           34 00
+	 * sequence         xx xx
+	 * result           00 00
+	 * BSS id           00 13 19 80 da 30
+	 * capabilities     11 00
+	 * listen interval  0a 00
+	 * beacon interval  00 00
+	 * DTIM period      00
+	 * TLVs             xx   (up to 512 bytes)
+	 */
+	cmd->hdr.command = cpu_to_le16(CMD_802_11_ASSOCIATE);
+
+	/* Fill in static fields */
+	memcpy(cmd->bssid, bss->bssid, ETH_ALEN);
+	cmd->listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
+	cmd->capability = cpu_to_le16(bss->capability);
+
+	/* add SSID TLV */
+	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
+	if (ssid_eid)
+		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_eid[1]);
+	else
+		lbs_deb_assoc("no SSID\n");
+
+	/* add DS param TLV */
+	if (bss->channel)
+		pos += lbs_add_channel_tlv(pos, bss->channel->hw_value);
+	else
+		lbs_deb_assoc("no channel\n");
+
+	/* add (empty) CF param TLV */
+	pos += lbs_add_cf_param_tlv(pos);
+
+	/* add rates TLV */
+	pos += lbs_add_common_rates_tlv(pos, bss);
+
+	/* add auth type TLV */
+	if (priv->fwrelease >= 0x09000000)
+		pos += lbs_add_auth_type_tlv(pos, sme->auth_type);
+
+	/* add WPA/WPA2 TLV */
+	if (sme->ie && sme->ie_len)
+		pos += lbs_add_wpa_tlv(pos, sme->ie, sme->ie_len);
+
+	len = (sizeof(*cmd) - sizeof(cmd->iebuf)) +
+		(u16)(pos - (u8 *) &cmd->iebuf);
+	cmd->hdr.size = cpu_to_le16(len);
+
+	/* store for later use */
+	memcpy(priv->assoc_bss, bss->bssid, ETH_ALEN);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_ASSOCIATE, cmd);
+	if (ret)
+		goto done;
+
+
+	/* generate connect message to cfg80211 */
+
+	resp = (void *) cmd; /* recast for easier field access */
+	status = le16_to_cpu(resp->statuscode);
+
+	/* Convert statis code of old firmware */
+	if (priv->fwrelease < 0x09000000)
+		switch (status) {
+		case 0:
+			break;
+		case 1:
+			lbs_deb_assoc("invalid association parameters\n");
+			status = WLAN_STATUS_CAPS_UNSUPPORTED;
+			break;
+		case 2:
+			lbs_deb_assoc("timer expired while waiting for AP\n");
+			status = WLAN_STATUS_AUTH_TIMEOUT;
+			break;
+		case 3:
+			lbs_deb_assoc("association refused by AP\n");
+			status = WLAN_STATUS_ASSOC_DENIED_UNSPEC;
+			break;
+		case 4:
+			lbs_deb_assoc("authentication refused by AP\n");
+			status = WLAN_STATUS_UNKNOWN_AUTH_TRANSACTION;
+			break;
+		default:
+			lbs_deb_assoc("association failure %d\n", status);
+			status = WLAN_STATUS_UNSPECIFIED_FAILURE;
+	}
+
+	lbs_deb_assoc("status %d, capability 0x%04x\n", status,
+		      le16_to_cpu(resp->capability));
+
+	resp_ie_len = le16_to_cpu(resp->hdr.size)
+		- sizeof(resp->hdr)
+		- 6;
+
+	cfg80211_connect_result(priv->dev,
+				priv->assoc_bss,
+				sme->ie, sme->ie_len,
+				resp->iebuf, resp_ie_len,
+				status,
+				GFP_KERNEL);
+
+	if (status == 0) {
+		/* TODO: get rid of priv->connect_status */
+		priv->connect_status = LBS_CONNECTED;
+		netif_carrier_on(priv->dev);
+		if (!priv->tx_pending_len)
+			netif_tx_wake_all_queues(priv->dev);
+	}
+
+
+done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_connect_params *sme)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cfg80211_bss *bss = NULL;
+	int ret = 0;
+	u8 preamble = RADIO_PREAMBLE_SHORT;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
+			       sme->ssid, sme->ssid_len,
+			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+
+	if (!bss) {
+		if (sme->bssid || sme->ssid_len != IEEE80211_MAX_SSID_LEN) {
+			DECLARE_SSID_BUF(ssid);
+			lbs_pr_err("associate: BSS %s not in scan results\n",
+				   print_ssid(ssid, sme->ssid, sme->ssid_len));
+			ret = -ENOENT;
+		}
+
+		goto done;
+	}
+	lbs_deb_assoc("trying %pM", bss->bssid);
+	lbs_deb_assoc("cipher 0x%x, key index %d, key len %d\n",
+		      sme->crypto.cipher_group,
+		      sme->key_idx, sme->key_len);
+
+	/* As this is a new connection, clear locally stored WEP keys */
+	priv->wep_tx_key = 0;
+	memset(priv->wep_key, 0, sizeof(priv->wep_key));
+	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
+
+	/* set/remove WEP keys */
+	switch (sme->crypto.cipher_group) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		/* Store provided WEP keys in priv-> */
+		priv->wep_tx_key = sme->key_idx;
+		priv->wep_key_len[sme->key_idx] = sme->key_len;
+		memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
+		/* Set WEP keys and WEP mode */
+		lbs_set_wep_keys(priv);
+		priv->mac_control |= CMD_ACT_MAC_WEP_ENABLE;
+		lbs_set_mac_control(priv);
+		/* No RSN mode for WEP */
+		lbs_enable_rsn(priv, 0);
+		break;
+	case 0: /* there's no WLAN_CIPHER_SUITE_NONE definition */
+		/*
+		 * If we don't have no WEP, no WPA and no WPA2,
+		 * we remove all keys like in the WPA/WPA2 setup,
+		 * we just don't set RSN.
+		 *
+		 * Therefore: fall-throught
+		 */
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		/* Remove WEP keys and WEP mode */
+		lbs_remove_wep_keys(priv);
+		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
+		lbs_set_mac_control(priv);
+
+		/* clear the WPA/WPA2 keys */
+		lbs_set_key_material(priv,
+			KEY_TYPE_ID_WEP, /* doesn't matter */
+			KEY_INFO_WPA_UNICAST,
+			NULL, 0);
+		lbs_set_key_material(priv,
+			KEY_TYPE_ID_WEP, /* doesn't matter */
+			KEY_INFO_WPA_MCAST,
+			NULL, 0);
+		/* RSN mode for WPA/WPA2 */
+		lbs_enable_rsn(priv, sme->crypto.cipher_group != 0);
+		break;
+	default:
+		lbs_pr_err("unsupported cipher group 0x%x\n",
+			   sme->crypto.cipher_group);
+		ret = -ENOTSUPP;
+		goto done;
+	}
+
+	lbs_set_authtype(priv, sme);
+	lbs_set_radio(priv, preamble, 1);
+
+	/* Do the actual association */
+	lbs_associate(priv, bss, sme);
+
+ done:
+	if (bss)
+		cfg80211_put_bss(bss);
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+
+/* callback from lbs_cfg_disconnect() */
+static int lbs_cfg_ret_disconnect(struct lbs_private *priv, unsigned long dummy,
+			      struct cmd_header *resp)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	cfg80211_disconnected(priv->dev,
+			      priv->disassoc_reason,
+			      NULL, 0, /* TODO? */
+			      GFP_KERNEL);
+
+	/* TODO: get rid of priv->connect_status */
+	priv->connect_status = LBS_DISCONNECTED;
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return 0;
+}
+
+
+static int lbs_cfg_disconnect(struct wiphy *wiphy, struct net_device *dev,
+	u16 reason_code)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cmd_ds_802_11_deauthenticate cmd;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "reason_code %d", reason_code);
+
+	/* store for lbs_cfg_ret_disconnect() */
+	priv->disassoc_reason = reason_code;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	/* Mildly ugly to use a locally store my own BSSID ... */
+	memcpy(cmd.macaddr, &priv->assoc_bss, ETH_ALEN);
+	cmd.reasoncode = cpu_to_le16(reason_code);
+
+	__lbs_cmd_async(priv, CMD_802_11_DEAUTHENTICATE,
+			&cmd.hdr, sizeof(cmd),
+			lbs_cfg_ret_disconnect, 0);
+
+	return 0;
+}
+
+
+static int lbs_cfg_set_default_key(struct wiphy *wiphy,
+				   struct net_device *netdev,
+				   u8 key_index)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (key_index != priv->wep_tx_key) {
+		lbs_deb_assoc("set_default_key: to %d\n", key_index);
+		priv->wep_tx_key = key_index;
+		lbs_set_wep_keys(priv);
+	}
+
+	return 0;
+}
+
+
+static int lbs_cfg_add_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 idx, const u8 *mac_addr,
+			   struct key_params *params)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	u16 key_info;
+	u16 key_type;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	lbs_deb_assoc("add_key: cipher 0x%x, mac_addr %pM\n",
+		      params->cipher, mac_addr);
+	lbs_deb_assoc("add_key: key index %d, key len %d\n",
+		      idx, params->key_len);
+	if (params->key_len)
+		lbs_deb_hex(LBS_DEB_CFG80211, "KEY",
+			    params->key, params->key_len);
+
+	lbs_deb_assoc("add_key: seq len %d\n", params->seq_len);
+	if (params->seq_len)
+		lbs_deb_hex(LBS_DEB_CFG80211, "SEQ",
+			    params->seq, params->seq_len);
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		/* actually compare if something has changed ... */
+		if ((priv->wep_key_len[idx] != params->key_len) ||
+			memcmp(priv->wep_key[idx],
+			       params->key, params->key_len) != 0) {
+			priv->wep_key_len[idx] = params->key_len;
+			memcpy(priv->wep_key[idx],
+			       params->key, params->key_len);
+			lbs_set_wep_keys(priv);
+		}
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		key_info = KEY_INFO_WPA_ENABLED | ((idx == 0)
+						   ? KEY_INFO_WPA_UNICAST
+						   : KEY_INFO_WPA_MCAST);
+		key_type = (params->cipher == WLAN_CIPHER_SUITE_TKIP)
+			? KEY_TYPE_ID_TKIP
+			: KEY_TYPE_ID_AES;
+		lbs_set_key_material(priv,
+				     key_type,
+				     key_info,
+				     params->key, params->key_len);
+		break;
+	default:
+		lbs_pr_err("unhandled cipher 0x%x\n", params->cipher);
+		ret = -ENOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+
+static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, const u8 *mac_addr)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (key_index < 3 && priv->wep_key_len[key_index]) {
+		priv->wep_key_len[key_index] = 0;
+		lbs_set_wep_keys(priv);
+	}
+
+	lbs_deb_assoc("del_key: key_idx %d, mac_addr %pM\n",
+		      key_index, mac_addr);
+
+	return 0;
+}
+
+
+
+/***************************************************************************
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
+	if (ret == 0)
+		priv->dev->type = ARPHRD_IEEE80211_RADIOTAP;
+	else
+		priv->dev->type = ARPHRD_ETHER;
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+
+
+
+
+/***************************************************************************
+ * Get station
+ */
+
+/*
+ * Returns the signal or 0 in case of an error.
+ */
+
+/* like "struct cmd_ds_802_11_rssi", but with cmd_header. Once we get rid
+ * of WEXT, this should go into host.h */
+struct cmd_rssi {
+	struct cmd_header hdr;
+
+	__le16 n_or_snr;
+	__le16 nf;
+	__le16 avg_snr;
+	__le16 avg_nf;
+} __attribute__ ((packed));
+
+static int lbs_get_signal(struct lbs_private *priv, s8 *signal, s8 *noise)
+{
+	struct cmd_rssi cmd;
+	int ret;
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.n_or_snr = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RSSI, &cmd);
+
+	if (ret == 0) {
+		*signal = CAL_RSSI(le16_to_cpu(cmd.n_or_snr),
+				le16_to_cpu(cmd.nf));
+		*noise  = CAL_NF(le16_to_cpu(cmd.nf));
+	}
+	return ret;
+}
+
+
+static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
+			      u8 *mac, struct station_info *sinfo)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	s8 signal, noise;
+	int ret;
+	size_t i;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	sinfo->filled |= STATION_INFO_TX_BYTES |
+			 STATION_INFO_TX_PACKETS |
+			 STATION_INFO_RX_BYTES |
+			 STATION_INFO_RX_PACKETS;
+	sinfo->tx_bytes = priv->dev->stats.tx_bytes;
+	sinfo->tx_packets = priv->dev->stats.tx_packets;
+	sinfo->rx_bytes = priv->dev->stats.rx_bytes;
+	sinfo->rx_packets = priv->dev->stats.rx_packets;
+
+	/* Get current RSSI */
+	ret = lbs_get_signal(priv, &signal, &noise);
+	if (ret == 0) {
+		sinfo->signal = signal;
+		sinfo->filled |= STATION_INFO_SIGNAL;
+	}
+
+	/* Convert priv->cur_rate from hw_value to NL80211 value */
+	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
+		if (priv->cur_rate == lbs_rates[i].hw_value) {
+			sinfo->txrate.legacy = lbs_rates[i].bitrate;
+			sinfo->filled |= STATION_INFO_TX_BITRATE;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+
+
+
+/***************************************************************************
+ * "Site survey", here just current channel and noise level
+ */
+
+static int lbs_get_survey(struct wiphy *wiphy, struct net_device *dev,
+	int idx, struct survey_info *survey)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	s8 signal, noise;
+	int ret;
+
+	if (idx != 0)
+		ret = -ENOENT;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	survey->channel = ieee80211_get_channel(wiphy,
+		ieee80211_channel_to_frequency(priv->channel));
+
+	ret = lbs_get_signal(priv, &signal, &noise);
+	if (ret == 0) {
+		survey->filled = SURVEY_INFO_NOISE_DBM;
+		survey->noise = noise;
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+
+/***************************************************************************
+ * Change interface
+ */
+
+static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
+	enum nl80211_iftype type, u32 *flags,
+	       struct vif_params *params)
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
+	case NL80211_IFTYPE_STATION:
+		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
+			ret = lbs_enable_monitor_mode(priv, 0);
+		if (!ret)
+			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 1);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
+			ret = lbs_enable_monitor_mode(priv, 0);
+		if (!ret)
+			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 2);
+		break;
+	default:
+		ret = -ENOTSUPP;
+	}
+
+	if (!ret)
+		priv->wdev->iftype = type;
+
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+/***************************************************************************
+ * IBSS (Ad-Hoc)
+ */
+
+/* The firmware needs the following bits masked out of the beacon-derived
+ * capability field when associating/joining to a BSS:
+ *  9 (QoS), 11 (APSD), 12 (unused), 14 (unused), 15 (unused)
+ */
+#define CAPINFO_MASK (~(0xda00))
+
+
+static void lbs_join_post(struct lbs_private *priv,
+			  struct cfg80211_ibss_params *params,
+			  u8 *bssid, u16 capability)
+{
+	u8 fake_ie[2 + IEEE80211_MAX_SSID_LEN + /* ssid */
+		   2 + 4 +                      /* basic rates */
+		   2 + 1 +                      /* DS parameter */
+		   2 + 2 +                      /* atim */
+		   2 + 8];                      /* extended rates */
+	u8 *fake = fake_ie;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/*
+	 * For cfg80211_inform_bss, we'll need a fake IE, as we can't get
+	 * the real IE from the firmware. So we fabricate a fake IE based on
+	 * what the firmware actually sends (sniffed with wireshark).
+	 */
+	/* Fake SSID IE */
+	*fake++ = WLAN_EID_SSID;
+	*fake++ = params->ssid_len;
+	memcpy(fake, params->ssid, params->ssid_len);
+	fake += params->ssid_len;
+	/* Fake supported basic rates IE */
+	*fake++ = WLAN_EID_SUPP_RATES;
+	*fake++ = 4;
+	*fake++ = 0x82;
+	*fake++ = 0x84;
+	*fake++ = 0x8b;
+	*fake++ = 0x96;
+	/* Fake DS channel IE */
+	*fake++ = WLAN_EID_DS_PARAMS;
+	*fake++ = 1;
+	*fake++ = params->channel->hw_value;
+	/* Fake IBSS params IE */
+	*fake++ = WLAN_EID_IBSS_PARAMS;
+	*fake++ = 2;
+	*fake++ = 0; /* ATIM=0 */
+	*fake++ = 0;
+	/* Fake extended rates IE, TODO: don't add this for 802.11b only,
+	 * but I don't know how this could be checked */
+	*fake++ = WLAN_EID_EXT_SUPP_RATES;
+	*fake++ = 8;
+	*fake++ = 0x0c;
+	*fake++ = 0x12;
+	*fake++ = 0x18;
+	*fake++ = 0x24;
+	*fake++ = 0x30;
+	*fake++ = 0x48;
+	*fake++ = 0x60;
+	*fake++ = 0x6c;
+	lbs_deb_hex(LBS_DEB_CFG80211, "IE", fake_ie, fake - fake_ie);
+
+	cfg80211_inform_bss(priv->wdev->wiphy,
+			    params->channel,
+			    bssid,
+			    0,
+			    capability,
+			    params->beacon_interval,
+			    fake_ie, fake - fake_ie,
+			    0, GFP_KERNEL);
+	cfg80211_ibss_joined(priv->dev, bssid, GFP_KERNEL);
+
+	/* TODO: consider doing this at MACREG_INT_CODE_LINK_SENSED time */
+	priv->connect_status = LBS_CONNECTED;
+	netif_carrier_on(priv->dev);
+	if (!priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
+
+static int lbs_ibss_join_existing(struct lbs_private *priv,
+	struct cfg80211_ibss_params *params,
+	struct cfg80211_bss *bss)
+{
+	const u8 *rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+	struct cmd_ds_802_11_ad_hoc_join cmd;
+	u8 preamble = RADIO_PREAMBLE_SHORT;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO: set preamble based on scan result */
+	ret = lbs_set_radio(priv, preamble, 1);
+	if (ret)
+		goto out;
+
+	/*
+	 * Example CMD_802_11_AD_HOC_JOIN command:
+	 *
+	 * command         2c 00         CMD_802_11_AD_HOC_JOIN
+	 * size            65 00
+	 * sequence        xx xx
+	 * result          00 00
+	 * bssid           02 27 27 97 2f 96
+	 * ssid            49 42 53 53 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * type            02            CMD_BSS_TYPE_IBSS
+	 * beacon period   64 00
+	 * dtim period     00
+	 * timestamp       00 00 00 00 00 00 00 00
+	 * localtime       00 00 00 00 00 00 00 00
+	 * IE DS           03
+	 * IE DS len       01
+	 * IE DS channel   01
+	 * reserveed       00 00 00 00
+	 * IE IBSS         06
+	 * IE IBSS len     02
+	 * IE IBSS atim    00 00
+	 * reserved        00 00 00 00
+	 * capability      02 00
+	 * rates           82 84 8b 96 0c 12 18 24 30 48 60 6c 00
+	 * fail timeout    ff 00
+	 * probe delay     00 00
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	memcpy(cmd.bss.bssid, bss->bssid, ETH_ALEN);
+	memcpy(cmd.bss.ssid, params->ssid, params->ssid_len);
+	cmd.bss.type = CMD_BSS_TYPE_IBSS;
+	cmd.bss.beaconperiod = cpu_to_le16(params->beacon_interval);
+	cmd.bss.ds.header.id = WLAN_EID_DS_PARAMS;
+	cmd.bss.ds.header.len = 1;
+	cmd.bss.ds.channel = params->channel->hw_value;
+	cmd.bss.ibss.header.id = WLAN_EID_IBSS_PARAMS;
+	cmd.bss.ibss.header.len = 2;
+	cmd.bss.ibss.atimwindow = 0;
+	cmd.bss.capability = cpu_to_le16(bss->capability & CAPINFO_MASK);
+
+	/* set rates to the intersection of our rates and the rates in the
+	   bss */
+	if (!rates_eid) {
+		lbs_add_rates(cmd.bss.rates);
+	} else {
+		int hw, i;
+		u8 rates_max = rates_eid[1];
+		u8 *rates = cmd.bss.rates;
+		for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
+			u8 hw_rate = lbs_rates[hw].bitrate / 5;
+			for (i = 0; i < rates_max; i++) {
+				if (hw_rate == (rates_eid[i+2] & 0x7f)) {
+					u8 rate = rates_eid[i+2];
+					if (rate == 0x02 || rate == 0x04 ||
+					    rate == 0x0b || rate == 0x16)
+						rate |= 0x80;
+					*rates++ = rate;
+				}
+			}
+		}
+	}
+
+	/* Only v8 and below support setting this */
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8) {
+		cmd.failtimeout = cpu_to_le16(MRVDRV_ASSOCIATION_TIME_OUT);
+		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
+	}
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_JOIN, &cmd);
+	if (ret)
+		goto out;
+
+	/*
+	 * This is a sample response to CMD_802_11_AD_HOC_JOIN:
+	 *
+	 * response        2c 80
+	 * size            09 00
+	 * sequence        xx xx
+	 * result          00 00
+	 * reserved        00
+	 */
+	lbs_join_post(priv, params, bss->bssid, bss->capability);
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+static int lbs_ibss_start_new(struct lbs_private *priv,
+	struct cfg80211_ibss_params *params)
+{
+	struct cmd_ds_802_11_ad_hoc_start cmd;
+	struct cmd_ds_802_11_ad_hoc_result *resp =
+		(struct cmd_ds_802_11_ad_hoc_result *) &cmd;
+	u8 preamble = RADIO_PREAMBLE_SHORT;
+	int ret = 0;
+	u16 capability;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	ret = lbs_set_radio(priv, preamble, 1);
+	if (ret)
+		goto out;
+
+	/*
+	 * Example CMD_802_11_AD_HOC_START command:
+	 *
+	 * command         2b 00         CMD_802_11_AD_HOC_START
+	 * size            b1 00
+	 * sequence        xx xx
+	 * result          00 00
+	 * ssid            54 45 53 54 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * bss type        02
+	 * beacon period   64 00
+	 * dtim period     00
+	 * IE IBSS         06
+	 * IE IBSS len     02
+	 * IE IBSS atim    00 00
+	 * reserved        00 00 00 00
+	 * IE DS           03
+	 * IE DS len       01
+	 * IE DS channel   01
+	 * reserved        00 00 00 00
+	 * probe delay     00 00
+	 * capability      02 00
+	 * rates           82 84 8b 96   (basic rates with have bit 7 set)
+	 *                 0c 12 18 24 30 48 60 6c
+	 * padding         100 bytes
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	memcpy(cmd.ssid, params->ssid, params->ssid_len);
+	cmd.bsstype = CMD_BSS_TYPE_IBSS;
+	cmd.beaconperiod = cpu_to_le16(params->beacon_interval);
+	cmd.ibss.header.id = WLAN_EID_IBSS_PARAMS;
+	cmd.ibss.header.len = 2;
+	cmd.ibss.atimwindow = 0;
+	cmd.ds.header.id = WLAN_EID_DS_PARAMS;
+	cmd.ds.header.len = 1;
+	cmd.ds.channel = params->channel->hw_value;
+	/* Only v8 and below support setting probe delay */
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8)
+		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
+	/* TODO: mix in WLAN_CAPABILITY_PRIVACY */
+	capability = cpu_to_le16(WLAN_CAPABILITY_IBSS);
+	cmd.capability = cpu_to_le16(capability);
+	lbs_add_rates(cmd.rates);
+
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_START, &cmd);
+	if (ret)
+		goto out;
+
+	/*
+	 * This is a sample response to CMD_802_11_AD_HOC_JOIN:
+	 *
+	 * response        2b 80
+	 * size            14 00
+	 * sequence        xx xx
+	 * result          00 00
+	 * reserved        00
+	 * bssid           02 2b 7b 0f 86 0e
+	 */
+	lbs_join_post(priv, params, resp->bssid, capability);
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+		struct cfg80211_ibss_params *params)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = 0;
+	struct cfg80211_bss *bss;
+	DECLARE_SSID_BUF(ssid_buf);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (!params->channel) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	ret = lbs_set_channel(priv, params->channel->hw_value);
+	if (ret)
+		goto out;
+
+	/* Search if someone is beaconing. This assumes that the
+	 * bss list is populated already */
+	bss = cfg80211_get_bss(wiphy, params->channel, params->bssid,
+		params->ssid, params->ssid_len,
+		WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+
+	if (bss) {
+		ret = lbs_ibss_join_existing(priv, params, bss);
+		cfg80211_put_bss(bss);
+	} else
+		ret = lbs_ibss_start_new(priv, params);
+
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+static int lbs_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cmd_ds_802_11_ad_hoc_stop cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_STOP, &cmd);
+
+	/* TODO: consider doing this at MACREG_INT_CODE_ADHOC_BCN_LOST time */
+	lbs_mac_event_disconnected(priv);
+
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+
+/***************************************************************************
+ * Initialization
+ */
 
 static struct cfg80211_ops lbs_cfg80211_ops = {
 	.set_channel = lbs_cfg_set_channel,
+	.scan = lbs_cfg_scan,
+	.set_wiphy_params = lbs_cfg_set_wiphy_params,
+	.connect = lbs_cfg_connect,
+	.disconnect = lbs_cfg_disconnect,
+	.add_key = lbs_cfg_add_key,
+	.del_key = lbs_cfg_del_key,
+	.set_default_key = lbs_cfg_set_default_key,
+	.get_station = lbs_cfg_get_station,
+	.dump_survey = lbs_get_survey,
+	.change_virtual_intf = lbs_change_intf,
+	.join_ibss = lbs_join_ibss,
+	.leave_ibss = lbs_leave_ibss,
 };
 
 
@@ -140,6 +1992,36 @@ struct wireless_dev *lbs_cfg_alloc(struct device *dev)
 }
 
 
+static void lbs_cfg_set_regulatory_hint(struct lbs_private *priv)
+{
+	struct region_code_mapping {
+		const char *cn;
+		int code;
+	};
+
+	/* Section 5.17.2 */
+	static struct region_code_mapping regmap[] = {
+		{"US ", 0x10}, /* US FCC */
+		{"CA ", 0x20}, /* Canada */
+		{"EU ", 0x30}, /* ETSI   */
+		{"ES ", 0x31}, /* Spain  */
+		{"FR ", 0x32}, /* France */
+		{"JP ", 0x40}, /* Japan  */
+	};
+	size_t i;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	for (i = 0; i < ARRAY_SIZE(regmap); i++)
+		if (regmap[i].code == priv->regioncode) {
+			regulatory_hint(priv->wdev->wiphy, regmap[i].cn);
+			break;
+		}
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
+
+
 /*
  * This function get's called after lbs_setup_firmware() determined the
  * firmware capabities. So we can setup the wiphy according to our
@@ -155,10 +2037,12 @@ int lbs_cfg_register(struct lbs_private *priv)
 	wdev->wiphy->max_scan_ssids = 1;
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-	/* TODO: BIT(NL80211_IFTYPE_ADHOC); */
-	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wdev->wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_ADHOC);
+	if (lbs_rtap_supported(priv))
+		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 
-	/* TODO: honor priv->regioncode */
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
 
 	/*
@@ -176,11 +2060,22 @@ int lbs_cfg_register(struct lbs_private *priv)
 	if (ret)
 		lbs_pr_err("cannot register network device\n");
 
+	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
+
+	lbs_cfg_set_regulatory_hint(priv);
+
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
 }
 
 
+void lbs_scan_deinit(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+	cancel_delayed_work_sync(&priv->scan_work);
+}
+
+
 void lbs_cfg_free(struct lbs_private *priv)
 {
 	struct wireless_dev *wdev = priv->wdev;
diff --git a/drivers/net/wireless/libertas/cfg.h b/drivers/net/wireless/libertas/cfg.h
index e09a193..eae3fd9 100644
--- a/drivers/net/wireless/libertas/cfg.h
+++ b/drivers/net/wireless/libertas/cfg.h
@@ -1,16 +1,22 @@
 #ifndef __LBS_CFG80211_H__
 #define __LBS_CFG80211_H__
 
-#include "dev.h"
+struct device;
+struct lbs_private;
 
 struct wireless_dev *lbs_cfg_alloc(struct device *dev);
 int lbs_cfg_register(struct lbs_private *priv);
 void lbs_cfg_free(struct lbs_private *priv);
 
-int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
-	u8 ssid_len);
-int lbs_scan_networks(struct lbs_private *priv, int full_scan);
-void lbs_cfg_scan_worker(struct work_struct *work);
+/* All of those are TODOs: */
+#define lbs_cmd_802_11_rssi(priv, cmdptr) (0)
+#define lbs_ret_802_11_rssi(priv, resp) (0)
+#define lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action) (0)
+#define lbs_ret_802_11_bcn_ctrl(priv, resp) (0)
 
+void lbs_send_disconnect_notification(struct lbs_private *priv);
+void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
+
+void lbs_scan_deinit(struct lbs_private *priv);
 
 #endif
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 82371ef..44eb10b 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -6,13 +6,8 @@
 #include <linux/kfifo.h>
 #include <linux/sched.h>
 
-#include "host.h"
 #include "decl.h"
-#include "defs.h"
-#include "dev.h"
-#include "assoc.h"
-#include "wext.h"
-#include "scan.h"
+#include "cfg.h"
 #include "cmd.h"
 
 
@@ -174,11 +169,6 @@ int lbs_update_hw_spec(struct lbs_private *priv)
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
-	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
-		ret = -1;
-		goto out;
-	}
-
 out:
 	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
@@ -1302,6 +1292,15 @@ int lbs_execute_next_command(struct lbs_private *priv)
 		 * check if in power save mode, if yes, put the device back
 		 * to PS mode
 		 */
+#ifdef TODO
+		/*
+		 * This was the old code for libertas+wext. Someone that
+		 * understands this beast should re-code it in a sane way.
+		 *
+		 * I actually don't understand why this is related to WPA
+		 * and to connection status, shouldn't powering should be
+		 * independ of such things?
+		 */
 		if ((priv->psmode != LBS802_11POWERMODECAM) &&
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
 		    ((priv->connect_status == LBS_CONNECTED) ||
@@ -1323,6 +1322,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				lbs_ps_sleep(priv, 0);
 			}
 		}
+#endif
 	}
 
 	ret = 0;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 0334a58..300f1fe 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -4,18 +4,11 @@
   */
 #include <linux/delay.h>
 #include <linux/sched.h>
-#include <linux/if_arp.h>
-#include <linux/netdevice.h>
 #include <asm/unaligned.h>
-#include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
-#include "host.h"
-#include "decl.h"
+#include "cfg.h"
 #include "cmd.h"
-#include "defs.h"
-#include "dev.h"
-#include "assoc.h"
-#include "wext.h"
 
 /**
  *  @brief This function handles disconnect event. it
@@ -48,23 +41,8 @@ void lbs_mac_event_disconnected(struct lbs_private *priv)
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 
-	/* reset SNR/NF/RSSI values */
-	memset(priv->SNR, 0x00, sizeof(priv->SNR));
-	memset(priv->NF, 0x00, sizeof(priv->NF));
-	memset(priv->RSSI, 0x00, sizeof(priv->RSSI));
-	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
-	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
-	priv->nextSNRNF = 0;
-	priv->numSNRNF = 0;
 	priv->connect_status = LBS_DISCONNECTED;
 
-	/* Clear out associated SSID and BSSID since connection is
-	 * no longer valid.
-	 */
-	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
-	memset(&priv->curbssparams.ssid, 0, IEEE80211_MAX_SSID_LEN);
-	priv->curbssparams.ssid_len = 0;
-
 	if (priv->psstate != PS_STATE_FULL_POWER) {
 		/* make firmware to exit PS mode */
 		lbs_deb_cmd("disconnected, so exit PS mode\n");
@@ -265,7 +243,7 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 			 * ad-hoc mode. It takes place in
 			 * lbs_execute_next_command().
 			 */
-			if (priv->mode == IW_MODE_ADHOC &&
+			if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR &&
 			    action == CMD_SUBCMD_ENTER_PS)
 				priv->psmode = LBS802_11POWERMODECAM;
 		} else if (action == CMD_SUBCMD_ENTER_PS) {
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 587b0cb..22e9ae9 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -1,17 +1,12 @@
-#include <linux/module.h>
 #include <linux/dcache.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <net/iw_handler.h>
-#include <net/lib80211.h>
 
-#include "dev.h"
 #include "decl.h"
-#include "host.h"
-#include "debugfs.h"
 #include "cmd.h"
+#include "debugfs.h"
 
 static struct dentry *lbs_dir;
 static char *szStates[] = {
@@ -60,50 +55,6 @@ static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 }
 
 
-static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	size_t pos = 0;
-	int numscansdone = 0, res;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-	DECLARE_SSID_BUF(ssid);
-	struct bss_descriptor * iter_bss;
-	if (!buf)
-		return -ENOMEM;
-
-	pos += snprintf(buf+pos, len-pos,
-		"# | ch  | rssi |       bssid       |   cap    | Qual | SSID \n");
-
-	mutex_lock(&priv->lock);
-	list_for_each_entry (iter_bss, &priv->network_list, list) {
-		u16 ibss = (iter_bss->capability & WLAN_CAPABILITY_IBSS);
-		u16 privacy = (iter_bss->capability & WLAN_CAPABILITY_PRIVACY);
-		u16 spectrum_mgmt = (iter_bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT);
-
-		pos += snprintf(buf+pos, len-pos, "%02u| %03d | %04d | %pM |",
-			numscansdone, iter_bss->channel, iter_bss->rssi,
-			iter_bss->bssid);
-		pos += snprintf(buf+pos, len-pos, " %04x-", iter_bss->capability);
-		pos += snprintf(buf+pos, len-pos, "%c%c%c |",
-				ibss ? 'A' : 'I', privacy ? 'P' : ' ',
-				spectrum_mgmt ? 'S' : ' ');
-		pos += snprintf(buf+pos, len-pos, " %04d |", SCAN_RSSI(iter_bss->rssi));
-		pos += snprintf(buf+pos, len-pos, " %s\n",
-		                print_ssid(ssid, iter_bss->ssid,
-					   iter_bss->ssid_len));
-
-		numscansdone++;
-	}
-	mutex_unlock(&priv->lock);
-
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return res;
-}
-
 static ssize_t lbs_sleepparams_write(struct file *file,
 				const char __user *user_buf, size_t count,
 				loff_t *ppos)
@@ -722,8 +673,6 @@ struct lbs_debugfs_files {
 
 static const struct lbs_debugfs_files debugfs_files[] = {
 	{ "info", 0444, FOPS(lbs_dev_info, write_file_dummy), },
-	{ "getscantable", 0444, FOPS(lbs_getscantable,
-					write_file_dummy), },
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
 };
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 709ffca..2bccad3 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -1,3 +1,4 @@
+
 /**
   *  This file contains declaration referring to
   *  functions defined in other source files
@@ -34,6 +35,8 @@ int lbs_start_card(struct lbs_private *priv);
 void lbs_stop_card(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
+int lbs_rtap_supported(struct lbs_private *priv);
+
 int lbs_set_mac_address(struct net_device *dev, void *addr);
 void lbs_set_multicast_list(struct net_device *dev);
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index c348aff..41e48fa 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -7,8 +7,8 @@
 #define _LBS_DEV_H_
 
 #include "mesh.h"
-#include "scan.h"
-#include "assoc.h"
+#include "defs.h"
+#include "host.h"
 
 #include <linux/kfifo.h>
 
@@ -29,13 +29,15 @@ struct lbs_private {
 	/* Basic networking */
 	struct net_device *dev;
 	u32 connect_status;
-	int infra_open;
 	struct work_struct mcast_work;
 	u32 nr_of_multicastmacaddr;
 	u8 multicastlist[MRVDRV_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
 
 	/* CFG80211 */
 	struct wireless_dev *wdev;
+	struct cfg80211_scan_request *scan_req;
+	u8 assoc_bss[ETH_ALEN];
+	u8 disassoc_reason;
 
 	/* Mesh */
 	struct net_device *mesh_dev; /* Virtual device */
@@ -48,10 +50,6 @@ struct lbs_private {
 	u8 mesh_ssid_len;
 #endif
 
-	/* Monitor mode */
-	struct net_device *rtap_net_dev;
-	u32 monitormode;
-
 	/* Debugfs */
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_debug;
@@ -127,13 +125,9 @@ struct lbs_private {
 	struct workqueue_struct *work_thread;
 
 	/** Encryption stuff */
-	struct lbs_802_11_security secinfo;
-	struct enc_key wpa_mcast_key;
-	struct enc_key wpa_unicast_key;
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
-	u16 wep_tx_keyidx;
-	struct enc_key wep_keys[4];
+	u8 wep_tx_key;
+	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
+	u8 wep_key_len[4];
 
 	/* Wake On LAN */
 	uint32_t wol_criteria;
@@ -154,6 +148,7 @@ struct lbs_private {
 	/* NIC/link operation characteristics */
 	u16 mac_control;
 	u8 radio_on;
+	u8 cur_rate;
 	u8 channel;
 	s16 txpower_cur;
 	s16 txpower_min;
@@ -162,42 +157,6 @@ struct lbs_private {
 	/** Scanning */
 	struct delayed_work scan_work;
 	int scan_channel;
-	/* remember which channel was scanned last, != 0 if currently scanning */
-	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 scan_ssid_len;
-
-	/* Associating */
-	struct delayed_work assoc_work;
-	struct current_bss_params curbssparams;
-	u8 mode;
-	struct list_head network_list;
-	struct list_head network_free_list;
-	struct bss_descriptor *networks;
-	struct assoc_request * pending_assoc_req;
-	struct assoc_request * in_progress_assoc_req;
-	uint16_t enablehwauto;
-
-	/* ADHOC */
-	u16 beacon_period;
-	u8 beacon_enable;
-	u8 adhoccreate;
-
-	/* WEXT */
-	char name[DEV_NAME_LEN];
-	u8 nodename[16];
-	struct iw_statistics wstats;
-	u8 cur_rate;
-#define	MAX_REGION_CHANNEL_NUM	2
-	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
-
-	/** Requested Signal Strength*/
-	u16 SNR[MAX_TYPE_B][MAX_TYPE_AVG];
-	u16 NF[MAX_TYPE_B][MAX_TYPE_AVG];
-	u8 RSSI[MAX_TYPE_B][MAX_TYPE_AVG];
-	u8 rawSNR[DEFAULT_DATA_AVG_FACTOR];
-	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
-	u16 nextSNRNF;
-	u16 numSNRNF;
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 3804a58..7c49d1c 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -2,13 +2,8 @@
 #include <linux/ethtool.h>
 #include <linux/delay.h>
 
-#include "host.h"
 #include "decl.h"
-#include "defs.h"
-#include "dev.h"
-#include "wext.h"
 #include "cmd.h"
-#include "mesh.h"
 
 
 static void lbs_ethtool_get_drvinfo(struct net_device *dev,
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 60bde12..fcc90a6 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -11,19 +11,13 @@
 #include <linux/if_arp.h>
 #include <linux/kthread.h>
 #include <linux/kfifo.h>
-#include <linux/stddef.h>
-#include <linux/ieee80211.h>
-#include <net/iw_handler.h>
 #include <net/cfg80211.h>
 
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
-#include "wext.h"
 #include "cfg.h"
 #include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
 #include "cmd.h"
 
 #define DRIVER_RELEASE_VERSION "323.p0"
@@ -95,72 +89,6 @@ u8 lbs_data_rate_to_fw_index(u32 rate)
 }
 
 
-static int lbs_add_rtap(struct lbs_private *priv);
-static void lbs_remove_rtap(struct lbs_private *priv);
-
-
-/**
- * Get function for sysfs attribute rtap
- */
-static ssize_t lbs_rtap_get(struct device *dev,
-		struct device_attribute *attr, char * buf)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	return snprintf(buf, 5, "0x%X\n", priv->monitormode);
-}
-
-/**
- *  Set function for sysfs attribute rtap
- */
-static ssize_t lbs_rtap_set(struct device *dev,
-		struct device_attribute *attr, const char * buf, size_t count)
-{
-	int monitor_mode;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-
-	sscanf(buf, "%x", &monitor_mode);
-	if (monitor_mode) {
-		if (priv->monitormode == monitor_mode)
-			return strlen(buf);
-		if (!priv->monitormode) {
-			if (priv->infra_open || lbs_mesh_open(priv))
-				return -EBUSY;
-			if (priv->mode == IW_MODE_INFRA)
-				lbs_cmd_80211_deauthenticate(priv,
-							     priv->curbssparams.bssid,
-							     WLAN_REASON_DEAUTH_LEAVING);
-			else if (priv->mode == IW_MODE_ADHOC)
-				lbs_adhoc_stop(priv);
-			lbs_add_rtap(priv);
-		}
-		priv->monitormode = monitor_mode;
-	} else {
-		if (!priv->monitormode)
-			return strlen(buf);
-		priv->monitormode = 0;
-		lbs_remove_rtap(priv);
-
-		if (priv->currenttxskb) {
-			dev_kfree_skb_any(priv->currenttxskb);
-			priv->currenttxskb = NULL;
-		}
-
-		/* Wake queues, command thread, etc. */
-		lbs_host_to_card_done(priv);
-	}
-
-	lbs_prepare_and_send_command(priv,
-			CMD_802_11_MONITOR_MODE, CMD_ACT_SET,
-			CMD_OPTION_WAITFORRSP, 0, &priv->monitormode);
-	return strlen(buf);
-}
-
-/**
- * lbs_rtap attribute to be exported per ethX interface
- * through sysfs (/sys/class/net/ethX/lbs_rtap)
- */
-static DEVICE_ATTR(lbs_rtap, 0644, lbs_rtap_get, lbs_rtap_set );
-
 /**
  *  @brief This function opens the ethX interface
  *
@@ -176,13 +104,6 @@ static int lbs_dev_open(struct net_device *dev)
 
 	spin_lock_irq(&priv->driver_lock);
 
-	if (priv->monitormode) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	priv->infra_open = 1;
-
 	if (priv->connect_status == LBS_CONNECTED)
 		netif_carrier_on(dev);
 	else
@@ -190,7 +111,6 @@ static int lbs_dev_open(struct net_device *dev)
 
 	if (!priv->tx_pending_len)
 		netif_wake_queue(dev);
- out:
 
 	spin_unlock_irq(&priv->driver_lock);
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
@@ -210,7 +130,6 @@ static int lbs_eth_stop(struct net_device *dev)
 	lbs_deb_enter(LBS_DEB_NET);
 
 	spin_lock_irq(&priv->driver_lock);
-	priv->infra_open = 0;
 	netif_stop_queue(dev);
 	spin_unlock_irq(&priv->driver_lock);
 
@@ -811,37 +730,16 @@ int lbs_exit_auto_deep_sleep(struct lbs_private *priv)
 
 static int lbs_init_adapter(struct lbs_private *priv)
 {
-	size_t bufsize;
-	int i, ret = 0;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	/* Allocate buffer to store the BSSID list */
-	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
-	priv->networks = kzalloc(bufsize, GFP_KERNEL);
-	if (!priv->networks) {
-		lbs_pr_err("Out of memory allocating beacons\n");
-		ret = -1;
-		goto out;
-	}
-
-	/* Initialize scan result lists */
-	INIT_LIST_HEAD(&priv->network_free_list);
-	INIT_LIST_HEAD(&priv->network_list);
-	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		list_add_tail(&priv->networks[i].list,
-			      &priv->network_free_list);
-	}
-
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	priv->connect_status = LBS_DISCONNECTED;
-	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	priv->mode = IW_MODE_INFRA;
 	priv->channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
-	priv->enablehwauto = 1;
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
 	priv->is_deep_sleep = 0;
@@ -892,8 +790,6 @@ static void lbs_free_adapter(struct lbs_private *priv)
 	kfifo_free(&priv->event_fifo);
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
-	kfree(priv->networks);
-	priv->networks = NULL;
 
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
@@ -930,7 +826,7 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 		lbs_pr_err("cfg80211 init failed\n");
 		goto done;
 	}
-	/* TODO? */
+
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	priv = wdev_priv(wdev);
 	priv->wdev = wdev;
@@ -940,7 +836,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 		goto err_wdev;
 	}
 
-	//TODO? dev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
 	dev = alloc_netdev(0, "wlan%d", ether_setup);
 	if (!dev) {
 		dev_err(dmdev, "no memory for network device instance\n");
@@ -956,20 +851,10 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->ethtool_ops = &lbs_ethtool_ops;
-#ifdef	WIRELESS_EXT
-	dev->wireless_handlers = &lbs_handler_def;
-#endif
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 
-
-	// TODO: kzalloc + iwm_init_default_profile(iwm, iwm->umac_profile); ??
-
-
 	priv->card = card;
-	priv->infra_open = 0;
-
 
-	priv->rtap_net_dev = NULL;
 	strcpy(dev->name, "wlan%d");
 
 	lbs_deb_thread("Starting main thread...\n");
@@ -981,8 +866,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
-	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
-	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 
 	priv->wol_criteria = 0xffffffff;
@@ -1015,12 +898,10 @@ void lbs_remove_card(struct lbs_private *priv)
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	lbs_remove_mesh(priv);
-	lbs_remove_rtap(priv);
+	lbs_scan_deinit(priv);
 
 	dev = priv->dev;
 
-	cancel_delayed_work_sync(&priv->scan_work);
-	cancel_delayed_work_sync(&priv->assoc_work);
 	cancel_work_sync(&priv->mcast_work);
 
 	/* worker thread destruction blocks on the in-flight command which
@@ -1057,7 +938,7 @@ void lbs_remove_card(struct lbs_private *priv)
 EXPORT_SYMBOL_GPL(lbs_remove_card);
 
 
-static int lbs_rtap_supported(struct lbs_private *priv)
+int lbs_rtap_supported(struct lbs_private *priv)
 {
 	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V5)
 		return 1;
@@ -1089,16 +970,6 @@ int lbs_start_card(struct lbs_private *priv)
 
 	lbs_init_mesh(priv);
 
-	/*
-	 * While rtap isn't related to mesh, only mesh-enabled
-	 * firmware implements the rtap functionality via
-	 * CMD_802_11_MONITOR_MODE.
-	 */
-	if (lbs_rtap_supported(priv)) {
-		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
-			lbs_pr_err("cannot register lbs_rtap attribute\n");
-	}
-
 	lbs_debugfs_init_one(priv, dev);
 
 	lbs_pr_info("%s: Marvell WLAN 802.11 adapter\n", dev->name);
@@ -1130,9 +1001,6 @@ void lbs_stop_card(struct lbs_private *priv)
 	lbs_debugfs_remove_one(priv);
 	lbs_deinit_mesh(priv);
 
-	if (lbs_rtap_supported(priv))
-		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
-
 	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
 	del_timer_sync(&priv->auto_deepsleep_timer);
@@ -1219,87 +1087,6 @@ static void __exit lbs_exit_module(void)
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
-/*
- * rtap interface support fuctions
- */
-
-static int lbs_rtap_open(struct net_device *dev)
-{
-	/* Yes, _stop_ the queue. Because we don't support injection */
-	lbs_deb_enter(LBS_DEB_MAIN);
-	netif_carrier_off(dev);
-	netif_stop_queue(dev);
-	lbs_deb_leave(LBS_DEB_LEAVE);
-	return 0;
-}
-
-static int lbs_rtap_stop(struct net_device *dev)
-{
-	lbs_deb_enter(LBS_DEB_MAIN);
-	lbs_deb_leave(LBS_DEB_MAIN);
-	return 0;
-}
-
-static netdev_tx_t lbs_rtap_hard_start_xmit(struct sk_buff *skb,
-					    struct net_device *dev)
-{
-	netif_stop_queue(dev);
-	return NETDEV_TX_BUSY;
-}
-
-static void lbs_remove_rtap(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_MAIN);
-	if (priv->rtap_net_dev == NULL)
-		goto out;
-	unregister_netdev(priv->rtap_net_dev);
-	free_netdev(priv->rtap_net_dev);
-	priv->rtap_net_dev = NULL;
-out:
-	lbs_deb_leave(LBS_DEB_MAIN);
-}
-
-static const struct net_device_ops rtap_netdev_ops = {
-	.ndo_open = lbs_rtap_open,
-	.ndo_stop = lbs_rtap_stop,
-	.ndo_start_xmit = lbs_rtap_hard_start_xmit,
-};
-
-static int lbs_add_rtap(struct lbs_private *priv)
-{
-	int ret = 0;
-	struct net_device *rtap_dev;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-	if (priv->rtap_net_dev) {
-		ret = -EPERM;
-		goto out;
-	}
-
-	rtap_dev = alloc_netdev(0, "rtap%d", ether_setup);
-	if (rtap_dev == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
-	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	rtap_dev->netdev_ops = &rtap_netdev_ops;
-	rtap_dev->ml_priv = priv;
-	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
-
-	ret = register_netdev(rtap_dev);
-	if (ret) {
-		free_netdev(rtap_dev);
-		goto out;
-	}
-	priv->rtap_net_dev = rtap_dev;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
-	return ret;
-}
-
 module_init(lbs_init_module);
 module_exit(lbs_exit_module);
 
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 2daf8ff..0cc3488 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -3,12 +3,13 @@
   */
 #include <linux/etherdevice.h>
 #include <linux/types.h>
+#include <net/cfg80211.h>
 
+#include "defs.h"
 #include "host.h"
 #include "radiotap.h"
 #include "decl.h"
 #include "dev.h"
-#include "wext.h"
 
 struct eth803hdr {
 	u8 dest_addr[6];
@@ -38,99 +39,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	struct sk_buff *skb);
 
 /**
- *  @brief This function computes the avgSNR .
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   avgSNR
- */
-static u8 lbs_getavgsnr(struct lbs_private *priv)
-{
-	u8 i;
-	u16 temp = 0;
-	if (priv->numSNRNF == 0)
-		return 0;
-	for (i = 0; i < priv->numSNRNF; i++)
-		temp += priv->rawSNR[i];
-	return (u8) (temp / priv->numSNRNF);
-
-}
-
-/**
- *  @brief This function computes the AvgNF
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   AvgNF
- */
-static u8 lbs_getavgnf(struct lbs_private *priv)
-{
-	u8 i;
-	u16 temp = 0;
-	if (priv->numSNRNF == 0)
-		return 0;
-	for (i = 0; i < priv->numSNRNF; i++)
-		temp += priv->rawNF[i];
-	return (u8) (temp / priv->numSNRNF);
-
-}
-
-/**
- *  @brief This function save the raw SNR/NF to our internel buffer
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @param prxpd   A pointer to rxpd structure of received packet
- *  @return 	   n/a
- */
-static void lbs_save_rawSNRNF(struct lbs_private *priv, struct rxpd *p_rx_pd)
-{
-	if (priv->numSNRNF < DEFAULT_DATA_AVG_FACTOR)
-		priv->numSNRNF++;
-	priv->rawSNR[priv->nextSNRNF] = p_rx_pd->snr;
-	priv->rawNF[priv->nextSNRNF] = p_rx_pd->nf;
-	priv->nextSNRNF++;
-	if (priv->nextSNRNF >= DEFAULT_DATA_AVG_FACTOR)
-		priv->nextSNRNF = 0;
-	return;
-}
-
-/**
- *  @brief This function computes the RSSI in received packet.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @param prxpd   A pointer to rxpd structure of received packet
- *  @return 	   n/a
- */
-static void lbs_compute_rssi(struct lbs_private *priv, struct rxpd *p_rx_pd)
-{
-
-	lbs_deb_enter(LBS_DEB_RX);
-
-	lbs_deb_rx("rxpd: SNR %d, NF %d\n", p_rx_pd->snr, p_rx_pd->nf);
-	lbs_deb_rx("before computing SNR: SNR-avg = %d, NF-avg = %d\n",
-	       priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-	       priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-
-	priv->SNR[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->snr;
-	priv->NF[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->nf;
-	lbs_save_rawSNRNF(priv, p_rx_pd);
-
-	priv->SNR[TYPE_RXPD][TYPE_AVG] = lbs_getavgsnr(priv) * AVG_SCALE;
-	priv->NF[TYPE_RXPD][TYPE_AVG] = lbs_getavgnf(priv) * AVG_SCALE;
-	lbs_deb_rx("after computing SNR: SNR-avg = %d, NF-avg = %d\n",
-	       priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-	       priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-
-	priv->RSSI[TYPE_RXPD][TYPE_NOAVG] =
-	    CAL_RSSI(priv->SNR[TYPE_RXPD][TYPE_NOAVG],
-		     priv->NF[TYPE_RXPD][TYPE_NOAVG]);
-
-	priv->RSSI[TYPE_RXPD][TYPE_AVG] =
-	    CAL_RSSI(priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-		     priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-
-	lbs_deb_leave(LBS_DEB_RX);
-}
-
-/**
  *  @brief This function processes received packet and forwards it
  *  to kernel/upper layer
  *
@@ -154,7 +62,7 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	if (priv->monitormode)
+	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
 		return process_rxed_802_11_packet(priv, skb);
 
 	p_rx_pd = (struct rxpd *) skb->data;
@@ -225,13 +133,7 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 	 */
 	skb_pull(skb, hdrchop);
 
-	/* Take the data rate from the rxpd structure
-	 * only if the rate is auto
-	 */
-	if (priv->enablehwauto)
-		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
-
-	lbs_compute_rssi(priv, p_rx_pd);
+	priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
 
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
@@ -353,20 +255,18 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
 	memcpy(pradiotap_hdr, &radiotap_hdr, sizeof(struct rx_radiotap_hdr));
 
-	/* Take the data rate from the rxpd structure
-	 * only if the rate is auto
-	 */
-	if (priv->enablehwauto)
-		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
-
-	lbs_compute_rssi(priv, prxpd);
+	priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
 
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
 
-	skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
-	netif_rx(skb);
+	skb->protocol = eth_type_trans(skb, priv->dev);
+
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		netif_rx_ni(skb);
 
 	ret = 0;
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
deleted file mode 100644
index 220361e..0000000
--- a/drivers/net/wireless/libertas/scan.c
+++ /dev/null
@@ -1,1353 +0,0 @@
-/**
-  * Functions implementing wlan scan IOCTL and firmware command APIs
-  *
-  * IOCTL handlers as well as command preperation and response routines
-  *  for sending scan commands to the firmware.
-  */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/etherdevice.h>
-#include <linux/if_arp.h>
-#include <asm/unaligned.h>
-#include <net/lib80211.h>
-
-#include "host.h"
-#include "dev.h"
-#include "scan.h"
-#include "assoc.h"
-#include "wext.h"
-#include "cmd.h"
-
-//! Approximate amount of data needed to pass a scan result back to iwlist
-#define MAX_SCAN_CELL_SIZE  (IW_EV_ADDR_LEN             \
-                             + IEEE80211_MAX_SSID_LEN   \
-                             + IW_EV_UINT_LEN           \
-                             + IW_EV_FREQ_LEN           \
-                             + IW_EV_QUAL_LEN           \
-                             + IEEE80211_MAX_SSID_LEN   \
-                             + IW_EV_PARAM_LEN          \
-                             + 40)	/* 40 for WPAIE */
-
-//! Memory needed to store a max sized channel List TLV for a firmware scan
-#define CHAN_TLV_MAX_SIZE  (sizeof(struct mrvl_ie_header)    \
-                            + (MRVDRV_MAX_CHANNELS_PER_SCAN     \
-                               * sizeof(struct chanscanparamset)))
-
-//! Memory needed to store a max number/size SSID TLV for a firmware scan
-#define SSID_TLV_MAX_SIZE  (1 * sizeof(struct mrvl_ie_ssid_param_set))
-
-//! Maximum memory needed for a cmd_ds_802_11_scan with all TLVs at max
-#define MAX_SCAN_CFG_ALLOC (sizeof(struct cmd_ds_802_11_scan)	\
-                            + CHAN_TLV_MAX_SIZE + SSID_TLV_MAX_SIZE)
-
-//! The maximum number of channels the firmware can scan per command
-#define MRVDRV_MAX_CHANNELS_PER_SCAN   14
-
-/**
- * @brief Number of channels to scan per firmware scan command issuance.
- *
- *  Number restricted to prevent hitting the limit on the amount of scan data
- *  returned in a single firmware scan command.
- */
-#define MRVDRV_CHANNELS_PER_SCAN_CMD   4
-
-//! Scan time specified in the channel TLV for each channel for passive scans
-#define MRVDRV_PASSIVE_SCAN_CHAN_TIME  100
-
-//! Scan time specified in the channel TLV for each channel for active scans
-#define MRVDRV_ACTIVE_SCAN_CHAN_TIME   100
-
-#define DEFAULT_MAX_SCAN_AGE (15 * HZ)
-
-static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
-			      struct cmd_header *resp);
-
-/*********************************************************************/
-/*                                                                   */
-/*  Misc helper functions                                            */
-/*                                                                   */
-/*********************************************************************/
-
-/**
- *  @brief Unsets the MSB on basic rates
- *
- * Scan through an array and unset the MSB for basic data rates.
- *
- *  @param rates     buffer of data rates
- *  @param len       size of buffer
- */
-static void lbs_unset_basic_rate_flags(u8 *rates, size_t len)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		rates[i] &= 0x7f;
-}
-
-
-static inline void clear_bss_descriptor(struct bss_descriptor *bss)
-{
-	/* Don't blow away ->list, just BSS data */
-	memset(bss, 0, offsetof(struct bss_descriptor, list));
-}
-
-/**
- *  @brief Compare two SSIDs
- *
- *  @param ssid1    A pointer to ssid to compare
- *  @param ssid2    A pointer to ssid to compare
- *
- *  @return         0: ssid is same, otherwise is different
- */
-int lbs_ssid_cmp(uint8_t *ssid1, uint8_t ssid1_len, uint8_t *ssid2,
-		 uint8_t ssid2_len)
-{
-	if (ssid1_len != ssid2_len)
-		return -1;
-
-	return memcmp(ssid1, ssid2, ssid1_len);
-}
-
-static inline int is_same_network(struct bss_descriptor *src,
-				  struct bss_descriptor *dst)
-{
-	/* A network is only a duplicate if the channel, BSSID, and ESSID
-	 * all match.  We treat all <hidden> with the same BSSID and channel
-	 * as one network */
-	return ((src->ssid_len == dst->ssid_len) &&
-		(src->channel == dst->channel) &&
-		!compare_ether_addr(src->bssid, dst->bssid) &&
-		!memcmp(src->ssid, dst->ssid, src->ssid_len));
-}
-
-
-
-/*********************************************************************/
-/*                                                                   */
-/* Region channel support                                            */
-/*                                                                   */
-/*********************************************************************/
-
-#define LBS_TX_PWR_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_US_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_JP_DEFAULT		16	/*50mW */
-#define LBS_TX_PWR_FR_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_EMEA_DEFAULT	20	/*100mW */
-
-/* Format { channel, frequency (MHz), maxtxpower } */
-/* band: 'B/G', region: USA FCC/Canada IC */
-static struct chan_freq_power channel_freq_power_US_BG[] = {
-	{1, 2412, LBS_TX_PWR_US_DEFAULT},
-	{2, 2417, LBS_TX_PWR_US_DEFAULT},
-	{3, 2422, LBS_TX_PWR_US_DEFAULT},
-	{4, 2427, LBS_TX_PWR_US_DEFAULT},
-	{5, 2432, LBS_TX_PWR_US_DEFAULT},
-	{6, 2437, LBS_TX_PWR_US_DEFAULT},
-	{7, 2442, LBS_TX_PWR_US_DEFAULT},
-	{8, 2447, LBS_TX_PWR_US_DEFAULT},
-	{9, 2452, LBS_TX_PWR_US_DEFAULT},
-	{10, 2457, LBS_TX_PWR_US_DEFAULT},
-	{11, 2462, LBS_TX_PWR_US_DEFAULT}
-};
-
-/* band: 'B/G', region: Europe ETSI */
-static struct chan_freq_power channel_freq_power_EU_BG[] = {
-	{1, 2412, LBS_TX_PWR_EMEA_DEFAULT},
-	{2, 2417, LBS_TX_PWR_EMEA_DEFAULT},
-	{3, 2422, LBS_TX_PWR_EMEA_DEFAULT},
-	{4, 2427, LBS_TX_PWR_EMEA_DEFAULT},
-	{5, 2432, LBS_TX_PWR_EMEA_DEFAULT},
-	{6, 2437, LBS_TX_PWR_EMEA_DEFAULT},
-	{7, 2442, LBS_TX_PWR_EMEA_DEFAULT},
-	{8, 2447, LBS_TX_PWR_EMEA_DEFAULT},
-	{9, 2452, LBS_TX_PWR_EMEA_DEFAULT},
-	{10, 2457, LBS_TX_PWR_EMEA_DEFAULT},
-	{11, 2462, LBS_TX_PWR_EMEA_DEFAULT},
-	{12, 2467, LBS_TX_PWR_EMEA_DEFAULT},
-	{13, 2472, LBS_TX_PWR_EMEA_DEFAULT}
-};
-
-/* band: 'B/G', region: Spain */
-static struct chan_freq_power channel_freq_power_SPN_BG[] = {
-	{10, 2457, LBS_TX_PWR_DEFAULT},
-	{11, 2462, LBS_TX_PWR_DEFAULT}
-};
-
-/* band: 'B/G', region: France */
-static struct chan_freq_power channel_freq_power_FR_BG[] = {
-	{10, 2457, LBS_TX_PWR_FR_DEFAULT},
-	{11, 2462, LBS_TX_PWR_FR_DEFAULT},
-	{12, 2467, LBS_TX_PWR_FR_DEFAULT},
-	{13, 2472, LBS_TX_PWR_FR_DEFAULT}
-};
-
-/* band: 'B/G', region: Japan */
-static struct chan_freq_power channel_freq_power_JPN_BG[] = {
-	{1, 2412, LBS_TX_PWR_JP_DEFAULT},
-	{2, 2417, LBS_TX_PWR_JP_DEFAULT},
-	{3, 2422, LBS_TX_PWR_JP_DEFAULT},
-	{4, 2427, LBS_TX_PWR_JP_DEFAULT},
-	{5, 2432, LBS_TX_PWR_JP_DEFAULT},
-	{6, 2437, LBS_TX_PWR_JP_DEFAULT},
-	{7, 2442, LBS_TX_PWR_JP_DEFAULT},
-	{8, 2447, LBS_TX_PWR_JP_DEFAULT},
-	{9, 2452, LBS_TX_PWR_JP_DEFAULT},
-	{10, 2457, LBS_TX_PWR_JP_DEFAULT},
-	{11, 2462, LBS_TX_PWR_JP_DEFAULT},
-	{12, 2467, LBS_TX_PWR_JP_DEFAULT},
-	{13, 2472, LBS_TX_PWR_JP_DEFAULT},
-	{14, 2484, LBS_TX_PWR_JP_DEFAULT}
-};
-
-/**
- * the structure for channel, frequency and power
- */
-struct region_cfp_table {
-	u8 region;
-	struct chan_freq_power *cfp_BG;
-	int cfp_no_BG;
-};
-
-/**
- * the structure for the mapping between region and CFP
- */
-static struct region_cfp_table region_cfp_table[] = {
-	{0x10,			/*US FCC */
-	 channel_freq_power_US_BG,
-	 ARRAY_SIZE(channel_freq_power_US_BG),
-	 }
-	,
-	{0x20,			/*CANADA IC */
-	 channel_freq_power_US_BG,
-	 ARRAY_SIZE(channel_freq_power_US_BG),
-	 }
-	,
-	{0x30, /*EU*/ channel_freq_power_EU_BG,
-	 ARRAY_SIZE(channel_freq_power_EU_BG),
-	 }
-	,
-	{0x31, /*SPAIN*/ channel_freq_power_SPN_BG,
-	 ARRAY_SIZE(channel_freq_power_SPN_BG),
-	 }
-	,
-	{0x32, /*FRANCE*/ channel_freq_power_FR_BG,
-	 ARRAY_SIZE(channel_freq_power_FR_BG),
-	 }
-	,
-	{0x40, /*JAPAN*/ channel_freq_power_JPN_BG,
-	 ARRAY_SIZE(channel_freq_power_JPN_BG),
-	 }
-	,
-/*Add new region here */
-};
-
-/**
- *  @brief This function finds the CFP in
- *  region_cfp_table based on region and band parameter.
- *
- *  @param region  The region code
- *  @param band	   The band
- *  @param cfp_no  A pointer to CFP number
- *  @return 	   A pointer to CFP
- */
-static struct chan_freq_power *lbs_get_region_cfp_table(u8 region, int *cfp_no)
-{
-	int i, end;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	end = ARRAY_SIZE(region_cfp_table);
-
-	for (i = 0; i < end ; i++) {
-		lbs_deb_main("region_cfp_table[i].region=%d\n",
-			region_cfp_table[i].region);
-		if (region_cfp_table[i].region == region) {
-			*cfp_no = region_cfp_table[i].cfp_no_BG;
-			lbs_deb_leave(LBS_DEB_MAIN);
-			return region_cfp_table[i].cfp_BG;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret NULL");
-	return NULL;
-}
-
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
-{
-	int ret = 0;
-	int i = 0;
-
-	struct chan_freq_power *cfp;
-	int cfp_no;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	memset(priv->region_channel, 0, sizeof(priv->region_channel));
-
-	cfp = lbs_get_region_cfp_table(region, &cfp_no);
-	if (cfp != NULL) {
-		priv->region_channel[i].nrcfp = cfp_no;
-		priv->region_channel[i].CFP = cfp;
-	} else {
-		lbs_deb_main("wrong region code %#x in band B/G\n",
-		       region);
-		ret = -1;
-		goto out;
-	}
-	priv->region_channel[i].valid = 1;
-	priv->region_channel[i].region = region;
-	priv->region_channel[i].band = band;
-	i++;
-out:
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
-	return ret;
-}
-
-
-
-
-/*********************************************************************/
-/*                                                                   */
-/*  Main scanning support                                            */
-/*                                                                   */
-/*********************************************************************/
-
-/**
- *  @brief Create a channel list for the driver to scan based on region info
- *
- *  Only used from lbs_scan_setup_scan_config()
- *
- *  Use the driver region/band information to construct a comprehensive list
- *    of channels to scan.  This routine is used for any scan that is not
- *    provided a specific channel list to scan.
- *
- *  @param priv          A pointer to struct lbs_private structure
- *  @param scanchanlist  Output parameter: resulting channel list to scan
- *
- *  @return              void
- */
-static int lbs_scan_create_channel_list(struct lbs_private *priv,
-					struct chanscanparamset *scanchanlist)
-{
-	struct region_channel *scanregion;
-	struct chan_freq_power *cfp;
-	int rgnidx;
-	int chanidx;
-	int nextchan;
-	uint8_t scantype;
-
-	chanidx = 0;
-
-	/* Set the default scan type to the user specified type, will later
-	 *   be changed to passive on a per channel basis if restricted by
-	 *   regulatory requirements (11d or 11h)
-	 */
-	scantype = CMD_SCAN_TYPE_ACTIVE;
-
-	for (rgnidx = 0; rgnidx < ARRAY_SIZE(priv->region_channel); rgnidx++) {
-		if (!priv->region_channel[rgnidx].valid)
-			continue;
-		scanregion = &priv->region_channel[rgnidx];
-
-		for (nextchan = 0; nextchan < scanregion->nrcfp; nextchan++, chanidx++) {
-			struct chanscanparamset *chan = &scanchanlist[chanidx];
-
-			cfp = scanregion->CFP + nextchan;
-
-			if (scanregion->band == BAND_B || scanregion->band == BAND_G)
-				chan->radiotype = CMD_SCAN_RADIO_TYPE_BG;
-
-			if (scantype == CMD_SCAN_TYPE_PASSIVE) {
-				chan->maxscantime = cpu_to_le16(MRVDRV_PASSIVE_SCAN_CHAN_TIME);
-				chan->chanscanmode.passivescan = 1;
-			} else {
-				chan->maxscantime = cpu_to_le16(MRVDRV_ACTIVE_SCAN_CHAN_TIME);
-				chan->chanscanmode.passivescan = 0;
-			}
-
-			chan->channumber = cfp->channel;
-		}
-	}
-	return chanidx;
-}
-
-/*
- * Add SSID TLV of the form:
- *
- * TLV-ID SSID     00 00
- * length          06 00
- * ssid            4d 4e 54 45 53 54
- */
-static int lbs_scan_add_ssid_tlv(struct lbs_private *priv, u8 *tlv)
-{
-	struct mrvl_ie_ssid_param_set *ssid_tlv = (void *)tlv;
-
-	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
-	ssid_tlv->header.len = cpu_to_le16(priv->scan_ssid_len);
-	memcpy(ssid_tlv->ssid, priv->scan_ssid, priv->scan_ssid_len);
-	return sizeof(ssid_tlv->header) + priv->scan_ssid_len;
-}
-
-/*
- * Add CHANLIST TLV of the form
- *
- * TLV-ID CHANLIST 01 01
- * length          5b 00
- * channel 1       00 01 00 00 00 64 00
- *   radio type    00
- *   channel          01
- *   scan type           00
- *   min scan time          00 00
- *   max scan time                64 00
- * channel 2       00 02 00 00 00 64 00
- * channel 3       00 03 00 00 00 64 00
- * channel 4       00 04 00 00 00 64 00
- * channel 5       00 05 00 00 00 64 00
- * channel 6       00 06 00 00 00 64 00
- * channel 7       00 07 00 00 00 64 00
- * channel 8       00 08 00 00 00 64 00
- * channel 9       00 09 00 00 00 64 00
- * channel 10      00 0a 00 00 00 64 00
- * channel 11      00 0b 00 00 00 64 00
- * channel 12      00 0c 00 00 00 64 00
- * channel 13      00 0d 00 00 00 64 00
- *
- */
-static int lbs_scan_add_chanlist_tlv(uint8_t *tlv,
-				     struct chanscanparamset *chan_list,
-				     int chan_count)
-{
-	size_t size = sizeof(struct chanscanparamset) *chan_count;
-	struct mrvl_ie_chanlist_param_set *chan_tlv = (void *)tlv;
-
-	chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
-	memcpy(chan_tlv->chanscanparam, chan_list, size);
-	chan_tlv->header.len = cpu_to_le16(size);
-	return sizeof(chan_tlv->header) + size;
-}
-
-/*
- * Add RATES TLV of the form
- *
- * TLV-ID RATES    01 00
- * length          0e 00
- * rates           82 84 8b 96 0c 12 18 24 30 48 60 6c
- *
- * The rates are in lbs_bg_rates[], but for the 802.11b
- * rates the high bit isn't set.
- */
-static int lbs_scan_add_rates_tlv(uint8_t *tlv)
-{
-	int i;
-	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
-
-	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
-	tlv += sizeof(rate_tlv->header);
-	for (i = 0; i < MAX_RATES; i++) {
-		*tlv = lbs_bg_rates[i];
-		if (*tlv == 0)
-			break;
-		/* This code makes sure that the 802.11b rates (1 MBit/s, 2
-		   MBit/s, 5.5 MBit/s and 11 MBit/s get's the high bit set.
-		   Note that the values are MBit/s * 2, to mark them as
-		   basic rates so that the firmware likes it better */
-		if (*tlv == 0x02 || *tlv == 0x04 ||
-		    *tlv == 0x0b || *tlv == 0x16)
-			*tlv |= 0x80;
-		tlv++;
-	}
-	rate_tlv->header.len = cpu_to_le16(i);
-	return sizeof(rate_tlv->header) + i;
-}
-
-/*
- * Generate the CMD_802_11_SCAN command with the proper tlv
- * for a bunch of channels.
- */
-static int lbs_do_scan(struct lbs_private *priv, uint8_t bsstype,
-		       struct chanscanparamset *chan_list, int chan_count)
-{
-	int ret = -ENOMEM;
-	struct cmd_ds_802_11_scan *scan_cmd;
-	uint8_t *tlv;	/* pointer into our current, growing TLV storage area */
-
-	lbs_deb_enter_args(LBS_DEB_SCAN, "bsstype %d, chanlist[].chan %d, chan_count %d",
-		bsstype, chan_list ? chan_list[0].channumber : -1,
-		chan_count);
-
-	/* create the fixed part for scan command */
-	scan_cmd = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
-	if (scan_cmd == NULL)
-		goto out;
-
-	tlv = scan_cmd->tlvbuffer;
-	/* TODO: do we need to scan for a specific BSSID?
-	memcpy(scan_cmd->bssid, priv->scan_bssid, ETH_ALEN); */
-	scan_cmd->bsstype = bsstype;
-
-	/* add TLVs */
-	if (priv->scan_ssid_len)
-		tlv += lbs_scan_add_ssid_tlv(priv, tlv);
-	if (chan_list && chan_count)
-		tlv += lbs_scan_add_chanlist_tlv(tlv, chan_list, chan_count);
-	tlv += lbs_scan_add_rates_tlv(tlv);
-
-	/* This is the final data we are about to send */
-	scan_cmd->hdr.size = cpu_to_le16(tlv - (uint8_t *)scan_cmd);
-	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_CMD", (void *)scan_cmd,
-		    sizeof(*scan_cmd));
-	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_TLV", scan_cmd->tlvbuffer,
-		    tlv - scan_cmd->tlvbuffer);
-
-	ret = __lbs_cmd(priv, CMD_802_11_SCAN, &scan_cmd->hdr,
-			le16_to_cpu(scan_cmd->hdr.size),
-			lbs_ret_80211_scan, 0);
-
-out:
-	kfree(scan_cmd);
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Internal function used to start a scan based on an input config
- *
- *  Use the input user scan configuration information when provided in
- *    order to send the appropriate scan commands to firmware to populate or
- *    update the internal driver scan table
- *
- *  @param priv          A pointer to struct lbs_private structure
- *  @param full_scan     Do a full-scan (blocking)
- *
- *  @return              0 or < 0 if error
- */
-int lbs_scan_networks(struct lbs_private *priv, int full_scan)
-{
-	int ret = -ENOMEM;
-	struct chanscanparamset *chan_list;
-	struct chanscanparamset *curr_chans;
-	int chan_count;
-	uint8_t bsstype = CMD_BSS_TYPE_ANY;
-	int numchannels = MRVDRV_CHANNELS_PER_SCAN_CMD;
-	union iwreq_data wrqu;
-#ifdef CONFIG_LIBERTAS_DEBUG
-	struct bss_descriptor *iter;
-	int i = 0;
-	DECLARE_SSID_BUF(ssid);
-#endif
-
-	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d", full_scan);
-
-	/* Cancel any partial outstanding partial scans if this scan
-	 * is a full scan.
-	 */
-	if (full_scan && delayed_work_pending(&priv->scan_work))
-		cancel_delayed_work(&priv->scan_work);
-
-	/* User-specified bsstype or channel list
-	TODO: this can be implemented if some user-space application
-	need the feature. Formerly, it was accessible from debugfs,
-	but then nowhere used.
-	if (user_cfg) {
-		if (user_cfg->bsstype)
-		bsstype = user_cfg->bsstype;
-	} */
-
-	lbs_deb_scan("numchannels %d, bsstype %d\n", numchannels, bsstype);
-
-	/* Create list of channels to scan */
-	chan_list = kzalloc(sizeof(struct chanscanparamset) *
-			    LBS_IOCTL_USER_SCAN_CHAN_MAX, GFP_KERNEL);
-	if (!chan_list) {
-		lbs_pr_alert("SCAN: chan_list empty\n");
-		goto out;
-	}
-
-	/* We want to scan all channels */
-	chan_count = lbs_scan_create_channel_list(priv, chan_list);
-
-	netif_stop_queue(priv->dev);
-	if (priv->mesh_dev)
-		netif_stop_queue(priv->mesh_dev);
-
-	/* Prepare to continue an interrupted scan */
-	lbs_deb_scan("chan_count %d, scan_channel %d\n",
-		     chan_count, priv->scan_channel);
-	curr_chans = chan_list;
-	/* advance channel list by already-scanned-channels */
-	if (priv->scan_channel > 0) {
-		curr_chans += priv->scan_channel;
-		chan_count -= priv->scan_channel;
-	}
-
-	/* Send scan command(s)
-	 * numchannels contains the number of channels we should maximally scan
-	 * chan_count is the total number of channels to scan
-	 */
-
-	while (chan_count) {
-		int to_scan = min(numchannels, chan_count);
-		lbs_deb_scan("scanning %d of %d channels\n",
-			     to_scan, chan_count);
-		ret = lbs_do_scan(priv, bsstype, curr_chans,
-				  to_scan);
-		if (ret) {
-			lbs_pr_err("SCAN_CMD failed\n");
-			goto out2;
-		}
-		curr_chans += to_scan;
-		chan_count -= to_scan;
-
-		/* somehow schedule the next part of the scan */
-		if (chan_count && !full_scan &&
-		    !priv->surpriseremoved) {
-			/* -1 marks just that we're currently scanning */
-			if (priv->scan_channel < 0)
-				priv->scan_channel = to_scan;
-			else
-				priv->scan_channel += to_scan;
-			cancel_delayed_work(&priv->scan_work);
-			queue_delayed_work(priv->work_thread, &priv->scan_work,
-					   msecs_to_jiffies(300));
-			/* skip over GIWSCAN event */
-			goto out;
-		}
-
-	}
-	memset(&wrqu, 0, sizeof(union iwreq_data));
-	wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
-
-#ifdef CONFIG_LIBERTAS_DEBUG
-	/* Dump the scan table */
-	mutex_lock(&priv->lock);
-	lbs_deb_scan("scan table:\n");
-	list_for_each_entry(iter, &priv->network_list, list)
-		lbs_deb_scan("%02d: BSSID %pM, RSSI %d, SSID '%s'\n",
-			     i++, iter->bssid, iter->rssi,
-			     print_ssid(ssid, iter->ssid, iter->ssid_len));
-	mutex_unlock(&priv->lock);
-#endif
-
-out2:
-	priv->scan_channel = 0;
-
-out:
-	if (priv->connect_status == LBS_CONNECTED && !priv->tx_pending_len)
-		netif_wake_queue(priv->dev);
-
-	if (priv->mesh_dev && lbs_mesh_connected(priv) &&
-	    !priv->tx_pending_len)
-		netif_wake_queue(priv->mesh_dev);
-
-	kfree(chan_list);
-
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-	return ret;
-}
-
-void lbs_scan_worker(struct work_struct *work)
-{
-	struct lbs_private *priv =
-		container_of(work, struct lbs_private, scan_work.work);
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-	lbs_scan_networks(priv, 0);
-	lbs_deb_leave(LBS_DEB_SCAN);
-}
-
-
-/*********************************************************************/
-/*                                                                   */
-/*  Result interpretation                                            */
-/*                                                                   */
-/*********************************************************************/
-
-/**
- *  @brief Interpret a BSS scan response returned from the firmware
- *
- *  Parse the various fixed fields and IEs passed back for a a BSS probe
- *  response or beacon from the scan command.  Record information as needed
- *  in the scan table struct bss_descriptor for that entry.
- *
- *  @param bss  Output parameter: Pointer to the BSS Entry
- *
- *  @return             0 or -1
- */
-static int lbs_process_bss(struct bss_descriptor *bss,
-			   uint8_t **pbeaconinfo, int *bytesleft)
-{
-	struct ieee_ie_fh_param_set *fh;
-	struct ieee_ie_ds_param_set *ds;
-	struct ieee_ie_cf_param_set *cf;
-	struct ieee_ie_ibss_param_set *ibss;
-	DECLARE_SSID_BUF(ssid);
-	uint8_t *pos, *end, *p;
-	uint8_t n_ex_rates = 0, got_basic_rates = 0, n_basic_rates = 0;
-	uint16_t beaconsize = 0;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	if (*bytesleft >= sizeof(beaconsize)) {
-		/* Extract & convert beacon size from the command buffer */
-		beaconsize = get_unaligned_le16(*pbeaconinfo);
-		*bytesleft -= sizeof(beaconsize);
-		*pbeaconinfo += sizeof(beaconsize);
-	}
-
-	if (beaconsize == 0 || beaconsize > *bytesleft) {
-		*pbeaconinfo += *bytesleft;
-		*bytesleft = 0;
-		ret = -1;
-		goto done;
-	}
-
-	/* Initialize the current working beacon pointer for this BSS iteration */
-	pos = *pbeaconinfo;
-	end = pos + beaconsize;
-
-	/* Advance the return beacon pointer past the current beacon */
-	*pbeaconinfo += beaconsize;
-	*bytesleft -= beaconsize;
-
-	memcpy(bss->bssid, pos, ETH_ALEN);
-	lbs_deb_scan("process_bss: BSSID %pM\n", bss->bssid);
-	pos += ETH_ALEN;
-
-	if ((end - pos) < 12) {
-		lbs_deb_scan("process_bss: Not enough bytes left\n");
-		ret = -1;
-		goto done;
-	}
-
-	/*
-	 * next 4 fields are RSSI, time stamp, beacon interval,
-	 *   and capability information
-	 */
-
-	/* RSSI is 1 byte long */
-	bss->rssi = *pos;
-	lbs_deb_scan("process_bss: RSSI %d\n", *pos);
-	pos++;
-
-	/* time stamp is 8 bytes long */
-	pos += 8;
-
-	/* beacon interval is 2 bytes long */
-	bss->beaconperiod = get_unaligned_le16(pos);
-	pos += 2;
-
-	/* capability information is 2 bytes long */
-	bss->capability = get_unaligned_le16(pos);
-	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
-	pos += 2;
-
-	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
-		lbs_deb_scan("process_bss: WEP enabled\n");
-	if (bss->capability & WLAN_CAPABILITY_IBSS)
-		bss->mode = IW_MODE_ADHOC;
-	else
-		bss->mode = IW_MODE_INFRA;
-
-	/* rest of the current buffer are IE's */
-	lbs_deb_scan("process_bss: IE len %zd\n", end - pos);
-	lbs_deb_hex(LBS_DEB_SCAN, "process_bss: IE info", pos, end - pos);
-
-	/* process variable IE */
-	while (pos <= end - 2) {
-		if (pos + pos[1] > end) {
-			lbs_deb_scan("process_bss: error in processing IE, "
-				     "bytes left < IE length\n");
-			break;
-		}
-
-		switch (pos[0]) {
-		case WLAN_EID_SSID:
-			bss->ssid_len = min_t(int, IEEE80211_MAX_SSID_LEN, pos[1]);
-			memcpy(bss->ssid, pos + 2, bss->ssid_len);
-			lbs_deb_scan("got SSID IE: '%s', len %u\n",
-			             print_ssid(ssid, bss->ssid, bss->ssid_len),
-			             bss->ssid_len);
-			break;
-
-		case WLAN_EID_SUPP_RATES:
-			n_basic_rates = min_t(uint8_t, MAX_RATES, pos[1]);
-			memcpy(bss->rates, pos + 2, n_basic_rates);
-			got_basic_rates = 1;
-			lbs_deb_scan("got RATES IE\n");
-			break;
-
-		case WLAN_EID_FH_PARAMS:
-			fh = (struct ieee_ie_fh_param_set *) pos;
-			memcpy(&bss->phy.fh, fh, sizeof(*fh));
-			lbs_deb_scan("got FH IE\n");
-			break;
-
-		case WLAN_EID_DS_PARAMS:
-			ds = (struct ieee_ie_ds_param_set *) pos;
-			bss->channel = ds->channel;
-			memcpy(&bss->phy.ds, ds, sizeof(*ds));
-			lbs_deb_scan("got DS IE, channel %d\n", bss->channel);
-			break;
-
-		case WLAN_EID_CF_PARAMS:
-			cf = (struct ieee_ie_cf_param_set *) pos;
-			memcpy(&bss->ss.cf, cf, sizeof(*cf));
-			lbs_deb_scan("got CF IE\n");
-			break;
-
-		case WLAN_EID_IBSS_PARAMS:
-			ibss = (struct ieee_ie_ibss_param_set *) pos;
-			bss->atimwindow = ibss->atimwindow;
-			memcpy(&bss->ss.ibss, ibss, sizeof(*ibss));
-			lbs_deb_scan("got IBSS IE\n");
-			break;
-
-		case WLAN_EID_EXT_SUPP_RATES:
-			/* only process extended supported rate if data rate is
-			 * already found. Data rate IE should come before
-			 * extended supported rate IE
-			 */
-			lbs_deb_scan("got RATESEX IE\n");
-			if (!got_basic_rates) {
-				lbs_deb_scan("... but ignoring it\n");
-				break;
-			}
-
-			n_ex_rates = pos[1];
-			if (n_basic_rates + n_ex_rates > MAX_RATES)
-				n_ex_rates = MAX_RATES - n_basic_rates;
-
-			p = bss->rates + n_basic_rates;
-			memcpy(p, pos + 2, n_ex_rates);
-			break;
-
-		case WLAN_EID_GENERIC:
-			if (pos[1] >= 4 &&
-			    pos[2] == 0x00 && pos[3] == 0x50 &&
-			    pos[4] == 0xf2 && pos[5] == 0x01) {
-				bss->wpa_ie_len = min(pos[1] + 2, MAX_WPA_IE_LEN);
-				memcpy(bss->wpa_ie, pos, bss->wpa_ie_len);
-				lbs_deb_scan("got WPA IE\n");
-				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie,
-					    bss->wpa_ie_len);
-			} else if (pos[1] >= MARVELL_MESH_IE_LENGTH &&
-				   pos[2] == 0x00 && pos[3] == 0x50 &&
-				   pos[4] == 0x43 && pos[5] == 0x04) {
-				lbs_deb_scan("got mesh IE\n");
-				bss->mesh = 1;
-			} else {
-				lbs_deb_scan("got generic IE: %02x:%02x:%02x:%02x, len %d\n",
-					pos[2], pos[3],
-					pos[4], pos[5],
-					pos[1]);
-			}
-			break;
-
-		case WLAN_EID_RSN:
-			lbs_deb_scan("got RSN IE\n");
-			bss->rsn_ie_len = min(pos[1] + 2, MAX_WPA_IE_LEN);
-			memcpy(bss->rsn_ie, pos, bss->rsn_ie_len);
-			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: RSN_IE",
-				    bss->rsn_ie, bss->rsn_ie_len);
-			break;
-
-		default:
-			lbs_deb_scan("got IE 0x%04x, len %d\n",
-				     pos[0], pos[1]);
-			break;
-		}
-
-		pos += pos[1] + 2;
-	}
-
-	/* Timestamp */
-	bss->last_scanned = jiffies;
-	lbs_unset_basic_rate_flags(bss->rates, sizeof(bss->rates));
-
-	ret = 0;
-
-done:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Send a scan command for all available channels filtered on a spec
- *
- *  Used in association code and from debugfs
- *
- *  @param priv             A pointer to struct lbs_private structure
- *  @param ssid             A pointer to the SSID to scan for
- *  @param ssid_len         Length of the SSID
- *
- *  @return                0-success, otherwise fail
- */
-int lbs_send_specific_ssid_scan(struct lbs_private *priv, uint8_t *ssid,
-				uint8_t ssid_len)
-{
-	DECLARE_SSID_BUF(ssid_buf);
-	int ret = 0;
-
-	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s'\n",
-			   print_ssid(ssid_buf, ssid, ssid_len));
-
-	if (!ssid_len)
-		goto out;
-
-	memcpy(priv->scan_ssid, ssid, ssid_len);
-	priv->scan_ssid_len = ssid_len;
-
-	lbs_scan_networks(priv, 1);
-	if (priv->surpriseremoved) {
-		ret = -1;
-		goto out;
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-	return ret;
-}
-
-
-
-
-/*********************************************************************/
-/*                                                                   */
-/*  Support for Wireless Extensions                                  */
-/*                                                                   */
-/*********************************************************************/
-
-
-#define MAX_CUSTOM_LEN 64
-
-static inline char *lbs_translate_scan(struct lbs_private *priv,
-					    struct iw_request_info *info,
-					    char *start, char *stop,
-					    struct bss_descriptor *bss)
-{
-	struct chan_freq_power *cfp;
-	char *current_val;	/* For rates */
-	struct iw_event iwe;	/* Temporary buffer */
-	int j;
-#define PERFECT_RSSI ((uint8_t)50)
-#define WORST_RSSI   ((uint8_t)0)
-#define RSSI_DIFF    ((uint8_t)(PERFECT_RSSI - WORST_RSSI))
-	uint8_t rssi;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, bss->channel);
-	if (!cfp) {
-		lbs_deb_scan("Invalid channel number %d\n", bss->channel);
-		start = NULL;
-		goto out;
-	}
-
-	/* First entry *MUST* be the BSSID */
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, &bss->bssid, ETH_ALEN);
-	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_ADDR_LEN);
-
-	/* SSID */
-	iwe.cmd = SIOCGIWESSID;
-	iwe.u.data.flags = 1;
-	iwe.u.data.length = min((uint32_t) bss->ssid_len, (uint32_t) IEEE80211_MAX_SSID_LEN);
-	start = iwe_stream_add_point(info, start, stop, &iwe, bss->ssid);
-
-	/* Mode */
-	iwe.cmd = SIOCGIWMODE;
-	iwe.u.mode = bss->mode;
-	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_UINT_LEN);
-
-	/* Frequency */
-	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = (long)cfp->freq * 100000;
-	iwe.u.freq.e = 1;
-	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_FREQ_LEN);
-
-	/* Add quality statistics */
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.updated = IW_QUAL_ALL_UPDATED;
-	iwe.u.qual.level = SCAN_RSSI(bss->rssi);
-
-	rssi = iwe.u.qual.level - MRVDRV_NF_DEFAULT_SCAN_VALUE;
-	iwe.u.qual.qual =
-		(100 * RSSI_DIFF * RSSI_DIFF - (PERFECT_RSSI - rssi) *
-		 (15 * (RSSI_DIFF) + 62 * (PERFECT_RSSI - rssi))) /
-		(RSSI_DIFF * RSSI_DIFF);
-	if (iwe.u.qual.qual > 100)
-		iwe.u.qual.qual = 100;
-
-	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
-		iwe.u.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
-	} else {
-		iwe.u.qual.noise = CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-	}
-
-	/* Locally created ad-hoc BSSs won't have beacons if this is the
-	 * only station in the adhoc network; so get signal strength
-	 * from receive statistics.
-	 */
-	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate
-	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
-			     priv->curbssparams.ssid_len,
-			     bss->ssid, bss->ssid_len)) {
-		int snr, nf;
-		snr = priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		nf = priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		iwe.u.qual.level = CAL_RSSI(snr, nf);
-	}
-	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_QUAL_LEN);
-
-	/* Add encryption capability */
-	iwe.cmd = SIOCGIWENCODE;
-	if (bss->capability & WLAN_CAPABILITY_PRIVACY) {
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	} else {
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	}
-	iwe.u.data.length = 0;
-	start = iwe_stream_add_point(info, start, stop, &iwe, bss->ssid);
-
-	current_val = start + iwe_stream_lcp_len(info);
-
-	iwe.cmd = SIOCGIWRATE;
-	iwe.u.bitrate.fixed = 0;
-	iwe.u.bitrate.disabled = 0;
-	iwe.u.bitrate.value = 0;
-
-	for (j = 0; j < ARRAY_SIZE(bss->rates) && bss->rates[j]; j++) {
-		/* Bit rate given in 500 kb/s units */
-		iwe.u.bitrate.value = bss->rates[j] * 500000;
-		current_val = iwe_stream_add_value(info, start, current_val,
-						   stop, &iwe, IW_EV_PARAM_LEN);
-	}
-	if ((bss->mode == IW_MODE_ADHOC) && priv->adhoccreate
-	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
-			     priv->curbssparams.ssid_len,
-			     bss->ssid, bss->ssid_len)) {
-		iwe.u.bitrate.value = 22 * 500000;
-		current_val = iwe_stream_add_value(info, start, current_val,
-						   stop, &iwe, IW_EV_PARAM_LEN);
-	}
-	/* Check if we added any event */
-	if ((current_val - start) > iwe_stream_lcp_len(info))
-		start = current_val;
-
-	memset(&iwe, 0, sizeof(iwe));
-	if (bss->wpa_ie_len) {
-		char buf[MAX_WPA_IE_LEN];
-		memcpy(buf, bss->wpa_ie, bss->wpa_ie_len);
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = bss->wpa_ie_len;
-		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-	}
-
-	memset(&iwe, 0, sizeof(iwe));
-	if (bss->rsn_ie_len) {
-		char buf[MAX_WPA_IE_LEN];
-		memcpy(buf, bss->rsn_ie, bss->rsn_ie_len);
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = bss->rsn_ie_len;
-		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-	}
-
-	if (bss->mesh) {
-		char custom[MAX_CUSTOM_LEN];
-		char *p = custom;
-
-		iwe.cmd = IWEVCUSTOM;
-		p += snprintf(p, MAX_CUSTOM_LEN, "mesh-type: olpc");
-		iwe.u.data.length = p - custom;
-		if (iwe.u.data.length)
-			start = iwe_stream_add_point(info, start, stop,
-						     &iwe, custom);
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "start %p", start);
-	return start;
-}
-
-
-/**
- *  @brief Handle Scan Network ioctl
- *
- *  @param dev          A pointer to net_device structure
- *  @param info         A pointer to iw_request_info structure
- *  @param vwrq         A pointer to iw_param structure
- *  @param extra        A pointer to extra data buf
- *
- *  @return             0 --success, otherwise fail
- */
-int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
-		 union iwreq_data *wrqu, char *extra)
-{
-	DECLARE_SSID_BUF(ssid);
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->radio_on) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (!netif_running(dev)) {
-		ret = -ENETDOWN;
-		goto out;
-	}
-
-	/* mac80211 does this:
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type != IEEE80211_IF_TYPE_xxx) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-	*/
-
-	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
-	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-		struct iw_scan_req *req = (struct iw_scan_req *)extra;
-		priv->scan_ssid_len = req->essid_len;
-		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
-		lbs_deb_wext("set_scan, essid '%s'\n",
-			print_ssid(ssid, priv->scan_ssid, priv->scan_ssid_len));
-	} else {
-		priv->scan_ssid_len = 0;
-	}
-
-	if (!delayed_work_pending(&priv->scan_work))
-		queue_delayed_work(priv->work_thread, &priv->scan_work,
-				   msecs_to_jiffies(50));
-	/* set marker that currently a scan is taking place */
-	priv->scan_channel = -1;
-
-	if (priv->surpriseremoved)
-		ret = -EIO;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-
-/**
- *  @brief  Handle Retrieve scan table ioctl
- *
- *  @param dev          A pointer to net_device structure
- *  @param info         A pointer to iw_request_info structure
- *  @param dwrq         A pointer to iw_point structure
- *  @param extra        A pointer to extra data buf
- *
- *  @return             0 --success, otherwise fail
- */
-int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
-		 struct iw_point *dwrq, char *extra)
-{
-#define SCAN_ITEM_SIZE 128
-	struct lbs_private *priv = dev->ml_priv;
-	int err = 0;
-	char *ev = extra;
-	char *stop = ev + dwrq->length;
-	struct bss_descriptor *iter_bss;
-	struct bss_descriptor *safe;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* iwlist should wait until the current scan is finished */
-	if (priv->scan_channel)
-		return -EAGAIN;
-
-	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
-	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate) {
-		err = lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				CMD_OPTION_WAITFORRSP, 0, NULL);
-		if (err)
-			goto out;
-	}
-
-	mutex_lock(&priv->lock);
-	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
-		char *next_ev;
-		unsigned long stale_time;
-
-		if (stop - ev < SCAN_ITEM_SIZE) {
-			err = -E2BIG;
-			break;
-		}
-
-		/* For mesh device, list only mesh networks */
-		if (dev == priv->mesh_dev && !iter_bss->mesh)
-			continue;
-
-		/* Prune old an old scan result */
-		stale_time = iter_bss->last_scanned + DEFAULT_MAX_SCAN_AGE;
-		if (time_after(jiffies, stale_time)) {
-			list_move_tail(&iter_bss->list, &priv->network_free_list);
-			clear_bss_descriptor(iter_bss);
-			continue;
-		}
-
-		/* Translate to WE format this entry */
-		next_ev = lbs_translate_scan(priv, info, ev, stop, iter_bss);
-		if (next_ev == NULL)
-			continue;
-		ev = next_ev;
-	}
-	mutex_unlock(&priv->lock);
-
-	dwrq->length = (ev - extra);
-	dwrq->flags = 0;
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", err);
-	return err;
-}
-
-
-
-
-/*********************************************************************/
-/*                                                                   */
-/*  Command execution                                                */
-/*                                                                   */
-/*********************************************************************/
-
-
-/**
- *  @brief This function handles the command response of scan
- *
- *  Called from handle_cmd_response() in cmdrespc.
- *
- *   The response buffer for the scan command has the following
- *      memory layout:
- *
- *     .-----------------------------------------------------------.
- *     |  header (4 * sizeof(u16)):  Standard command response hdr |
- *     .-----------------------------------------------------------.
- *     |  bufsize (u16) : sizeof the BSS Description data          |
- *     .-----------------------------------------------------------.
- *     |  NumOfSet (u8) : Number of BSS Descs returned             |
- *     .-----------------------------------------------------------.
- *     |  BSSDescription data (variable, size given in bufsize)    |
- *     .-----------------------------------------------------------.
- *     |  TLV data (variable, size calculated using header->size,  |
- *     |            bufsize and sizeof the fixed fields above)     |
- *     .-----------------------------------------------------------.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @param resp    A pointer to cmd_ds_command
- *
- *  @return        0 or -1
- */
-static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
-			      struct cmd_header *resp)
-{
-	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
-	struct bss_descriptor *iter_bss;
-	struct bss_descriptor *safe;
-	uint8_t *bssinfo;
-	uint16_t scanrespsize;
-	int bytesleft;
-	int idx;
-	int tlvbufsize;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-
-	/* Prune old entries from scan table */
-	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
-		unsigned long stale_time = iter_bss->last_scanned + DEFAULT_MAX_SCAN_AGE;
-		if (time_before(jiffies, stale_time))
-			continue;
-		list_move_tail (&iter_bss->list, &priv->network_free_list);
-		clear_bss_descriptor(iter_bss);
-	}
-
-	if (scanresp->nr_sets > MAX_NETWORK_COUNT) {
-		lbs_deb_scan("SCAN_RESP: too many scan results (%d, max %d)\n",
-			     scanresp->nr_sets, MAX_NETWORK_COUNT);
-		ret = -1;
-		goto done;
-	}
-
-	bytesleft = get_unaligned_le16(&scanresp->bssdescriptsize);
-	lbs_deb_scan("SCAN_RESP: bssdescriptsize %d\n", bytesleft);
-
-	scanrespsize = le16_to_cpu(resp->size);
-	lbs_deb_scan("SCAN_RESP: scan results %d\n", scanresp->nr_sets);
-
-	bssinfo = scanresp->bssdesc_and_tlvbuffer;
-
-	/* The size of the TLV buffer is equal to the entire command response
-	 *   size (scanrespsize) minus the fixed fields (sizeof()'s), the
-	 *   BSS Descriptions (bssdescriptsize as bytesLef) and the command
-	 *   response header (sizeof(struct cmd_header))
-	 */
-	tlvbufsize = scanrespsize - (bytesleft + sizeof(scanresp->bssdescriptsize)
-				     + sizeof(scanresp->nr_sets)
-				     + sizeof(struct cmd_header));
-
-	/*
-	 *  Process each scan response returned (scanresp->nr_sets). Save
-	 *    the information in the newbssentry and then insert into the
-	 *    driver scan table either as an update to an existing entry
-	 *    or as an addition at the end of the table
-	 */
-	for (idx = 0; idx < scanresp->nr_sets && bytesleft; idx++) {
-		struct bss_descriptor new;
-		struct bss_descriptor *found = NULL;
-		struct bss_descriptor *oldest = NULL;
-
-		/* Process the data fields and IEs returned for this BSS */
-		memset(&new, 0, sizeof (struct bss_descriptor));
-		if (lbs_process_bss(&new, &bssinfo, &bytesleft) != 0) {
-			/* error parsing the scan response, skipped */
-			lbs_deb_scan("SCAN_RESP: process_bss returned ERROR\n");
-			continue;
-		}
-
-		/* Try to find this bss in the scan table */
-		list_for_each_entry (iter_bss, &priv->network_list, list) {
-			if (is_same_network(iter_bss, &new)) {
-				found = iter_bss;
-				break;
-			}
-
-			if ((oldest == NULL) ||
-			    (iter_bss->last_scanned < oldest->last_scanned))
-				oldest = iter_bss;
-		}
-
-		if (found) {
-			/* found, clear it */
-			clear_bss_descriptor(found);
-		} else if (!list_empty(&priv->network_free_list)) {
-			/* Pull one from the free list */
-			found = list_entry(priv->network_free_list.next,
-					   struct bss_descriptor, list);
-			list_move_tail(&found->list, &priv->network_list);
-		} else if (oldest) {
-			/* If there are no more slots, expire the oldest */
-			found = oldest;
-			clear_bss_descriptor(found);
-			list_move_tail(&found->list, &priv->network_list);
-		} else {
-			continue;
-		}
-
-		lbs_deb_scan("SCAN_RESP: BSSID %pM\n", new.bssid);
-
-		/* Copy the locally created newbssentry to the scan table */
-		memcpy(found, &new, offsetof(struct bss_descriptor, list));
-	}
-
-	ret = 0;
-
-done:
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-	return ret;
-}
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
deleted file mode 100644
index 8fb1706..0000000
--- a/drivers/net/wireless/libertas/scan.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/**
-  * Interface for the wlan network scan routines
-  *
-  * Driver interface functions and type declarations for the scan module
-  * implemented in scan.c.
-  */
-#ifndef _LBS_SCAN_H
-#define _LBS_SCAN_H
-
-#include <net/iw_handler.h>
-
-struct lbs_private;
-
-#define MAX_NETWORK_COUNT 128
-
-/** Chan-freq-TxPower mapping table*/
-struct chan_freq_power {
-	/** channel Number		*/
-	u16 channel;
-	/** frequency of this channel	*/
-	u32 freq;
-	/** Max allowed Tx power level	*/
-	u16 maxtxpower;
-	/** TRUE:channel unsupported;  FLASE:supported*/
-	u8 unsupported;
-};
-
-/** region-band mapping table*/
-struct region_channel {
-	/** TRUE if this entry is valid		     */
-	u8 valid;
-	/** region code for US, Japan ...	     */
-	u8 region;
-	/** band B/G/A, used for BAND_CONFIG cmd	     */
-	u8 band;
-	/** Actual No. of elements in the array below */
-	u8 nrcfp;
-	/** chan-freq-txpower mapping table*/
-	struct chan_freq_power *CFP;
-};
-
-/**
- *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
- */
-#define LBS_IOCTL_USER_SCAN_CHAN_MAX  50
-
-int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len);
-
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
-
-int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
-				u8 ssid_len);
-
-int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_point *dwrq, char *extra);
-int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
-			 union iwreq_data *wrqu, char *extra);
-
-int lbs_scan_networks(struct lbs_private *priv, int full_scan);
-
-void lbs_scan_worker(struct work_struct *work);
-
-#endif
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 52d244e..eafcc80 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -4,13 +4,13 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
+#include <net/cfg80211.h>
 
 #include "host.h"
 #include "radiotap.h"
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
-#include "wext.h"
 
 /**
  *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
@@ -111,7 +111,7 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	p802x_hdr = skb->data;
 	pkt_len = skb->len;
 
-	if (dev == priv->rtap_net_dev) {
+	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
 		/* set txpd fields from the radiotap header */
@@ -149,7 +149,7 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dev->trans_start = jiffies;
 
-	if (priv->monitormode) {
+	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		/* Keep the skb to echo it back once Tx feedback is
 		   received from FW */
 		skb_orphan(skb);
@@ -160,6 +160,7 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
  free:
 		dev_kfree_skb_any(skb);
 	}
+
  unlock:
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 	wake_up(&priv->waitq);
@@ -181,7 +182,8 @@ void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count)
 {
 	struct tx_radiotap_hdr *radiotap_hdr;
 
-	if (!priv->monitormode || priv->currenttxskb == NULL)
+	if (!priv->wdev->iftype == NL80211_IFTYPE_MONITOR ||
+	    priv->currenttxskb == NULL)
 		return;
 
 	radiotap_hdr = (struct tx_radiotap_hdr *)priv->currenttxskb->data;
@@ -190,7 +192,7 @@ void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count)
 		(1 + priv->txretrycount - try_count) : 0;
 
 	priv->currenttxskb->protocol = eth_type_trans(priv->currenttxskb,
-						      priv->rtap_net_dev);
+						      priv->dev);
 	netif_rx(priv->currenttxskb);
 
 	priv->currenttxskb = NULL;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
deleted file mode 100644
index 71f88a0..0000000
--- a/drivers/net/wireless/libertas/wext.c
+++ /dev/null
@@ -1,2348 +0,0 @@
-/**
-  * This file contains ioctl functions
-  */
-#include <linux/ctype.h>
-#include <linux/delay.h>
-#include <linux/if.h>
-#include <linux/if_arp.h>
-#include <linux/wireless.h>
-#include <linux/bitops.h>
-
-#include <net/lib80211.h>
-#include <net/iw_handler.h>
-
-#include "host.h"
-#include "radiotap.h"
-#include "decl.h"
-#include "defs.h"
-#include "dev.h"
-#include "wext.h"
-#include "scan.h"
-#include "assoc.h"
-#include "cmd.h"
-
-
-static inline void lbs_postpone_association_work(struct lbs_private *priv)
-{
-	if (priv->surpriseremoved)
-		return;
-	cancel_delayed_work(&priv->assoc_work);
-	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
-}
-
-static inline void lbs_do_association_work(struct lbs_private *priv)
-{
-	if (priv->surpriseremoved)
-		return;
-	cancel_delayed_work(&priv->assoc_work);
-	queue_delayed_work(priv->work_thread, &priv->assoc_work, 0);
-}
-
-static inline void lbs_cancel_association_work(struct lbs_private *priv)
-{
-	cancel_delayed_work(&priv->assoc_work);
-	kfree(priv->pending_assoc_req);
-	priv->pending_assoc_req = NULL;
-}
-
-void lbs_send_disconnect_notification(struct lbs_private *priv)
-{
-	union iwreq_data wrqu;
-
-	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-}
-
-static void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
-{
-	union iwreq_data iwrq;
-	u8 buf[50];
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	memset(&iwrq, 0, sizeof(union iwreq_data));
-	memset(buf, 0, sizeof(buf));
-
-	snprintf(buf, sizeof(buf) - 1, "%s", str);
-
-	iwrq.data.length = strlen(buf) + 1 + IW_EV_LCP_LEN;
-
-	/* Send Event to upper layer */
-	lbs_deb_wext("event indication string %s\n", (char *)buf);
-	lbs_deb_wext("event indication length %d\n", iwrq.data.length);
-	lbs_deb_wext("sending wireless event IWEVCUSTOM for %s\n", str);
-
-	wireless_send_event(priv->dev, IWEVCUSTOM, &iwrq, buf);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-}
-
-/**
- *  @brief This function handles MIC failure event.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @para  event   the event id
- *  @return 	   n/a
- */
-void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
-{
-	char buf[50];
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	memset(buf, 0, sizeof(buf));
-
-	sprintf(buf, "%s", "MLME-MICHAELMICFAILURE.indication ");
-
-	if (event == MACREG_INT_CODE_MIC_ERR_UNICAST)
-		strcat(buf, "unicast ");
-	else
-		strcat(buf, "multicast ");
-
-	lbs_send_iwevcustom_event(priv, buf);
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
-/**
- *  @brief Find the channel frequency power info with specific channel
- *
- *  @param priv 	A pointer to struct lbs_private structure
- *  @param band		it can be BAND_A, BAND_G or BAND_B
- *  @param channel      the channel for looking
- *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
- */
-struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_private *priv,
-	u8 band,
-	u16 channel)
-{
-	struct chan_freq_power *cfp = NULL;
-	struct region_channel *rc;
-	int i, j;
-
-	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
-		rc = &priv->region_channel[j];
-
-		if (!rc->valid || !rc->CFP)
-			continue;
-		if (rc->band != band)
-			continue;
-		for (i = 0; i < rc->nrcfp; i++) {
-			if (rc->CFP[i].channel == channel) {
-				cfp = &rc->CFP[i];
-				break;
-			}
-		}
-	}
-
-	if (!cfp && channel)
-		lbs_deb_wext("lbs_find_cfp_by_band_and_channel: can't find "
-		       "cfp by band %d / channel %d\n", band, channel);
-
-	return cfp;
-}
-
-/**
- *  @brief Find the channel frequency power info with specific frequency
- *
- *  @param priv 	A pointer to struct lbs_private structure
- *  @param band		it can be BAND_A, BAND_G or BAND_B
- *  @param freq	        the frequency for looking
- *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
- */
-static struct chan_freq_power *find_cfp_by_band_and_freq(
-	struct lbs_private *priv,
-	u8 band,
-	u32 freq)
-{
-	struct chan_freq_power *cfp = NULL;
-	struct region_channel *rc;
-	int i, j;
-
-	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
-		rc = &priv->region_channel[j];
-
-		if (!rc->valid || !rc->CFP)
-			continue;
-		if (rc->band != band)
-			continue;
-		for (i = 0; i < rc->nrcfp; i++) {
-			if (rc->CFP[i].freq == freq) {
-				cfp = &rc->CFP[i];
-				break;
-			}
-		}
-	}
-
-	if (!cfp && freq)
-		lbs_deb_wext("find_cfp_by_band_and_freql: can't find cfp by "
-		       "band %d / freq %d\n", band, freq);
-
-	return cfp;
-}
-
-/**
- *  @brief Copy active data rates based on adapter mode and status
- *
- *  @param priv              A pointer to struct lbs_private structure
- *  @param rate		        The buf to return the active rates
- */
-static void copy_active_data_rates(struct lbs_private *priv, u8 *rates)
-{
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if ((priv->connect_status != LBS_CONNECTED) &&
-		!lbs_mesh_connected(priv))
-		memcpy(rates, lbs_bg_rates, MAX_RATES);
-	else
-		memcpy(rates, priv->curbssparams.rates, MAX_RATES);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-}
-
-static int lbs_get_name(struct net_device *dev, struct iw_request_info *info,
-			 char *cwrq, char *extra)
-{
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* We could add support for 802.11n here as needed. Jean II */
-	snprintf(cwrq, IFNAMSIZ, "IEEE 802.11b/g");
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_freq *fwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	struct chan_freq_power *cfp;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	cfp = lbs_find_cfp_by_band_and_channel(priv, 0,
-					   priv->channel);
-
-	if (!cfp) {
-		if (priv->channel)
-			lbs_deb_wext("invalid channel %d\n",
-			       priv->channel);
-		return -EINVAL;
-	}
-
-	fwrq->m = (long)cfp->freq * 100000;
-	fwrq->e = 1;
-
-	lbs_deb_wext("freq %u\n", fwrq->m);
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_get_wap(struct net_device *dev, struct iw_request_info *info,
-			struct sockaddr *awrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (priv->connect_status == LBS_CONNECTED) {
-		memcpy(awrq->sa_data, priv->curbssparams.bssid, ETH_ALEN);
-	} else {
-		memset(awrq->sa_data, 0, ETH_ALEN);
-	}
-	awrq->sa_family = ARPHRD_ETHER;
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_set_nick(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/*
-	 * Check the size of the string
-	 */
-
-	if (dwrq->length > 16) {
-		return -E2BIG;
-	}
-
-	mutex_lock(&priv->lock);
-	memset(priv->nodename, 0, sizeof(priv->nodename));
-	memcpy(priv->nodename, extra, dwrq->length);
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_get_nick(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	dwrq->length = strlen(priv->nodename);
-	memcpy(extra, priv->nodename, dwrq->length);
-	extra[dwrq->length] = '\0';
-
-	dwrq->flags = 1;	/* active */
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-#ifdef CONFIG_LIBERTAS_MESH
-static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* Use nickname to indicate that mesh is on */
-
-	if (lbs_mesh_connected(priv)) {
-		strncpy(extra, "Mesh", 12);
-		extra[12] = '\0';
-		dwrq->length = strlen(extra);
-	}
-
-	else {
-		extra[0] = '\0';
-		dwrq->length = 0;
-	}
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-#endif
-
-static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
-			struct iw_param *vwrq, char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-	u32 val = vwrq->value;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (vwrq->disabled)
-		val = MRVDRV_RTS_MAX_VALUE;
-
-	if (val > MRVDRV_RTS_MAX_VALUE) /* min rts value is 0 */
-		return -EINVAL;
-
-	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, (u16) val);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_rts(struct net_device *dev, struct iw_request_info *info,
-			struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	u16 val = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, &val);
-	if (ret)
-		goto out;
-
-	vwrq->value = val;
-	vwrq->disabled = val > MRVDRV_RTS_MAX_VALUE; /* min rts value is 0 */
-	vwrq->fixed = 1;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_set_frag(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	u32 val = vwrq->value;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (vwrq->disabled)
-		val = MRVDRV_FRAG_MAX_VALUE;
-
-	if (val < MRVDRV_FRAG_MIN_VALUE || val > MRVDRV_FRAG_MAX_VALUE)
-		return -EINVAL;
-
-	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD, (u16) val);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_frag(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	u16 val = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD, &val);
-	if (ret)
-		goto out;
-
-	vwrq->value = val;
-	vwrq->disabled = ((val < MRVDRV_FRAG_MIN_VALUE)
-			  || (val > MRVDRV_FRAG_MAX_VALUE));
-	vwrq->fixed = 1;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_mode(struct net_device *dev,
-			 struct iw_request_info *info, u32 * uwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	*uwrq = priv->mode;
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-#ifdef CONFIG_LIBERTAS_MESH
-static int mesh_wlan_get_mode(struct net_device *dev,
-		              struct iw_request_info *info, u32 * uwrq,
-			      char *extra)
-{
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	*uwrq = IW_MODE_REPEAT;
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-#endif
-
-static int lbs_get_txpow(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	s16 curlevel = 0;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->radio_on) {
-		lbs_deb_wext("tx power off\n");
-		vwrq->value = 0;
-		vwrq->disabled = 1;
-		goto out;
-	}
-
-	ret = lbs_get_tx_power(priv, &curlevel, NULL, NULL);
-	if (ret)
-		goto out;
-
-	lbs_deb_wext("tx power level %d dbm\n", curlevel);
-	priv->txpower_cur = curlevel;
-
-	vwrq->value = curlevel;
-	vwrq->fixed = 1;
-	vwrq->disabled = 0;
-	vwrq->flags = IW_TXPOW_DBM;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_set_retry(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	u16 slimit = 0, llimit = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-        if ((vwrq->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
-                return -EOPNOTSUPP;
-
-	/* The MAC has a 4-bit Total_Tx_Count register
-	   Total_Tx_Count = 1 + Tx_Retry_Count */
-#define TX_RETRY_MIN 0
-#define TX_RETRY_MAX 14
-	if (vwrq->value < TX_RETRY_MIN || vwrq->value > TX_RETRY_MAX)
-		return -EINVAL;
-
-	/* Add 1 to convert retry count to try count */
-	if (vwrq->flags & IW_RETRY_SHORT)
-		slimit = (u16) (vwrq->value + 1);
-	else if (vwrq->flags & IW_RETRY_LONG)
-		llimit = (u16) (vwrq->value + 1);
-	else
-		slimit = llimit = (u16) (vwrq->value + 1); /* set both */
-
-	if (llimit) {
-		ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_LONG_RETRY_LIMIT,
-				       llimit);
-		if (ret)
-			goto out;
-	}
-
-	if (slimit) {
-		/* txretrycount follows the short retry limit */
-		priv->txretrycount = slimit;
-		ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_SHORT_RETRY_LIMIT,
-				       slimit);
-		if (ret)
-			goto out;
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	u16 val = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	vwrq->disabled = 0;
-
-	if (vwrq->flags & IW_RETRY_LONG) {
-		ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_LONG_RETRY_LIMIT, &val);
-		if (ret)
-			goto out;
-
-		/* Subtract 1 to convert try count to retry count */
-		vwrq->value = val - 1;
-		vwrq->flags = IW_RETRY_LIMIT | IW_RETRY_LONG;
-	} else {
-		ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_SHORT_RETRY_LIMIT, &val);
-		if (ret)
-			goto out;
-
-		/* txretry count follows the short retry limit */
-		priv->txretrycount = val;
-		/* Subtract 1 to convert try count to retry count */
-		vwrq->value = val - 1;
-		vwrq->flags = IW_RETRY_LIMIT | IW_RETRY_SHORT;
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static inline void sort_channels(struct iw_freq *freq, int num)
-{
-	int i, j;
-	struct iw_freq temp;
-
-	for (i = 0; i < num; i++)
-		for (j = i + 1; j < num; j++)
-			if (freq[i].i > freq[j].i) {
-				temp.i = freq[i].i;
-				temp.m = freq[i].m;
-
-				freq[i].i = freq[j].i;
-				freq[i].m = freq[j].m;
-
-				freq[j].i = temp.i;
-				freq[j].m = temp.m;
-			}
-}
-
-/* data rate listing
-	MULTI_BANDS:
-		abg		a	b	b/g
-   Infra 	G(12)		A(8)	B(4)	G(12)
-   Adhoc 	A+B(12)		A(8)	B(4)	B(4)
-
-	non-MULTI_BANDS:
-					b	b/g
-   Infra 	     		    	B(4)	G(12)
-   Adhoc 	      		    	B(4)	B(4)
- */
-/**
- *  @brief Get Range Info
- *
- *  @param dev                  A pointer to net_device structure
- *  @param info			A pointer to iw_request_info structure
- *  @param vwrq 		A pointer to iw_param structure
- *  @param extra		A pointer to extra data buf
- *  @return 	   		0 --success, otherwise fail
- */
-static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_point *dwrq, char *extra)
-{
-	int i, j;
-	struct lbs_private *priv = dev->ml_priv;
-	struct iw_range *range = (struct iw_range *)extra;
-	struct chan_freq_power *cfp;
-	u8 rates[MAX_RATES + 1];
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	dwrq->length = sizeof(struct iw_range);
-	memset(range, 0, sizeof(struct iw_range));
-
-	range->min_nwid = 0;
-	range->max_nwid = 0;
-
-	memset(rates, 0, sizeof(rates));
-	copy_active_data_rates(priv, rates);
-	range->num_bitrates = strnlen(rates, IW_MAX_BITRATES);
-	for (i = 0; i < range->num_bitrates; i++)
-		range->bitrate[i] = rates[i] * 500000;
-	range->num_bitrates = i;
-	lbs_deb_wext("IW_MAX_BITRATES %d, num_bitrates %d\n", IW_MAX_BITRATES,
-	       range->num_bitrates);
-
-	range->num_frequency = 0;
-
-	range->scan_capa = IW_SCAN_CAPA_ESSID;
-
-	for (j = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
-	     && (j < ARRAY_SIZE(priv->region_channel)); j++) {
-		cfp = priv->region_channel[j].CFP;
-		for (i = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
-		     && priv->region_channel[j].valid
-		     && cfp
-		     && (i < priv->region_channel[j].nrcfp); i++) {
-			range->freq[range->num_frequency].i =
-			    (long)cfp->channel;
-			range->freq[range->num_frequency].m =
-			    (long)cfp->freq * 100000;
-			range->freq[range->num_frequency].e = 1;
-			cfp++;
-			range->num_frequency++;
-		}
-	}
-
-	lbs_deb_wext("IW_MAX_FREQUENCIES %d, num_frequency %d\n",
-	       IW_MAX_FREQUENCIES, range->num_frequency);
-
-	range->num_channels = range->num_frequency;
-
-	sort_channels(&range->freq[0], range->num_frequency);
-
-	/*
-	 * Set an indication of the max TCP throughput in bit/s that we can
-	 * expect using this interface
-	 */
-	if (i > 2)
-		range->throughput = 5000 * 1000;
-	else
-		range->throughput = 1500 * 1000;
-
-	range->min_rts = MRVDRV_RTS_MIN_VALUE;
-	range->max_rts = MRVDRV_RTS_MAX_VALUE;
-	range->min_frag = MRVDRV_FRAG_MIN_VALUE;
-	range->max_frag = MRVDRV_FRAG_MAX_VALUE;
-
-	range->encoding_size[0] = 5;
-	range->encoding_size[1] = 13;
-	range->num_encoding_sizes = 2;
-	range->max_encoding_tokens = 4;
-
-	/*
-	 * Right now we support only "iwconfig ethX power on|off"
-	 */
-	range->pm_capa = IW_POWER_ON;
-
-	/*
-	 * Minimum version we recommend
-	 */
-	range->we_version_source = 15;
-
-	/*
-	 * Version we are compiled with
-	 */
-	range->we_version_compiled = WIRELESS_EXT;
-
-	range->retry_capa = IW_RETRY_LIMIT;
-	range->retry_flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
-
-	range->min_retry = TX_RETRY_MIN;
-	range->max_retry = TX_RETRY_MAX;
-
-	/*
-	 * Set the qual, level and noise range values
-	 */
-	range->max_qual.qual = 100;
-	range->max_qual.level = 0;
-	range->max_qual.noise = 0;
-	range->max_qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
-
-	range->avg_qual.qual = 70;
-	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
-	range->avg_qual.level = 0;
-	range->avg_qual.noise = 0;
-	range->avg_qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
-
-	range->sensitivity = 0;
-
-	/* Setup the supported power level ranges */
-	memset(range->txpower, 0, sizeof(range->txpower));
-	range->txpower_capa = IW_TXPOW_DBM | IW_TXPOW_RANGE;
-	range->txpower[0] = priv->txpower_min;
-	range->txpower[1] = priv->txpower_max;
-	range->num_txpower = 2;
-
-	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |
-				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
-				IW_EVENT_CAPA_MASK(SIOCGIWSCAN));
-	range->event_capa[1] = IW_EVENT_CAPA_K_1;
-
-	if (priv->fwcapinfo & FW_CAPINFO_WPA) {
-		range->enc_capa =   IW_ENC_CAPA_WPA
-		                  | IW_ENC_CAPA_WPA2
-		                  | IW_ENC_CAPA_CIPHER_TKIP
-		                  | IW_ENC_CAPA_CIPHER_CCMP;
-	}
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!(priv->fwcapinfo & FW_CAPINFO_PS)) {
-		if (vwrq->disabled)
-			return 0;
-		else
-			return -EINVAL;
-	}
-
-	/* PS is currently supported only in Infrastructure mode
-	 * Remove this check if it is to be supported in IBSS mode also
-	 */
-
-	if (vwrq->disabled) {
-		priv->psmode = LBS802_11POWERMODECAM;
-		if (priv->psstate != PS_STATE_FULL_POWER) {
-			lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
-		}
-
-		return 0;
-	}
-
-	if ((vwrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
-		lbs_deb_wext(
-		       "setting power timeout is not supported\n");
-		return -EINVAL;
-	} else if ((vwrq->flags & IW_POWER_TYPE) == IW_POWER_PERIOD) {
-		vwrq->value = vwrq->value / 1000;
-		if (!priv->enter_deep_sleep) {
-			lbs_pr_err("deep sleep feature is not implemented "
-					"for this interface driver\n");
-			return -EINVAL;
-		}
-
-		if (priv->connect_status == LBS_CONNECTED) {
-			if ((priv->is_auto_deep_sleep_enabled) &&
-						(vwrq->value == -1000)) {
-				lbs_exit_auto_deep_sleep(priv);
-				return 0;
-			} else {
-				lbs_pr_err("can't use deep sleep cmd in "
-						"connected state\n");
-				return -EINVAL;
-			}
-		}
-
-		if ((vwrq->value < 0) && (vwrq->value != -1000)) {
-			lbs_pr_err("unknown option\n");
-			return -EINVAL;
-		}
-
-		if (vwrq->value > 0) {
-			if (!priv->is_auto_deep_sleep_enabled) {
-				priv->is_activity_detected = 0;
-				priv->auto_deep_sleep_timeout = vwrq->value;
-				lbs_enter_auto_deep_sleep(priv);
-			} else {
-				priv->auto_deep_sleep_timeout = vwrq->value;
-				lbs_deb_debugfs("auto deep sleep: "
-						"already enabled\n");
-			}
-			return 0;
-		} else {
-			if (priv->is_auto_deep_sleep_enabled) {
-				lbs_exit_auto_deep_sleep(priv);
-				/* Try to exit deep sleep if auto */
-				/*deep sleep disabled */
-				ret = lbs_set_deep_sleep(priv, 0);
-			}
-			if (vwrq->value == 0)
-				ret = lbs_set_deep_sleep(priv, 1);
-			else if (vwrq->value == -1000)
-				ret = lbs_set_deep_sleep(priv, 0);
-			return ret;
-		}
-	}
-
-	if (priv->psmode != LBS802_11POWERMODECAM) {
-		return 0;
-	}
-
-	priv->psmode = LBS802_11POWERMODEMAX_PSP;
-
-	if (priv->connect_status == LBS_CONNECTED) {
-		lbs_ps_sleep(priv, CMD_OPTION_WAITFORRSP);
-	}
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-
-	return 0;
-}
-
-static int lbs_get_power(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	vwrq->value = 0;
-	vwrq->flags = 0;
-	vwrq->disabled = priv->psmode == LBS802_11POWERMODECAM
-		|| priv->connect_status == LBS_DISCONNECTED;
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
-{
-	enum {
-		POOR = 30,
-		FAIR = 60,
-		GOOD = 80,
-		VERY_GOOD = 90,
-		EXCELLENT = 95,
-		PERFECT = 100
-	};
-	struct lbs_private *priv = dev->ml_priv;
-	u32 rssi_qual;
-	u32 tx_qual;
-	u32 quality = 0;
-	int ret, stats_valid = 0;
-	u8 rssi;
-	u32 tx_retries;
-	struct cmd_ds_802_11_get_log log;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	priv->wstats.status = priv->mode;
-
-	/* If we're not associated, all quality values are meaningless */
-	if ((priv->connect_status != LBS_CONNECTED) &&
-	    !lbs_mesh_connected(priv))
-		goto out;
-
-	/* Quality by RSSI */
-	priv->wstats.qual.level =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
-	     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-
-	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
-		priv->wstats.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
-	} else {
-		priv->wstats.qual.noise =
-		    CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-	}
-
-	lbs_deb_wext("signal level %#x\n", priv->wstats.qual.level);
-	lbs_deb_wext("noise %#x\n", priv->wstats.qual.noise);
-
-	rssi = priv->wstats.qual.level - priv->wstats.qual.noise;
-	if (rssi < 15)
-		rssi_qual = rssi * POOR / 10;
-	else if (rssi < 20)
-		rssi_qual = (rssi - 15) * (FAIR - POOR) / 5 + POOR;
-	else if (rssi < 30)
-		rssi_qual = (rssi - 20) * (GOOD - FAIR) / 5 + FAIR;
-	else if (rssi < 40)
-		rssi_qual = (rssi - 30) * (VERY_GOOD - GOOD) /
-		    10 + GOOD;
-	else
-		rssi_qual = (rssi - 40) * (PERFECT - VERY_GOOD) /
-		    10 + VERY_GOOD;
-	quality = rssi_qual;
-
-	/* Quality by TX errors */
-	priv->wstats.discard.retries = dev->stats.tx_errors;
-
-	memset(&log, 0, sizeof(log));
-	log.hdr.size = cpu_to_le16(sizeof(log));
-	ret = lbs_cmd_with_response(priv, CMD_802_11_GET_LOG, &log);
-	if (ret)
-		goto out;
-
-	tx_retries = le32_to_cpu(log.retry);
-
-	if (tx_retries > 75)
-		tx_qual = (90 - tx_retries) * POOR / 15;
-	else if (tx_retries > 70)
-		tx_qual = (75 - tx_retries) * (FAIR - POOR) / 5 + POOR;
-	else if (tx_retries > 65)
-		tx_qual = (70 - tx_retries) * (GOOD - FAIR) / 5 + FAIR;
-	else if (tx_retries > 50)
-		tx_qual = (65 - tx_retries) * (VERY_GOOD - GOOD) /
-		    15 + GOOD;
-	else
-		tx_qual = (50 - tx_retries) *
-		    (PERFECT - VERY_GOOD) / 50 + VERY_GOOD;
-	quality = min(quality, tx_qual);
-
-	priv->wstats.discard.code = le32_to_cpu(log.wepundecryptable);
-	priv->wstats.discard.retries = tx_retries;
-	priv->wstats.discard.misc = le32_to_cpu(log.ackfailure);
-
-	/* Calculate quality */
-	priv->wstats.qual.qual = min_t(u8, quality, 100);
-	priv->wstats.qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
-	stats_valid = 1;
-
-	/* update stats asynchronously for future calls */
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-					0, 0, NULL);
-	if (ret)
-		lbs_pr_err("RSSI command failed\n");
-out:
-	if (!stats_valid) {
-		priv->wstats.miss.beacon = 0;
-		priv->wstats.discard.retries = 0;
-		priv->wstats.qual.qual = 0;
-		priv->wstats.qual.level = 0;
-		priv->wstats.qual.noise = 0;
-		priv->wstats.qual.updated = IW_QUAL_ALL_UPDATED;
-		priv->wstats.qual.updated |= IW_QUAL_NOISE_INVALID |
-		    IW_QUAL_QUAL_INVALID | IW_QUAL_LEVEL_INVALID;
-	}
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return &priv->wstats;
-
-
-}
-
-static int lbs_set_freq(struct net_device *dev, struct iw_request_info *info,
-		  struct iw_freq *fwrq, char *extra)
-{
-	int ret = -EINVAL;
-	struct lbs_private *priv = dev->ml_priv;
-	struct chan_freq_power *cfp;
-	struct assoc_request * assoc_req;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	mutex_lock(&priv->lock);
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* If setting by frequency, convert to a channel */
-	if (fwrq->e == 1) {
-		long f = fwrq->m / 100000;
-
-		cfp = find_cfp_by_band_and_freq(priv, 0, f);
-		if (!cfp) {
-			lbs_deb_wext("invalid freq %ld\n", f);
-			goto out;
-		}
-
-		fwrq->e = 0;
-		fwrq->m = (int) cfp->channel;
-	}
-
-	/* Setting by channel number */
-	if (fwrq->m > 1000 || fwrq->e > 0) {
-		goto out;
-	}
-
-	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, fwrq->m);
-	if (!cfp) {
-		goto out;
-	}
-
-	assoc_req->channel = fwrq->m;
-	ret = 0;
-
-out:
-	if (ret == 0) {
-		set_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags);
-		lbs_postpone_association_work(priv);
-	} else {
-		lbs_cancel_association_work(priv);
-	}
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-#ifdef CONFIG_LIBERTAS_MESH
-static int lbs_mesh_set_freq(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_freq *fwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	struct chan_freq_power *cfp;
-	int ret = -EINVAL;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* If setting by frequency, convert to a channel */
-	if (fwrq->e == 1) {
-		long f = fwrq->m / 100000;
-
-		cfp = find_cfp_by_band_and_freq(priv, 0, f);
-		if (!cfp) {
-			lbs_deb_wext("invalid freq %ld\n", f);
-			goto out;
-		}
-
-		fwrq->e = 0;
-		fwrq->m = (int) cfp->channel;
-	}
-
-	/* Setting by channel number */
-	if (fwrq->m > 1000 || fwrq->e > 0) {
-		goto out;
-	}
-
-	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, fwrq->m);
-	if (!cfp) {
-		goto out;
-	}
-
-	if (fwrq->m != priv->channel) {
-		lbs_deb_wext("mesh channel change forces eth disconnect\n");
-		if (priv->mode == IW_MODE_INFRA)
-			lbs_cmd_80211_deauthenticate(priv,
-						     priv->curbssparams.bssid,
-						     WLAN_REASON_DEAUTH_LEAVING);
-		else if (priv->mode == IW_MODE_ADHOC)
-			lbs_adhoc_stop(priv);
-	}
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, fwrq->m);
-	lbs_update_channel(priv);
-	ret = 0;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-#endif
-
-static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
-		  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	u8 new_rate = 0;
-	int ret = -EINVAL;
-	u8 rates[MAX_RATES + 1];
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	lbs_deb_wext("vwrq->value %d\n", vwrq->value);
-	lbs_deb_wext("vwrq->fixed %d\n", vwrq->fixed);
-
-	if (vwrq->fixed && vwrq->value == -1)
-		goto out;
-
-	/* Auto rate? */
-	priv->enablehwauto = !vwrq->fixed;
-
-	if (vwrq->value == -1)
-		priv->cur_rate = 0;
-	else {
-		if (vwrq->value % 100000)
-			goto out;
-
-		new_rate = vwrq->value / 500000;
-		priv->cur_rate = new_rate;
-		/* the rest is only needed for lbs_set_data_rate() */
-		memset(rates, 0, sizeof(rates));
-		copy_active_data_rates(priv, rates);
-		if (!memchr(rates, new_rate, sizeof(rates))) {
-			lbs_pr_alert("fixed data rate 0x%X out of range\n",
-				new_rate);
-			goto out;
-		}
-		if (priv->fwrelease < 0x09000000) {
-			ret = lbs_set_power_adapt_cfg(priv, 0,
-					POW_ADAPT_DEFAULT_P0,
-					POW_ADAPT_DEFAULT_P1,
-					POW_ADAPT_DEFAULT_P2);
-			if (ret)
-				goto out;
-		}
-		ret = lbs_set_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
-				TPC_DEFAULT_P2, 1);
-		if (ret)
-			goto out;
-	}
-
-	/* Try the newer command first (Firmware Spec 5.1 and above) */
-	ret = lbs_cmd_802_11_rate_adapt_rateset(priv, CMD_ACT_SET);
-
-	/* Fallback to older version */
-	if (ret)
-		ret = lbs_set_data_rate(priv, new_rate);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_rate(struct net_device *dev, struct iw_request_info *info,
-		  struct iw_param *vwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (priv->connect_status == LBS_CONNECTED) {
-		vwrq->value = priv->cur_rate * 500000;
-
-		if (priv->enablehwauto)
-			vwrq->fixed = 0;
-		else
-			vwrq->fixed = 1;
-
-	} else {
-		vwrq->fixed = 0;
-		vwrq->value = 0;
-	}
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_set_mode(struct net_device *dev,
-		  struct iw_request_info *info, u32 * uwrq, char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-	struct assoc_request * assoc_req;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (   (*uwrq != IW_MODE_ADHOC)
-	    && (*uwrq != IW_MODE_INFRA)
-	    && (*uwrq != IW_MODE_AUTO)) {
-		lbs_deb_wext("Invalid mode: 0x%x\n", *uwrq);
-		ret = -EINVAL;
-		goto out;
-	}
-
-	mutex_lock(&priv->lock);
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		ret = -ENOMEM;
-		lbs_cancel_association_work(priv);
-	} else {
-		assoc_req->mode = *uwrq;
-		set_bit(ASSOC_FLAG_MODE, &assoc_req->flags);
-		lbs_postpone_association_work(priv);
-		lbs_deb_wext("Switching to mode: 0x%x\n", *uwrq);
-	}
-	mutex_unlock(&priv->lock);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-
-/**
- *  @brief Get Encryption key
- *
- *  @param dev                  A pointer to net_device structure
- *  @param info			A pointer to iw_request_info structure
- *  @param vwrq 		A pointer to iw_param structure
- *  @param extra		A pointer to extra data buf
- *  @return 	   		0 --success, otherwise fail
- */
-static int lbs_get_encode(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *dwrq, u8 * extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	lbs_deb_wext("flags 0x%x, index %d, length %d, wep_tx_keyidx %d\n",
-	       dwrq->flags, index, dwrq->length, priv->wep_tx_keyidx);
-
-	dwrq->flags = 0;
-
-	/* Authentication method */
-	switch (priv->secinfo.auth_mode) {
-	case IW_AUTH_ALG_OPEN_SYSTEM:
-		dwrq->flags = IW_ENCODE_OPEN;
-		break;
-
-	case IW_AUTH_ALG_SHARED_KEY:
-	case IW_AUTH_ALG_LEAP:
-		dwrq->flags = IW_ENCODE_RESTRICTED;
-		break;
-	default:
-		dwrq->flags = IW_ENCODE_DISABLED | IW_ENCODE_OPEN;
-		break;
-	}
-
-	memset(extra, 0, 16);
-
-	mutex_lock(&priv->lock);
-
-	/* Default to returning current transmit key */
-	if (index < 0)
-		index = priv->wep_tx_keyidx;
-
-	if ((priv->wep_keys[index].len) && priv->secinfo.wep_enabled) {
-		memcpy(extra, priv->wep_keys[index].key,
-		       priv->wep_keys[index].len);
-		dwrq->length = priv->wep_keys[index].len;
-
-		dwrq->flags |= (index + 1);
-		/* Return WEP enabled */
-		dwrq->flags &= ~IW_ENCODE_DISABLED;
-	} else if ((priv->secinfo.WPAenabled)
-		   || (priv->secinfo.WPA2enabled)) {
-		/* return WPA enabled */
-		dwrq->flags &= ~IW_ENCODE_DISABLED;
-		dwrq->flags |= IW_ENCODE_NOKEY;
-	} else {
-		dwrq->flags |= IW_ENCODE_DISABLED;
-	}
-
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_wext("key: %02x:%02x:%02x:%02x:%02x:%02x, keylen %d\n",
-	       extra[0], extra[1], extra[2],
-	       extra[3], extra[4], extra[5], dwrq->length);
-
-	lbs_deb_wext("return flags 0x%x\n", dwrq->flags);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-/**
- *  @brief Set Encryption key (internal)
- *
- *  @param priv			A pointer to private card structure
- *  @param key_material		A pointer to key material
- *  @param key_length		length of key material
- *  @param index		key index to set
- *  @param set_tx_key		Force set TX key (1 = yes, 0 = no)
- *  @return 	   		0 --success, otherwise fail
- */
-static int lbs_set_wep_key(struct assoc_request *assoc_req,
-			    const char *key_material,
-			    u16 key_length,
-			    u16 index,
-			    int set_tx_key)
-{
-	int ret = 0;
-	struct enc_key *pkey;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* Paranoid validation of key index */
-	if (index > 3) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* validate max key length */
-	if (key_length > KEY_LEN_WEP_104) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	pkey = &assoc_req->wep_keys[index];
-
-	if (key_length > 0) {
-		memset(pkey, 0, sizeof(struct enc_key));
-		pkey->type = KEY_TYPE_ID_WEP;
-
-		/* Standardize the key length */
-		pkey->len = (key_length > KEY_LEN_WEP_40) ?
-		                KEY_LEN_WEP_104 : KEY_LEN_WEP_40;
-		memcpy(pkey->key, key_material, key_length);
-	}
-
-	if (set_tx_key) {
-		/* Ensure the chosen key is valid */
-		if (!pkey->len) {
-			lbs_deb_wext("key not set, so cannot enable it\n");
-			ret = -EINVAL;
-			goto out;
-		}
-		assoc_req->wep_tx_keyidx = index;
-	}
-
-	assoc_req->secinfo.wep_enabled = 1;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int validate_key_index(u16 def_index, u16 raw_index,
-			      u16 *out_index, u16 *is_default)
-{
-	if (!out_index || !is_default)
-		return -EINVAL;
-
-	/* Verify index if present, otherwise use default TX key index */
-	if (raw_index > 0) {
-		if (raw_index > 4)
-			return -EINVAL;
-		*out_index = raw_index - 1;
-	} else {
-		*out_index = def_index;
-		*is_default = 1;
-	}
-	return 0;
-}
-
-static void disable_wep(struct assoc_request *assoc_req)
-{
-	int i;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* Set Open System auth mode */
-	assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-
-	/* Clear WEP keys and mark WEP as disabled */
-	assoc_req->secinfo.wep_enabled = 0;
-	for (i = 0; i < 4; i++)
-		assoc_req->wep_keys[i].len = 0;
-
-	set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-	set_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-}
-
-static void disable_wpa(struct assoc_request *assoc_req)
-{
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	memset(&assoc_req->wpa_mcast_key, 0, sizeof (struct enc_key));
-	assoc_req->wpa_mcast_key.flags = KEY_INFO_WPA_MCAST;
-	set_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags);
-
-	memset(&assoc_req->wpa_unicast_key, 0, sizeof (struct enc_key));
-	assoc_req->wpa_unicast_key.flags = KEY_INFO_WPA_UNICAST;
-	set_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
-
-	assoc_req->secinfo.WPAenabled = 0;
-	assoc_req->secinfo.WPA2enabled = 0;
-	set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-}
-
-/**
- *  @brief Set Encryption key
- *
- *  @param dev                  A pointer to net_device structure
- *  @param info			A pointer to iw_request_info structure
- *  @param vwrq 		A pointer to iw_param structure
- *  @param extra		A pointer to extra data buf
- *  @return 	   		0 --success, otherwise fail
- */
-static int lbs_set_encode(struct net_device *dev,
-		    struct iw_request_info *info,
-		    struct iw_point *dwrq, char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-	struct assoc_request * assoc_req;
-	u16 is_default = 0, index = 0, set_tx_key = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	mutex_lock(&priv->lock);
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (dwrq->flags & IW_ENCODE_DISABLED) {
-		disable_wep (assoc_req);
-		disable_wpa (assoc_req);
-		goto out;
-	}
-
-	ret = validate_key_index(assoc_req->wep_tx_keyidx,
-	                         (dwrq->flags & IW_ENCODE_INDEX),
-	                         &index, &is_default);
-	if (ret) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* If WEP isn't enabled, or if there is no key data but a valid
-	 * index, set the TX key.
-	 */
-	if (!assoc_req->secinfo.wep_enabled || (dwrq->length == 0 && !is_default))
-		set_tx_key = 1;
-
-	ret = lbs_set_wep_key(assoc_req, extra, dwrq->length, index, set_tx_key);
-	if (ret)
-		goto out;
-
-	if (dwrq->length)
-		set_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags);
-	if (set_tx_key)
-		set_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags);
-
-	if (dwrq->flags & IW_ENCODE_RESTRICTED) {
-		assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
-	} else if (dwrq->flags & IW_ENCODE_OPEN) {
-		assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	}
-
-out:
-	if (ret == 0) {
-		set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-		lbs_postpone_association_work(priv);
-	} else {
-		lbs_cancel_association_work(priv);
-	}
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Get Extended Encryption key (WPA/802.1x and WEP)
- *
- *  @param dev                  A pointer to net_device structure
- *  @param info			A pointer to iw_request_info structure
- *  @param vwrq 		A pointer to iw_param structure
- *  @param extra		A pointer to extra data buf
- *  @return 	   		0 on success, otherwise failure
- */
-static int lbs_get_encodeext(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq,
-			      char *extra)
-{
-	int ret = -EINVAL;
-	struct lbs_private *priv = dev->ml_priv;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	int index, max_key_len;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	max_key_len = dwrq->length - sizeof(*ext);
-	if (max_key_len < 0)
-		goto out;
-
-	index = dwrq->flags & IW_ENCODE_INDEX;
-	if (index) {
-		if (index < 1 || index > 4)
-			goto out;
-		index--;
-	} else {
-		index = priv->wep_tx_keyidx;
-	}
-
-	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
-	    ext->alg != IW_ENCODE_ALG_WEP) {
-		if (index != 0 || priv->mode != IW_MODE_INFRA)
-			goto out;
-	}
-
-	dwrq->flags = index + 1;
-	memset(ext, 0, sizeof(*ext));
-
-	if (   !priv->secinfo.wep_enabled
-	    && !priv->secinfo.WPAenabled
-	    && !priv->secinfo.WPA2enabled) {
-		ext->alg = IW_ENCODE_ALG_NONE;
-		ext->key_len = 0;
-		dwrq->flags |= IW_ENCODE_DISABLED;
-	} else {
-		u8 *key = NULL;
-
-		if (   priv->secinfo.wep_enabled
-		    && !priv->secinfo.WPAenabled
-		    && !priv->secinfo.WPA2enabled) {
-			/* WEP */
-			ext->alg = IW_ENCODE_ALG_WEP;
-			ext->key_len = priv->wep_keys[index].len;
-			key = &priv->wep_keys[index].key[0];
-		} else if (   !priv->secinfo.wep_enabled
-		           && (priv->secinfo.WPAenabled ||
-		               priv->secinfo.WPA2enabled)) {
-			/* WPA */
-			struct enc_key * pkey = NULL;
-
-			if (   priv->wpa_mcast_key.len
-			    && (priv->wpa_mcast_key.flags & KEY_INFO_WPA_ENABLED))
-				pkey = &priv->wpa_mcast_key;
-			else if (   priv->wpa_unicast_key.len
-			         && (priv->wpa_unicast_key.flags & KEY_INFO_WPA_ENABLED))
-				pkey = &priv->wpa_unicast_key;
-
-			if (pkey) {
-				if (pkey->type == KEY_TYPE_ID_AES) {
-					ext->alg = IW_ENCODE_ALG_CCMP;
-				} else {
-					ext->alg = IW_ENCODE_ALG_TKIP;
-				}
-				ext->key_len = pkey->len;
-				key = &pkey->key[0];
-			} else {
-				ext->alg = IW_ENCODE_ALG_TKIP;
-				ext->key_len = 0;
-			}
-		} else {
-			goto out;
-		}
-
-		if (ext->key_len > max_key_len) {
-			ret = -E2BIG;
-			goto out;
-		}
-
-		if (ext->key_len)
-			memcpy(ext->key, key, ext->key_len);
-		else
-			dwrq->flags |= IW_ENCODE_NOKEY;
-		dwrq->flags |= IW_ENCODE_ENABLED;
-	}
-	ret = 0;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-/**
- *  @brief Set Encryption key Extended (WPA/802.1x and WEP)
- *
- *  @param dev                  A pointer to net_device structure
- *  @param info			A pointer to iw_request_info structure
- *  @param vwrq 		A pointer to iw_param structure
- *  @param extra		A pointer to extra data buf
- *  @return 	   		0 --success, otherwise fail
- */
-static int lbs_set_encodeext(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq,
-			      char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	int alg = ext->alg;
-	struct assoc_request * assoc_req;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	mutex_lock(&priv->lock);
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if ((alg == IW_ENCODE_ALG_NONE) || (dwrq->flags & IW_ENCODE_DISABLED)) {
-		disable_wep (assoc_req);
-		disable_wpa (assoc_req);
-	} else if (alg == IW_ENCODE_ALG_WEP) {
-		u16 is_default = 0, index, set_tx_key = 0;
-
-		ret = validate_key_index(assoc_req->wep_tx_keyidx,
-		                         (dwrq->flags & IW_ENCODE_INDEX),
-		                         &index, &is_default);
-		if (ret)
-			goto out;
-
-		/* If WEP isn't enabled, or if there is no key data but a valid
-		 * index, or if the set-TX-key flag was passed, set the TX key.
-		 */
-		if (   !assoc_req->secinfo.wep_enabled
-		    || (dwrq->length == 0 && !is_default)
-		    || (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY))
-			set_tx_key = 1;
-
-		/* Copy key to driver */
-		ret = lbs_set_wep_key(assoc_req, ext->key, ext->key_len, index,
-					set_tx_key);
-		if (ret)
-			goto out;
-
-		if (dwrq->flags & IW_ENCODE_RESTRICTED) {
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
-		} else if (dwrq->flags & IW_ENCODE_OPEN) {
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-		}
-
-		/* Mark the various WEP bits as modified */
-		set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-		if (dwrq->length)
-			set_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags);
-		if (set_tx_key)
-			set_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags);
-	} else if ((alg == IW_ENCODE_ALG_TKIP) || (alg == IW_ENCODE_ALG_CCMP)) {
-		struct enc_key * pkey;
-
-		/* validate key length */
-		if (((alg == IW_ENCODE_ALG_TKIP)
-			&& (ext->key_len != KEY_LEN_WPA_TKIP))
-		    || ((alg == IW_ENCODE_ALG_CCMP)
-		        && (ext->key_len != KEY_LEN_WPA_AES))) {
-				lbs_deb_wext("invalid size %d for key of alg "
-				       "type %d\n",
-				       ext->key_len,
-				       alg);
-				ret = -EINVAL;
-				goto out;
-		}
-
-		if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
-			pkey = &assoc_req->wpa_mcast_key;
-			set_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags);
-		} else {
-			pkey = &assoc_req->wpa_unicast_key;
-			set_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
-		}
-
-		memset(pkey, 0, sizeof (struct enc_key));
-		memcpy(pkey->key, ext->key, ext->key_len);
-		pkey->len = ext->key_len;
-		if (pkey->len)
-			pkey->flags |= KEY_INFO_WPA_ENABLED;
-
-		/* Do this after zeroing key structure */
-		if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
-			pkey->flags |= KEY_INFO_WPA_MCAST;
-		} else {
-			pkey->flags |= KEY_INFO_WPA_UNICAST;
-		}
-
-		if (alg == IW_ENCODE_ALG_TKIP) {
-			pkey->type = KEY_TYPE_ID_TKIP;
-		} else if (alg == IW_ENCODE_ALG_CCMP) {
-			pkey->type = KEY_TYPE_ID_AES;
-		}
-
-		/* If WPA isn't enabled yet, do that now */
-		if (   assoc_req->secinfo.WPAenabled == 0
-		    && assoc_req->secinfo.WPA2enabled == 0) {
-			assoc_req->secinfo.WPAenabled = 1;
-			assoc_req->secinfo.WPA2enabled = 1;
-			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-		}
-
-		/* Only disable wep if necessary: can't waste time here. */
-		if (priv->mac_control & CMD_ACT_MAC_WEP_ENABLE)
-			disable_wep(assoc_req);
-	}
-
-out:
-	if (ret == 0) {
-		/* 802.1x and WPA rekeying must happen as quickly as possible,
-		 * especially during the 4-way handshake; thus if in
-		 * infrastructure mode, and either (a) 802.1x is enabled or
-		 * (b) WPA is being used, set the key right away.
-		 */
-		if (assoc_req->mode == IW_MODE_INFRA &&
-		    ((assoc_req->secinfo.key_mgmt & IW_AUTH_KEY_MGMT_802_1X) ||
-		     (assoc_req->secinfo.key_mgmt & IW_AUTH_KEY_MGMT_PSK) ||
-		      assoc_req->secinfo.WPAenabled ||
-		      assoc_req->secinfo.WPA2enabled)) {
-			lbs_do_association_work(priv);
-		} else
-			lbs_postpone_association_work(priv);
-	} else {
-		lbs_cancel_association_work(priv);
-	}
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-
-static int lbs_set_genie(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
-			  char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	struct assoc_request * assoc_req;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	mutex_lock(&priv->lock);
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (dwrq->length > MAX_WPA_IE_LEN ||
-	    (dwrq->length && extra == NULL)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (dwrq->length) {
-		memcpy(&assoc_req->wpa_ie[0], extra, dwrq->length);
-		assoc_req->wpa_ie_len = dwrq->length;
-	} else {
-		memset(&assoc_req->wpa_ie[0], 0, sizeof(priv->wpa_ie));
-		assoc_req->wpa_ie_len = 0;
-	}
-
-out:
-	if (ret == 0) {
-		set_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags);
-		lbs_postpone_association_work(priv);
-	} else {
-		lbs_cancel_association_work(priv);
-	}
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_genie(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
-			  char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (priv->wpa_ie_len == 0) {
-		dwrq->length = 0;
-		goto out;
-	}
-
-	if (dwrq->length < priv->wpa_ie_len) {
-		ret = -E2BIG;
-		goto out;
-	}
-
-	dwrq->length = priv->wpa_ie_len;
-	memcpy(extra, &priv->wpa_ie[0], priv->wpa_ie_len);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-
-static int lbs_set_auth(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *dwrq,
-			 char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	struct assoc_request * assoc_req;
-	int ret = 0;
-	int updated = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	mutex_lock(&priv->lock);
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	switch (dwrq->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_PRIVACY_INVOKED:
-	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-	case IW_AUTH_TKIP_COUNTERMEASURES:
-	case IW_AUTH_CIPHER_PAIRWISE:
-	case IW_AUTH_CIPHER_GROUP:
-	case IW_AUTH_DROP_UNENCRYPTED:
-		/*
-		 * libertas does not use these parameters
-		 */
-		break;
-
-	case IW_AUTH_KEY_MGMT:
-		assoc_req->secinfo.key_mgmt = dwrq->value;
-		updated = 1;
-		break;
-
-	case IW_AUTH_WPA_VERSION:
-		if (dwrq->value & IW_AUTH_WPA_VERSION_DISABLED) {
-			assoc_req->secinfo.WPAenabled = 0;
-			assoc_req->secinfo.WPA2enabled = 0;
-			disable_wpa (assoc_req);
-		}
-		if (dwrq->value & IW_AUTH_WPA_VERSION_WPA) {
-			assoc_req->secinfo.WPAenabled = 1;
-			assoc_req->secinfo.wep_enabled = 0;
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-		}
-		if (dwrq->value & IW_AUTH_WPA_VERSION_WPA2) {
-			assoc_req->secinfo.WPA2enabled = 1;
-			assoc_req->secinfo.wep_enabled = 0;
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-		}
-		updated = 1;
-		break;
-
-	case IW_AUTH_80211_AUTH_ALG:
-		if (dwrq->value & IW_AUTH_ALG_SHARED_KEY) {
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
-		} else if (dwrq->value & IW_AUTH_ALG_OPEN_SYSTEM) {
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-		} else if (dwrq->value & IW_AUTH_ALG_LEAP) {
-			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_LEAP;
-		} else {
-			ret = -EINVAL;
-		}
-		updated = 1;
-		break;
-
-	case IW_AUTH_WPA_ENABLED:
-		if (dwrq->value) {
-			if (!assoc_req->secinfo.WPAenabled &&
-			    !assoc_req->secinfo.WPA2enabled) {
-				assoc_req->secinfo.WPAenabled = 1;
-				assoc_req->secinfo.WPA2enabled = 1;
-				assoc_req->secinfo.wep_enabled = 0;
-				assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-			}
-		} else {
-			assoc_req->secinfo.WPAenabled = 0;
-			assoc_req->secinfo.WPA2enabled = 0;
-			disable_wpa (assoc_req);
-		}
-		updated = 1;
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-out:
-	if (ret == 0) {
-		if (updated)
-			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-		lbs_postpone_association_work(priv);
-	} else if (ret != -EOPNOTSUPP) {
-		lbs_cancel_association_work(priv);
-	}
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_auth(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *dwrq,
-			 char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	switch (dwrq->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_KEY_MGMT:
-		dwrq->value = priv->secinfo.key_mgmt;
-		break;
-
-	case IW_AUTH_WPA_VERSION:
-		dwrq->value = 0;
-		if (priv->secinfo.WPAenabled)
-			dwrq->value |= IW_AUTH_WPA_VERSION_WPA;
-		if (priv->secinfo.WPA2enabled)
-			dwrq->value |= IW_AUTH_WPA_VERSION_WPA2;
-		if (!dwrq->value)
-			dwrq->value |= IW_AUTH_WPA_VERSION_DISABLED;
-		break;
-
-	case IW_AUTH_80211_AUTH_ALG:
-		dwrq->value = priv->secinfo.auth_mode;
-		break;
-
-	case IW_AUTH_WPA_ENABLED:
-		if (priv->secinfo.WPAenabled && priv->secinfo.WPA2enabled)
-			dwrq->value = 1;
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-	}
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-
-static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
-		   struct iw_param *vwrq, char *extra)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->ml_priv;
-	s16 dbm = (s16) vwrq->value;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (vwrq->disabled) {
-		lbs_set_radio(priv, RADIO_PREAMBLE_AUTO, 0);
-		goto out;
-	}
-
-	if (vwrq->fixed == 0) {
-		/* User requests automatic tx power control, however there are
-		 * many auto tx settings.  For now use firmware defaults until
-		 * we come up with a good way to expose these to the user. */
-		if (priv->fwrelease < 0x09000000) {
-			ret = lbs_set_power_adapt_cfg(priv, 1,
-					POW_ADAPT_DEFAULT_P0,
-					POW_ADAPT_DEFAULT_P1,
-					POW_ADAPT_DEFAULT_P2);
-			if (ret)
-				goto out;
-		}
-		ret = lbs_set_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
-				TPC_DEFAULT_P2, 1);
-		if (ret)
-			goto out;
-		dbm = priv->txpower_max;
-	} else {
-		/* Userspace check in iwrange if it should use dBm or mW,
-		 * therefore this should never happen... Jean II */
-		if ((vwrq->flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM) {
-			ret = -EOPNOTSUPP;
-			goto out;
-		}
-
-		/* Validate requested power level against firmware allowed
-		 * levels */
-		if (priv->txpower_min && (dbm < priv->txpower_min)) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (priv->txpower_max && (dbm > priv->txpower_max)) {
-			ret = -EINVAL;
-			goto out;
-		}
-		if (priv->fwrelease < 0x09000000) {
-			ret = lbs_set_power_adapt_cfg(priv, 0,
-					POW_ADAPT_DEFAULT_P0,
-					POW_ADAPT_DEFAULT_P1,
-					POW_ADAPT_DEFAULT_P2);
-			if (ret)
-				goto out;
-		}
-		ret = lbs_set_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
-				TPC_DEFAULT_P2, 1);
-		if (ret)
-			goto out;
-	}
-
-	/* If the radio was off, turn it on */
-	if (!priv->radio_on) {
-		ret = lbs_set_radio(priv, RADIO_PREAMBLE_AUTO, 1);
-		if (ret)
-			goto out;
-	}
-
-	lbs_deb_wext("txpower set %d dBm\n", dbm);
-
-	ret = lbs_set_tx_power(priv, dbm);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_get_essid(struct net_device *dev, struct iw_request_info *info,
-		   struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/*
-	 * Note : if dwrq->flags != 0, we should get the relevant SSID from
-	 * the SSID list...
-	 */
-
-	/*
-	 * Get the current SSID
-	 */
-	if (priv->connect_status == LBS_CONNECTED) {
-		memcpy(extra, priv->curbssparams.ssid,
-		       priv->curbssparams.ssid_len);
-	} else {
-		memset(extra, 0, 32);
-	}
-	/*
-	 * If none, we may want to get the one that was set
-	 */
-
-	dwrq->length = priv->curbssparams.ssid_len;
-
-	dwrq->flags = 1;	/* active */
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
-		   struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 ssid_len = 0;
-	struct assoc_request * assoc_req;
-	int in_ssid_len = dwrq->length;
-	DECLARE_SSID_BUF(ssid_buf);
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->radio_on) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* Check the size of the string */
-	if (in_ssid_len > IEEE80211_MAX_SSID_LEN) {
-		ret = -E2BIG;
-		goto out;
-	}
-
-	memset(&ssid, 0, sizeof(ssid));
-
-	if (!dwrq->flags || !in_ssid_len) {
-		/* "any" SSID requested; leave SSID blank */
-	} else {
-		/* Specific SSID requested */
-		memcpy(&ssid, extra, in_ssid_len);
-		ssid_len = in_ssid_len;
-	}
-
-	if (!ssid_len) {
-		lbs_deb_wext("requested any SSID\n");
-	} else {
-		lbs_deb_wext("requested SSID '%s'\n",
-		             print_ssid(ssid_buf, ssid, ssid_len));
-	}
-
-out:
-	mutex_lock(&priv->lock);
-	if (ret == 0) {
-		/* Get or create the current association request */
-		assoc_req = lbs_get_association_request(priv);
-		if (!assoc_req) {
-			ret = -ENOMEM;
-		} else {
-			/* Copy the SSID to the association request */
-			memcpy(&assoc_req->ssid, &ssid, IEEE80211_MAX_SSID_LEN);
-			assoc_req->ssid_len = ssid_len;
-			set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
-			lbs_postpone_association_work(priv);
-		}
-	}
-
-	/* Cancel the association request if there was an error */
-	if (ret != 0) {
-		lbs_cancel_association_work(priv);
-	}
-
-	mutex_unlock(&priv->lock);
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
-#ifdef CONFIG_LIBERTAS_MESH
-static int lbs_mesh_get_essid(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	memcpy(extra, priv->mesh_ssid, priv->mesh_ssid_len);
-
-	dwrq->length = priv->mesh_ssid_len;
-
-	dwrq->flags = 1;	/* active */
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_mesh_set_essid(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->radio_on) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* Check the size of the string */
-	if (dwrq->length > IEEE80211_MAX_SSID_LEN) {
-		ret = -E2BIG;
-		goto out;
-	}
-
-	if (!dwrq->flags || !dwrq->length) {
-		ret = -EINVAL;
-		goto out;
-	} else {
-		/* Specific SSID requested */
-		memcpy(priv->mesh_ssid, extra, dwrq->length);
-		priv->mesh_ssid_len = dwrq->length;
-	}
-
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-			priv->channel);
- out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-#endif
-
-/**
- *  @brief Connect to the AP or Ad-hoc Network with specific bssid
- *
- *  @param dev          A pointer to net_device structure
- *  @param info         A pointer to iw_request_info structure
- *  @param awrq         A pointer to iw_param structure
- *  @param extra        A pointer to extra data buf
- *  @return             0 --success, otherwise fail
- */
-static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
-		 struct sockaddr *awrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	struct assoc_request * assoc_req;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->radio_on)
-		return -EINVAL;
-
-	if (awrq->sa_family != ARPHRD_ETHER)
-		return -EINVAL;
-
-	lbs_deb_wext("ASSOC: WAP: sa_data %pM\n", awrq->sa_data);
-
-	mutex_lock(&priv->lock);
-
-	/* Get or create the current association request */
-	assoc_req = lbs_get_association_request(priv);
-	if (!assoc_req) {
-		lbs_cancel_association_work(priv);
-		ret = -ENOMEM;
-	} else {
-		/* Copy the BSSID to the association request */
-		memcpy(&assoc_req->bssid, awrq->sa_data, ETH_ALEN);
-		set_bit(ASSOC_FLAG_BSSID, &assoc_req->flags);
-		lbs_postpone_association_work(priv);
-	}
-
-	mutex_unlock(&priv->lock);
-
-	return ret;
-}
-
-/*
- * iwconfig settable callbacks
- */
-static const iw_handler lbs_handler[] = {
-	(iw_handler) NULL,	/* SIOCSIWCOMMIT */
-	(iw_handler) lbs_get_name,	/* SIOCGIWNAME */
-	(iw_handler) NULL,	/* SIOCSIWNWID */
-	(iw_handler) NULL,	/* SIOCGIWNWID */
-	(iw_handler) lbs_set_freq,	/* SIOCSIWFREQ */
-	(iw_handler) lbs_get_freq,	/* SIOCGIWFREQ */
-	(iw_handler) lbs_set_mode,	/* SIOCSIWMODE */
-	(iw_handler) lbs_get_mode,	/* SIOCGIWMODE */
-	(iw_handler) NULL,	/* SIOCSIWSENS */
-	(iw_handler) NULL,	/* SIOCGIWSENS */
-	(iw_handler) NULL,	/* SIOCSIWRANGE */
-	(iw_handler) lbs_get_range,	/* SIOCGIWRANGE */
-	(iw_handler) NULL,	/* SIOCSIWPRIV */
-	(iw_handler) NULL,	/* SIOCGIWPRIV */
-	(iw_handler) NULL,	/* SIOCSIWSTATS */
-	(iw_handler) NULL,	/* SIOCGIWSTATS */
-	iw_handler_set_spy,	/* SIOCSIWSPY */
-	iw_handler_get_spy,	/* SIOCGIWSPY */
-	iw_handler_set_thrspy,	/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,	/* SIOCGIWTHRSPY */
-	(iw_handler) lbs_set_wap,	/* SIOCSIWAP */
-	(iw_handler) lbs_get_wap,	/* SIOCGIWAP */
-	(iw_handler) NULL,	/* SIOCSIWMLME */
-	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
-	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
-	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
-	(iw_handler) lbs_set_essid,	/* SIOCSIWESSID */
-	(iw_handler) lbs_get_essid,	/* SIOCGIWESSID */
-	(iw_handler) lbs_set_nick,	/* SIOCSIWNICKN */
-	(iw_handler) lbs_get_nick,	/* SIOCGIWNICKN */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) lbs_set_rate,	/* SIOCSIWRATE */
-	(iw_handler) lbs_get_rate,	/* SIOCGIWRATE */
-	(iw_handler) lbs_set_rts,	/* SIOCSIWRTS */
-	(iw_handler) lbs_get_rts,	/* SIOCGIWRTS */
-	(iw_handler) lbs_set_frag,	/* SIOCSIWFRAG */
-	(iw_handler) lbs_get_frag,	/* SIOCGIWFRAG */
-	(iw_handler) lbs_set_txpow,	/* SIOCSIWTXPOW */
-	(iw_handler) lbs_get_txpow,	/* SIOCGIWTXPOW */
-	(iw_handler) lbs_set_retry,	/* SIOCSIWRETRY */
-	(iw_handler) lbs_get_retry,	/* SIOCGIWRETRY */
-	(iw_handler) lbs_set_encode,	/* SIOCSIWENCODE */
-	(iw_handler) lbs_get_encode,	/* SIOCGIWENCODE */
-	(iw_handler) lbs_set_power,	/* SIOCSIWPOWER */
-	(iw_handler) lbs_get_power,	/* SIOCGIWPOWER */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) lbs_set_genie,	/* SIOCSIWGENIE */
-	(iw_handler) lbs_get_genie,	/* SIOCGIWGENIE */
-	(iw_handler) lbs_set_auth,	/* SIOCSIWAUTH */
-	(iw_handler) lbs_get_auth,	/* SIOCGIWAUTH */
-	(iw_handler) lbs_set_encodeext,/* SIOCSIWENCODEEXT */
-	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,		/* SIOCSIWPMKSA */
-};
-struct iw_handler_def lbs_handler_def = {
-	.num_standard	= ARRAY_SIZE(lbs_handler),
-	.standard	= (iw_handler *) lbs_handler,
-	.get_wireless_stats = lbs_get_wireless_stats,
-};
-
-#ifdef CONFIG_LIBERTAS_MESH
-static const iw_handler mesh_wlan_handler[] = {
-	(iw_handler) NULL,	/* SIOCSIWCOMMIT */
-	(iw_handler) lbs_get_name,	/* SIOCGIWNAME */
-	(iw_handler) NULL,	/* SIOCSIWNWID */
-	(iw_handler) NULL,	/* SIOCGIWNWID */
-	(iw_handler) lbs_mesh_set_freq,	/* SIOCSIWFREQ */
-	(iw_handler) lbs_get_freq,	/* SIOCGIWFREQ */
-	(iw_handler) NULL,		/* SIOCSIWMODE */
-	(iw_handler) mesh_wlan_get_mode,	/* SIOCGIWMODE */
-	(iw_handler) NULL,	/* SIOCSIWSENS */
-	(iw_handler) NULL,	/* SIOCGIWSENS */
-	(iw_handler) NULL,	/* SIOCSIWRANGE */
-	(iw_handler) lbs_get_range,	/* SIOCGIWRANGE */
-	(iw_handler) NULL,	/* SIOCSIWPRIV */
-	(iw_handler) NULL,	/* SIOCGIWPRIV */
-	(iw_handler) NULL,	/* SIOCSIWSTATS */
-	(iw_handler) NULL,	/* SIOCGIWSTATS */
-	iw_handler_set_spy,	/* SIOCSIWSPY */
-	iw_handler_get_spy,	/* SIOCGIWSPY */
-	iw_handler_set_thrspy,	/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,	/* SIOCGIWTHRSPY */
-	(iw_handler) NULL,	/* SIOCSIWAP */
-	(iw_handler) NULL,	/* SIOCGIWAP */
-	(iw_handler) NULL,	/* SIOCSIWMLME */
-	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
-	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
-	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
-	(iw_handler) lbs_mesh_set_essid,/* SIOCSIWESSID */
-	(iw_handler) lbs_mesh_get_essid,/* SIOCGIWESSID */
-	(iw_handler) NULL,		/* SIOCSIWNICKN */
-	(iw_handler) mesh_get_nick,	/* SIOCGIWNICKN */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) lbs_set_rate,	/* SIOCSIWRATE */
-	(iw_handler) lbs_get_rate,	/* SIOCGIWRATE */
-	(iw_handler) lbs_set_rts,	/* SIOCSIWRTS */
-	(iw_handler) lbs_get_rts,	/* SIOCGIWRTS */
-	(iw_handler) lbs_set_frag,	/* SIOCSIWFRAG */
-	(iw_handler) lbs_get_frag,	/* SIOCGIWFRAG */
-	(iw_handler) lbs_set_txpow,	/* SIOCSIWTXPOW */
-	(iw_handler) lbs_get_txpow,	/* SIOCGIWTXPOW */
-	(iw_handler) lbs_set_retry,	/* SIOCSIWRETRY */
-	(iw_handler) lbs_get_retry,	/* SIOCGIWRETRY */
-	(iw_handler) lbs_set_encode,	/* SIOCSIWENCODE */
-	(iw_handler) lbs_get_encode,	/* SIOCGIWENCODE */
-	(iw_handler) lbs_set_power,	/* SIOCSIWPOWER */
-	(iw_handler) lbs_get_power,	/* SIOCGIWPOWER */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) lbs_set_genie,	/* SIOCSIWGENIE */
-	(iw_handler) lbs_get_genie,	/* SIOCGIWGENIE */
-	(iw_handler) lbs_set_auth,	/* SIOCSIWAUTH */
-	(iw_handler) lbs_get_auth,	/* SIOCGIWAUTH */
-	(iw_handler) lbs_set_encodeext,/* SIOCSIWENCODEEXT */
-	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,		/* SIOCSIWPMKSA */
-};
-
-struct iw_handler_def mesh_handler_def = {
-	.num_standard	= ARRAY_SIZE(mesh_wlan_handler),
-	.standard	= (iw_handler *) mesh_wlan_handler,
-	.get_wireless_stats = lbs_get_wireless_stats,
-};
-#endif
diff --git a/drivers/net/wireless/libertas/wext.h b/drivers/net/wireless/libertas/wext.h
deleted file mode 100644
index f3f19fe..0000000
--- a/drivers/net/wireless/libertas/wext.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/**
-  * This file contains definition for IOCTL call.
-  */
-#ifndef	_LBS_WEXT_H_
-#define	_LBS_WEXT_H_
-
-void lbs_send_disconnect_notification(struct lbs_private *priv);
-void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
-
-struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_private *priv,
-	u8 band,
-	u16 channel);
-
-extern struct iw_handler_def lbs_handler_def;
-
-#endif
-- 
1.6.3.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
