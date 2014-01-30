Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:22315 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaA3P7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 10:59:39 -0500
Message-ID: <52EA763D.4030103@redpinesignals.com> (sfid-20140130_165942_034721_23A0163B)
Date: Thu, 30 Jan 2014 21:26:45 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.13.1 9/9] rsi: mac80211 callbacks to driver
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This patch has the callbacks from mac80211 to the driver.

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

rsi_91x_mac80211.c |  912 +++++++++++++++++++++++++++++++++++++++++++++++++++++
1 file changed, 912 insertions(+)

diff -uprN a/drivers/net/wireless/rsi/91x/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/91x/rsi_91x_mac80211.c
--- a/drivers/net/wireless/rsi/91x/rsi_91x_mac80211.c	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/91x/rsi_91x_mac80211.c	2014-01-30 16:27:12.989672065 +0530
@@ -0,0 +1,912 @@
+/**
+ * @file rsi_91x_mac80211.c
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * @section DESCRIPTION
+ *
+ * This file contains the definition of the callbacks to the driver from the
+ * mac80211 layer.
+ */
+
+#include "../include/rsi_main.h"
+#include "../include/rsi_device_ops.h"
+#include "../include/rsi_mac80211.h"
+
+/**
+ * This function determines if the ptk cipher is WEP or not.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return If cipher type is WEP, a value of 1 is returned, else 0.
+ */
+
+bool rsi_is_cipher_wep(struct rsi_common *common)
+{
+	if (((common->secinfo.gtk_cipher == WLAN_CIPHER_SUITE_WEP104) ||
+	     (common->secinfo.gtk_cipher == WLAN_CIPHER_SUITE_WEP40)) &&
+	    (!common->secinfo.ptk_cipher))
+		return true;
+	else
+		return false;
+}
+
+/**
+ * This function initializes the channels and rates.
+ *
+ * @param  adapter Pointer to the adapter structure.
+ * @param  band Operating band to be set.
+ * @return None.
+ */
+static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
+{
+	void *channels = NULL;
+	struct ieee80211_supported_band *sbands = &adapter->sbands[band];
+
+	if (band == IEEE80211_BAND_2GHZ) {
+		channels = kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);
+		memcpy(channels,
+		       rsi_2ghz_channels,
+		       sizeof(rsi_2ghz_channels));
+		sbands->band = IEEE80211_BAND_2GHZ;
+		sbands->n_channels = ARRAY_SIZE(rsi_2ghz_channels);
+		sbands->bitrates = rsi_rates;
+		sbands->n_bitrates = ARRAY_SIZE(rsi_rates);
+	} else {
+		channels = kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL);
+		memcpy(channels,
+		       rsi_5ghz_channels,
+		       sizeof(rsi_5ghz_channels));
+		sbands->band = IEEE80211_BAND_5GHZ;
+		sbands->n_channels = ARRAY_SIZE(rsi_5ghz_channels);
+		sbands->bitrates = &rsi_rates[4];
+		sbands->n_bitrates = ARRAY_SIZE(rsi_rates) - 4;
+	}
+
+	sbands->channels = channels;
+
+	memset(&sbands->ht_cap, 0, sizeof(struct ieee80211_sta_ht_cap));
+	sbands->ht_cap.ht_supported = true;
+	sbands->ht_cap.cap = (IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+			      IEEE80211_HT_CAP_SGI_20 |
+			      IEEE80211_HT_CAP_SGI_40);
+	sbands->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
+	sbands->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
+	sbands->ht_cap.mcs.rx_mask[0] = 0xff;
+	sbands->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	/* sbands->ht_cap.mcs.rx_highest = 0x82; */
+}
+
+/**
+ * This function is used to de-initialize Mac80211 stack.
+ *
+ * @param  adapter Pointer to the adapter structure.
+ * @return None.
+ */
+void rsi_mac80211_detach(struct rsi_hw *adapter)
+{
+	struct ieee80211_hw *hw = adapter->hw;
+
+	if (hw) {
+		ieee80211_stop_queues(hw);
+		ieee80211_unregister_hw(hw);
+		ieee80211_free_hw(hw);
+	}
+	return;
+}
+
+/**
+ * This function indicates the transmit status.
+ *
+ * @param  adapter Pointer to the adapter structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @param  status Status
+ * @return None.
+ */
+void rsi_indicate_tx_status(struct rsi_hw *adapter,
+			    struct sk_buff *skb,
+			    int status)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	memset(info->driver_data, 0, IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
+
+	if (!status)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
+	ieee80211_tx_status_irqsafe(adapter->hw, skb);
+}
+
+/**
+ * This is the handler that 802.11 module calls for each transmitted frame.
+ * And skb contains the buffer starting from the IEEE 802.11 header.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  control Pointer to the ieee80211_tx_control structure
+ *         (for kernel version>=3.8.0).
+ * @param  skb Pointer to the socket buffer structure.
+ * @return None/0 on success (for kernel version <= 2.6.38).
+ */
+static void rsi_mac80211_tx(struct ieee80211_hw *hw,
+			    struct ieee80211_tx_control *control,
+			    struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	common->common_ops->core_xmit(common, skb);
+
+	return;
+}
+
+/**
+ * This is first handler that 802.11 module calls, since we complete the driver
+ * init by then, just returns success.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @return 0 as success.
+ */
+static int rsi_mac80211_start(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	common->iface_down = false;
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+/**
+ * This is the last handler that 802.11 modules calls.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @return None.
+ */
+static void rsi_mac80211_stop(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	common->iface_down = true;
+	mutex_unlock(&common->mutex);
+
+	return;
+}
+
+/**
+ * This function is called when a netdevice attached to the hardware is enabled.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @return ret: 0 on success, negative error code on failure.
+ */
+static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	int ret = -EOPNOTSUPP;
+
+	mutex_lock(&common->mutex);
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		if (!adapter->sc_nvifs) {
+			++adapter->sc_nvifs;
+			adapter->vifs[0] = vif;
+			ret = rsi_set_vap_capabilities(common, 1);
+		}
+		break;
+	default:
+		rsi_dbg(ERR_ZONE,
+			"%s: Interface type %d not supported\n", __func__,
+			vif->type);
+	}
+	mutex_unlock(&common->mutex);
+
+	return ret;
+}
+
+/**
+ * This function notifies driver that an interface is going down.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @return None.
+ */
+static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	if (vif->type == NL80211_IFTYPE_STATION)
+		adapter->sc_nvifs--;
+
+	if (!memcmp(adapter->vifs[0], vif, sizeof(struct ieee80211_vif)))
+		adapter->vifs[0] = NULL;
+	mutex_unlock(&common->mutex);
+
+	return;
+}
+
+/**
+ * This function is a handler for configuration requests. IEEE 802.11 code calls
+ * this function to change hardware configuration, e.g., channel.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  changed Changed flags set.
+ * @return 0 on success, negative error code on failure.
+ */
+static int rsi_mac80211_config(struct ieee80211_hw *hw,
+			       unsigned int changed)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	int status = -EOPNOTSUPP;
+
+	mutex_lock(&common->mutex);
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+		unsigned short channel = curchan->hw_value;
+
+		rsi_dbg(INFO_ZONE,
+			"%s: Set channel: %d MHz type: %d channel_no %d\n",
+			__func__, curchan->center_freq,
+			curchan->flags, channel);
+		common->band = curchan->band;
+		status = rsi_set_channel(adapter->priv, channel);
+	}
+	mutex_unlock(&common->mutex);
+
+	return status;
+}
+
+/**
+ * This function is used to get the current connected channel number.
+ *
+ * @param  adapter Pointer to the struct rsi_hw
+ * @return Current connected AP's channel number is returned.
+ */
+unsigned short rsi_get_connected_channel(struct rsi_hw *adapter)
+{
+	struct ieee80211_vif *vif = adapter->vifs[0];
+	if (vif) {
+		struct ieee80211_bss_conf *bss = &vif->bss_conf;
+		struct ieee80211_channel *channel = bss->chandef.chan;
+	return channel->hw_value;
+	} else {
+		return 0;
+	}
+}
+
+/**
+ * This function is a handler for configuration requests related to BSS
+ * parameters that may vary during BSS's lifespan.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @param  bss_conf Pointer to the ieee80211_bss_conf structure.
+ * @param  changed Changed flags set.
+ * @return None.
+ */
+static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_bss_conf *bss_conf,
+					  unsigned int changed)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	if (changed & BSS_CHANGED_ASSOC) {
+		rsi_dbg(INFO_ZONE,
+			"%s: Changed Association status: %d\n",
+			__func__, bss_conf->assoc);
+		rsi_inform_bss_status(common,
+				      bss_conf->assoc,
+				      bss_conf->bssid,
+				      bss_conf->qos,
+				      bss_conf->aid);
+	}
+	mutex_unlock(&common->mutex);
+
+	return;
+}
+
+/**
+ * This function configure the device's RX filter.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  changed Changed flags set.
+ * @param  total_flags Total initial flags set.
+ * @param  multicast Multicast.
+ * @return None.
+ */
+static void rsi_mac80211_conf_filter(struct ieee80211_hw *hw,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     u64 multicast)
+{
+	*total_flags &= FIF_FCSFAIL;
+	changed_flags &= FIF_FCSFAIL;
+
+	return;
+}
+
+/**
+ * This function configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
+ * bursting) for a hardware TX queue.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure
+ * @param  vif Pointer to the ieee80211_vif structure (for kernel version >= 3.2.0).
+ * @param  queue Queue number.
+ * @param  params Pointer to ieee80211_tx_queue_params structure.
+ * @return 0 on success, negative error code on failure.
+ */
+static int rsi_mac80211_conf_tx(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				unsigned short queue,
+				const struct ieee80211_tx_queue_params *params)
+{
+	unsigned char idx = 0;
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	if (queue >= IEEE80211_NUM_ACS)
+		return 0;
+
+	rsi_dbg(INFO_ZONE,
+		"%s: Configure tx queue %d, aifs: %d, cw_min: %d, "
+		"cw_max: %d, txop: %d\n",
+		__func__, queue, params->aifs,
+		params->cw_min, params->cw_max, params->txop);
+
+	mutex_lock(&common->mutex);
+	/* Map into the way the f/w expects */
+	switch (queue) {
+	case IEEE80211_AC_VO:
+		idx = VO_Q;
+		break;
+	case IEEE80211_AC_VI:
+		idx = VI_Q;
+		break;
+	case IEEE80211_AC_BE:
+		idx = BE_Q;
+		break;
+	case IEEE80211_AC_BK:
+		idx = BK_Q;
+		break;
+	default:
+		idx = BE_Q;
+		break;
+	}
+
+	memcpy(&common->edca_params[queue],
+	       params,
+	       sizeof(struct ieee80211_tx_queue_params));
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+/**
+ * This function load the keys into the firmware.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @param  key Pointer to the ieee80211_key_conf structure.
+ * @return status: 0 on success, -1 on failure.
+ */
+static int rsi_hal_key_config(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_key_conf *key)
+{
+	struct rsi_hw *adapter = hw->priv;
+	unsigned char key_type;
+	int status;
+
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		key_type = RSI_PAIRWISE_KEY;
+	else
+		key_type = RSI_GROUP_KEY;
+
+	rsi_dbg(ERR_ZONE, "%s: Cipher 0x%x key_type: %d key_len: %d\n",
+		__func__, key->cipher, key_type, key->keylen);
+
+	if ((key->cipher == WLAN_CIPHER_SUITE_WEP104) ||
+	    (key->cipher == WLAN_CIPHER_SUITE_WEP40)) {
+		status = rsi_hal_load_key(adapter->priv,
+					  key->key,
+					  key->keylen,
+					  RSI_PAIRWISE_KEY,
+					  key->keyidx,
+					  key->cipher);
+	}
+	return rsi_hal_load_key(adapter->priv,
+				key->key,
+				key->keylen,
+				key_type,
+				key->keyidx,
+				key->cipher);
+}
+
+/**
+ * This function sets type of key to be loaded.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  cmd enum set_key_cmd.
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @param  sta Pointer to the ieee80211_sta structure.
+ * @param  key Pointer to the ieee80211_key_conf structure.
+ * @return status: 0 on success, negative error code on failure.
+ */
+static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
+				enum set_key_cmd cmd,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct ieee80211_key_conf *key)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct security_info *secinfo = &common->secinfo;
+	int status = 0;
+
+	mutex_lock(&common->mutex);
+	switch (cmd) {
+	case SET_KEY:
+		secinfo->security_enable = true;
+		status = rsi_hal_key_config(hw, vif, key);
+		if (status) {
+			mutex_unlock(&common->mutex);
+			return -EINVAL;
+		}
+
+		if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+			secinfo->ptk_cipher = key->cipher;
+		else
+			secinfo->gtk_cipher = key->cipher;
+
+		key->hw_key_idx = key->keyidx;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+
+		rsi_dbg(ERR_ZONE, "%s: RSI set_key\n", __func__);
+		break;
+
+	case DISABLE_KEY:
+		secinfo->security_enable = false;
+		rsi_dbg(ERR_ZONE, "%s: RSI del key\n", __func__);
+		memset(key, 0, sizeof(struct ieee80211_key_conf));
+		status = rsi_hal_key_config(hw, vif, key);
+		break;
+
+	default:
+		status = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&common->mutex);
+	return status;
+}
+
+/**
+ * This function is to select corresponding AMPDU action for corresponding
+ * mlme_action flag.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @param  action ieee80211_ampdu_mlme_action enum.
+ * @param  sta Pointer to the ieee80211_sta structure.
+ * @param  tid Traffic identifier.
+ * @param  ssn Pointer to ssn value.
+ * @param  buf_size Buffer size (for kernel version > 2.6.38).
+ * @return status: 0 on success, negative error code on failure.
+ */
+static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     enum ieee80211_ampdu_mlme_action action,
+				     struct ieee80211_sta *sta,
+				     unsigned short tid,
+				     unsigned short *ssn,
+				     unsigned char buf_size)
+{
+	int status = 0;
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	static unsigned short seq_start;
+	static unsigned short seq_no;
+
+	mutex_lock(&common->mutex);
+	rsi_dbg(INFO_ZONE, "%s: AMPDU action %d called\n", __func__, action);
+	if (ssn != NULL)
+		seq_no = *ssn;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		status = rsi_send_ampdu_indication_frame(common,
+							 tid,
+							 seq_no,
+							 buf_size,
+							 STA_RX_ADDBA_DONE);
+		break;
+
+	case IEEE80211_AMPDU_RX_STOP:
+		status = rsi_send_ampdu_indication_frame(common,
+							 tid,
+							 0,
+							 buf_size,
+							 STA_RX_DELBA);
+		break;
+
+	case IEEE80211_AMPDU_TX_START:
+		seq_start = seq_no;
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		status = rsi_send_ampdu_indication_frame(common,
+							 tid,
+							 seq_no,
+							 buf_size,
+							 STA_TX_DELBA);
+		if (!status)
+			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		status = rsi_send_ampdu_indication_frame(common,
+							 tid,
+							 seq_start,
+							 buf_size,
+							 STA_TX_ADDBA_DONE);
+		break;
+
+	default:
+		rsi_dbg(ERR_ZONE, "%s: Uknown AMPDU action\n", __func__);
+		break;
+	}
+
+	mutex_unlock(&common->mutex);
+	return status;
+}
+
+/**
+ * This function sets the rts threshold value.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  value Rts threshold value.
+ * @return 0 on success.
+ */
+static int rsi_mac80211_set_rts_threshold(struct ieee80211_hw *hw,
+					  unsigned int value)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	common->rts_threshold = value;
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+/**
+ * This function sets the bitrate_mask to be used.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure
+ * @param  vif Pointer to the ieee80211_vif structure.
+ * @param  mask Pointer to the cfg80211_bitrate_mask structure.
+ * @return 0 on success.
+ */
+static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      const struct cfg80211_bitrate_mask *mask)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+
+	common->fixedrate_mask[IEEE80211_BAND_2GHZ] = 0;
+
+	if (mask->control[IEEE80211_BAND_2GHZ].legacy == 0xfff) {
+		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
+			(mask->control[IEEE80211_BAND_2GHZ].mcs[0] << 12);
+	} else {
+		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
+			mask->control[IEEE80211_BAND_2GHZ].legacy;
+	}
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+/**
+ * This function fills rx status in ieee80211_rx_status structure.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @param  common Pointer to the driver private structure.
+ * @param  rxs Pointer to the ieee80211_rx_status structure.
+ * @return None.
+ */
+static void rsi_fill_rx_status(struct ieee80211_hw *hw,
+			       struct sk_buff *skb,
+			       struct rsi_common *common,
+			       struct ieee80211_rx_status *rxs)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct skb_info *rx_params = (struct skb_info *)info->driver_data;
+	struct ieee80211_hdr *hdr;
+	unsigned char hdrlen = 0;
+	char rssi = rx_params->rssi;
+	unsigned char channel = rx_params->channel;
+	int freq;
+
+	hdr = ((struct ieee80211_hdr *)(skb->data));
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	memset(info, 0, sizeof(struct ieee80211_tx_info));
+
+	rxs->signal = -(rssi);
+
+	if (channel <= 14)
+		rxs->band = IEEE80211_BAND_2GHZ;
+	else
+		rxs->band = IEEE80211_BAND_5GHZ;
+
+	freq = ieee80211_channel_to_frequency(channel, rxs->band);
+
+	if (freq)
+		rxs->freq = freq;
+
+	if (ieee80211_has_protected(hdr->frame_control)) {
+		if (rsi_is_cipher_wep(common)) {
+			memmove(skb->data + 4, skb->data, hdrlen);
+			skb_pull(skb, 4);
+		} else {
+			memmove(skb->data + 8, skb->data, hdrlen);
+			skb_pull(skb, 8);
+			rxs->flag |= RX_FLAG_MMIC_STRIPPED;
+		}
+		rxs->flag |= RX_FLAG_DECRYPTED;
+		rxs->flag |= RX_FLAG_IV_STRIPPED;
+	}
+
+	return;
+}
+
+/**
+ * This function send the recieved packet to mac80211.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return None.
+ */
+void rsi_indicate_pkt_to_os(struct rsi_common *common,
+			    struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+
+	if (common->iface_down) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	/* filling in the ieee80211_rx_status flags */
+	rsi_fill_rx_status(hw, skb, common, rx_status);
+
+	ieee80211_rx_irqsafe(hw, skb);
+	return;
+}
+
+static void rsi_set_min_rate(struct ieee80211_hw *hw,
+			     struct ieee80211_sta *sta,
+			     struct rsi_common *common)
+{
+	unsigned char band = hw->conf.chandef.chan->band;
+	unsigned char ii;
+	unsigned int rate_bitmap;
+	bool matched = false;
+
+	common->bitrate_mask[band] = sta->supp_rates[band];
+
+	rate_bitmap = (common->fixedrate_mask[band] & sta->supp_rates[band]);
+
+	if (rate_bitmap & 0xfff) {
+		/* Find out the min rate */
+		for (ii = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
+			if (rate_bitmap & BIT(ii)) {
+				common->min_rate = rsi_rates[ii].hw_value;
+				matched = true;
+				break;
+			}
+		}
+	}
+
+	common->vif_info[0].is_ht = sta->ht_cap.ht_supported;
+
+	if ((common->vif_info[0].is_ht) && (rate_bitmap >> 12)) {
+		for (ii = 0; ii < ARRAY_SIZE(rsi_mcsrates); ii++) {
+			if ((rate_bitmap >> 12) & BIT(ii)) {
+				common->min_rate = rsi_mcsrates[ii];
+				matched = true;
+				break;
+			}
+		}
+	}
+
+	if (!matched)
+		common->min_rate = 0xffff;
+	return;
+}
+
+/**
+ * This function notifies driver about a peer getting connected.
+ *
+ * @param  hw pointer to the ieee80211_hw structure.
+ * @param  vif pointer to the ieee80211_vif structure.
+ * @param  sta pointer to the ieee80211_sta structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	if (!sta)
+		return -1;
+
+	mutex_lock(&common->mutex);
+
+	rsi_set_min_rate(hw, sta, common);
+
+	if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ||
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)) {
+		common->vif_info[0].sgi = true;
+	}
+
+	if (sta->ht_cap.ht_supported)
+		ieee80211_start_tx_ba_session(sta, 0, 0);
+
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+/**
+ * This function notifies driver about a peer getting disconnected.
+ *
+ * @param  hw pointer to the ieee80211_hw structure.
+ * @param  vif pointer to the ieee80211_vif structure.
+ * @param  sta pointer to the ieee80211_sta structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	/* Resetting all the fields to default values */
+	common->bitrate_mask[IEEE80211_BAND_2GHZ] = 0;
+	common->bitrate_mask[IEEE80211_BAND_5GHZ] = 0;
+	common->min_rate = 0xffff;
+	common->vif_info[0].is_ht = false;
+	common->vif_info[0].sgi = false;
+	common->secinfo.ptk_cipher = 0;
+	common->secinfo.gtk_cipher = 0;
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+static struct ieee80211_ops mac80211_ops = {
+	.tx = rsi_mac80211_tx,
+	.start = rsi_mac80211_start,
+	.stop = rsi_mac80211_stop,
+	.add_interface = rsi_mac80211_add_interface,
+	.remove_interface = rsi_mac80211_remove_interface,
+	.config = rsi_mac80211_config,
+	.bss_info_changed = rsi_mac80211_bss_info_changed,
+	.conf_tx = rsi_mac80211_conf_tx,
+	.configure_filter = rsi_mac80211_conf_filter,
+	.set_key = rsi_mac80211_set_key,
+	.set_rts_threshold = rsi_mac80211_set_rts_threshold,
+	.set_bitrate_mask = rsi_mac80211_set_rate_mask,
+	.ampdu_action = rsi_mac80211_ampdu_action,
+	.sta_add = rsi_mac80211_sta_add,
+	.sta_remove = rsi_mac80211_sta_remove,
+};
+
+/**
+ * This function is used to initialize Mac80211 stack.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_mac80211_attach(struct rsi_common *common)
+{
+	int error = 0;
+	struct ieee80211_hw *hw = NULL;
+	struct wiphy *wiphy = NULL;
+	struct rsi_hw *adapter = common->priv;
+	unsigned char addr_mask[ETH_ALEN] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x3};
+	struct ieee80211_supported_band *sband = &adapter->sbands[0];
+
+	rsi_dbg(INIT_ZONE, "%s: Performing mac80211 attach\n", __func__);
+
+	hw = ieee80211_alloc_hw(sizeof(struct rsi_hw), &mac80211_ops);
+	if (!hw) {
+		rsi_dbg(ERR_ZONE, "%s: ieee80211 hw alloc failed\n", __func__);
+		return -1;
+	}
+
+	wiphy = hw->wiphy;
+
+	SET_IEEE80211_DEV(hw, adapter->device);
+
+	hw->priv = adapter;
+	adapter->hw = hw;
+
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_HAS_RATE_CONTROL |
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    0;
+
+	hw->queues = MAX_HW_QUEUES;
+	hw->channel_change_time = 2000;
+	hw->extra_tx_headroom = RSI_NEEDED_HEADROOM;
+
+	hw->max_rates = 1;
+	hw->max_rate_tries = MAX_RETRIES;
+
+	hw->max_tx_aggregation_subframes = 6;
+	rsi_register_rates_channels(adapter, IEEE80211_BAND_2GHZ);
+	/* rsi_register_rates_channels(adapter, IEEE80211_BAND_5GHZ); */
+	hw->rate_control_algorithm = "AARF";
+
+	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
+	memcpy(hw->wiphy->addr_mask, addr_mask, ETH_ALEN);
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->retry_short = 3;
+	wiphy->retry_long  = 7;
+	wiphy->frag_threshold = MAX_FRAG_LEN;
+	wiphy->rts_threshold = MAX_RTS_THRESHOLD;
+	wiphy->flags = 0;
+
+	wiphy->available_antennas_rx = 1;
+	wiphy->available_antennas_tx = 1;
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &sband[IEEE80211_BAND_2GHZ];
+	/* wiphy->bands[IEEE80211_BAND_5GHZ] = &sband[IEEE80211_BAND_5GHZ]; */
+
+	error = ieee80211_register_hw(hw);
+	return 0;
+}



