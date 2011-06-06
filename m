Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40803 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1FFOMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:12:37 -0400
Received: by pwi15 with SMTP id 15so2108324pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 07:12:37 -0700 (PDT)
Message-ID: <4DECE038.1080805@ring3k.org> (sfid-20110606_161240_897308_8B8CD886)
Date: Mon, 06 Jun 2011 23:12:08 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] rtlwifi: Remove unnecessary indent
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c |  184 +++++++++++++++++-------------------
 1 files changed, 85 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index e502db0..fbb4c13 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -654,128 +654,114 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		/*rx pkt */
 		struct sk_buff *skb = rtlpci->rx_ring[rx_queue_idx].rx_buf[
 				index];
+		struct ieee80211_hdr *hdr;
+		__le16 fc;
+		struct sk_buff *new_skb = NULL;
 
 		own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
 						       false, HW_DESC_OWN);
 
-		if (own) {
-			/*wait data to be filled by hardware */
+		/*wait data to be filled by hardware */
+		if (own)
 			break;
-		} else {
-			struct ieee80211_hdr *hdr;
-			__le16 fc;
-			struct sk_buff *new_skb = NULL;
-
-			rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
-							 &rx_status,
-							 (u8 *) pdesc, skb);
-
-			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
-			if (unlikely(!new_skb)) {
-				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
-					 DBG_DMESG,
-					 ("can't alloc skb for rx\n"));
-				goto done;
-			}
 
-			pci_unmap_single(rtlpci->pdev,
-					 *((dma_addr_t *) skb->cb),
-					 rtlpci->rxbuffersize,
-					 PCI_DMA_FROMDEVICE);
+		rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
+						 &rx_status,
+						 (u8 *) pdesc, skb);
+
+		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
+		if (unlikely(!new_skb)) {
+			RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
+				 DBG_DMESG,
+				 ("can't alloc skb for rx\n"));
+			goto done;
+		}
 
-			skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
-							 false,
-							 HW_DESC_RXPKT_LEN));
-			skb_reserve(skb,
-				    stats.rx_drvinfo_size + stats.rx_bufshift);
+		pci_unmap_single(rtlpci->pdev,
+				 *((dma_addr_t *) skb->cb),
+				 rtlpci->rxbuffersize,
+				 PCI_DMA_FROMDEVICE);
 
-			/*
-			 *NOTICE This can not be use for mac80211,
-			 *this is done in mac80211 code,
-			 *if you done here sec DHCP will fail
-			 *skb_trim(skb, skb->len - 4);
-			 */
+		skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc, false,
+			HW_DESC_RXPKT_LEN));
+		skb_reserve(skb, stats.rx_drvinfo_size + stats.rx_bufshift);
 
-			hdr = rtl_get_hdr(skb);
-			fc = rtl_get_fc(skb);
+		/*
+		 * NOTICE This can not be use for mac80211,
+		 * this is done in mac80211 code,
+		 * if you done here sec DHCP will fail
+		 * skb_trim(skb, skb->len - 4);
+		 */
+
+		hdr = rtl_get_hdr(skb);
+		fc = rtl_get_fc(skb);
 
-			if (!stats.crc && !stats.hwerror) {
-				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
+		if (!stats.crc && !stats.hwerror) {
+			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
-				if (is_broadcast_ether_addr(hdr->addr1)) {
-					;/*TODO*/
-				} else if (is_multicast_ether_addr(hdr->addr1)) {
-					;/*TODO*/
-				} else {
-					unicast = true;
-					rtlpriv->stats.rxbytesunicast +=
-					    skb->len;
-				}
+			if (is_broadcast_ether_addr(hdr->addr1)) {
+				;/*TODO*/
+			} else if (is_multicast_ether_addr(hdr->addr1)) {
+				;/*TODO*/
+			} else {
+				unicast = true;
+				rtlpriv->stats.rxbytesunicast += skb->len;
+			}
 
-				rtl_is_special_data(hw, skb, false);
+			rtl_is_special_data(hw, skb, false);
 
-				if (ieee80211_is_data(fc)) {
-					rtlpriv->cfg->ops->led_control(hw,
-							       LED_CTL_RX);
+			if (ieee80211_is_data(fc)) {
+				rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
 
-					if (unicast)
-						rtlpriv->link_info.
-						    num_rx_inperiod++;
-				}
+				if (unicast)
+					rtlpriv->link_info.num_rx_inperiod++;
+			}
 
-				/* for sw lps */
-				rtl_swlps_beacon(hw, (void *)skb->data,
-						 skb->len);
-				rtl_recognize_peer(hw, (void *)skb->data,
-						   skb->len);
-				if ((rtlpriv->mac80211.opmode ==
-				     NL80211_IFTYPE_AP) &&
-				    (rtlpriv->rtlhal.current_bandtype ==
-				     BAND_ON_2_4G) &&
-				     (ieee80211_is_beacon(fc) ||
-				     ieee80211_is_probe_resp(fc))) {
+			/* for sw lps */
+			rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
+			rtl_recognize_peer(hw, (void *)skb->data, skb->len);
+			if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
+			    (rtlpriv->rtlhal.current_bandtype ==
+			     BAND_ON_2_4G) &&
+			     (ieee80211_is_beacon(fc) ||
+			     ieee80211_is_probe_resp(fc))) {
+				dev_kfree_skb_any(skb);
+			} else {
+				if (unlikely(!rtl_action_proc(hw, skb,
+				    false))) {
 					dev_kfree_skb_any(skb);
 				} else {
-					if (unlikely(!rtl_action_proc(hw, skb,
-					    false))) {
-						dev_kfree_skb_any(skb);
-					} else {
-						struct sk_buff *uskb = NULL;
-						u8 *pdata;
-						uskb = dev_alloc_skb(skb->len
-								     + 128);
-						memcpy(IEEE80211_SKB_RXCB(uskb),
-						       &rx_status,
-						       sizeof(rx_status));
-						pdata = (u8 *)skb_put(uskb,
-							skb->len);
-						memcpy(pdata, skb->data,
-						       skb->len);
-						dev_kfree_skb_any(skb);
-
-						ieee80211_rx_irqsafe(hw, uskb);
-					}
+					struct sk_buff *uskb = NULL;
+					u8 *pdata;
+					uskb = dev_alloc_skb(skb->len + 128);
+					memcpy(IEEE80211_SKB_RXCB(uskb),
+					       &rx_status, sizeof(rx_status));
+					pdata = (u8 *)skb_put(uskb, skb->len);
+					memcpy(pdata, skb->data, skb->len);
+					dev_kfree_skb_any(skb);
+
+					ieee80211_rx_irqsafe(hw, uskb);
 				}
-			} else {
-				dev_kfree_skb_any(skb);
 			}
+		} else {
+			dev_kfree_skb_any(skb);
+		}
 
-			if (((rtlpriv->link_info.num_rx_inperiod +
-				rtlpriv->link_info.num_tx_inperiod) > 8) ||
-				(rtlpriv->link_info.num_rx_inperiod > 2)) {
-				tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
-			}
+		if (((rtlpriv->link_info.num_rx_inperiod +
+			rtlpriv->link_info.num_tx_inperiod) > 8) ||
+			(rtlpriv->link_info.num_rx_inperiod > 2)) {
+			tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
+		}
 
-			skb = new_skb;
+		skb = new_skb;
 
-			rtlpci->rx_ring[rx_queue_idx].rx_buf[index] = skb;
-			*((dma_addr_t *) skb->cb) =
+		rtlpci->rx_ring[rx_queue_idx].rx_buf[index] = skb;
+		*((dma_addr_t *) skb->cb) =
 			    pci_map_single(rtlpci->pdev, skb_tail_pointer(skb),
 					   rtlpci->rxbuffersize,
 					   PCI_DMA_FROMDEVICE);
 
-		}
 done:
 		bufferaddress = (*((dma_addr_t *)skb->cb));
 		tmp_one = 1;
-- 
1.7.4.1


