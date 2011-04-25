Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab1DYRwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:52:45 -0400
Date: Mon, 25 Apr 2011 12:52:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/18] rtlwifi: Change efuse routines addition of
 RTL8192SE and RTL8192DE
Message-ID: <4db5b4ec.nf9iAi5YOmnjjnIZ%Larry.Finger@lwfinger.net> (sfid-20110425_195251_166410_ED53D7C4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change efuse routines for addition of RTL8192SE and RTL8192DE code

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 efuse.c |  100 ++++++++++++++++++++++++++++++++++++++++------------------------
 efuse.h |    6 +++
 2 files changed, 68 insertions(+), 38 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
@@ -52,8 +52,6 @@ static const struct efuse_map RTL8712_SD
 	{11, 0, 0, 28}
 };
 
-static void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset,
-					u8 *pbuf);
 static void efuse_shadow_read_1byte(struct ieee80211_hw *hw, u16 offset,
 				    u8 *value);
 static void efuse_shadow_read_2byte(struct ieee80211_hw *hw, u16 offset,
@@ -79,7 +77,7 @@ static void efuse_word_enable_data_read(
 					u8 *targetdata);
 static u8 efuse_word_enable_data_write(struct ieee80211_hw *hw,
 				       u16 efuse_addr, u8 word_en, u8 *data);
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 bwrite,
+static void efuse_power_switch(struct ieee80211_hw *hw, u8 write,
 					u8 pwrstate);
 static u16 efuse_get_current_size(struct ieee80211_hw *hw);
 static u8 efuse_calculate_word_cnts(u8 word_en);
@@ -115,8 +113,10 @@ u8 efuse_read_1byte(struct ieee80211_hw
 	u8 bytetemp;
 	u8 temp;
 	u32 k = 0;
+	const u32 efuse_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
-	if (address < EFUSE_REAL_CONTENT_LEN) {
+	if (address < efuse_len) {
 		temp = address & 0xFF;
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 1,
 			       temp);
@@ -158,11 +158,13 @@ void efuse_write_1byte(struct ieee80211_
 	u8 bytetemp;
 	u8 temp;
 	u32 k = 0;
+	const u32 efuse_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("Addr=%x Data =%x\n", address, value));
 
-	if (address < EFUSE_REAL_CONTENT_LEN) {
+	if (address < efuse_len) {
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL], value);
 
 		temp = address & 0xFF;
@@ -198,7 +200,7 @@ void efuse_write_1byte(struct ieee80211_
 
 }
 
-static void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf)
+void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 value32;
@@ -233,24 +235,28 @@ void read_efuse(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[EFUSE_MAP_LEN];
+	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
 	u16 i;
 	u16 j;
-	u16 efuse_word[EFUSE_MAX_SECTION][EFUSE_MAX_WORD_UNIT];
+	const u16 efuse_max_section =
+		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
+	const u32 efuse_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
+	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
-	if ((_offset + _size_byte) > EFUSE_MAP_LEN) {
+	if ((_offset + _size_byte) > rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]) {
 		RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 			 ("read_efuse(): Invalid offset(%#x) with read "
 			  "bytes(%#x)!!\n", _offset, _size_byte));
 		return;
 	}
 
-	for (i = 0; i < EFUSE_MAX_SECTION; i++)
+	for (i = 0; i < efuse_max_section; i++)
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
 			efuse_word[i][j] = 0xFFFF;
 
@@ -262,10 +268,10 @@ void read_efuse(struct ieee80211_hw *hw,
 		efuse_addr++;
 	}
 
-	while ((*rtemp8 != 0xFF) && (efuse_addr < EFUSE_REAL_CONTENT_LEN)) {
+	while ((*rtemp8 != 0xFF) && (efuse_addr < efuse_len)) {
 		offset = ((*rtemp8 >> 4) & 0x0f);
 
-		if (offset < EFUSE_MAX_SECTION) {
+		if (offset < efuse_max_section) {
 			wren = (*rtemp8 & 0x0f);
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
 				("offset-%d Worden=%x\n", offset, wren));
@@ -281,7 +287,7 @@ void read_efuse(struct ieee80211_hw *hw,
 					efuse_utilized++;
 					efuse_word[offset][i] = (*rtemp8 & 0xff);
 
-					if (efuse_addr >= EFUSE_REAL_CONTENT_LEN)
+					if (efuse_addr >= efuse_len)
 						break;
 
 					RTPRINT(rtlpriv, FEEPROM,
@@ -294,7 +300,7 @@ void read_efuse(struct ieee80211_hw *hw,
 					efuse_word[offset][i] |=
 					    (((u16)*rtemp8 << 8) & 0xff00);
 
-					if (efuse_addr >= EFUSE_REAL_CONTENT_LEN)
+					if (efuse_addr >= efuse_len)
 						break;
 				}
 
@@ -305,13 +311,13 @@ void read_efuse(struct ieee80211_hw *hw,
 		RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
 			("Addr=%d\n", efuse_addr));
 		read_efuse_byte(hw, efuse_addr, rtemp8);
-		if (*rtemp8 != 0xFF && (efuse_addr < 512)) {
+		if (*rtemp8 != 0xFF && (efuse_addr < efuse_len)) {
 			efuse_utilized++;
 			efuse_addr++;
 		}
 	}
 
-	for (i = 0; i < EFUSE_MAX_SECTION; i++) {
+	for (i = 0; i < efuse_max_section; i++) {
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
 			efuse_tbl[(i * 8) + (j * 2)] =
 			    (efuse_word[i][j] & 0xff);
@@ -324,7 +330,7 @@ void read_efuse(struct ieee80211_hw *hw,
 		pbuf[i] = efuse_tbl[_offset + i];
 
 	rtlefuse->efuse_usedbytes = efuse_utilized;
-	efuse_usage = (u8)((efuse_utilized * 100) / EFUSE_REAL_CONTENT_LEN);
+	efuse_usage = (u8) ((efuse_utilized * 100) / efuse_len);
 	rtlefuse->efuse_usedpercentage = efuse_usage;
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_EFUSE_BYTES,
 				      (u8 *)&efuse_utilized);
@@ -478,9 +484,10 @@ void rtl_efuse_shadow_map_update(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
-	if (rtlefuse->autoload_failflag == true) {
-		memset(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0], 0xFF, 128);
-	} else
+	if (rtlefuse->autoload_failflag == true)
+		memset(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0], 0xFF,
+			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
+	else
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
 	memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
@@ -632,8 +639,9 @@ static int efuse_one_byte_write(struct i
 
 static void efuse_read_all_map(struct ieee80211_hw *hw, u8 * efuse)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	efuse_power_switch(hw, false, true);
-	read_efuse(hw, 0, 128, efuse);
+	read_efuse(hw, 0, rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], efuse);
 	efuse_power_switch(hw, false, false);
 }
 
@@ -641,7 +649,7 @@ static void efuse_read_data_case1(struct
 				u8 efuse_data, u8 offset, u8 *tmpdata,
 				u8 *readstate)
 {
-	bool bdataempty = true;
+	bool dataempty = true;
 	u8 hoffset;
 	u8 tmpidx;
 	u8 hworden;
@@ -657,13 +665,13 @@ static void efuse_read_data_case1(struct
 			    &efuse_data)) {
 				tmpdata[tmpidx] = efuse_data;
 				if (efuse_data != 0xff)
-					bdataempty = true;
+					dataempty = true;
 			}
 		}
 
-		if (bdataempty == true)
+		if (dataempty == true) {
 			*readstate = PG_STATE_DATA;
-		else {
+		} else {
 			*efuse_addr = *efuse_addr + (word_cnts * 2) + 1;
 			*readstate = PG_STATE_HEADER;
 		}
@@ -677,9 +685,7 @@ static void efuse_read_data_case1(struct
 static int efuse_pg_packet_read(struct ieee80211_hw *hw, u8 offset, u8 *data)
 {
 	u8 readstate = PG_STATE_HEADER;
-
 	bool continual = true;
-
 	u8 efuse_data, word_cnts = 0;
 	u16 efuse_addr = 0;
 	u8 tmpdata[8];
@@ -795,19 +801,20 @@ static void efuse_write_data_case1(struc
 					tmp_word_en &= (~BIT(1));
 
 				if ((target_pkt->word_en & BIT(2)) ^
-					(match_word_en & BIT(2)))
+				     (match_word_en & BIT(2)))
 					tmp_word_en &= (~BIT(2));
 
 				if ((target_pkt->word_en & BIT(3)) ^
-				    (match_word_en & BIT(3)))
+				     (match_word_en & BIT(3)))
 					tmp_word_en &= (~BIT(3));
 
 				if ((tmp_word_en & 0x0F) != 0x0F) {
 					*efuse_addr = efuse_get_current_size(hw);
 					target_pkt->offset = offset;
 					target_pkt->word_en = tmp_word_en;
-				} else
+				} else {
 					*continual = false;
+				}
 				*write_state = PG_STATE_HEADER;
 				*repeat_times += 1;
 				if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
@@ -842,9 +849,9 @@ static void efuse_write_data_case2(struc
 	efuse_one_byte_write(hw, *efuse_addr, pg_header);
 	efuse_one_byte_read(hw, *efuse_addr, &tmp_header);
 
-	if (tmp_header == pg_header)
+	if (tmp_header == pg_header) {
 		*write_state = PG_STATE_DATA;
-	else if (tmp_header == 0xFF) {
+	} else if (tmp_header == 0xFF) {
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
 		if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
@@ -871,11 +878,13 @@ static void efuse_write_data_case2(struc
 						      reorg_worden,
 						      originaldata);
 				*efuse_addr = efuse_get_current_size(hw);
-			 } else
+			} else {
 				*efuse_addr = *efuse_addr + (tmp_word_cnts * 2)
 					      + 1;
-		} else
+			}
+		} else {
 			*efuse_addr = *efuse_addr + (tmp_word_cnts * 2) + 1;
+		}
 
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
@@ -1069,10 +1078,12 @@ static u8 efuse_word_enable_data_write(s
 static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 tempval;
 	u16 tmpV16;
 
-	if (pwrstate) {
+	if (pwrstate && (rtlhal->hw_type !=
+		HARDWARE_TYPE_RTL8192SE)) {
 		tmpV16 = rtl_read_word(rtlpriv,
 				       rtlpriv->cfg->maps[SYS_ISO_CTRL]);
 		if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
@@ -1105,13 +1116,22 @@ static void efuse_power_switch(struct ie
 			tempval = rtl_read_byte(rtlpriv,
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
-			tempval &= 0x0F;
-			tempval |= (VOLTAGE_V25 << 4);
+
+			if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE) {
+				tempval &= 0x0F;
+				tempval |= (VOLTAGE_V25 << 4);
+			}
+
 			rtl_write_byte(rtlpriv,
 				       rtlpriv->cfg->maps[EFUSE_TEST] + 3,
 				       (tempval | 0x80));
 		}
 
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
+						0x03);
+		}
+
 	} else {
 		if (write) {
 			tempval = rtl_read_byte(rtlpriv,
@@ -1122,6 +1142,11 @@ static void efuse_power_switch(struct ie
 				       (tempval & 0x7F));
 		}
 
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
+						0x02);
+		}
+
 	}
 
 }
@@ -1162,3 +1187,4 @@ static u8 efuse_calculate_word_cnts(u8 w
 	return word_cnts;
 }
 
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.h
@@ -30,9 +30,10 @@
 #ifndef __RTL_EFUSE_H_
 #define __RTL_EFUSE_H_
 
+#define EFUSE_IC_ID_OFFSET		506
+
 #define EFUSE_REAL_CONTENT_LEN		512
 #define EFUSE_MAP_LEN			128
-#define EFUSE_MAX_SECTION		16
 #define EFUSE_MAX_WORD_UNIT		4
 
 #define EFUSE_INIT_MAP			0
@@ -52,6 +53,7 @@
 #define _PRE_EXECUTE_READ_CMD_
 
 #define EFUSE_REPEAT_THRESHOLD_		3
+#define EFUSE_ERROE_HANDLE		1
 
 struct efuse_map {
 	u8 offset;
@@ -103,6 +105,7 @@ struct efuse_priv {
 	u8 tx_power_g[14];
 };
 
+extern void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
 extern void efuse_initialize(struct ieee80211_hw *hw);
 extern u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address);
 extern void efuse_write_1byte(struct ieee80211_hw *hw, u16 address, u8 value);
@@ -119,3 +122,4 @@ extern void efuse_force_write_vendor_Id(
 extern void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
 
 #endif
+

