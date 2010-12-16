Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38169 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab0LPOpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:45:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtlwifi: convert to __packed notation
Date: Thu, 16 Dec 2010 09:34:48 -0500
Message-Id: <1292510088-7449-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use "__packed" instead of "__attribute__ ((packed))"...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtlwifi/pci.h                 |    6 +++---
 .../net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h  |    6 +++---
 drivers/net/wireless/rtlwifi/wifi.h                |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index cdde858..d36a669 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -131,15 +131,15 @@ enum pci_bridge_vendor {
 
 struct rtl_rx_desc {
 	u32 dword[8];
-} __attribute__ ((packed));
+} __packed;
 
 struct rtl_tx_desc {
 	u32 dword[16];
-} __attribute__ ((packed));
+} __packed;
 
 struct rtl_tx_cmd_desc {
 	u32 dword[16];
-} __attribute__ ((packed));
+} __packed;
 
 struct rtl8192_tx_ring {
 	struct rtl_tx_desc *desc;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h
index 91e13c3..53d0e0a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h
@@ -535,7 +535,7 @@ struct rx_fwinfo_92c {
 	u8 sgi_en:1;
 	u8 rxsc:2;
 	u8 reserve:4;
-} __attribute__ ((packed));
+} __packed;
 
 struct tx_desc_92c {
 	u32 pktsize:16;
@@ -637,7 +637,7 @@ struct tx_desc_92c {
 	u32 nextdescaddress64;
 
 	u32 reserve_pass_pcie_mm_limit[4];
-} __attribute__ ((packed));
+} __packed;
 
 struct rx_desc_92c {
 	u32 length:14;
@@ -695,7 +695,7 @@ struct rx_desc_92c {
 	u32 bufferaddress;
 	u32 bufferaddress64;
 
-} __attribute__ ((packed));
+} __packed;
 
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr,
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 0dd6824..3844dc9 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -551,13 +551,13 @@ struct rtl_hdr_3addr {
 	u8 addr3[ETH_ALEN];
 	__le16 seq_ctl;
 	u8 payload[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct rtl_info_element {
 	u8 id;
 	u8 len;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct rtl_probe_rsp {
 	struct rtl_hdr_3addr header;
@@ -567,7 +567,7 @@ struct rtl_probe_rsp {
 	/*SSID, supported rates, FH params, DS params,
 	   CF params, IBSS params, TIM (if beacon), RSN */
 	struct rtl_info_element info_element[0];
-} __attribute__ ((packed));
+} __packed;
 
 /*LED related.*/
 /*ledpin Identify how to implement this SW led.*/
@@ -589,7 +589,7 @@ struct rtl_qos_parameters {
 	u8 aifs;
 	u8 flag;
 	__le16 tx_op;
-} __attribute__ ((packed));
+} __packed;
 
 struct rt_smooth_data {
 	u32 elements[100];	/*array to store values */
-- 
1.7.3.3

