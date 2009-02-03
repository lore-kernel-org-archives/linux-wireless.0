Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbZBCUmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:42:49 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:42:48 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 14/17] orinoco: Move hardware functions into separate file
Date: Tue,  3 Feb 2009 20:40:36 +0000
Message-Id: <1233693639-8608-15-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214253_972008_3BEEF306)
In-Reply-To: <1233693639-8608-14-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-6-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-7-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-8-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-9-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-10-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-11-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-12-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-13-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-14-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional change.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile |    2 +-
 drivers/net/wireless/orinoco/hw.c     |  586 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/hw.h     |   47 +++
 drivers/net/wireless/orinoco/main.c   |  583 +--------------------------------
 4 files changed, 635 insertions(+), 583 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/hw.c
 create mode 100644 drivers/net/wireless/orinoco/hw.h

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index fecdbce..f40f54d 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
-orinoco-objs := main.o fw.o mic.o scan.o
+orinoco-objs := main.o fw.o hw.o mic.o scan.o
 
 obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
new file mode 100644
index 0000000..081428d
--- /dev/null
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -0,0 +1,586 @@
+/* Encapsulate basic setting changes and retrieval on Hermes hardware
+ *
+ * See copyright notice in main.c
+ */
+#include <linux/kernel.h>
+#include <linux/if_arp.h>
+#include <linux/ieee80211.h>
+#include <linux/wireless.h>
+
+#include "hermes.h"
+#include "hermes_rid.h"
+#include "orinoco.h"
+
+#include "hw.h"
+
+/********************************************************************/
+/* Data tables                                                      */
+/********************************************************************/
+
+/* This tables gives the actual meanings of the bitrate IDs returned
+ * by the firmware. */
+static const struct {
+	int bitrate; /* in 100s of kilobits */
+	int automatic;
+	u16 agere_txratectrl;
+	u16 intersil_txratectrl;
+} bitrate_table[] = {
+	{110, 1,  3, 15}, /* Entry 0 is the default */
+	{10,  0,  1,  1},
+	{10,  1,  1,  1},
+	{20,  0,  2,  2},
+	{20,  1,  6,  3},
+	{55,  0,  4,  4},
+	{55,  1,  7,  7},
+	{110, 0,  5,  8},
+};
+#define BITRATE_TABLE_SIZE ARRAY_SIZE(bitrate_table)
+
+int orinoco_get_bitratemode(int bitrate, int automatic)
+{
+	int ratemode = -1;
+	int i;
+
+	if ((bitrate != 10) && (bitrate != 20) &&
+	    (bitrate != 55) && (bitrate != 110))
+		return ratemode;
+
+	for (i = 0; i < BITRATE_TABLE_SIZE; i++) {
+		if ((bitrate_table[i].bitrate == bitrate) &&
+		    (bitrate_table[i].automatic == automatic)) {
+			ratemode = i;
+			break;
+		}
+	}
+	return ratemode;
+}
+
+void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic)
+{
+	BUG_ON((ratemode < 0) || (ratemode >= BITRATE_TABLE_SIZE));
+
+	*bitrate = bitrate_table[ratemode].bitrate * 100000;
+	*automatic = bitrate_table[ratemode].automatic;
+}
+
+/* Get tsc from the firmware */
+int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc)
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+	u8 tsc_arr[4][IW_ENCODE_SEQ_MAX_SIZE];
+
+	if ((key < 0) || (key > 4))
+		return -EINVAL;
+
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_TKIP_IV,
+			      sizeof(tsc_arr), NULL, &tsc_arr);
+	if (!err)
+		memcpy(tsc, &tsc_arr[key][0], sizeof(tsc_arr[0]));
+
+	return err;
+}
+
+int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
+{
+	hermes_t *hw = &priv->hw;
+	int ratemode = priv->bitratemode;
+	int err = 0;
+
+	if (ratemode >= BITRATE_TABLE_SIZE) {
+		printk(KERN_ERR "%s: BUG: Invalid bitrate mode %d\n",
+		       priv->ndev->name, ratemode);
+		return -EINVAL;
+	}
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		err = hermes_write_wordrec(hw, USER_BAP,
+				HERMES_RID_CNFTXRATECONTROL,
+				bitrate_table[ratemode].agere_txratectrl);
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+	case FIRMWARE_TYPE_SYMBOL:
+		err = hermes_write_wordrec(hw, USER_BAP,
+				HERMES_RID_CNFTXRATECONTROL,
+				bitrate_table[ratemode].intersil_txratectrl);
+		break;
+	default:
+		BUG();
+	}
+
+	return err;
+}
+
+int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate)
+{
+	hermes_t *hw = &priv->hw;
+	int i;
+	int err = 0;
+	u16 val;
+
+	err = hermes_read_wordrec(hw, USER_BAP,
+				  HERMES_RID_CURRENTTXRATE, &val);
+	if (err)
+		return err;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE: /* Lucent style rate */
+		/* Note : in Lucent firmware, the return value of
+		 * HERMES_RID_CURRENTTXRATE is the bitrate in Mb/s,
+		 * and therefore is totally different from the
+		 * encoding of HERMES_RID_CNFTXRATECONTROL.
+		 * Don't forget that 6Mb/s is really 5.5Mb/s */
+		if (val == 6)
+			*bitrate = 5500000;
+		else
+			*bitrate = val * 1000000;
+		break;
+	case FIRMWARE_TYPE_INTERSIL: /* Intersil style rate */
+	case FIRMWARE_TYPE_SYMBOL: /* Symbol style rate */
+		for (i = 0; i < BITRATE_TABLE_SIZE; i++)
+			if (bitrate_table[i].intersil_txratectrl == val)
+				break;
+
+		if (i >= BITRATE_TABLE_SIZE)
+			printk(KERN_INFO "%s: Unable to determine current bitrate (0x%04hx)\n",
+			       priv->ndev->name, val);
+
+		*bitrate = bitrate_table[i].bitrate * 100000;
+		break;
+	default:
+		BUG();
+	}
+
+	return err;
+}
+
+/* Set fixed AP address */
+int __orinoco_hw_set_wap(struct orinoco_private *priv)
+{
+	int roaming_flag;
+	int err = 0;
+	hermes_t *hw = &priv->hw;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		/* not supported */
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+		if (priv->bssid_fixed)
+			roaming_flag = 2;
+		else
+			roaming_flag = 1;
+
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFROAMINGMODE,
+					   roaming_flag);
+		break;
+	case FIRMWARE_TYPE_SYMBOL:
+		err = HERMES_WRITE_RECORD(hw, USER_BAP,
+					  HERMES_RID_CNFMANDATORYBSSID_SYMBOL,
+					  &priv->desired_bssid);
+		break;
+	}
+	return err;
+}
+
+/* Change the WEP keys and/or the current keys.  Can be called
+ * either from __orinoco_hw_setup_enc() or directly from
+ * orinoco_ioctl_setiwencode().  In the later case the association
+ * with the AP is not broken (if the firmware can handle it),
+ * which is needed for 802.1x implementations. */
+int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		err = HERMES_WRITE_RECORD(hw, USER_BAP,
+					  HERMES_RID_CNFWEPKEYS_AGERE,
+					  &priv->keys);
+		if (err)
+			return err;
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFTXKEY_AGERE,
+					   priv->tx_key);
+		if (err)
+			return err;
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+	case FIRMWARE_TYPE_SYMBOL:
+		{
+			int keylen;
+			int i;
+
+			/* Force uniform key length to work around
+			 * firmware bugs */
+			keylen = le16_to_cpu(priv->keys[priv->tx_key].len);
+
+			if (keylen > LARGE_KEY_SIZE) {
+				printk(KERN_ERR "%s: BUG: Key %d has oversize length %d.\n",
+				       priv->ndev->name, priv->tx_key, keylen);
+				return -E2BIG;
+			}
+
+			/* Write all 4 keys */
+			for (i = 0; i < ORINOCO_MAX_KEYS; i++) {
+				err = hermes_write_ltv(hw, USER_BAP,
+						HERMES_RID_CNFDEFAULTKEY0 + i,
+						HERMES_BYTES_TO_RECLEN(keylen),
+						priv->keys[i].data);
+				if (err)
+					return err;
+			}
+
+			/* Write the index of the key used in transmission */
+			err = hermes_write_wordrec(hw, USER_BAP,
+						HERMES_RID_CNFWEPDEFAULTKEYID,
+						priv->tx_key);
+			if (err)
+				return err;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+int __orinoco_hw_setup_enc(struct orinoco_private *priv)
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+	int master_wep_flag;
+	int auth_flag;
+	int enc_flag;
+
+	/* Setup WEP keys for WEP and WPA */
+	if (priv->encode_alg)
+		__orinoco_hw_setup_wepkeys(priv);
+
+	if (priv->wep_restrict)
+		auth_flag = HERMES_AUTH_SHARED_KEY;
+	else
+		auth_flag = HERMES_AUTH_OPEN;
+
+	if (priv->wpa_enabled)
+		enc_flag = 2;
+	else if (priv->encode_alg == IW_ENCODE_ALG_WEP)
+		enc_flag = 1;
+	else
+		enc_flag = 0;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE: /* Agere style WEP */
+		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
+			/* Enable the shared-key authentication. */
+			err = hermes_write_wordrec(hw, USER_BAP,
+					HERMES_RID_CNFAUTHENTICATION_AGERE,
+					auth_flag);
+		}
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFWEPENABLED_AGERE,
+					   enc_flag);
+		if (err)
+			return err;
+
+		if (priv->has_wpa) {
+			/* Set WPA key management */
+			err = hermes_write_wordrec(hw, USER_BAP,
+				  HERMES_RID_CNFSETWPAAUTHMGMTSUITE_AGERE,
+				  priv->key_mgmt);
+			if (err)
+				return err;
+		}
+
+		break;
+
+	case FIRMWARE_TYPE_INTERSIL: /* Intersil style WEP */
+	case FIRMWARE_TYPE_SYMBOL: /* Symbol style WEP */
+		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
+			if (priv->wep_restrict ||
+			    (priv->firmware_type == FIRMWARE_TYPE_SYMBOL))
+				master_wep_flag = HERMES_WEP_PRIVACY_INVOKED |
+						  HERMES_WEP_EXCL_UNENCRYPTED;
+			else
+				master_wep_flag = HERMES_WEP_PRIVACY_INVOKED;
+
+			err = hermes_write_wordrec(hw, USER_BAP,
+						   HERMES_RID_CNFAUTHENTICATION,
+						   auth_flag);
+			if (err)
+				return err;
+		} else
+			master_wep_flag = 0;
+
+		if (priv->iw_mode == IW_MODE_MONITOR)
+			master_wep_flag |= HERMES_WEP_HOST_DECRYPT;
+
+		/* Master WEP setting : on/off */
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFWEPFLAGS_INTERSIL,
+					   master_wep_flag);
+		if (err)
+			return err;
+
+		break;
+	}
+
+	return 0;
+}
+
+/* key must be 32 bytes, including the tx and rx MIC keys.
+ * rsc must be 8 bytes
+ * tsc must be 8 bytes or NULL
+ */
+int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
+			      u8 *key, u8 *rsc, u8 *tsc)
+{
+	struct {
+		__le16 idx;
+		u8 rsc[IW_ENCODE_SEQ_MAX_SIZE];
+		u8 key[TKIP_KEYLEN];
+		u8 tx_mic[MIC_KEYLEN];
+		u8 rx_mic[MIC_KEYLEN];
+		u8 tsc[IW_ENCODE_SEQ_MAX_SIZE];
+	} __attribute__ ((packed)) buf;
+	int ret;
+	int err;
+	int k;
+	u16 xmitting;
+
+	key_idx &= 0x3;
+
+	if (set_tx)
+		key_idx |= 0x8000;
+
+	buf.idx = cpu_to_le16(key_idx);
+	memcpy(buf.key, key,
+	       sizeof(buf.key) + sizeof(buf.tx_mic) + sizeof(buf.rx_mic));
+
+	if (rsc == NULL)
+		memset(buf.rsc, 0, sizeof(buf.rsc));
+	else
+		memcpy(buf.rsc, rsc, sizeof(buf.rsc));
+
+	if (tsc == NULL) {
+		memset(buf.tsc, 0, sizeof(buf.tsc));
+		buf.tsc[4] = 0x10;
+	} else {
+		memcpy(buf.tsc, tsc, sizeof(buf.tsc));
+	}
+
+	/* Wait upto 100ms for tx queue to empty */
+	k = 100;
+	do {
+		k--;
+		udelay(1000);
+		ret = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_TXQUEUEEMPTY,
+					  &xmitting);
+		if (ret)
+			break;
+	} while ((k > 0) && xmitting);
+
+	if (k == 0)
+		ret = -ETIMEDOUT;
+
+	err = HERMES_WRITE_RECORD(hw, USER_BAP,
+				  HERMES_RID_CNFADDDEFAULTTKIPKEY_AGERE,
+				  &buf);
+
+	return ret ? ret : err;
+}
+
+int orinoco_clear_tkip_key(struct orinoco_private *priv, int key_idx)
+{
+	hermes_t *hw = &priv->hw;
+	int err;
+
+	memset(&priv->tkip_key[key_idx], 0, sizeof(priv->tkip_key[key_idx]));
+	err = hermes_write_wordrec(hw, USER_BAP,
+				   HERMES_RID_CNFREMDEFAULTTKIPKEY_AGERE,
+				   key_idx);
+	if (err)
+		printk(KERN_WARNING "%s: Error %d clearing TKIP key %d\n",
+		       priv->ndev->name, err, key_idx);
+	return err;
+}
+
+int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
+				    struct dev_addr_list *mc_list,
+				    int mc_count, int promisc)
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+
+	if (promisc != priv->promiscuous) {
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFPROMISCUOUSMODE,
+					   promisc);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting PROMISCUOUSMODE to 1.\n",
+			       priv->ndev->name, err);
+		} else
+			priv->promiscuous = promisc;
+	}
+
+	/* If we're not in promiscuous mode, then we need to set the
+	 * group address if either we want to multicast, or if we were
+	 * multicasting and want to stop */
+	if (!promisc && (mc_count || priv->mc_count)) {
+		struct dev_mc_list *p = mc_list;
+		struct hermes_multicast mclist;
+		int i;
+
+		for (i = 0; i < mc_count; i++) {
+			/* paranoia: is list shorter than mc_count? */
+			BUG_ON(!p);
+			/* paranoia: bad address size in list? */
+			BUG_ON(p->dmi_addrlen != ETH_ALEN);
+
+			memcpy(mclist.addr[i], p->dmi_addr, ETH_ALEN);
+			p = p->next;
+		}
+
+		if (p)
+			printk(KERN_WARNING "%s: Multicast list is "
+			       "longer than mc_count\n", priv->ndev->name);
+
+		err = hermes_write_ltv(hw, USER_BAP,
+				   HERMES_RID_CNFGROUPADDRESSES,
+				   HERMES_BYTES_TO_RECLEN(mc_count * ETH_ALEN),
+				   &mclist);
+		if (err)
+			printk(KERN_ERR "%s: Error %d setting multicast list.\n",
+			       priv->ndev->name, err);
+		else
+			priv->mc_count = mc_count;
+	}
+	return err;
+}
+
+/* Return : < 0 -> error code ; >= 0 -> length */
+int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
+			 char buf[IW_ESSID_MAX_SIZE+1])
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+	struct hermes_idstring essidbuf;
+	char *p = (char *)(&essidbuf.val);
+	int len;
+	unsigned long flags;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	if (strlen(priv->desired_essid) > 0) {
+		/* We read the desired SSID from the hardware rather
+		   than from priv->desired_essid, just in case the
+		   firmware is allowed to change it on us. I'm not
+		   sure about this */
+		/* My guess is that the OWNSSID should always be whatever
+		 * we set to the card, whereas CURRENT_SSID is the one that
+		 * may change... - Jean II */
+		u16 rid;
+
+		*active = 1;
+
+		rid = (priv->port_type == 3) ? HERMES_RID_CNFOWNSSID :
+			HERMES_RID_CNFDESIREDSSID;
+
+		err = hermes_read_ltv(hw, USER_BAP, rid, sizeof(essidbuf),
+				      NULL, &essidbuf);
+		if (err)
+			goto fail_unlock;
+	} else {
+		*active = 0;
+
+		err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTSSID,
+				      sizeof(essidbuf), NULL, &essidbuf);
+		if (err)
+			goto fail_unlock;
+	}
+
+	len = le16_to_cpu(essidbuf.len);
+	BUG_ON(len > IW_ESSID_MAX_SIZE);
+
+	memset(buf, 0, IW_ESSID_MAX_SIZE);
+	memcpy(buf, p, len);
+	err = len;
+
+ fail_unlock:
+	orinoco_unlock(priv, &flags);
+
+	return err;
+}
+
+int orinoco_hw_get_freq(struct orinoco_private *priv)
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+	u16 channel;
+	int freq = 0;
+	unsigned long flags;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CURRENTCHANNEL,
+				  &channel);
+	if (err)
+		goto out;
+
+	/* Intersil firmware 1.3.5 returns 0 when the interface is down */
+	if (channel == 0) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if ((channel < 1) || (channel > NUM_CHANNELS)) {
+		printk(KERN_WARNING "%s: Channel out of range (%d)!\n",
+		       priv->ndev->name, channel);
+		err = -EBUSY;
+		goto out;
+
+	}
+	freq = ieee80211_dsss_chan_to_freq(channel);
+
+ out:
+	orinoco_unlock(priv, &flags);
+
+	if (err > 0)
+		err = -EBUSY;
+	return err ? err : freq;
+}
+
+int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
+			       int *numrates, s32 *rates, int max)
+{
+	hermes_t *hw = &priv->hw;
+	struct hermes_idstring list;
+	unsigned char *p = (unsigned char *)&list.val;
+	int err = 0;
+	int num;
+	int i;
+	unsigned long flags;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_SUPPORTEDDATARATES,
+			      sizeof(list), NULL, &list);
+	orinoco_unlock(priv, &flags);
+
+	if (err)
+		return err;
+
+	num = le16_to_cpu(list.len);
+	*numrates = num;
+	num = min(num, max);
+
+	for (i = 0; i < num; i++)
+		rates[i] = (p[i] & 0x7f) * 500000; /* convert to bps */
+
+	return 0;
+}
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
new file mode 100644
index 0000000..dc3f23a
--- /dev/null
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -0,0 +1,47 @@
+/* Encapsulate basic setting changes on Hermes hardware
+ *
+ * See copyright notice in main.c
+ */
+#ifndef _ORINOCO_HW_H_
+#define _ORINOCO_HW_H_
+
+#include <linux/types.h>
+#include <linux/wireless.h>
+
+/* Hardware BAPs */
+#define USER_BAP 0
+#define IRQ_BAP  1
+
+/* WEP key sizes */
+#define SMALL_KEY_SIZE 5
+#define LARGE_KEY_SIZE 13
+
+/* Number of supported channels */
+#define NUM_CHANNELS 14
+
+/* Forward declarations */
+struct orinoco_private;
+struct dev_addr_list;
+
+int orinoco_get_bitratemode(int bitrate, int automatic);
+void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic);
+
+int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc);
+int __orinoco_hw_set_bitrate(struct orinoco_private *priv);
+int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate);
+int __orinoco_hw_set_wap(struct orinoco_private *priv);
+int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv);
+int __orinoco_hw_setup_enc(struct orinoco_private *priv);
+int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
+			      u8 *key, u8 *rsc, u8 *tsc);
+int orinoco_clear_tkip_key(struct orinoco_private *priv, int key_idx);
+int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
+				    struct dev_addr_list *mc_list,
+				    int mc_count, int promisc);
+int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
+			 char buf[IW_ESSID_MAX_SIZE+1]);
+int orinoco_hw_get_freq(struct orinoco_private *priv);
+int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
+			       int *numrates, s32 *rates, int max);
+
+#endif /* _ORINOCO_HW_H_ */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 442df51..8c79485 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -91,6 +91,7 @@
 
 #include "hermes_rid.h"
 #include "hermes_dld.h"
+#include "hw.h"
 #include "scan.h"
 #include "mic.h"
 #include "fw.h"
@@ -151,15 +152,11 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 #define ORINOCO_MAX_MTU		(IEEE80211_MAX_DATA_LEN - ENCAPS_OVERHEAD)
 
 #define SYMBOL_MAX_VER_LEN	(14)
-#define USER_BAP		0
-#define IRQ_BAP			1
 #define MAX_IRQLOOPS_PER_IRQ	10
 #define MAX_IRQLOOPS_PER_JIFFY	(20000/HZ) /* Based on a guestimate of
 					    * how many events the
 					    * device could
 					    * legitimately generate */
-#define SMALL_KEY_SIZE		5
-#define LARGE_KEY_SIZE		13
 #define TX_NICBUF_SIZE_BUG	1585		/* Bug in Symbol firmware */
 
 #define DUMMY_FID		0xFFFF
@@ -179,31 +176,6 @@ static const struct iw_handler_def orinoco_handler_def;
 static const struct ethtool_ops orinoco_ethtool_ops;
 
 /********************************************************************/
-/* Data tables                                                      */
-/********************************************************************/
-
-#define NUM_CHANNELS 14
-
-/* This tables gives the actual meanings of the bitrate IDs returned
- * by the firmware. */
-static struct {
-	int bitrate; /* in 100s of kilobits */
-	int automatic;
-	u16 agere_txratectrl;
-	u16 intersil_txratectrl;
-} bitrate_table[] = {
-	{110, 1,  3, 15}, /* Entry 0 is the default */
-	{10,  0,  1,  1},
-	{10,  1,  1,  1},
-	{20,  0,  2,  2},
-	{20,  1,  6,  3},
-	{55,  0,  4,  4},
-	{55,  1,  7,  7},
-	{110, 0,  5,  8},
-};
-#define BITRATE_TABLE_SIZE ARRAY_SIZE(bitrate_table)
-
-/********************************************************************/
 /* Data types                                                       */
 /********************************************************************/
 
@@ -282,33 +254,6 @@ static inline void set_port_type(struct orinoco_private *priv)
 	}
 }
 
-static int orinoco_get_bitratemode(int bitrate, int automatic)
-{
-	int ratemode = -1;
-	int i;
-
-	if ((bitrate != 10) && (bitrate != 20) &&
-	    (bitrate != 55) && (bitrate != 110))
-		return ratemode;
-
-	for (i = 0; i < BITRATE_TABLE_SIZE; i++) {
-		if ((bitrate_table[i].bitrate == bitrate) &&
-		    (bitrate_table[i].automatic == automatic)) {
-			ratemode = i;
-			break;
-		}
-	}
-	return ratemode;
-}
-
-static void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic)
-{
-	BUG_ON((ratemode < 0) || (ratemode >= BITRATE_TABLE_SIZE));
-
-	*bitrate = bitrate_table[ratemode].bitrate * 100000;
-	*automatic = bitrate_table[ratemode].automatic;
-}
-
 static inline u8 *orinoco_get_ie(u8 *data, size_t len,
 				 enum ieee80211_eid eid)
 {
@@ -933,25 +878,6 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	stats->rx_dropped++;
 }
 
-/* Get tsc from the firmware */
-static int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key,
-				  u8 *tsc)
-{
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-	u8 tsc_arr[4][IW_ENCODE_SEQ_MAX_SIZE];
-
-	if ((key < 0) || (key > 4))
-		return -EINVAL;
-
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_TKIP_IV,
-			      sizeof(tsc_arr), NULL, &tsc_arr);
-	if (!err)
-		memcpy(tsc, &tsc_arr[key][0], sizeof(tsc_arr[0]));
-
-	return err;
-}
-
 static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -1790,334 +1716,6 @@ int orinoco_reinit_firmware(struct net_device *dev)
 }
 EXPORT_SYMBOL(orinoco_reinit_firmware);
 
-static int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
-{
-	hermes_t *hw = &priv->hw;
-	int ratemode = priv->bitratemode;
-	int err = 0;
-
-	if (ratemode >= BITRATE_TABLE_SIZE) {
-		printk(KERN_ERR "%s: BUG: Invalid bitrate mode %d\n",
-		       priv->ndev->name, ratemode);
-		return -EINVAL;
-	}
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE:
-		err = hermes_write_wordrec(hw, USER_BAP,
-				HERMES_RID_CNFTXRATECONTROL,
-				bitrate_table[ratemode].agere_txratectrl);
-		break;
-	case FIRMWARE_TYPE_INTERSIL:
-	case FIRMWARE_TYPE_SYMBOL:
-		err = hermes_write_wordrec(hw, USER_BAP,
-				HERMES_RID_CNFTXRATECONTROL,
-				bitrate_table[ratemode].intersil_txratectrl);
-		break;
-	default:
-		BUG();
-	}
-
-	return err;
-}
-
-static int orinoco_hw_get_act_bitrate(struct orinoco_private *priv,
-				      int *bitrate)
-{
-	hermes_t *hw = &priv->hw;
-	int i;
-	int err = 0;
-	u16 val;
-
-	err = hermes_read_wordrec(hw, USER_BAP,
-				  HERMES_RID_CURRENTTXRATE, &val);
-	if (err)
-		return err;
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE: /* Lucent style rate */
-		/* Note : in Lucent firmware, the return value of
-		 * HERMES_RID_CURRENTTXRATE is the bitrate in Mb/s,
-		 * and therefore is totally different from the
-		 * encoding of HERMES_RID_CNFTXRATECONTROL.
-		 * Don't forget that 6Mb/s is really 5.5Mb/s */
-		if (val == 6)
-			*bitrate = 5500000;
-		else
-			*bitrate = val * 1000000;
-		break;
-	case FIRMWARE_TYPE_INTERSIL: /* Intersil style rate */
-	case FIRMWARE_TYPE_SYMBOL: /* Symbol style rate */
-		for (i = 0; i < BITRATE_TABLE_SIZE; i++)
-			if (bitrate_table[i].intersil_txratectrl == val)
-				break;
-
-		if (i >= BITRATE_TABLE_SIZE)
-			printk(KERN_INFO "%s: Unable to determine current bitrate (0x%04hx)\n",
-			       priv->ndev->name, val);
-
-		*bitrate = bitrate_table[i].bitrate * 100000;
-		break;
-	default:
-		BUG();
-	}
-
-	return err;
-}
-
-/* Set fixed AP address */
-static int __orinoco_hw_set_wap(struct orinoco_private *priv)
-{
-	int roaming_flag;
-	int err = 0;
-	hermes_t *hw = &priv->hw;
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE:
-		/* not supported */
-		break;
-	case FIRMWARE_TYPE_INTERSIL:
-		if (priv->bssid_fixed)
-			roaming_flag = 2;
-		else
-			roaming_flag = 1;
-
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFROAMINGMODE,
-					   roaming_flag);
-		break;
-	case FIRMWARE_TYPE_SYMBOL:
-		err = HERMES_WRITE_RECORD(hw, USER_BAP,
-					  HERMES_RID_CNFMANDATORYBSSID_SYMBOL,
-					  &priv->desired_bssid);
-		break;
-	}
-	return err;
-}
-
-/* Change the WEP keys and/or the current keys.  Can be called
- * either from __orinoco_hw_setup_enc() or directly from
- * orinoco_ioctl_setiwencode().  In the later case the association
- * with the AP is not broken (if the firmware can handle it),
- * which is needed for 802.1x implementations. */
-static int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
-{
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE:
-		err = HERMES_WRITE_RECORD(hw, USER_BAP,
-					  HERMES_RID_CNFWEPKEYS_AGERE,
-					  &priv->keys);
-		if (err)
-			return err;
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFTXKEY_AGERE,
-					   priv->tx_key);
-		if (err)
-			return err;
-		break;
-	case FIRMWARE_TYPE_INTERSIL:
-	case FIRMWARE_TYPE_SYMBOL:
-		{
-			int keylen;
-			int i;
-
-			/* Force uniform key length to work around
-			 * firmware bugs */
-			keylen = le16_to_cpu(priv->keys[priv->tx_key].len);
-
-			if (keylen > LARGE_KEY_SIZE) {
-				printk(KERN_ERR "%s: BUG: Key %d has oversize length %d.\n",
-				       priv->ndev->name, priv->tx_key, keylen);
-				return -E2BIG;
-			}
-
-			/* Write all 4 keys */
-			for (i = 0; i < ORINOCO_MAX_KEYS; i++) {
-				err = hermes_write_ltv(hw, USER_BAP,
-						HERMES_RID_CNFDEFAULTKEY0 + i,
-						HERMES_BYTES_TO_RECLEN(keylen),
-						priv->keys[i].data);
-				if (err)
-					return err;
-			}
-
-			/* Write the index of the key used in transmission */
-			err = hermes_write_wordrec(hw, USER_BAP,
-						HERMES_RID_CNFWEPDEFAULTKEYID,
-						priv->tx_key);
-			if (err)
-				return err;
-		}
-		break;
-	}
-
-	return 0;
-}
-
-static int __orinoco_hw_setup_enc(struct orinoco_private *priv)
-{
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-	int master_wep_flag;
-	int auth_flag;
-	int enc_flag;
-
-	/* Setup WEP keys for WEP and WPA */
-	if (priv->encode_alg)
-		__orinoco_hw_setup_wepkeys(priv);
-
-	if (priv->wep_restrict)
-		auth_flag = HERMES_AUTH_SHARED_KEY;
-	else
-		auth_flag = HERMES_AUTH_OPEN;
-
-	if (priv->wpa_enabled)
-		enc_flag = 2;
-	else if (priv->encode_alg == IW_ENCODE_ALG_WEP)
-		enc_flag = 1;
-	else
-		enc_flag = 0;
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE: /* Agere style WEP */
-		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
-			/* Enable the shared-key authentication. */
-			err = hermes_write_wordrec(hw, USER_BAP,
-					HERMES_RID_CNFAUTHENTICATION_AGERE,
-					auth_flag);
-		}
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFWEPENABLED_AGERE,
-					   enc_flag);
-		if (err)
-			return err;
-
-		if (priv->has_wpa) {
-			/* Set WPA key management */
-			err = hermes_write_wordrec(hw, USER_BAP,
-				  HERMES_RID_CNFSETWPAAUTHMGMTSUITE_AGERE,
-				  priv->key_mgmt);
-			if (err)
-				return err;
-		}
-
-		break;
-
-	case FIRMWARE_TYPE_INTERSIL: /* Intersil style WEP */
-	case FIRMWARE_TYPE_SYMBOL: /* Symbol style WEP */
-		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
-			if (priv->wep_restrict ||
-			    (priv->firmware_type == FIRMWARE_TYPE_SYMBOL))
-				master_wep_flag = HERMES_WEP_PRIVACY_INVOKED |
-						  HERMES_WEP_EXCL_UNENCRYPTED;
-			else
-				master_wep_flag = HERMES_WEP_PRIVACY_INVOKED;
-
-			err = hermes_write_wordrec(hw, USER_BAP,
-						   HERMES_RID_CNFAUTHENTICATION,
-						   auth_flag);
-			if (err)
-				return err;
-		} else
-			master_wep_flag = 0;
-
-		if (priv->iw_mode == IW_MODE_MONITOR)
-			master_wep_flag |= HERMES_WEP_HOST_DECRYPT;
-
-		/* Master WEP setting : on/off */
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFWEPFLAGS_INTERSIL,
-					   master_wep_flag);
-		if (err)
-			return err;
-
-		break;
-	}
-
-	return 0;
-}
-
-/* key must be 32 bytes, including the tx and rx MIC keys.
- * rsc must be 8 bytes
- * tsc must be 8 bytes or NULL
- */
-static int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
-				     u8 *key, u8 *rsc, u8 *tsc)
-{
-	struct {
-		__le16 idx;
-		u8 rsc[IW_ENCODE_SEQ_MAX_SIZE];
-		u8 key[TKIP_KEYLEN];
-		u8 tx_mic[MIC_KEYLEN];
-		u8 rx_mic[MIC_KEYLEN];
-		u8 tsc[IW_ENCODE_SEQ_MAX_SIZE];
-	} __attribute__ ((packed)) buf;
-	int ret;
-	int err;
-	int k;
-	u16 xmitting;
-
-	key_idx &= 0x3;
-
-	if (set_tx)
-		key_idx |= 0x8000;
-
-	buf.idx = cpu_to_le16(key_idx);
-	memcpy(buf.key, key,
-	       sizeof(buf.key) + sizeof(buf.tx_mic) + sizeof(buf.rx_mic));
-
-	if (rsc == NULL)
-		memset(buf.rsc, 0, sizeof(buf.rsc));
-	else
-		memcpy(buf.rsc, rsc, sizeof(buf.rsc));
-
-	if (tsc == NULL) {
-		memset(buf.tsc, 0, sizeof(buf.tsc));
-		buf.tsc[4] = 0x10;
-	} else {
-		memcpy(buf.tsc, tsc, sizeof(buf.tsc));
-	}
-
-	/* Wait upto 100ms for tx queue to empty */
-	k = 100;
-	do {
-		k--;
-		udelay(1000);
-		ret = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_TXQUEUEEMPTY,
-					  &xmitting);
-		if (ret)
-			break;
-	} while ((k > 0) && xmitting);
-
-	if (k == 0)
-		ret = -ETIMEDOUT;
-
-	err = HERMES_WRITE_RECORD(hw, USER_BAP,
-				  HERMES_RID_CNFADDDEFAULTTKIPKEY_AGERE,
-				  &buf);
-
-	return ret ? ret : err;
-}
-
-static int orinoco_clear_tkip_key(struct orinoco_private *priv,
-				  int key_idx)
-{
-	hermes_t *hw = &priv->hw;
-	int err;
-
-	memset(&priv->tkip_key[key_idx], 0, sizeof(priv->tkip_key[key_idx]));
-	err = hermes_write_wordrec(hw, USER_BAP,
-				   HERMES_RID_CNFREMDEFAULTTKIPKEY_AGERE,
-				   key_idx);
-	if (err)
-		printk(KERN_WARNING "%s: Error %d clearing TKIP key %d\n",
-		       priv->ndev->name, err, key_idx);
-	return err;
-}
-
 static int __orinoco_program_rids(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -2347,59 +1945,6 @@ static int __orinoco_program_rids(struct net_device *dev)
 	return 0;
 }
 
-static int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
-					   struct dev_addr_list *mc_list,
-					   int mc_count, int promisc)
-{
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-
-	if (promisc != priv->promiscuous) {
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFPROMISCUOUSMODE,
-					   promisc);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting PROMISCUOUSMODE to 1.\n",
-			       priv->ndev->name, err);
-		} else
-			priv->promiscuous = promisc;
-	}
-
-	/* If we're not in promiscuous mode, then we need to set the
-	 * group address if either we want to multicast, or if we were
-	 * multicasting and want to stop */
-	if (!promisc && (mc_count || priv->mc_count)) {
-		struct dev_mc_list *p = mc_list;
-		struct hermes_multicast mclist;
-		int i;
-
-		for (i = 0; i < mc_count; i++) {
-			/* paranoia: is list shorter than mc_count? */
-			BUG_ON(!p);
-			/* paranoia: bad address size in list? */
-			BUG_ON(p->dmi_addrlen != ETH_ALEN);
-
-			memcpy(mclist.addr[i], p->dmi_addr, ETH_ALEN);
-			p = p->next;
-		}
-
-		if (p)
-			printk(KERN_WARNING "%s: Multicast list is "
-			       "longer than mc_count\n", priv->ndev->name);
-
-		err = hermes_write_ltv(hw, USER_BAP,
-				   HERMES_RID_CNFGROUPADDRESSES,
-				   HERMES_BYTES_TO_RECLEN(mc_count * ETH_ALEN),
-				   &mclist);
-		if (err)
-			printk(KERN_ERR "%s: Error %d setting multicast list.\n",
-			       priv->ndev->name, err);
-		else
-			priv->mc_count = mc_count;
-	}
-	return err;
-}
-
 /* FIXME: return int? */
 static void
 __orinoco_set_multicast_list(struct net_device *dev)
@@ -3170,132 +2715,6 @@ EXPORT_SYMBOL(free_orinocodev);
 /* Wireless extensions                                              */
 /********************************************************************/
 
-/* Return : < 0 -> error code ; >= 0 -> length */
-static int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
-				char buf[IW_ESSID_MAX_SIZE+1])
-{
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-	struct hermes_idstring essidbuf;
-	char *p = (char *)(&essidbuf.val);
-	int len;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	if (strlen(priv->desired_essid) > 0) {
-		/* We read the desired SSID from the hardware rather
-		   than from priv->desired_essid, just in case the
-		   firmware is allowed to change it on us. I'm not
-		   sure about this */
-		/* My guess is that the OWNSSID should always be whatever
-		 * we set to the card, whereas CURRENT_SSID is the one that
-		 * may change... - Jean II */
-		u16 rid;
-
-		*active = 1;
-
-		rid = (priv->port_type == 3) ? HERMES_RID_CNFOWNSSID :
-			HERMES_RID_CNFDESIREDSSID;
-
-		err = hermes_read_ltv(hw, USER_BAP, rid, sizeof(essidbuf),
-				      NULL, &essidbuf);
-		if (err)
-			goto fail_unlock;
-	} else {
-		*active = 0;
-
-		err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTSSID,
-				      sizeof(essidbuf), NULL, &essidbuf);
-		if (err)
-			goto fail_unlock;
-	}
-
-	len = le16_to_cpu(essidbuf.len);
-	BUG_ON(len > IW_ESSID_MAX_SIZE);
-
-	memset(buf, 0, IW_ESSID_MAX_SIZE);
-	memcpy(buf, p, len);
-	err = len;
-
- fail_unlock:
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_hw_get_freq(struct orinoco_private *priv)
-{
-
-	hermes_t *hw = &priv->hw;
-	int err = 0;
-	u16 channel;
-	int freq = 0;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CURRENTCHANNEL,
-				  &channel);
-	if (err)
-		goto out;
-
-	/* Intersil firmware 1.3.5 returns 0 when the interface is down */
-	if (channel == 0) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	if ((channel < 1) || (channel > NUM_CHANNELS)) {
-		printk(KERN_WARNING "%s: Channel out of range (%d)!\n",
-		       priv->ndev->name, channel);
-		err = -EBUSY;
-		goto out;
-
-	}
-	freq = ieee80211_dsss_chan_to_freq(channel);
-
- out:
-	orinoco_unlock(priv, &flags);
-
-	if (err > 0)
-		err = -EBUSY;
-	return err ? err : freq;
-}
-
-static int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
-				      int *numrates, s32 *rates, int max)
-{
-	hermes_t *hw = &priv->hw;
-	struct hermes_idstring list;
-	unsigned char *p = (unsigned char *)&list.val;
-	int err = 0;
-	int num;
-	int i;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_SUPPORTEDDATARATES,
-			      sizeof(list), NULL, &list);
-	orinoco_unlock(priv, &flags);
-
-	if (err)
-		return err;
-
-	num = le16_to_cpu(list.len);
-	*numrates = num;
-	num = min(num, max);
-
-	for (i = 0; i < num; i++)
-		rates[i] = (p[i] & 0x7f) * 500000; /* convert to bps */
-
-	return 0;
-}
-
 static int orinoco_ioctl_getname(struct net_device *dev,
 				 struct iw_request_info *info,
 				 char *name,
-- 
1.6.0.6

