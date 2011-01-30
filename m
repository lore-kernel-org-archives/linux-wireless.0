Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37843 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1A3SMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:12:23 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so4705242iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 10:12:22 -0800 (PST)
From: Larry.Finger@lwfinger.net
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	george0505 <george0505@realtek.com>,
	'Zhaoming_Li' <chaoming_li@realsil.com.cn>
Subject: [RFC/RFT 8/8] rtl8192cu: Add new driver code - Part 7
Date: Sun, 30 Jan 2011 12:11:40 -0600
Message-Id: <1296411100-5675-9-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: george0505 <george0505@realtek.com>
Cc: 'Zhaoming_Li' <chaoming_li@realsil.com.cn>
---
 drivers/net/wireless/rtlwifi/Kconfig            |   11 +
 drivers/net/wireless/rtlwifi/Makefile           |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/Makefile |   13 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c    |  685 +++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h    |  404 +++++++++++++
 5 files changed, 1114 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index 7f6573f..e4ac530 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -9,6 +9,17 @@ config RTL8192CE
 
 	If you choose to build it as a module, it will be called rtl8192ce
 
+config RTL8192CU
+	tristate "Realtek RTL8192CU/RTL8188SU USB Wireless Network Adapter"
+	depends on MAC80211 && EXPERIMENTAL && USB
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192CU/RTL8188CU 802.11n USB
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be called rtl8192cu
+
 config RTLWIFI
 	tristate
 	depends on RTL8192CE
diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
index efbff2f..d0f4c12 100644
--- a/drivers/net/wireless/rtlwifi/Makefile
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -12,3 +12,4 @@ rtlwifi-objs	:=		\
 		usb.o
 
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
+obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile b/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
new file mode 100644
index 0000000..073f5e5
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
@@ -0,0 +1,13 @@
+rtl8192cu-objs :=		\
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		mac.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
+
+obj-$(CONFIG_RTL8192CU) += rtl8192cu.o
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
new file mode 100644
index 0000000..a3fcf08
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -0,0 +1,685 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../usb.h"
+#include "../ps.h"
+#include "../base.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "rf.h"
+#include "dm.h"
+#include "mac.h"
+#include "trx.h"
+
+static int _ConfigVerTOutEP(struct ieee80211_hw *hw)
+{
+	u8 ep_cfg, txqsele;
+	u8 ep_nums = 0;
+
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
+
+	rtlusb->out_queue_sel = 0;
+	ep_cfg = rtl_read_byte(rtlpriv, REG_TEST_SIE_OPTIONAL);
+	ep_cfg = (ep_cfg & USB_TEST_EP_MASK) >> USB_TEST_EP_SHIFT;
+	switch (ep_cfg)	{
+	case 0:		/* 2 bulk OUT, 1 bulk IN */
+	case 3:
+		rtlusb->out_queue_sel  = TX_SELE_HQ | TX_SELE_LQ;
+		ep_nums = 2;
+		break;
+	case 1:	/* 1 bulk IN/OUT => map all endpoint to Low queue */
+	case 2:	/* 1 bulk IN, 1 bulk OUT => map all endpoint to High queue */
+		txqsele = rtl_read_byte(rtlpriv, REG_TEST_USB_TXQS);
+		if (txqsele & 0x0F) /* /map all endpoint to High queue */
+			rtlusb->out_queue_sel =  TX_SELE_HQ;
+		else if (txqsele&0xF0) /* map all endpoint to Low queue */
+			rtlusb->out_queue_sel =  TX_SELE_LQ;
+		ep_nums = 1;
+		break;
+	default:
+		break;
+	}
+	return (rtlusb->out_ep_nums == ep_nums) ? 0 : -EINVAL;
+}
+
+static int _ConfigVerNOutEP(struct ieee80211_hw *hw)
+{
+	u8 ep_cfg;
+	u8 ep_nums = 0;
+
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
+
+	rtlusb->out_queue_sel = 0;
+	/* Normal and High queue */
+	ep_cfg =  rtl_read_byte(rtlpriv, (REG_NORMAL_SIE_EP + 1));
+	if (ep_cfg & USB_NORMAL_SIE_EP_MASK) {
+		rtlusb->out_queue_sel |= TX_SELE_HQ;
+		ep_nums++;
+	}
+	if ((ep_cfg >> USB_NORMAL_SIE_EP_SHIFT) & USB_NORMAL_SIE_EP_MASK) {
+		rtlusb->out_queue_sel |= TX_SELE_NQ;
+		ep_nums++;
+	}
+	/* Low queue */
+	ep_cfg =  rtl_read_byte(rtlpriv, (REG_NORMAL_SIE_EP + 2));
+	if (ep_cfg & USB_NORMAL_SIE_EP_MASK) {
+		rtlusb->out_queue_sel |= TX_SELE_LQ;
+		ep_nums++;
+	}
+	return (rtlusb->out_ep_nums == ep_nums) ? 0 : -EINVAL;
+}
+
+static void _TwoOutEpMapping(struct ieee80211_hw *hw, bool bIsChipB,
+			     bool  bwificfg, struct rtl_ep_map *ep_map)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (bwificfg) { /* for WMM */
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("USB Chip-B & WMM Setting.....\n"));
+		ep_map->ep_mapping[RTL_TXQ_BE]	= 2;
+		ep_map->ep_mapping[RTL_TXQ_BK]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_VI]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_VO] = 2;
+		ep_map->ep_mapping[RTL_TXQ_MGT] = 2;
+		ep_map->ep_mapping[RTL_TXQ_BCN] = 2;
+		ep_map->ep_mapping[RTL_TXQ_HI]	= 2;
+	} else { /* typical setting */
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("USB typical Setting.....\n"));
+		ep_map->ep_mapping[RTL_TXQ_BE]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_BK]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_VI]	= 2;
+		ep_map->ep_mapping[RTL_TXQ_VO]	= 2;
+		ep_map->ep_mapping[RTL_TXQ_MGT] = 2;
+		ep_map->ep_mapping[RTL_TXQ_BCN] = 2;
+		ep_map->ep_mapping[RTL_TXQ_HI]	= 2;
+	}
+}
+
+static void _ThreeOutEpMapping(struct ieee80211_hw *hw, bool  bwificfg,
+			       struct rtl_ep_map *ep_map)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	if (bwificfg) { /* for WMM */
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("USB 3EP Setting for WMM.....\n"));
+		ep_map->ep_mapping[RTL_TXQ_BE]	= 5;
+		ep_map->ep_mapping[RTL_TXQ_BK]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_VI]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_VO]	= 2;
+		ep_map->ep_mapping[RTL_TXQ_MGT] = 2;
+		ep_map->ep_mapping[RTL_TXQ_BCN] = 2;
+		ep_map->ep_mapping[RTL_TXQ_HI]	= 2;
+	} else { /* typical setting */
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("USB 3EP Setting for typical.....\n"));
+		ep_map->ep_mapping[RTL_TXQ_BE]	= 5;
+		ep_map->ep_mapping[RTL_TXQ_BK]	= 5;
+		ep_map->ep_mapping[RTL_TXQ_VI]	= 3;
+		ep_map->ep_mapping[RTL_TXQ_VO]	= 2;
+		ep_map->ep_mapping[RTL_TXQ_MGT] = 2;
+		ep_map->ep_mapping[RTL_TXQ_BCN] = 2;
+		ep_map->ep_mapping[RTL_TXQ_HI]	= 2;
+	}
+}
+
+static void _OneOutEpMapping(struct ieee80211_hw *hw, struct rtl_ep_map *ep_map)
+{
+	ep_map->ep_mapping[RTL_TXQ_BE]	= 2;
+	ep_map->ep_mapping[RTL_TXQ_BK]	= 2;
+	ep_map->ep_mapping[RTL_TXQ_VI]	= 2;
+	ep_map->ep_mapping[RTL_TXQ_VO] = 2;
+	ep_map->ep_mapping[RTL_TXQ_MGT] = 2;
+	ep_map->ep_mapping[RTL_TXQ_BCN] = 2;
+	ep_map->ep_mapping[RTL_TXQ_HI]	= 2;
+}
+static int _out_ep_mapping(struct ieee80211_hw *hw)
+{
+	int err = 0;
+	bool bIsChipN, bwificfg = false;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
+	struct rtl_ep_map *ep_map = &(rtlusb->ep_map);
+
+	bIsChipN = IS_NORMAL_CHIP(rtlhal->version);
+	switch (rtlusb->out_ep_nums) {
+	case 2:
+		_TwoOutEpMapping(hw, bIsChipN, bwificfg, ep_map);
+		break;
+	case 3:
+		/* Test chip doesn't support three out EPs. */
+		if (!bIsChipN) {
+			err  =  -EINVAL;
+			goto err_out;
+		}
+		_ThreeOutEpMapping(hw, bIsChipN, ep_map);
+		break;
+	case 1:
+		_OneOutEpMapping(hw, ep_map);
+		break;
+	default:
+		err  =  -EINVAL;
+		break;
+	}
+err_out:
+	return err;
+
+}
+/* endpoint mapping */
+int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	int error = 0;
+	if (likely(IS_NORMAL_CHIP(rtlhal->version)))
+		error = _ConfigVerNOutEP(hw);
+	else
+		error = _ConfigVerTOutEP(hw);
+	if (error)
+		goto err_out;
+	error = _out_ep_mapping(hw);
+	if (error)
+		goto err_out;
+err_out:
+	return error;
+}
+
+u16 rtl8192cu_mq_to_hwq(u16 fc, u16 mac80211_queue_index)
+{
+	u16 hw_queue_index;
+
+	if (unlikely(ieee80211_is_beacon(fc))) {
+		hw_queue_index = RTL_TXQ_BCN;
+		goto out;
+	}
+	if (ieee80211_is_mgmt(fc)) {
+		hw_queue_index = RTL_TXQ_MGT;
+		goto out;
+	}
+	switch (mac80211_queue_index) {
+	case 0:
+		hw_queue_index = RTL_TXQ_VO;
+		break;
+	case 1:
+		hw_queue_index = RTL_TXQ_VI;
+		break;
+	case 2:
+		hw_queue_index = RTL_TXQ_BE;
+		break;
+	case 3:
+		hw_queue_index = RTL_TXQ_BK;
+		break;
+	default:
+		hw_queue_index = RTL_TXQ_BE;
+		RT_ASSERT(false, ("QSLT_BE queue, skb_queue:%d\n",
+			  mac80211_queue_index));
+		break;
+	}
+out:
+	return hw_queue_index;
+}
+
+static enum rtl_desc_qsel _rtl8192cu_mq_to_descq(struct ieee80211_hw *hw,
+					 u16 fc, u16 mac80211_queue_index)
+{
+	enum rtl_desc_qsel qsel;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (unlikely(ieee80211_is_beacon(fc))) {
+		qsel = QSLT_BEACON;
+		goto out;
+	}
+	if (ieee80211_is_mgmt(fc)) {
+		qsel = QSLT_MGNT;
+		goto out;
+	}
+	switch (mac80211_queue_index) {
+	case 0:	/* VO */
+		qsel = QSLT_VO;
+		RT_TRACE(rtlpriv, COMP_USB, DBG_DMESG,
+			 ("VO queue, set qsel = 0x%x\n", QSLT_VO));
+		break;
+	case 1:	/* VI */
+		qsel = QSLT_VI;
+		RT_TRACE(rtlpriv, COMP_USB, DBG_DMESG,
+			 ("VI queue, set qsel = 0x%x\n", QSLT_VI));
+		break;
+	case 3:	/* BK */
+		qsel = QSLT_BK;
+		RT_TRACE(rtlpriv, COMP_USB, DBG_DMESG,
+			 ("BK queue, set qsel = 0x%x\n", QSLT_BK));
+		break;
+	case 2:	/* BE */
+	default:
+		qsel = QSLT_BE;
+		RT_TRACE(rtlpriv, COMP_USB, DBG_DMESG,
+			 ("BE queue, set qsel = 0x%x\n", QSLT_BE));
+		break;
+	}
+out:
+	return qsel;
+}
+
+/* =============================================================== */
+
+/*----------------------------------------------------------------------
+ *
+ *	Rx handler
+ *
+ *---------------------------------------------------------------------- */
+bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
+			   struct rtl_stats *stats,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *p_desc, struct sk_buff *skb)
+{
+	struct rx_fwinfo_92c *p_drvinfo;
+	struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
+	u32 phystatus = GET_RX_DESC_PHY_STATUS(pdesc);
+
+	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
+	stats->rx_drvinfo_size = (u8)GET_RX_DESC_DRVINFO_SIZE(pdesc) *
+				 RX_DRV_INFO_SIZE_UNIT;
+	stats->rx_bufshift = (u8) (GET_RX_DESC_SHIFT(pdesc) & 0x03);
+	stats->b_icv = (u16) GET_RX_DESC_ICV(pdesc);
+	stats->b_crc = (u16) GET_RX_DESC_CRC32(pdesc);
+	stats->b_hwerror = (stats->b_crc | stats->b_icv);
+	stats->decrypted = !GET_RX_DESC_SWDEC(pdesc);
+	stats->rate = (u8) GET_RX_DESC_RX_MCS(pdesc);
+	stats->b_shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
+	stats->b_isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
+	stats->b_isampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
+				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
+	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
+	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.channel->band;
+	if (GET_RX_DESC_CRC32(pdesc))
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (!GET_RX_DESC_SWDEC(pdesc))
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (GET_RX_DESC_BW(pdesc))
+		rx_status->flag |= RX_FLAG_40MHZ;
+	if (GET_RX_DESC_RX_HT(pdesc))
+		rx_status->flag |= RX_FLAG_HT;
+	rx_status->flag |= RX_FLAG_TSFT;
+	if (stats->decrypted)
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	rx_status->rate_idx = _rtl92c_rate_mapping(hw,
+						(bool)GET_RX_DESC_RX_HT(pdesc),
+						(u8)GET_RX_DESC_RX_MCS(pdesc),
+						(bool)GET_RX_DESC_PAGGR(pdesc));
+	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
+	if (phystatus == true) {
+		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
+		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
+						 p_drvinfo);
+	}
+	/*rx_status->qual = stats->signal; */
+	rx_status->signal = stats->rssi + 10;
+	/*rx_status->noise = -stats->noise; */
+	return true;
+}
+
+#define RTL_RX_DRV_INFO_UNIT		8
+
+static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status =
+		 (struct ieee80211_rx_status *)IEEE80211_SKB_RXCB(skb);
+	u32 skb_len, pkt_len, drvinfo_len;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 *rxdesc;
+	struct rtl_stats stats = {
+		.signal = 0,
+		.noise = -98,
+		.rate = 0,
+	};
+	struct rx_fwinfo_92c *p_drvinfo;
+	bool bv;
+	u16 fc;
+	struct ieee80211_hdr *hdr;
+
+	memset(rx_status, 0, sizeof(rx_status));
+	rxdesc	= skb->data;
+	skb_len	= skb->len;
+	drvinfo_len = (GET_RX_DESC_DRVINFO_SIZE(rxdesc) * RTL_RX_DRV_INFO_UNIT);
+	pkt_len		= GET_RX_DESC_PKT_LEN(rxdesc);
+	/* TODO: Error recovery. drop this skb or something. */
+	WARN_ON(skb_len < (pkt_len + RTL_RX_DESC_SIZE + drvinfo_len));
+	stats.length = (u16) GET_RX_DESC_PKT_LEN(rxdesc);
+	stats.rx_drvinfo_size = (u8)GET_RX_DESC_DRVINFO_SIZE(rxdesc) *
+				RX_DRV_INFO_SIZE_UNIT;
+	stats.rx_bufshift = (u8) (GET_RX_DESC_SHIFT(rxdesc) & 0x03);
+	stats.b_icv = (u16) GET_RX_DESC_ICV(rxdesc);
+	stats.b_crc = (u16) GET_RX_DESC_CRC32(rxdesc);
+	stats.b_hwerror = (stats.b_crc | stats.b_icv);
+	stats.decrypted = !GET_RX_DESC_SWDEC(rxdesc);
+	stats.rate = (u8) GET_RX_DESC_RX_MCS(rxdesc);
+	stats.b_shortpreamble = (u16) GET_RX_DESC_SPLCP(rxdesc);
+	stats.b_isampdu = (bool) (GET_RX_DESC_PAGGR(rxdesc) == 1);
+	stats.b_isampdu = (bool) ((GET_RX_DESC_PAGGR(rxdesc) == 1)
+				   && (GET_RX_DESC_FAGGR(rxdesc) == 1));
+	stats.timestamp_low = GET_RX_DESC_TSFL(rxdesc);
+	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
+	/* TODO: is center_freq changed when doing scan? */
+	/* TODO: Shall we add protection or just skip those two step? */
+	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.channel->band;
+	if (GET_RX_DESC_CRC32(rxdesc))
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (!GET_RX_DESC_SWDEC(rxdesc))
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (GET_RX_DESC_BW(rxdesc))
+		rx_status->flag |= RX_FLAG_40MHZ;
+	if (GET_RX_DESC_RX_HT(rxdesc))
+		rx_status->flag |= RX_FLAG_HT;
+	/* Data rate */
+	rx_status->rate_idx = _rtl92c_rate_mapping(hw,
+						(bool)GET_RX_DESC_RX_HT(rxdesc),
+						(u8)GET_RX_DESC_RX_MCS(rxdesc),
+						(bool)GET_RX_DESC_PAGGR(rxdesc)
+						);
+	/*  There is a phy status after this rx descriptor. */
+	if (GET_RX_DESC_PHY_STATUS(rxdesc)) {
+		p_drvinfo = (struct rx_fwinfo_92c *)(rxdesc + RTL_RX_DESC_SIZE);
+		rtl92c_translate_rx_signal_stuff(hw, skb, &stats,
+				 (struct rx_desc_92c *)rxdesc, p_drvinfo);
+	}
+	skb_pull(skb, (drvinfo_len + RTL_RX_DESC_SIZE));
+	hdr = (struct ieee80211_hdr *)(skb->data);
+	fc = le16_to_cpu(hdr->frame_control);
+	bv = ieee80211_is_probe_resp(fc);
+	if (bv)
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("Got probe response frame.\n"));
+	if (ieee80211_is_beacon(fc))
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("Got beacon frame.\n"));
+	if (ieee80211_is_data(fc))
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("Got data frame.\n"));
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+		 ("Fram: fc = 0x%X addr1 = 0x%02X:0x%02X:0x%02X:0x%02X:0x%02X:"
+		 "0x%02X\n", fc, (u32)hdr->addr1[0], (u32)hdr->addr1[1],
+		 (u32)hdr->addr1[2], (u32)hdr->addr1[3], (u32)hdr->addr1[4],
+		 (u32)hdr->addr1[5]));
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(hw, skb);
+}
+
+void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb)
+{
+	_rtl_rx_process(hw, skb);
+}
+
+void rtl8192c_rx_segregate_hdl(
+	struct ieee80211_hw *hw,
+	struct sk_buff *skb,
+	struct sk_buff_head *skb_list)
+{
+}
+
+/*----------------------------------------------------------------------
+ *
+ *	Tx handler
+ *
+ *---------------------------------------------------------------------- */
+void rtl8192c_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb)
+{
+}
+
+int rtl8192c_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
+			 struct sk_buff *skb)
+{
+	return 0;
+}
+
+struct sk_buff *rtl8192c_tx_aggregate_hdl(struct ieee80211_hw *hw,
+					   struct sk_buff_head *list)
+{
+	return skb_dequeue(list);
+}
+
+/*======================================== trx ===============================*/
+
+static void _rtl_fill_usb_tx_desc(u8 *txdesc)
+{
+	SET_TX_DESC_OWN(txdesc, 1);
+	SET_TX_DESC_LAST_SEG(txdesc, 1);
+	SET_TX_DESC_FIRST_SEG(txdesc, 1);
+}
+/**
+ *	For HW recovery information
+ */
+static void _rtl_tx_desc_checksum(u8 *txdesc)
+{
+	u16 *ptr = (u16 *)txdesc;
+	u16	checksum = 0;
+	u32 index;
+
+	/* Clear first */
+	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
+	for (index = 0; index < 16; index++)
+		checksum = checksum ^ le16_to_cpu(*(ptr + index));
+	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, checksum);
+}
+
+void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
+			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	bool b_defaultadapter = true;
+	struct ieee80211_sta *sta = ieee80211_find_sta(mac->vif, mac->bssid);
+	struct rtl_tcb_desc tcb_desc;
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+	u16 seq_number;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	u8 rate_flag = info->control.rates[0].flags;
+	u16 pktlen = skb->len;
+	enum rtl_desc_qsel fw_qsel = _rtl8192cu_mq_to_descq(hw, fc,
+						skb_get_queue_mapping(skb));
+	u8 *txdesc;
+
+	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+	rtl_get_tcb_desc(hw, info, skb, &tcb_desc);
+	txdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
+	memset(txdesc, 0, RTL_TX_HEADER_SIZE);
+	SET_TX_DESC_PKT_SIZE(txdesc, pktlen);
+	SET_TX_DESC_LINIP(txdesc, 0);
+	SET_TX_DESC_PKT_OFFSET(txdesc, RTL_DUMMY_OFFSET);
+	SET_TX_DESC_OFFSET(txdesc, RTL_TX_HEADER_SIZE);
+	SET_TX_DESC_TX_RATE(txdesc, tcb_desc.hw_rate);
+	if (tcb_desc.use_shortgi || tcb_desc.use_shortpreamble)
+		SET_TX_DESC_DATA_SHORTGI(txdesc, 1);
+	if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
+		    info->flags & IEEE80211_TX_CTL_AMPDU) {
+		SET_TX_DESC_AGG_ENABLE(txdesc, 1);
+		SET_TX_DESC_MAX_AGG_NUM(txdesc, 0x14);
+	} else {
+		SET_TX_DESC_AGG_BREAK(txdesc, 1);
+	}
+	SET_TX_DESC_SEQ(txdesc, seq_number);
+	SET_TX_DESC_RTS_ENABLE(txdesc, ((tcb_desc.b_rts_enable &&
+			       !tcb_desc.b_cts_enable) ? 1 : 0));
+	SET_TX_DESC_HW_RTS_ENABLE(txdesc, ((tcb_desc.b_rts_enable ||
+				  tcb_desc.b_cts_enable) ? 1 : 0));
+	SET_TX_DESC_CTS2SELF(txdesc, ((tcb_desc.b_cts_enable) ? 1 : 0));
+	SET_TX_DESC_RTS_STBC(txdesc, ((tcb_desc.b_rts_stbc) ? 1 : 0));
+	SET_TX_DESC_RTS_RATE(txdesc, tcb_desc.rts_rate);
+	SET_TX_DESC_RTS_BW(txdesc, 0);
+	SET_TX_DESC_RTS_SC(txdesc, tcb_desc.rts_sc);
+	SET_TX_DESC_RTS_SHORT(txdesc,
+			      ((tcb_desc.rts_rate <= DESC92C_RATE54M) ?
+			       (tcb_desc.b_rts_use_shortpreamble ? 1 : 0)
+			       : (tcb_desc.b_rts_use_shortgi ? 1 : 0)));
+	if (mac->bw_40) {
+		if (tcb_desc.b_packet_bw) {
+			SET_TX_DESC_DATA_BW(txdesc, 1);
+			SET_TX_DESC_DATA_SC(txdesc, 3);
+		} else {
+			SET_TX_DESC_DATA_BW(txdesc, 0);
+				if (rate_flag & IEEE80211_TX_RC_DUP_DATA)
+					SET_TX_DESC_DATA_SC(txdesc,
+							  mac->cur_40_prime_sc);
+			}
+	} else {
+		SET_TX_DESC_DATA_BW(txdesc, 0);
+		SET_TX_DESC_DATA_SC(txdesc, 0);
+	}
+	if (sta) {
+		u8 ampdu_density = sta->ht_cap.ampdu_density;
+		SET_TX_DESC_AMPDU_DENSITY(txdesc, ampdu_density);
+	}
+	if (info->control.hw_key) {
+		struct ieee80211_key_conf *keyconf = info->control.hw_key;
+		switch (keyconf->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+			SET_TX_DESC_SEC_TYPE(txdesc, 0x1);
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			SET_TX_DESC_SEC_TYPE(txdesc, 0x3);
+			break;
+		default:
+			SET_TX_DESC_SEC_TYPE(txdesc, 0x0);
+			break;
+		}
+	}
+	SET_TX_DESC_PKT_ID(txdesc, 0);
+	SET_TX_DESC_QUEUE_SEL(txdesc, fw_qsel);
+	SET_TX_DESC_DATA_RATE_FB_LIMIT(txdesc, 0x1F);
+	SET_TX_DESC_RTS_RATE_FB_LIMIT(txdesc, 0xF);
+	SET_TX_DESC_DISABLE_FB(txdesc, 0);
+	SET_TX_DESC_USE_RATE(txdesc, tcb_desc.use_driver_rate ? 1 : 0);
+	if (ieee80211_is_data_qos(fc)) {
+		if (mac->rdg_en) {
+			RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
+				 ("Enable RDG function.\n"));
+			SET_TX_DESC_RDG_ENABLE(txdesc, 1);
+			SET_TX_DESC_HTC(txdesc, 1);
+		}
+	}
+	if (rtlpriv->dm.b_useramask) {
+		SET_TX_DESC_RATE_ID(txdesc, tcb_desc.ratr_index);
+		SET_TX_DESC_MACID(txdesc, tcb_desc.mac_id);
+	} else {
+		SET_TX_DESC_RATE_ID(txdesc, 0xC + tcb_desc.ratr_index);
+		SET_TX_DESC_MACID(txdesc, tcb_desc.ratr_index);
+	}
+	if ((!ieee80211_is_data_qos(fc)) && ppsc->b_leisure_ps &&
+	      ppsc->b_fwctrl_lps) {
+		SET_TX_DESC_HWSEQ_EN(txdesc, 1);
+		SET_TX_DESC_PKT_ID(txdesc, 8);
+		if (!b_defaultadapter)
+			SET_TX_DESC_QOS(txdesc, 1);
+	}
+	if (ieee80211_has_morefrags(fc))
+		SET_TX_DESC_MORE_FRAG(txdesc, 1);
+	if (is_multicast_ether_addr(ieee80211_get_DA(hdr)) ||
+	    is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
+		SET_TX_DESC_BMC(txdesc, 1);
+	_rtl_fill_usb_tx_desc(txdesc);
+	_rtl_tx_desc_checksum(txdesc);
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, (" %s ==>\n", __func__));
+}
+
+void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
+			      u32 buffer_len, bool bIsPsPoll)
+{
+	/* Clear all status */
+	memset(pDesc, 0, RTL_TX_HEADER_SIZE);
+	SET_TX_DESC_FIRST_SEG(pDesc, 1); /* bFirstSeg; */
+	SET_TX_DESC_LAST_SEG(pDesc, 1); /* bLastSeg; */
+	SET_TX_DESC_OFFSET(pDesc, RTL_TX_HEADER_SIZE); /* Offset = 32 */
+	SET_TX_DESC_PKT_SIZE(pDesc, buffer_len); /* Buffer size + command hdr */
+	SET_TX_DESC_QUEUE_SEL(pDesc, QSLT_MGNT); /* Fixed queue of Mgnt queue */
+	/* Set NAVUSEHDR to prevent Ps-poll AId filed to be changed to error
+	 * vlaue by Hw. */
+	if (bIsPsPoll) {
+		SET_TX_DESC_NAV_USE_HDR(pDesc, 1);
+	} else {
+		SET_TX_DESC_HWSEQ_EN(pDesc, 1); /* Hw set sequence number */
+		SET_TX_DESC_PKT_ID(pDesc, 0x100); /* set bit3 to 1. */
+	}
+	SET_TX_DESC_USE_RATE(pDesc, 1); /* use data rate which is set by Sw */
+	SET_TX_DESC_OWN(pDesc, 1);
+	SET_TX_DESC_TX_RATE(pDesc, DESC92C_RATE1M);
+	_rtl_tx_desc_checksum(pDesc);
+}
+
+void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
+			     u8 *pdesc, bool b_firstseg,
+			     bool b_lastseg, struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 fw_queue = QSLT_BEACON;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	u16 fc = le16_to_cpu(hdr->frame_control);
+
+	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
+	if (b_firstseg)
+		SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE);
+	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
+	SET_TX_DESC_SEQ(pdesc, 0);
+	SET_TX_DESC_LINIP(pdesc, 0);
+	SET_TX_DESC_QUEUE_SEL(pdesc, fw_queue);
+	SET_TX_DESC_FIRST_SEG(pdesc, 1);
+	SET_TX_DESC_LAST_SEG(pdesc, 1);
+	SET_TX_DESC_RATE_ID(pdesc, 7);
+	SET_TX_DESC_MACID(pdesc, 0);
+	SET_TX_DESC_OWN(pdesc, 1);
+	SET_TX_DESC_PKT_SIZE((u8 *) pdesc, (u16) (skb->len));
+	SET_TX_DESC_FIRST_SEG(pdesc, 1);
+	SET_TX_DESC_LAST_SEG(pdesc, 1);
+	SET_TX_DESC_OFFSET(pdesc, 0x20);
+	SET_TX_DESC_USE_RATE(pdesc, 1);
+	if (!ieee80211_is_data_qos(fc)) {
+		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
+		SET_TX_DESC_PKT_ID(pdesc, 8);
+	}
+	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD, "H2C Tx Cmd Content\n",
+		      pdesc, RTL_TX_DESC_SIZE);
+}
+
+bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	return true;
+}
+
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
new file mode 100644
index 0000000..d5ea72c
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -0,0 +1,404 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92CU_TRX_H__
+#define __RTL92CU_TRX_H__
+
+#define RTL92C_USB_BULK_IN_NUM			1
+#define RTL92C_NUM_RX_URBS			8
+#define RTL92C_NUM_TX_URBS			32
+
+#define RTL92C_SIZE_MAX_RX_BUFFER		15360   /* 8192 */
+
+enum usb_rx_agg_mode {
+	USB_RX_AGG_DISABLE,
+	USB_RX_AGG_DMA,
+	USB_RX_AGG_USB,
+	USB_RX_AGG_DMA_USB
+};
+
+#define TX_SELE_HQ				BIT(0)	/* High Queue */
+#define TX_SELE_LQ				BIT(1)	/* Low Queue */
+#define TX_SELE_NQ				BIT(2)	/* Normal Queue */
+
+#define RTL_USB_TX_AGG_NUM_DESC			5
+
+#define RTL_USB_RX_AGG_PAGE_NUM			4
+#define RTL_USB_RX_AGG_PAGE_TIMEOUT		3
+
+#define RTL_USB_RX_AGG_BLOCK_NUM		5
+#define RTL_USB_RX_AGG_BLOCK_TIMEOUT		3
+
+/*======================== rx status =========================================*/
+
+struct rx_drv_info_92c {
+	/*
+	 * Driver info contain PHY status and other variabel size info
+	 * PHY Status content as below
+	 */
+
+	/* DWORD 0 */
+	u8 gain_trsw[4];
+
+	/* DWORD 1 */
+	u8 pwdb_all;
+	u8 cfosho[4];
+
+	/* DWORD 2 */
+	u8 cfotail[4];
+
+	/* DWORD 3 */
+	s8 rxevm[2];
+	s8 rxsnr[4];
+
+	/* DWORD 4 */
+	u8 pdsnr[2];
+
+	/* DWORD 5 */
+	u8 csi_current[2];
+	u8 csi_target[2];
+
+	/* DWORD 6 */
+	u8 sigevm;
+	u8 max_ex_pwr;
+	u8 ex_intf_flag:1;
+	u8 sgi_en:1;
+	u8 rxsc:2;
+	u8 reserve:4;
+} __packed;
+
+
+/* DWORD 0 */
+#define GET_RX_DESC_PKT_LEN(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 0, 14)
+#define GET_RX_DESC_CRC32(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 14, 1)
+#define GET_RX_DESC_ICV(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 15, 1)
+#define GET_RX_DESC_DRVINFO_SIZE(__rxdesc)	\
+	LE_BITS_TO_4BYTE(__rxdesc, 16, 4)
+#define GET_RX_DESC_SECURITY(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 20, 3)
+#define GET_RX_DESC_QOS(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 23, 1)
+#define GET_RX_DESC_SHIFT(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 24, 2)
+#define GET_RX_DESC_PHY_STATUS(__rxdesc)	\
+	LE_BITS_TO_4BYTE(__rxdesc, 26, 1)
+#define GET_RX_DESC_SWDEC(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 27, 1)
+#define GET_RX_DESC_LAST_SEG(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 28, 1)
+#define GET_RX_DESC_FIRST_SEG(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 29, 1)
+#define GET_RX_DESC_EOR(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 30, 1)
+#define GET_RX_DESC_OWN(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc, 31, 1)
+
+/* DWORD 1 */
+#define GET_RX_DESC_MACID(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 0, 5)
+#define GET_RX_DESC_TID(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 5, 4)
+#define GET_RX_DESC_PAGGR(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 14, 1)
+#define GET_RX_DESC_FAGGR(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 15, 1)
+#define GET_RX_DESC_A1_FIT(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 16, 4)
+#define GET_RX_DESC_A2_FIT(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 20, 4)
+#define GET_RX_DESC_PAM(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 24, 1)
+#define GET_RX_DESC_PWR(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 25, 1)
+#define GET_RX_DESC_MORE_DATA(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 26, 1)
+#define GET_RX_DESC_MORE_FRAG(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 27, 1)
+#define GET_RX_DESC_TYPE(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 28, 2)
+#define GET_RX_DESC_MC(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 30, 1)
+#define GET_RX_DESC_BC(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+4, 31, 1)
+
+/* DWORD 2 */
+#define GET_RX_DESC_SEQ(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+8, 0, 12)
+#define GET_RX_DESC_FRAG(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+8, 12, 4)
+#define GET_RX_DESC_USB_AGG_PKTNUM(__rxdesc)	\
+	LE_BITS_TO_4BYTE(__rxdesc+8, 16, 8)
+#define GET_RX_DESC_NEXT_IND(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+8, 30, 1)
+
+/* DWORD 3 */
+#define GET_RX_DESC_RX_MCS(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 0, 6)
+#define GET_RX_DESC_RX_HT(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 6, 1)
+#define GET_RX_DESC_AMSDU(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 7, 1)
+#define GET_RX_DESC_SPLCP(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 8, 1)
+#define GET_RX_DESC_BW(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 9, 1)
+#define GET_RX_DESC_HTC(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 10, 1)
+#define GET_RX_DESC_TCP_CHK_RPT(__rxdesc)	\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 11, 1)
+#define GET_RX_DESC_IP_CHK_RPT(__rxdesc)	\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 12, 1)
+#define GET_RX_DESC_TCP_CHK_VALID(__rxdesc)	\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 13, 1)
+#define GET_RX_DESC_HWPC_ERR(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 14, 1)
+#define GET_RX_DESC_HWPC_IND(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 15, 1)
+#define GET_RX_DESC_IV0(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+12, 16, 16)
+
+/* DWORD 4 */
+#define GET_RX_DESC_IV1(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+16, 0, 32)
+
+/* DWORD 5 */
+#define GET_RX_DESC_TSFL(__rxdesc)		\
+	LE_BITS_TO_4BYTE(__rxdesc+20, 0, 32)
+
+/*======================= tx desc ============================================*/
+
+/* Dword 0 */
+#define SET_TX_DESC_PKT_SIZE(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 0, 16, __value)
+#define SET_TX_DESC_OFFSET(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 16, 8, __value)
+#define SET_TX_DESC_BMC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 24, 1, __value)
+#define SET_TX_DESC_HTC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 25, 1, __value)
+#define SET_TX_DESC_LAST_SEG(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 26, 1, __value)
+#define SET_TX_DESC_FIRST_SEG(__txdesc, __value)	\
+	 SET_BITS_TO_LE_4BYTE(__txdesc, 27, 1, __value)
+#define SET_TX_DESC_LINIP(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 28, 1, __value)
+#define SET_TX_DESC_NO_ACM(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 29, 1, __value)
+#define SET_TX_DESC_GF(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 30, 1, __value)
+#define SET_TX_DESC_OWN(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc, 31, 1, __value)
+
+
+/* Dword 1 */
+#define SET_TX_DESC_MACID(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 0, 5, __value)
+#define SET_TX_DESC_AGG_ENABLE(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 5, 1, __value)
+#define SET_TX_DESC_AGG_BREAK(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 6, 1, __value)
+#define SET_TX_DESC_RDG_ENABLE(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 7, 1, __value)
+#define SET_TX_DESC_QUEUE_SEL(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 8, 5, __value)
+#define SET_TX_DESC_RDG_NAV_EXT(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 13, 1, __value)
+#define SET_TX_DESC_LSIG_TXOP_EN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 14, 1, __value)
+#define SET_TX_DESC_PIFS(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 15, 1, __value)
+#define SET_TX_DESC_RATE_ID(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 16, 4, __value)
+#define SET_TX_DESC_RA_BRSR_ID(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 16, 4, __value)
+#define SET_TX_DESC_NAV_USE_HDR(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 20, 1, __value)
+#define SET_TX_DESC_EN_DESC_ID(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 21, 1, __value)
+#define SET_TX_DESC_SEC_TYPE(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 22, 2, __value)
+#define SET_TX_DESC_PKT_OFFSET(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+4, 26, 5, __value)
+
+/* Dword 2 */
+#define SET_TX_DESC_RTS_RC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 0, 6, __value)
+#define SET_TX_DESC_DATA_RC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 6, 6, __value)
+#define SET_TX_DESC_BAR_RTY_TH(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 14, 2, __value)
+#define SET_TX_DESC_MORE_FRAG(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 17, 1, __value)
+#define SET_TX_DESC_RAW(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 18, 1, __value)
+#define SET_TX_DESC_CCX(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 19, 1, __value)
+#define SET_TX_DESC_AMPDU_DENSITY(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 20, 3, __value)
+#define SET_TX_DESC_ANTSEL_A(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 24, 1, __value)
+#define SET_TX_DESC_ANTSEL_B(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 25, 1, __value)
+#define SET_TX_DESC_TX_ANT_CCK(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 26, 2, __value)
+#define SET_TX_DESC_TX_ANTL(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 28, 2, __value)
+#define SET_TX_DESC_TX_ANT_HT(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+8, 30, 2, __value)
+
+/* Dword 3 */
+#define SET_TX_DESC_NEXT_HEAP_PAGE(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+12, 0, 8, __value)
+#define SET_TX_DESC_TAIL_PAGE(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+12, 8, 8, __value)
+#define SET_TX_DESC_SEQ(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+12, 16, 12, __value)
+#define SET_TX_DESC_PKT_ID(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+12, 28, 4, __value)
+
+/* Dword 4 */
+#define SET_TX_DESC_RTS_RATE(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 0, 5, __value)
+#define SET_TX_DESC_AP_DCFE(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 5, 1, __value)
+#define SET_TX_DESC_QOS(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 6, 1, __value)
+#define SET_TX_DESC_HWSEQ_EN(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 7, 1, __value)
+#define SET_TX_DESC_USE_RATE(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 8, 1, __value)
+#define SET_TX_DESC_DISABLE_RTS_FB(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 9, 1, __value)
+#define SET_TX_DESC_DISABLE_FB(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 10, 1, __value)
+#define SET_TX_DESC_CTS2SELF(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 11, 1, __value)
+#define SET_TX_DESC_RTS_ENABLE(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 12, 1, __value)
+#define SET_TX_DESC_HW_RTS_ENABLE(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 13, 1, __value)
+#define SET_TX_DESC_WAIT_DCTS(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 18, 1, __value)
+#define SET_TX_DESC_CTS2AP_EN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 19, 1, __value)
+#define SET_TX_DESC_DATA_SC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 20, 2, __value)
+#define SET_TX_DESC_DATA_STBC(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 22, 2, __value)
+#define SET_TX_DESC_DATA_SHORT(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 24, 1, __value)
+#define SET_TX_DESC_DATA_BW(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 25, 1, __value)
+#define SET_TX_DESC_RTS_SHORT(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 26, 1, __value)
+#define SET_TX_DESC_RTS_BW(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 27, 1, __value)
+#define SET_TX_DESC_RTS_SC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 28, 2, __value)
+#define SET_TX_DESC_RTS_STBC(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+16, 30, 2, __value)
+
+/* Dword 5 */
+#define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc+20, 0, 6, __val)
+#define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc+20, 6, 1, __val)
+#define SET_TX_DESC_CCX_TAG(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc+20, 7, 1, __val)
+#define SET_TX_DESC_DATA_RATE_FB_LIMIT(__txdesc, __value) \
+	SET_BITS_TO_LE_4BYTE(__txdesc+20, 8, 5, __value)
+#define SET_TX_DESC_RTS_RATE_FB_LIMIT(__txdesc, __value) \
+	SET_BITS_TO_LE_4BYTE(__txdesc+20, 13, 4, __value)
+#define SET_TX_DESC_RETRY_LIMIT_ENABLE(__txdesc, __value) \
+	SET_BITS_TO_LE_4BYTE(__txdesc+20, 17, 1, __value)
+#define SET_TX_DESC_DATA_RETRY_LIMIT(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+20, 18, 6, __value)
+#define SET_TX_DESC_USB_TXAGG_NUM(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+20, 24, 8, __value)
+
+/* Dword 6 */
+#define SET_TX_DESC_TXAGC_A(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 0, 5, __value)
+#define SET_TX_DESC_TXAGC_B(__txdesc, __value)		\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 5, 5, __value)
+#define SET_TX_DESC_USB_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 10, 1, __value)
+#define SET_TX_DESC_MAX_AGG_NUM(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 11, 5, __value)
+#define SET_TX_DESC_MCSG1_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 16, 4, __value)
+#define SET_TX_DESC_MCSG2_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 20, 4, __value)
+#define SET_TX_DESC_MCSG3_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 24, 4, __value)
+#define SET_TX_DESC_MCSG7_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+24, 28, 4, __value)
+
+/* Dword 7 */
+#define SET_TX_DESC_TX_DESC_CHECKSUM(__txdesc, __value) \
+	SET_BITS_TO_LE_4BYTE(__txdesc+28, 0, 16, __value)
+#define SET_TX_DESC_MCSG4_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+28, 16, 4, __value)
+#define SET_TX_DESC_MCSG5_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+28, 20, 4, __value)
+#define SET_TX_DESC_MCSG6_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+28, 24, 4, __value)
+#define SET_TX_DESC_MCSG15_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_TO_LE_4BYTE(__txdesc+28, 28, 4, __value)
+
+
+int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw);
+u16 rtl8192cu_mq_to_hwq(u16 fc, u16 mac80211_queue_index);
+bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
+			   struct rtl_stats *stats,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *p_desc, struct sk_buff *skb);
+void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb);
+void rtl8192c_rx_segregate_hdl(struct ieee80211_hw *, struct sk_buff *,
+			       struct sk_buff_head *);
+void rtl8192c_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb);
+int rtl8192c_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
+			 struct sk_buff *skb);
+struct sk_buff *rtl8192c_tx_aggregate_hdl(struct ieee80211_hw *,
+					   struct sk_buff_head *);
+void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
+			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc);
+void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
+			      u32 buffer_len, bool bIsPsPoll);
+void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
+			     u8 *pdesc, bool b_firstseg,
+			     bool b_lastseg, struct sk_buff *skb);
+bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
+
+#endif
+
-- 
1.7.1

