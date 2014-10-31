Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41277 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 11:07:56 -0400
Received: by mail-pd0-f182.google.com with SMTP id fp1so7364409pdb.41
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2014 08:07:56 -0700 (PDT)
Message-ID: <5453A5CF.90107@lwfinger.net> (sfid-20141031_160800_763596_5EED052C)
Date: Fri, 31 Oct 2014 10:07:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "S. Gilles" <sgilles@terpmail.umd.edu>
CC: "S. Gilles" <sgilles@umd.edu>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: Boot failure with bad RIP value
References: <20141013234509.GD22088@number18> <543C9B66.6050705@lwfinger.net> <20141014041313.GF22088@number18> <20141031135636.GB21718@number18>
In-Reply-To: <20141031135636.GB21718@number18>
Content-Type: multipart/mixed;
 boundary="------------010401030906050208090201"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010401030906050208090201
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2014 08:56 AM, S. Gilles wrote:
>> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
>
> Any progress on this, or duplication?  If this isn't replicable with
> the information in Bugzilla, I can provide anything requested.

Thanks for posting the PCI ID. I am currently on a family vacation, and I have 
had little time for driver problems, and none for chasing missing information.

The attached patches should fix the kernel crashes; however, I doubt that the 
driver will work. There seems to be a problem with DMA buffers that I have not 
had time to find.

Larry



--------------010401030906050208090201
Content-Type: text/x-patch;
 name="0002-rtlwifi-rtl8192ce-rtl8192de-rtl8192se-Fix-handling-f.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-rtlwifi-rtl8192ce-rtl8192de-rtl8192se-Fix-handling-f.pa";
 filename*1="tch"

>From bbaf5c9fc3bf1cf30576b546988e4e33cbd9c4a5 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 25 Oct 2014 23:39:08 -0500
Subject: [PATCH 2/7] rtlwifi: rtl8192ce: rtl8192de: rtl8192se: Fix handling
 for missing get_btc_status
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org,
    troy_tan@realsil.com.cn

The recent changes in checking for Bluetooth status added some callbacks to code
in rtlwifi. To make certain that all callbacks are defined, a dummy routine has been
added to rtlwifi, and the drivers that need to use it are modified.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/core.c         | 6 ++++++
 drivers/net/wireless/rtlwifi/core.h         | 1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c | 1 +
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c | 1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c | 1 +
 5 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index f6179bc..07dae0d 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1828,3 +1828,9 @@ const struct ieee80211_ops rtl_ops = {
 	.flush = rtl_op_flush,
 };
 EXPORT_SYMBOL_GPL(rtl_ops);
+
+bool rtl_btc_status_false(void)
+{
+	return false;
+}
+EXPORT_SYMBOL_GPL(rtl_btc_status_false);
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 59cd3b9..624e1dc 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -42,5 +42,6 @@ void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
 		     u32 mask, u32 data);
 void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data);
 bool rtl_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
+bool rtl_btc_status_false(void);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index d86b5b5..46ea076 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -244,6 +244,7 @@ static struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.phy_lc_calibrate = _rtl92ce_phy_lc_calibrate,
 	.phy_set_bw_mode_callback = rtl92ce_phy_set_bw_mode_callback,
 	.dm_dynamic_txpower = rtl92ce_dm_dynamic_txpower,
+	.get_btc_status = rtl_btc_status_false,
 };
 
 static struct rtl_mod_params rtl92ce_mod_params = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
index edab5a5..a0aba08 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -251,6 +251,7 @@ static struct rtl_hal_ops rtl8192de_hal_ops = {
 	.get_rfreg = rtl92d_phy_query_rf_reg,
 	.set_rfreg = rtl92d_phy_set_rf_reg,
 	.linked_set_reg = rtl92d_linked_set_reg,
+	.get_btc_status = rtl_btc_status_false,
 };
 
 static struct rtl_mod_params rtl92de_mod_params = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index 1bff2a0..5e16984 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -294,6 +294,7 @@ static struct rtl_hal_ops rtl8192se_hal_ops = {
 	.set_bbreg = rtl92s_phy_set_bb_reg,
 	.get_rfreg = rtl92s_phy_query_rf_reg,
 	.set_rfreg = rtl92s_phy_set_rf_reg,
+	.get_btc_status = rtl_btc_status_false,
 };
 
 static struct rtl_mod_params rtl92se_mod_params = {
-- 
2.1.1


--------------010401030906050208090201
Content-Type: text/x-patch;
 name="0005-rtlwifi-rtl8192ce-Add-missing-section-to-read-descri.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-rtlwifi-rtl8192ce-Add-missing-section-to-read-descri.pa";
 filename*1="tch"

>From 4f3d6a80198c539bbf200ff3a6dd00689b50bf78 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 25 Oct 2014 23:51:15 -0500
Subject: [PATCH 5/7] rtlwifi: rtl8192ce: Add missing section to read
 descriptor setting
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org,
    troy_tan@realsil.com.cn

The new version of rtlwifi needs code in rtl92ce_get_desc() that returns
the buffer address for read operations.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h | 2 ++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 831df10..9b660df 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -114,6 +114,8 @@
 	LE_BITS_TO_4BYTE(((__pcmdfbhdr) + 4), 16, 4)
 #define	GET_C2H_CMD_FEEDBACK_CCX_SEQ(__pcmdfbhdr)	\
 	LE_BITS_TO_4BYTE(((__pcmdfbhdr) + 4), 20, 12)
+#define GET_RX_STATUS_DESC_BUFF_ADDR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc + 24, 0, 32)
 
 #define CHIP_VER_B			BIT(4)
 #define CHIP_BONDING_IDENTIFIER(_value) (((_value) >> 22) & 0x3)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 2fb9c7a..dc3d20b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -728,6 +728,9 @@ u32 rtl92ce_get_desc(u8 *p_desc, bool istx, u8 desc_name)
 		case HW_DESC_RXPKT_LEN:
 			ret = GET_RX_DESC_PKT_LEN(pdesc);
 			break;
+		case HW_DESC_RXBUFF_ADDR:
+			ret = GET_RX_STATUS_DESC_BUFF_ADDR(pdesc);
+			break;
 		default:
 			RT_ASSERT(false, "ERR rxdesc :%d not process\n",
 				  desc_name);
-- 
2.1.1


--------------010401030906050208090201--
