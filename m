Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56198 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYBJPKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:53 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 09/12] Use wiphy_name everywhere where needed
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:56 +0200
Message-ID: <20080210150056.17592.63047.stgit@tikku> (sfid-20080210_151059_842378_9F7CBADD)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is for the preparation to remove struct net_device.

Functions used by the legacy stack were not converted, because they will
removed anyway.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |  110 ++++++++++++++++++++-------------------
 1 files changed, 57 insertions(+), 53 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 017c36c..8391443 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -738,7 +738,7 @@ exit:
 	kfree(hwcfg);
 	if (ret < 0)
 		printk(KERN_ERR "%s: cannot get HW Config (error %d)\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -870,13 +870,13 @@ static int at76_wait_completion(struct at76_priv *priv, int cmd)
 		status = at76_get_cmd_status(priv->udev, cmd);
 		if (status < 0) {
 			printk(KERN_ERR "%s: at76_get_cmd_status failed: %d\n",
-			       priv->netdev->name, status);
+			       wiphy_name(priv->hw->wiphy), status);
 			break;
 		}
 
 		at76_dbg(DBG_WAIT_COMPLETE,
 			 "%s: Waiting on cmd %d, status = %d (%s)",
-			 priv->netdev->name, cmd, status,
+			 wiphy_name(priv->hw->wiphy), cmd, status,
 			 at76_get_cmd_status_string(status));
 
 		if (status != CMD_STATUS_IN_PROGRESS
@@ -887,7 +887,7 @@ static int at76_wait_completion(struct at76_priv *priv, int cmd)
 		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR
 			       "%s: completion timeout for command %d\n",
-			       priv->netdev->name, cmd);
+			       wiphy_name(priv->hw->wiphy), cmd);
 			status = -ETIMEDOUT;
 			break;
 		}
@@ -910,7 +910,7 @@ static int at76_set_mib(struct at76_priv *priv, struct set_mib_buffer *buf)
 	if (ret != CMD_STATUS_COMPLETE) {
 		printk(KERN_INFO
 		       "%s: set_mib: at76_wait_completion failed "
-		       "with %d\n", priv->netdev->name, ret);
+		       "with %d\n", wiphy_name(priv->hw->wiphy), ret);
 		ret = -EIO;
 	}
 
@@ -931,7 +931,7 @@ static int at76_set_radio(struct at76_priv *priv, int enable)
 	ret = at76_set_card_command(priv->udev, cmd, NULL, 0);
 	if (ret < 0)
 		printk(KERN_ERR "%s: at76_set_card_command(%d) failed: %d\n",
-		       priv->netdev->name, cmd, ret);
+		       wiphy_name(priv->hw->wiphy), cmd, ret);
 	else
 		ret = 1;
 
@@ -952,7 +952,7 @@ static int at76_set_pm_mode(struct at76_priv *priv)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (pm_mode) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -970,7 +970,7 @@ static int at76_set_associd(struct at76_priv *priv, u16 id)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (associd) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -989,7 +989,7 @@ static int at76_set_listen_interval(struct at76_priv *priv, u16 interval)
 	if (ret < 0)
 		printk(KERN_ERR
 		       "%s: set_mib (listen_interval) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -1006,7 +1006,7 @@ static int at76_set_preamble(struct at76_priv *priv, u8 type)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (preamble) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -1023,7 +1023,7 @@ static int at76_set_frag(struct at76_priv *priv, u16 size)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (frag threshold) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -1040,7 +1040,7 @@ static int at76_set_rts(struct at76_priv *priv, u16 size)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (rts) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -1057,7 +1057,7 @@ static int at76_set_autorate_fallback(struct at76_priv *priv, int onoff)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (autorate fallback) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -1074,7 +1074,7 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (MAC_ADDR, mac_addr) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	return ret;
 }
@@ -1093,16 +1093,16 @@ static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 			   sizeof(struct mib_mac_addr));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (MAC_ADDR) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: mac_addr %s res 0x%x 0x%x",
-		 priv->netdev->name,
+		 wiphy_name(priv->hw->wiphy),
 		 mac2str(m->mac_addr), m->res[0], m->res[1]);
 	for (i = 0; i < ARRAY_SIZE(m->group_addr); i++)
 		at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: group addr %d: %s, "
-			 "status %d", priv->netdev->name, i,
+			 "status %d", wiphy_name(priv->hw->wiphy), i,
 			 mac2str(m->group_addr[i]), m->group_addr_status[i]);
 exit:
 	kfree(m);
@@ -1122,13 +1122,13 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
 			   sizeof(struct mib_mac_wep));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (MAC_WEP) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: priv_invoked %u def_key_id %u "
 		 "key_len %u excl_unencr %u wep_icv_err %u wep_excluded %u "
-		 "encr_level %u key %d", priv->netdev->name,
+		 "encr_level %u key %d", wiphy_name(priv->hw->wiphy),
 		 m->privacy_invoked, m->wep_default_key_id,
 		 m->wep_key_mapping_len, m->exclude_unencrypted,
 		 le32_to_cpu(m->wep_icv_error_count),
@@ -1140,7 +1140,7 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
 
 	for (i = 0; i < WEP_KEYS; i++)
 		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %s",
-			 priv->netdev->name, i,
+			 wiphy_name(priv->hw->wiphy), i,
 			 hex2str(m->wep_default_keyvalue[i], key_len));
 exit:
 	kfree(m);
@@ -1159,7 +1159,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (MAC_MGMT) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
@@ -1170,7 +1170,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		 "pm_mode %d ibss_change %d res %d "
 		 "multi_domain_capability_implemented %d "
 		 "international_roaming %d country_string %.3s",
-		 priv->netdev->name, le16_to_cpu(m->beacon_period),
+		 wiphy_name(priv->hw->wiphy), le16_to_cpu(m->beacon_period),
 		 le16_to_cpu(m->CFP_max_duration),
 		 le16_to_cpu(m->medium_occupancy_limit),
 		 le16_to_cpu(m->station_id), le16_to_cpu(m->ATIM_window),
@@ -1195,7 +1195,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MAC, m, sizeof(struct mib_mac));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (MAC) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
@@ -1205,7 +1205,8 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 		 "scan_type %d scan_channel %d probe_delay %u "
 		 "min_channel_time %d max_channel_time %d listen_int %d "
 		 "desired_ssid %s desired_bssid %s desired_bsstype %d",
-		 priv->netdev->name, le32_to_cpu(m->max_tx_msdu_lifetime),
+		 wiphy_name(priv->hw->wiphy),
+		 le32_to_cpu(m->max_tx_msdu_lifetime),
 		 le32_to_cpu(m->max_rx_lifetime),
 		 le16_to_cpu(m->frag_threshold), le16_to_cpu(m->rts_threshold),
 		 le16_to_cpu(m->cwmin), le16_to_cpu(m->cwmax),
@@ -1231,7 +1232,7 @@ static void at76_dump_mib_phy(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_PHY, m, sizeof(struct mib_phy));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (PHY) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
@@ -1240,7 +1241,7 @@ static void at76_dump_mib_phy(struct at76_priv *priv)
 		 "mpdu_max_length %d cca_mode_supported %d operation_rate_set "
 		 "0x%x 0x%x 0x%x 0x%x channel_id %d current_cca_mode %d "
 		 "phy_type %d current_reg_domain %d",
-		 priv->netdev->name, le32_to_cpu(m->ed_threshold),
+		 wiphy_name(priv->hw->wiphy), le32_to_cpu(m->ed_threshold),
 		 le16_to_cpu(m->slot_time), le16_to_cpu(m->sifs_time),
 		 le16_to_cpu(m->preamble_length),
 		 le16_to_cpu(m->plcp_header_length),
@@ -1264,13 +1265,14 @@ static void at76_dump_mib_local(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(struct mib_local));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (LOCAL) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB LOCAL: beacon_enable %d "
 		 "txautorate_fallback %d ssid_size %d promiscuous_mode %d "
-		 "preamble_type %d", priv->netdev->name, m->beacon_enable,
+		 "preamble_type %d", wiphy_name(priv->hw->wiphy),
+		 m->beacon_enable,
 		 m->txautorate_fallback, m->ssid_size, m->promiscuous_mode,
 		 m->preamble_type);
 exit:
@@ -1289,16 +1291,16 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
 			   sizeof(struct mib_mdomain));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib (MDOMAIN) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto exit;
 	}
 
 	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %s",
-		 priv->netdev->name,
+		 wiphy_name(priv->hw->wiphy),
 		 hex2str(m->channel_list, sizeof(m->channel_list)));
 
 	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %s",
-		 priv->netdev->name,
+		 wiphy_name(priv->hw->wiphy),
 		 hex2str(m->tx_powerlevel, sizeof(m->tx_powerlevel)));
 exit:
 	kfree(m);
@@ -1319,11 +1321,11 @@ static int at76_get_current_bssid(struct at76_priv *priv)
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto error;
 	}
 	memcpy(priv->bssid, mac_mgmt->current_bssid, ETH_ALEN);
-	printk(KERN_INFO "%s: using BSSID %s\n", priv->netdev->name,
+	printk(KERN_INFO "%s: using BSSID %s\n", wiphy_name(priv->hw->wiphy),
 	       mac2str(priv->bssid));
 error:
 	kfree(mac_mgmt);
@@ -1343,7 +1345,7 @@ static int at76_get_current_channel(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_PHY, phy, sizeof(struct mib_phy));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_get_mib(MIB_PHY) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto error;
 	}
 	priv->channel = phy->channel_id;
@@ -3292,7 +3294,7 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 
 	if (!priv->rx_urb) {
 		printk(KERN_ERR "%s: %s: priv->rx_urb is NULL\n",
-		       priv->netdev->name, __func__);
+		       wiphy_name(priv->hw->wiphy), __func__);
 		return -EFAULT;
 	}
 
@@ -3300,7 +3302,7 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 		skb = dev_alloc_skb(sizeof(struct at76_rx_buffer));
 		if (!skb) {
 			printk(KERN_ERR "%s: cannot allocate rx skbuff\n",
-			       priv->netdev->name);
+			       wiphy_name(priv->hw->wiphy));
 			ret = -ENOMEM;
 			goto exit;
 		}
@@ -3320,14 +3322,14 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 				 "usb_submit_urb returned -ENODEV");
 		else
 			printk(KERN_ERR "%s: rx, usb_submit_urb failed: %d\n",
-			       priv->netdev->name, ret);
+			       wiphy_name(priv->hw->wiphy), ret);
 	}
 
 exit:
 	if (ret < 0 && ret != -ENODEV)
 		printk(KERN_ERR "%s: cannot submit rx urb - please unload the "
 		       "driver and/or power cycle the device\n",
-		       priv->netdev->name);
+		       wiphy_name(priv->hw->wiphy));
 
 	return ret;
 }
@@ -3927,14 +3929,14 @@ static int at76_startup_device(struct at76_priv *priv)
 
 	at76_dbg(DBG_PARAMS,
 		 "%s param: ssid %.*s (%s) mode %s ch %d wep %s key %d "
-		 "keylen %d", priv->netdev->name, priv->essid_size, priv->essid,
-		 hex2str(priv->essid, IW_ESSID_MAX_SIZE),
+		 "keylen %d", wiphy_name(priv->hw->wiphy), priv->essid_size,
+		 priv->essid, hex2str(priv->essid, IW_ESSID_MAX_SIZE),
 		 priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
 		 priv->channel, priv->wep_enabled ? "enabled" : "disabled",
 		 priv->wep_key_id, priv->wep_keys_len[priv->wep_key_id]);
 	at76_dbg(DBG_PARAMS,
 		 "%s param: preamble %s rts %d retry %d frag %d "
-		 "txrate %s auth_mode %d", priv->netdev->name,
+		 "txrate %s auth_mode %d", wiphy_name(priv->hw->wiphy),
 		 preambles[priv->preamble_type], priv->rts_threshold,
 		 priv->short_retry_limit, priv->frag_threshold,
 		 priv->txrate == TX_RATE_1MBIT ? "1MBit" : priv->txrate ==
@@ -3945,7 +3947,7 @@ static int at76_startup_device(struct at76_priv *priv)
 	at76_dbg(DBG_PARAMS,
 		 "%s param: pm_mode %d pm_period %d auth_mode %s "
 		 "scan_times %d %d scan_mode %s",
-		 priv->netdev->name, priv->pm_mode, priv->pm_period,
+		 wiphy_name(priv->hw->wiphy), priv->pm_mode, priv->pm_period,
 		 priv->auth_mode == WLAN_AUTH_OPEN ? "open" : "shared_secret",
 		 priv->scan_min_time, priv->scan_max_time,
 		 priv->scan_mode == SCAN_TYPE_ACTIVE ? "active" : "passive");
@@ -3989,7 +3991,7 @@ static int at76_startup_device(struct at76_priv *priv)
 				    sizeof(struct at76_card_config));
 	if (ret < 0) {
 		printk(KERN_ERR "%s: at76_set_card_command failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		return ret;
 	}
 
@@ -4115,7 +4117,7 @@ static void at76_work_set_promisc(struct work_struct *work)
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		printk(KERN_ERR "%s: set_mib (promiscuous_mode) failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 
 	mutex_unlock(&priv->mtx);
 }
@@ -5037,14 +5039,16 @@ static void at76_rx_tasklet(unsigned long param)
 		if (urb->status != -ENOENT && urb->status != -ECONNRESET)
 			at76_dbg(DBG_URB,
 				 "%s %s: - nonzero Rx bulk status received: %d",
-				 __func__, netdev->name, urb->status);
+				 __func__, wiphy_name(priv->hw->wiphy),
+				 urb->status);
 		return;
 	}
 
 	at76_dbg(DBG_RX_ATMEL_HDR,
 		 "%s: rx frame: rate %d rssi %d noise %d link %d %s",
-		 priv->netdev->name, buf->rx_rate, buf->rssi, buf->noise_level,
-		 buf->link_quality, hex2str(i802_11_hdr, 48));
+		 wiphy_name(priv->hw->wiphy), buf->rx_rate, buf->rssi,
+		 buf->noise_level, buf->link_quality,
+		 hex2str(i802_11_hdr, 48));
 
 	{
 		struct ieee80211_rx_status rx_status = {0};
@@ -5229,7 +5233,7 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	if (priv->tx_urb->status == -EINPROGRESS) {
 		printk(KERN_ERR "%s: %s called while tx urb is pending\n",
-		       priv->netdev->name, __func__);
+		       wiphy_name(priv->hw->wiphy), __func__);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -5253,7 +5257,7 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	memcpy(tx_buffer->packet, skb->data, skb->len);
 
 	at76_dbg(DBG_TX_DATA, "%s tx: wlen 0x%x pad 0x%x rate %d hdr",
-		 priv->netdev->name, le16_to_cpu(tx_buffer->wlength),
+		 wiphy_name(priv->hw->wiphy), le16_to_cpu(tx_buffer->wlength),
 		 tx_buffer->padding, tx_buffer->tx_rate);
 
 	/* send stuff */
@@ -5264,11 +5268,11 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret) {
 		printk(KERN_ERR "%s: error in tx submit urb: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		if (ret == -EINVAL)
 			printk(KERN_ERR
 			       "%s: -EINVAL: tx urb %p hcpriv %p complete %p\n",
-			       priv->netdev->name, priv->tx_urb,
+			       wiphy_name(priv->hw->wiphy), priv->tx_urb,
 			       priv->tx_urb->hcpriv, priv->tx_urb->complete);
 	}
 
@@ -5288,7 +5292,7 @@ static int at76_mac80211_start(struct ieee80211_hw *hw)
 	ret = at76_submit_rx_urb(priv);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: open: submit_rx_urb failed: %d\n",
-		       priv->netdev->name, ret);
+		       wiphy_name(priv->hw->wiphy), ret);
 		goto error;
 	}
 
@@ -6077,7 +6081,7 @@ static void at76_disconnect(struct usb_interface *interface)
 	if (!priv)
 		return;
 
-	printk(KERN_INFO "%s: disconnecting\n", priv->netdev->name);
+	printk(KERN_INFO "%s: disconnecting\n", wiphy_name(priv->hw->wiphy));
 	at76_delete_device(priv);
 	dev_printk(KERN_INFO, &interface->dev, "disconnected\n");
 }

