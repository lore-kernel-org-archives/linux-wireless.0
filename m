Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35174 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755941AbcLOSYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 13:24:02 -0500
Received: by mail-oi0-f68.google.com with SMTP id v84so7054822oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 10:23:28 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 02/14 V2] rtlwifi: Remove RT_TRACE messages that use DBG_EMERG
Date: Thu, 15 Dec 2016 12:22:58 -0600
Message-Id: <20161215182310.13713-3-Larry.Finger@lwfinger.net> (sfid-20161215_192408_806996_0837F59D)
In-Reply-To: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These messages are always logged and represent error conditions, thus
we can use pr_err().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - eliminate some files that should not have been sent, and remove the
     module name from the format. It is already specified by a pr_fmt().
---
 drivers/net/wireless/realtek/rtlwifi/base.c  | 14 +++------
 drivers/net/wireless/realtek/rtlwifi/cam.c   | 14 +++------
 drivers/net/wireless/realtek/rtlwifi/core.c  | 20 +++++-------
 drivers/net/wireless/realtek/rtlwifi/efuse.c |  3 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c   | 36 ++++++++--------------
 drivers/net/wireless/realtek/rtlwifi/ps.c    |  3 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c    |  3 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c   | 46 +++++++++-------------------
 8 files changed, 47 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 4ac928b..0a8553e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -207,8 +207,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 	 *highest supported RX rate
 	 */
 	if (rtlpriv->dm.supp_phymode_switch) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
-			 "Support phy mode switch\n");
+		pr_info("Support phy mode switch\n");
 
 		ht_cap->mcs.rx_mask[0] = 0xFF;
 		ht_cap->mcs.rx_mask[1] = 0xFF;
@@ -389,8 +388,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 			/* <4> set mac->sband to wiphy->sband */
 			hw->wiphy->bands[NL80211_BAND_5GHZ] = sband;
 		} else {
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Err BAND %d\n",
-				 rtlhal->current_bandtype);
+			pr_err("Err BAND %d\n",
+			       rtlhal->current_bandtype);
 		}
 	}
 	/* <5> set hw caps */
@@ -544,7 +542,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	 * mac80211 hw  in _rtl_init_mac80211.
 	 */
 	if (rtl_regd_init(hw, rtl_reg_notifier)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "REGD init failed\n");
+		pr_err("REGD init failed\n");
 		return 1;
 	}
 
@@ -1694,8 +1692,7 @@ void rtl_watchdog_wq_callback(void *data)
 			 * we should reconnect this AP
 			 */
 			if (rtlpriv->link_info.roam_times >= 5) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 "AP off, try to reconnect now\n");
+				pr_err("AP off, try to reconnect now\n");
 				rtlpriv->link_info.roam_times = 0;
 				ieee80211_connection_loss(
 					rtlpriv->mac80211.vif);
@@ -1886,8 +1883,7 @@ void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 						      (u8 *)&iotype);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown Scan Backup operation.\n");
+			pr_err("Unknown Scan Backup operation.\n");
 			break;
 		}
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
index 8fe8b4c..a0605d8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/cam.c
+++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
@@ -285,8 +285,7 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	u8 i, *addr;
 
 	if (NULL == sta_addr) {
-		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
-			 "sta_addr is NULL.\n");
+		pr_err("sta_addr is NULL.\n");
 		return TOTAL_CAM_ENTRY;
 	}
 	/* Does STA already exist? */
@@ -298,9 +297,8 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	/* Get a free CAM entry. */
 	for (entry_idx = 4; entry_idx < TOTAL_CAM_ENTRY; entry_idx++) {
 		if ((bitmap & BIT(0)) == 0) {
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
-				 "-----hwsec_cam_bitmap: 0x%x entry_idx=%d\n",
-				 rtlpriv->sec.hwsec_cam_bitmap, entry_idx);
+			pr_err("-----hwsec_cam_bitmap: 0x%x entry_idx=%d\n",
+			       rtlpriv->sec.hwsec_cam_bitmap, entry_idx);
 			rtlpriv->sec.hwsec_cam_bitmap |= BIT(0) << entry_idx;
 			memcpy(rtlpriv->sec.hwsec_cam_sta_addr[entry_idx],
 			       sta_addr, ETH_ALEN);
@@ -319,14 +317,12 @@ void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	u8 i, *addr;
 
 	if (NULL == sta_addr) {
-		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
-			 "sta_addr is NULL.\n");
+		pr_err("sta_addr is NULL.\n");
 		return;
 	}
 
 	if (is_zero_ether_addr(sta_addr)) {
-		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
-			 "sta_addr is %pM\n", sta_addr);
+		pr_err("sta_addr is %pM\n", sta_addr);
 		return;
 	}
 	/* Does STA already exist? */
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 6aad64c..77d7baa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -117,8 +117,7 @@ static void rtl_fw_do_work(const struct firmware *firmware, void *context,
 	}
 found_alt:
 	if (firmware->size > rtlpriv->max_fw_size) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
+		pr_err("Firmware is too big!\n");
 		release_firmware(firmware);
 		return;
 	}
@@ -303,8 +302,8 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 				(u8 *)(&mac->basic_rates));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "operation mode %d is not support!\n", vif->type);
+		pr_err("operation mode %d is not supported!\n",
+		       vif->type);
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -764,9 +762,8 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 			default:
 					mac->bw_40 = false;
 					mac->bw_80 = false;
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "switch case %#x not processed\n",
-						 channel_type);
+					pr_err("switch case %#x not processed\n",
+					       channel_type);
 					break;
 			}
 		}
@@ -1399,8 +1396,7 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			 "IEEE80211_AMPDU_RX_STOP:TID:%d\n", tid);
 		return rtl_rx_agg_stop(hw, sta, tid);
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "IEEE80211_AMPDU_ERR!!!!:\n");
+		pr_err("IEEE80211_AMPDU_ERR!!!!:\n");
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -1536,8 +1532,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		err = -EOPNOTSUPP;
 		goto out_unlock;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "alg_err:%x!!!!:\n", key->cipher);
+		pr_err("alg_err:%x!!!!:\n", key->cipher);
 		goto out_unlock;
 	}
 	if (key_type == WEP40_ENCRYPTION ||
@@ -1662,8 +1657,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "cmd_err:%x!!!!:\n", cmd);
+		pr_err("cmd_err:%x!!!!:\n", cmd);
 	}
 out_unlock:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index 7becfef..afc7550 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -1259,8 +1259,7 @@ int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
 		break;
 
 	case EEPROM_93C46:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL8XXX did not boot from eeprom, check it !!\n");
+		pr_err("RTL8XXX did not boot from eeprom, check it !!\n");
 		return 1;
 
 	default:
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 661c66f..f8bfa73 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -174,9 +174,8 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n",
-			 rtlpci->const_support_pciaspm);
+		pr_err("switch case %#x not processed\n",
+		       rtlpci->const_support_pciaspm);
 		break;
 	}
 
@@ -1247,9 +1246,8 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 					 &buffer_desc_dma);
 
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Cannot allocate TX ring (prio = %d)\n",
-				 prio);
+			pr_err("Cannot allocate TX ring (prio = %d)\n",
+			       prio);
 			return -ENOMEM;
 		}
 
@@ -1266,8 +1264,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 				     sizeof(*desc) * entries, &desc_dma);
 
 	if (!desc || (unsigned long)desc & 0xFF) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Cannot allocate TX ring (prio = %d)\n", prio);
+		pr_err("Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
@@ -1314,8 +1311,7 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 					  &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (ulong)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Cannot allocate RX ring\n");
+			pr_err("Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
@@ -1338,8 +1334,7 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 					  &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Cannot allocate RX ring\n");
+			pr_err("Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
@@ -1799,15 +1794,13 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err;
 
 	_rtl_pci_init_struct(hw, pdev);
 
 	err = _rtl_pci_init_trx_ring(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "tx ring initialization failed\n");
+		pr_err("tx ring initialization failed\n");
 		return err;
 	}
 
@@ -2275,7 +2268,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		pr_err("Can't init_sw_vars\n");
 		err = -ENODEV;
 		goto fail3;
 	}
@@ -2287,22 +2280,20 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't allocate sw for mac80211\n");
+		pr_err("Can't allocate sw for mac80211\n");
 		goto fail3;
 	}
 
 	/* Init PCI sw */
 	err = rtl_pci_init(hw, pdev);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Failed to init PCI\n");
+		pr_err("Failed to init PCI\n");
 		goto fail3;
 	}
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw.\n");
+		pr_err("Can't register mac80211 hw.\n");
 		err = -ENODEV;
 		goto fail3;
 	}
@@ -2310,8 +2301,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 
 	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "failed to create sysfs device attributes\n");
+		pr_err("failed to create sysfs device attributes\n");
 		goto fail3;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index d0ffc4d..4f83270 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -150,8 +150,7 @@ static bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 		break;
 
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", state_toset);
+		pr_err("switch case %#x not processed\n", state_toset);
 		break;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index ce8621a..951d257 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -267,8 +267,7 @@ static void *rtl_rate_alloc_sta(void *ppriv,
 
 	rate_priv = kzalloc(sizeof(struct rtl_rate_priv), gfp);
 	if (!rate_priv) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Unable to allocate private rc structure\n");
+		pr_err("Unable to allocate private rc structure\n");
 		return NULL;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index dc58aa6..14d68e9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -421,14 +421,12 @@ static void _rtl_rx_completed(struct urb *urb);
 static int _rtl_prep_rx_urb(struct ieee80211_hw *hw, struct rtl_usb *rtlusb,
 			      struct urb *urb, gfp_t gfp_mask)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	void *buf;
 
 	buf = usb_alloc_coherent(rtlusb->udev, rtlusb->rx_max_size, gfp_mask,
 				 &urb->transfer_dma);
 	if (!buf) {
-		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-			 "Failed to usb_alloc_coherent!!\n");
+		pr_err("Failed to usb_alloc_coherent!!\n");
 		return -ENOMEM;
 	}
 
@@ -613,8 +611,6 @@ static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr *hdr,
 static void _rtl_rx_completed(struct urb *_urb)
 {
 	struct rtl_usb *rtlusb = (struct rtl_usb *)_urb->context;
-	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err = 0;
 
 	if (unlikely(IS_USB_STOP(rtlusb)))
@@ -628,17 +624,15 @@ static void _rtl_rx_completed(struct urb *_urb)
 		struct ieee80211_hdr *hdr;
 
 		if (size < RTL_RX_DESC_SIZE + sizeof(struct ieee80211_hdr)) {
-			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-				 "Too short packet from bulk IN! (len: %d)\n",
-				 size);
+			pr_err("Too short packet from bulk IN! (len: %d)\n",
+			       size);
 			goto resubmit;
 		}
 
 		qlen = skb_queue_len(&rtlusb->rx_queue);
 		if (qlen >= __RX_SKB_MAX_QUEUED) {
-			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-				 "Pending RX skbuff queue full! (qlen: %d)\n",
-				 qlen);
+			pr_err("Pending RX skbuff queue full! (qlen: %d)\n",
+			       qlen);
 			goto resubmit;
 		}
 
@@ -647,8 +641,7 @@ static void _rtl_rx_completed(struct urb *_urb)
 
 		skb = dev_alloc_skb(size + __RADIO_TAP_SIZE_RSV + padding);
 		if (!skb) {
-			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-				 "Can't allocate skb for bulk IN!\n");
+			pr_err("Can't allocate skb for bulk IN!\n");
 			goto resubmit;
 		}
 
@@ -725,7 +718,6 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 	struct urb *urb;
 	int err;
 	int i;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	WARN_ON(0 == rtlusb->rx_urb_num);
@@ -740,8 +732,7 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 
 		err = _rtl_prep_rx_urb(hw, rtlusb, urb, GFP_KERNEL);
 		if (err < 0) {
-			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-				 "Failed to prep_rx_urb!!\n");
+			pr_err("Failed to prep_rx_urb!!\n");
 			usb_free_urb(urb);
 			goto err_out;
 		}
@@ -839,7 +830,6 @@ static void rtl_usb_stop(struct ieee80211_hw *hw)
 static void _rtl_submit_tx_urb(struct ieee80211_hw *hw, struct urb *_urb)
 {
 	int err;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	usb_anchor_urb(_urb, &rtlusb->tx_submitted);
@@ -847,8 +837,7 @@ static void _rtl_submit_tx_urb(struct ieee80211_hw *hw, struct urb *_urb)
 	if (err < 0) {
 		struct sk_buff *skb;
 
-		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-			 "Failed to submit urb\n");
+		pr_err("Failed to submit urb\n");
 		usb_unanchor_urb(_urb);
 		skb = (struct sk_buff *)_urb->context;
 		kfree_skb(skb);
@@ -859,7 +848,6 @@ static void _rtl_submit_tx_urb(struct ieee80211_hw *hw, struct urb *_urb)
 static int _usb_tx_post(struct ieee80211_hw *hw, struct urb *urb,
 			struct sk_buff *skb)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct ieee80211_tx_info *txinfo;
 
@@ -870,8 +858,7 @@ static int _usb_tx_post(struct ieee80211_hw *hw, struct urb *urb,
 	txinfo->flags |= IEEE80211_TX_STAT_ACK;
 
 	if (urb->status) {
-		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-			 "Urb has error status 0x%X\n", urb->status);
+		pr_err("Urb has error status 0x%X\n", urb->status);
 		goto out;
 	}
 	/*  TODO:	statistics */
@@ -919,7 +906,6 @@ static struct urb *_rtl_usb_tx_urb_setup(struct ieee80211_hw *hw,
 static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 		       enum rtl_txq qnum)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	u32 ep_num;
 	struct urb *_urb = NULL;
@@ -927,8 +913,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	WARN_ON(NULL == rtlusb->usb_tx_aggregate_hdl);
 	if (unlikely(IS_USB_STOP(rtlusb))) {
-		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-			 "USB device is stopping...\n");
+		pr_err("USB device is stopping...\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -936,8 +921,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	_skb = skb;
 	_urb = _rtl_usb_tx_urb_setup(hw, _skb, ep_num);
 	if (unlikely(!_urb)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't allocate urb. Drop skb!\n");
+		pr_err("Can't allocate urb. Drop skb!\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -1102,20 +1086,18 @@ int rtl_usb_probe(struct usb_interface *intf,
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't allocate sw for mac80211\n");
+		pr_err("Can't allocate sw for mac80211\n");
 		goto error_out;
 	}
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		pr_err("Can't init_sw_vars\n");
 		goto error_out;
 	}
 	rtlpriv->cfg->ops->init_sw_leds(hw);
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw.\n");
+		pr_err("Can't register mac80211 hw.\n");
 		err = -ENODEV;
 		goto error_out;
 	}
-- 
2.10.2
