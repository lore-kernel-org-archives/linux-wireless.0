Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2HUPBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 11:01:34 -0400
Received: by ialo24 with SMTP id o24so3450903ial.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 08:01:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/6] rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se: Remove sparse warnings
Date: Tue, 21 Aug 2012 10:00:51 -0500
Message-Id: <1345561255-10349-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120821_170156_465283_F47A7323)
In-Reply-To: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtlwifi family of drivers has the following sparse errors:

  CHECK   drivers/net/wireless/rtlwifi/usb.c
drivers/net/wireless/rtlwifi/usb.c:122:17: warning: cast to restricted __le32
  CHECK   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:1157:13: warning: context imbalance in 'rtl92c_dm_refresh_rate_adaptive_mask' - different lock contexts for basic block
  CHECK   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
drivers/net/wireless/rtlwifi/rtl8192ce/hw.c:1909:30: warning: cast to restricted __le32
  CHECK   drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
drivers/net/wireless/rtlwifi/rtl8192ce/sw.c:345:1: warning: symbol 'rtl92ce_pci_ids' was not declared. Should it be static?
  CHECK   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
drivers/net/wireless/rtlwifi/rtl8192cu/trx.c:494:9: warning: cast from restricted __le16
  CHECK   drivers/net/wireless/rtlwifi/rtl8192se/fw.c
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:490:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:490:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:494:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:494:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:499:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:499:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:510:25: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:510:25: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:607:9: warning: cast to restricted __le16
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:607:9: warning: cast to restricted __le16
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:650:9: warning: cast to restricted __le16
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:650:9: warning: cast to restricted __le16
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:652:9: warning: cast to restricted __le16
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:652:9: warning: cast to restricted __le16
  CHECK   drivers/net/wireless/rtlwifi/rtl8192se/trx.c
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:758:9: warning: cast from restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:788:17: warning: cast from restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:804:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:804:17: warning: cast to restricted __le32
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:807:17: warning: cast from restricted __le32

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   11 +++--------
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |    4 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |    6 +++---
 drivers/net/wireless/rtlwifi/usb.c                |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h               |   14 +++++++-------
 7 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 2fd3b49..1ca4e25 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1214,18 +1214,13 @@ static void rtl92c_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 				 "PreState = %d, CurState = %d\n",
 				 p_ra->pre_ratr_state, p_ra->ratr_state);
 
-			/* Only the PCI card uses sta in the update rate table
-			 * callback routine */
-			if (rtlhal->interface == INTF_PCI) {
-				rcu_read_lock();
-				sta = ieee80211_find_sta(mac->vif, mac->bssid);
-			}
+			rcu_read_lock();
+			sta = ieee80211_find_sta(mac->vif, mac->bssid);
 			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
 					p_ra->ratr_state);
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
-			if (rtlhal->interface == INTF_PCI)
-				rcu_read_unlock();
+			rcu_read_unlock();
 		}
 	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index bd0da7e..cc89582 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1906,8 +1906,8 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 	}
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 "ratr_bitmap :%x\n", ratr_bitmap);
-	*(u32 *)&rate_mask = EF4BYTE((ratr_bitmap & 0x0fffffff) |
-				     (ratr_index << 28));
+	*(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
+				     (ratr_index << 28);
 	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 "Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x\n",
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 3aa927f..60451ee 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -342,7 +342,7 @@ static struct rtl_hal_cfg rtl92ce_hal_cfg = {
 	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
 };
 
-DEFINE_PCI_DEVICE_TABLE(rtl92ce_pci_ids) = {
+static DEFINE_PCI_DEVICE_TABLE(rtl92ce_pci_ids) = {
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8191, rtl92ce_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8178, rtl92ce_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8177, rtl92ce_hal_cfg)},
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 2e6eb35..bb51f8c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -491,7 +491,7 @@ static void _rtl_tx_desc_checksum(u8 *txdesc)
 	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
 	for (index = 0; index < 16; index++)
 		checksum = checksum ^ (*(ptr + index));
-	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, cpu_to_le16(checksum));
+	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, checksum);
 }
 
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 36d1cb3..e67b338 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -755,7 +755,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) skb->len);
 
 	/* DOWRD 8 */
-	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
 }
@@ -785,7 +785,7 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 		/* 92SE need not to set TX packet size when firmware download */
 		SET_TX_DESC_PKT_SIZE(pdesc, (u16)(skb->len));
 		SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16)(skb->len));
-		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 		wmb();
 		SET_TX_DESC_OWN(pdesc, 1);
@@ -804,7 +804,7 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 		SET_BITS_TO_LE_4BYTE(skb->data, 24, 7, rtlhal->h2c_txcmd_seq);
 
 		SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16)(skb->len));
-		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 		wmb();
 		SET_TX_DESC_OWN(pdesc, 1);
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index aa970fc..1dc758e 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -120,7 +120,7 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
 
 	if (status < 0 && count++ < 4)
 		pr_err("reg 0x%x, usbctrl_vendorreq TimeOut! status:0x%x value=0x%x\n",
-		       value, status, le32_to_cpu(*(u32 *)pdata));
+		       value, status, *(u32 *)pdata);
 	return status;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 3ae43f9..51da6de 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1815,9 +1815,9 @@ struct bt_coexist_info {
 	EF1BYTE(*((u8 *)(_ptr)))
 /* Read le16 data from memory and convert to host ordering */
 #define READEF2BYTE(_ptr)	\
-	EF2BYTE(*((u16 *)(_ptr)))
+	EF2BYTE(*(_ptr))
 #define READEF4BYTE(_ptr)	\
-	EF4BYTE(*((u32 *)(_ptr)))
+	EF4BYTE(*(_ptr))
 
 /* Write data to memory */
 #define WRITEEF1BYTE(_ptr, _val)	\
@@ -1826,7 +1826,7 @@ struct bt_coexist_info {
 #define WRITEEF2BYTE(_ptr, _val)	\
 	(*((u16 *)(_ptr))) = EF2BYTE(_val)
 #define WRITEEF4BYTE(_ptr, _val)	\
-	(*((u16 *)(_ptr))) = EF2BYTE(_val)
+	(*((u32 *)(_ptr))) = EF2BYTE(_val)
 
 /* Create a bit mask
  * Examples:
@@ -1859,9 +1859,9 @@ struct bt_coexist_info {
  * 4-byte pointer in little-endian system.
  */
 #define LE_P4BYTE_TO_HOST_4BYTE(__pstart) \
-	(EF4BYTE(*((u32 *)(__pstart))))
+	(EF4BYTE(*((__le32 *)(__pstart))))
 #define LE_P2BYTE_TO_HOST_2BYTE(__pstart) \
-	(EF2BYTE(*((u16 *)(__pstart))))
+	(EF2BYTE(*((__le16 *)(__pstart))))
 #define LE_P1BYTE_TO_HOST_1BYTE(__pstart) \
 	(EF1BYTE(*((u8 *)(__pstart))))
 
@@ -1908,13 +1908,13 @@ value to host byte ordering.*/
  * Set subfield of little-endian 4-byte value to specified value.
  */
 #define SET_BITS_TO_LE_4BYTE(__pstart, __bitoffset, __bitlen, __val) \
-	*((u32 *)(__pstart)) = EF4BYTE \
+	*((u32 *)(__pstart)) = \
 	( \
 		LE_BITS_CLEARED_TO_4BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u32)__val) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset)) \
 	);
 #define SET_BITS_TO_LE_2BYTE(__pstart, __bitoffset, __bitlen, __val) \
-	*((u16 *)(__pstart)) = EF2BYTE \
+	*((u16 *)(__pstart)) = \
 	( \
 		LE_BITS_CLEARED_TO_2BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u16)__val) & BIT_LEN_MASK_16(__bitlen)) << (__bitoffset)) \
-- 
1.7.10.4

