Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59464 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab1CFVa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 16:30:28 -0500
Received: by gxk8 with SMTP id 8so1412630gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 13:30:27 -0800 (PST)
Message-ID: <4D73FCED.3090300@lwfinger.net>
Date: Sun, 06 Mar 2011 15:30:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 11/11] rtlwifi: rtl8192se: Modify rtlwifi routines to
 handle rtl8192se and add Makefile and Kconfig
References: <4d732b88.lM+a0Gg928N+S/xO%Larry.Finger@lwfinger.net> <4D73EB12.3040102@tvcablenet.be> <4D73F209.8050406@lwfinger.net> <4D73F506.50609@tvcablenet.be>
In-Reply-To: <4D73F506.50609@tvcablenet.be>
Content-Type: multipart/mixed;
 boundary="------------050702030702040604040201"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050702030702040604040201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 03/06/2011 02:56 PM, François Valenduc wrote:
> Le 06/03/11 21:43, Larry Finger a écrit :
>> On 03/06/2011 02:14 PM, François Valenduc wrote:
>>>>
>>> Hello,
>>>
>>> It seems this patch is the same as the previous one (Merge routines
>>> trx.c and trx.h for RTL8192SE). It doesn't add a Makefile and doesn't
>>> contain KConfig entries.
>>>
>>> François Valenduc
>>
>> Yes, I messed up my sending script. The correct patch now submitted.
>>
>> Larry
>>
> Sorry to annoy you again but either I am doing something wrong or this
> new patch doesn't apply on top of the 10 first patches. There seems to
> be problems in fuse.c, pci.c and core.c (all in
> drivers/net/wireless/rtlwifi).
>

Are you using wireless-testing as your starting point? If so, you may need these 
two patches applied before any of the 11. The usb_config one was already 
submitted. The cleanup one needs to be part of the sequence.

Larry

--------------050702030702040604040201
Content-Type: text/plain;
 name="rtlwifi_usb_config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtlwifi_usb_config"

Subject:
[PATCH] rtlwifi: usb parts should depend on CONFIG_USB
From:
"John W. Linville" <linville@tuxdriver.com>
Date:
Mon, 28 Feb 2011 14:48:20 -0500
To:
linux-wireless@vger.kernel.org
CC:
Geert Uytterhoeven <geert@linux-m68k.org>, Larry Finger <Larry.Finger@lwfinger.net>, George <george0505@realtek.com>, linux-next@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>

ERROR: "usb_unanchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_control_msg" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_submit_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_get_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_kill_anchored_urbs" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_put_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_free_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_anchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

The USB-part of rtlwifi should depend on CONFIG_USB.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtlwifi/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

Index: wireless-testing/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/Makefile
@@ -7,15 +7,18 @@ rtlwifi-objs	:=		\
 		efuse.o		\
 		ps.o		\
 		rc.o		\
-		regd.o		\
-		usb.o
+		regd.o
 
 rtl8192c_common-objs +=		\
 
-ifeq ($(CONFIG_PCI),y)
+ifneq ($(CONFIG_PCI),)
 rtlwifi-objs	+= pci.o
 endif
 
+ifneq ($(CONFIG_USB),)
+rtlwifi-objs	+= usb.o
+endif
+
 obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/

--------------050702030702040604040201
Content-Type: text/plain;
 name="rtlwifi_cleanup_unused_vars"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtlwifi_cleanup_unused_vars"

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -440,7 +440,7 @@ static void _rtl_txrate_selectmode(struc
 	}
 
 	if (rtlpriv->dm.useramask) {
-		/* TODO we will differentiate adhoc and station futrue  */
+		/* TODO adhoc and station handled differently in the future */
 		tcb_desc->mac_id = 0;
 
 		if ((mac->mode == WIRELESS_MODE_N_24G) ||
@@ -638,7 +638,7 @@ u8 rtl_is_special_data(struct ieee80211_
 	const struct iphdr *ip;
 
 	if (!ieee80211_is_data(fc))
-		goto end;
+		return false;
 
 	if (ieee80211_is_nullfunc(fc))
 		return true;
@@ -694,7 +694,6 @@ u8 rtl_is_special_data(struct ieee80211_
 		return true;
 	}
 
-end:
 	return false;
 }
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -35,7 +35,7 @@
 /*mutex for start & stop is must here. */
 static int rtl_op_start(struct ieee80211_hw *hw)
 {
-	int err = 0;
+	int err;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
@@ -45,10 +45,8 @@ static int rtl_op_start(struct ieee80211
 		return 0;
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 	err = rtlpriv->intf_ops->adapter_start(hw);
-	if (err)
-		goto out;
-	rtl_watch_dog_timer_callback((unsigned long)hw);
-out:
+	if (!err)
+		rtl_watch_dog_timer_callback((unsigned long)hw);
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
 }
Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
@@ -338,11 +338,11 @@ bool efuse_shadow_update_chk(struct ieee
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 section_idx, i, Base;
 	u16 words_need = 0, hdr_num = 0, totalbytes, efuse_used;
-	bool bwordchanged, bresult = true;
+	bool wordchanged, result = true;
 
 	for (section_idx = 0; section_idx < 16; section_idx++) {
 		Base = section_idx * 8;
-		bwordchanged = false;
+		wordchanged = false;
 
 		for (i = 0; i < 8; i = i + 2) {
 			if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][Base + i] !=
@@ -351,11 +351,11 @@ bool efuse_shadow_update_chk(struct ieee
 			     rtlefuse->efuse_map[EFUSE_MODIFY_MAP][Base + i +
 								   1])) {
 				words_need++;
-				bwordchanged = true;
+				wordchanged = true;
 			}
 		}
 
-		if (bwordchanged == true)
+		if (wordchanged == true)
 			hdr_num++;
 	}
 
@@ -364,14 +364,14 @@ bool efuse_shadow_update_chk(struct ieee
 
 	if ((totalbytes + efuse_used) >=
 	    (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))
-		bresult = false;
+		result = false;
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("efuse_shadow_update_chk(): totalbytes(%#x), "
 		  "hdr_num(%#x), words_need(%#x), efuse_used(%d)\n",
 		  totalbytes, hdr_num, words_need, efuse_used));
 
-	return bresult;
+	return result;
 }
 
 void efuse_shadow_read(struct ieee80211_hw *hw, u8 type,
@@ -394,7 +394,7 @@ void efuse_shadow_write(struct ieee80211
 	else if (type == 2)
 		efuse_shadow_write_2byte(hw, offset, (u16) value);
 	else if (type == 4)
-		efuse_shadow_write_4byte(hw, offset, (u32) value);
+		efuse_shadow_write_4byte(hw, offset, value);
 
 }
 
@@ -573,7 +573,7 @@ static int efuse_one_byte_read(struct ie
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 tmpidx = 0;
-	int bresult;
+	int result;
 
 	rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 1,
 		       (u8) (addr & 0xff));
@@ -593,19 +593,18 @@ static int efuse_one_byte_read(struct ie
 
 	if (tmpidx < 100) {
 		*data = rtl_read_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL]);
-		bresult = true;
+		result = true;
 	} else {
 		*data = 0xff;
-		bresult = false;
+		result = false;
 	}
-	return bresult;
+	return result;
 }
 
 static int efuse_one_byte_write(struct ieee80211_hw *hw, u16 addr, u8 data)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 tmpidx = 0;
-	bool bresult;
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("Addr = %x Data=%x\n", addr, data));
@@ -627,11 +626,9 @@ static int efuse_one_byte_write(struct i
 	}
 
 	if (tmpidx < 100)
-		bresult = true;
-	else
-		bresult = false;
+		return true;
 
-	return bresult;
+	return false;
 }
 
 static void efuse_read_all_map(struct ieee80211_hw *hw, u8 * efuse)
@@ -682,11 +679,10 @@ static int efuse_pg_packet_read(struct i
 {
 	u8 readstate = PG_STATE_HEADER;
 
-	bool bcontinual = true;
+	bool continual = true;
 
 	u8 efuse_data, word_cnts = 0;
 	u16 efuse_addr = 0;
-	u8 hworden;
 	u8 tmpdata[8];
 
 	if (data == NULL)
@@ -697,7 +693,7 @@ static int efuse_pg_packet_read(struct i
 	memset((void *)data, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
 	memset((void *)tmpdata, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
 
-	while (bcontinual && (efuse_addr < EFUSE_MAX_SIZE)) {
+	while (continual && (efuse_addr < EFUSE_MAX_SIZE)) {
 		if (readstate & PG_STATE_HEADER) {
 			if (efuse_one_byte_read(hw, efuse_addr, &efuse_data)
 			    && (efuse_data != 0xFF))
@@ -706,9 +702,9 @@ static int efuse_pg_packet_read(struct i
 						      offset, tmpdata,
 						      &readstate);
 			else
-				bcontinual = false;
+				continual = false;
 		} else if (readstate & PG_STATE_DATA) {
-			efuse_word_enable_data_read(hworden, tmpdata, data);
+			efuse_word_enable_data_read(0, tmpdata, data);
 			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
 			readstate = PG_STATE_HEADER;
 		}
@@ -726,13 +722,13 @@ static int efuse_pg_packet_read(struct i
 }
 
 static void efuse_write_data_case1(struct ieee80211_hw *hw, u16 *efuse_addr,
-			u8 efuse_data, u8 offset, int *bcontinual,
+			u8 efuse_data, u8 offset, int *continual,
 			u8 *write_state, struct pgpkt_struct *target_pkt,
-			int *repeat_times, int *bresult, u8 word_en)
+			int *repeat_times, int *result, u8 word_en)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct tmp_pkt;
-	int bdataempty = true;
+	bool dataempty = true;
 	u8 originaldata[8 * sizeof(u8)];
 	u8 badworden = 0x0F;
 	u8 match_word_en, tmp_word_en;
@@ -752,10 +748,10 @@ static void efuse_write_data_case1(struc
 			u16 address = *efuse_addr + 1 + tmpindex;
 			if (efuse_one_byte_read(hw, address,
 			     &efuse_data) && (efuse_data != 0xFF))
-				bdataempty = false;
+				dataempty = false;
 		}
 
-		if (bdataempty == false) {
+		if (dataempty == false) {
 			*efuse_addr = *efuse_addr + (tmp_word_cnts * 2) + 1;
 			*write_state = PG_STATE_HEADER;
 		} else {
@@ -812,12 +808,12 @@ static void efuse_write_data_case1(struc
 					target_pkt->offset = offset;
 					target_pkt->word_en = tmp_word_en;
 				} else
-					*bcontinual = false;
+					*continual = false;
 				*write_state = PG_STATE_HEADER;
 				*repeat_times += 1;
 				if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
-					*bcontinual = false;
-					*bresult = false;
+					*continual = false;
+					*result = false;
 				}
 			} else {
 				*efuse_addr += (2 * tmp_word_cnts) + 1;
@@ -831,9 +827,9 @@ static void efuse_write_data_case1(struc
 }
 
 static void efuse_write_data_case2(struct ieee80211_hw *hw, u16 *efuse_addr,
-				   int *bcontinual, u8 *write_state,
+				   int *continual, u8 *write_state,
 				   struct pgpkt_struct target_pkt,
-				   int *repeat_times, int *bresult)
+				   int *repeat_times, int *result)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct tmp_pkt;
@@ -853,8 +849,8 @@ static void efuse_write_data_case2(struc
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
 		if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
-			*bcontinual = false;
-			*bresult = false;
+			*continual = false;
+			*result = false;
 		}
 	} else {
 		tmp_pkt.offset = (tmp_header >> 4) & 0x0F;
@@ -885,8 +881,8 @@ static void efuse_write_data_case2(struc
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
 		if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
-			*bcontinual = false;
-			*bresult = false;
+			*continual = false;
+			*result = false;
 		}
 
 		RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
@@ -900,7 +896,7 @@ static int efuse_pg_packet_write(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct target_pkt;
 	u8 write_state = PG_STATE_HEADER;
-	int bcontinual = true, bdataempty = true, bresult = true;
+	int continual = true, dataempty = true, result = true;
 	u16 efuse_addr = 0;
 	u8 efuse_data;
 	u8 target_word_cnts = 0;
@@ -924,11 +920,11 @@ static int efuse_pg_packet_write(struct
 
 	RTPRINT(rtlpriv, FEEPROM, EFUSE_PG, ("efuse Power ON\n"));
 
-	while (bcontinual && (efuse_addr <
+	while (continual && (efuse_addr <
 	       (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))) {
 
 		if (write_state == PG_STATE_HEADER) {
-			bdataempty = true;
+			dataempty = true;
 			badworden = 0x0F;
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				("efuse PG_STATE_HEADER\n"));
@@ -937,32 +933,30 @@ static int efuse_pg_packet_write(struct
 			    (efuse_data != 0xFF))
 				efuse_write_data_case1(hw, &efuse_addr,
 						       efuse_data, offset,
-						       &bcontinual,
+						       &continual,
 						       &write_state, &target_pkt,
-						       &repeat_times, &bresult,
+						       &repeat_times, &result,
 						       word_en);
 			else
 				efuse_write_data_case2(hw, &efuse_addr,
-						       &bcontinual,
+						       &continual,
 						       &write_state,
 						       target_pkt,
 						       &repeat_times,
-						       &bresult);
+						       &result);
 
 		} else if (write_state == PG_STATE_DATA) {
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				("efuse PG_STATE_DATA\n"));
-			badworden = 0x0f;
 			badworden =
 			    efuse_word_enable_data_write(hw, efuse_addr + 1,
 							 target_pkt.word_en,
 							 target_pkt.data);
 
 			if ((badworden & 0x0F) == 0x0F) {
-				bcontinual = false;
+				continual = false;
 			} else {
-				efuse_addr =
-				    efuse_addr + (2 * target_word_cnts) + 1;
+				efuse_addr += (2 * target_word_cnts) + 1;
 
 				target_pkt.offset = offset;
 				target_pkt.word_en = badworden;
@@ -972,8 +966,8 @@ static int efuse_pg_packet_write(struct
 				write_state = PG_STATE_HEADER;
 				repeat_times++;
 				if (repeat_times > EFUSE_REPEAT_THRESHOLD_) {
-					bcontinual = false;
-					bresult = false;
+					continual = false;
+					result = false;
 				}
 				RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 					("efuse PG_STATE_HEADER-3\n"));
@@ -1073,13 +1067,13 @@ static u8 efuse_word_enable_data_write(s
 	return badworden;
 }
 
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 bwrite, u8 pwrstate)
+static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 tempval;
 	u16 tmpV16;
 
-	if (pwrstate == true) {
+	if (pwrstate) {
 		tmpV16 = rtl_read_word(rtlpriv,
 				       rtlpriv->cfg->maps[SYS_ISO_CTRL]);
 		if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
@@ -1107,8 +1101,8 @@ static void efuse_power_switch(struct ie
 		}
 	}
 
-	if (pwrstate == true) {
-		if (bwrite == true) {
+	if (pwrstate) {
+		if (write) {
 			tempval = rtl_read_byte(rtlpriv,
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
@@ -1120,7 +1114,7 @@ static void efuse_power_switch(struct ie
 		}
 
 	} else {
-		if (bwrite == true) {
+		if (write) {
 			tempval = rtl_read_byte(rtlpriv,
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
@@ -1135,12 +1129,12 @@ static void efuse_power_switch(struct ie
 
 static u16 efuse_get_current_size(struct ieee80211_hw *hw)
 {
-	int bcontinual = true;
+	int continual = true;
 	u16 efuse_addr = 0;
 	u8 hoffset, hworden;
 	u8 efuse_data, word_cnts;
 
-	while (bcontinual && efuse_one_byte_read(hw, efuse_addr, &efuse_data)
+	while (continual && efuse_one_byte_read(hw, efuse_addr, &efuse_data)
 	       && (efuse_addr < EFUSE_MAX_SIZE)) {
 		if (efuse_data != 0xFF) {
 			hoffset = (efuse_data >> 4) & 0x0F;
@@ -1148,7 +1142,7 @@ static u16 efuse_get_current_size(struct
 			word_cnts = efuse_calculate_word_cnts(hworden);
 			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
 		} else {
-			bcontinual = false;
+			continual = false;
 		}
 	}
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -171,7 +171,6 @@ static void _rtl92c_write_fw(struct ieee
 static int _rtl92c_fw_free_to_go(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	int err = -EIO;
 	u32 counter = 0;
 	u32 value32;
 
@@ -184,7 +183,7 @@ static int _rtl92c_fw_free_to_go(struct
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("chksum report faill ! REG_MCUFWDL:0x%08x .\n",
 			  value32));
-		goto exit;
+		return -EIO;
 	}
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
@@ -204,8 +203,7 @@ static int _rtl92c_fw_free_to_go(struct
 				 ("Polling FW ready success!!"
 				 " REG_MCUFWDL:0x%08x .\n",
 				 value32));
-			err = 0;
-			goto exit;
+			return 0;
 		}
 
 		mdelay(FW_8192C_POLLING_DELAY);
@@ -214,9 +212,7 @@ static int _rtl92c_fw_free_to_go(struct
 
 	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 		 ("Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n", value32));
-
-exit:
-	return err;
+	return -EIO;
 }
 
 int rtl92c_download_fw(struct ieee80211_hw *hw)
@@ -226,16 +222,14 @@ int rtl92c_download_fw(struct ieee80211_
 	struct rtl92c_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
-	int err;
 	enum version_8192c version = rtlhal->version;
 	const struct firmware *firmware;
 
-	printk(KERN_INFO "rtl8192cu: Loading firmware file %s\n",
+	printk(KERN_INFO "rtl8192c: Loading firmware file %s\n",
 	       rtlpriv->cfg->fw_name);
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			       rtlpriv->io.dev);
-	if (err) {
-		printk(KERN_ERR "rtl8192cu: Firmware loading failed\n");
+	if (request_firmware(&firmware, rtlpriv->cfg->fw_name,
+			    rtlpriv->io.dev)) {
+		printk(KERN_ERR "rtl8192c: Firmware loading failed\n");
 		return 1;
 	}
 
@@ -267,8 +261,7 @@ int rtl92c_download_fw(struct ieee80211_
 	_rtl92c_write_fw(hw, version, pfwdata, fwsize);
 	_rtl92c_enable_fw_download(hw, false);
 
-	err = _rtl92c_fw_free_to_go(hw);
-	if (err) {
+	if (_rtl92c_fw_free_to_go(hw)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("Firmware is not ready to run!\n"));
 	} else {
@@ -303,7 +296,6 @@ static void _rtl92c_fill_h2c_command(str
 	u16 box_reg, box_extreg;
 	u8 u1b_tmp;
 	bool isfw_read = false;
-	u8 buf_index;
 	bool bwrite_sucess = false;
 	u8 wait_h2c_limmit = 100;
 	u8 wait_writeh2c_limmit = 100;
@@ -414,7 +406,7 @@ static void _rtl92c_fill_h2c_command(str
 		case 1:
 			boxcontent[0] &= ~(BIT(7));
 			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index, 1);
+			       p_cmdbuffer, 1);
 
 			for (idx = 0; idx < 4; idx++) {
 				rtl_write_byte(rtlpriv, box_reg + idx,
@@ -424,7 +416,7 @@ static void _rtl92c_fill_h2c_command(str
 		case 2:
 			boxcontent[0] &= ~(BIT(7));
 			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index, 2);
+			       p_cmdbuffer, 2);
 
 			for (idx = 0; idx < 4; idx++) {
 				rtl_write_byte(rtlpriv, box_reg + idx,
@@ -434,7 +426,7 @@ static void _rtl92c_fill_h2c_command(str
 		case 3:
 			boxcontent[0] &= ~(BIT(7));
 			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index, 3);
+			       p_cmdbuffer, 3);
 
 			for (idx = 0; idx < 4; idx++) {
 				rtl_write_byte(rtlpriv, box_reg + idx,
@@ -444,9 +436,9 @@ static void _rtl92c_fill_h2c_command(str
 		case 4:
 			boxcontent[0] |= (BIT(7));
 			memcpy((u8 *) (boxextcontent),
-			       p_cmdbuffer + buf_index, 2);
+			       p_cmdbuffer, 2);
 			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index + 2, 2);
+			       p_cmdbuffer + 2, 2);
 
 			for (idx = 0; idx < 2; idx++) {
 				rtl_write_byte(rtlpriv, box_extreg + idx,
@@ -461,9 +453,9 @@ static void _rtl92c_fill_h2c_command(str
 		case 5:
 			boxcontent[0] |= (BIT(7));
 			memcpy((u8 *) (boxextcontent),
-			       p_cmdbuffer + buf_index, 2);
+			       p_cmdbuffer, 2);
 			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index + 2, 3);
+			       p_cmdbuffer + 2, 3);
 
 			for (idx = 0; idx < 2; idx++) {
 				rtl_write_byte(rtlpriv, box_extreg + idx,
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -113,32 +113,19 @@ static void _rtl_pci_update_default_sett
 
 	/*Set HW definition to determine if it supports ASPM. */
 	switch (rtlpci->const_support_pciaspm) {
-	case 0:{
-			/*Not support ASPM. */
-			bool support_aspm = false;
-			ppsc->support_aspm = support_aspm;
-			break;
-		}
-	case 1:{
-			/*Support ASPM. */
-			bool support_aspm = true;
-			bool support_backdoor = true;
-			ppsc->support_aspm = support_aspm;
-
-			/*if(priv->oem_id == RT_CID_TOSHIBA &&
-			   !priv->ndis_adapter.amd_l1_patch)
-			   support_backdoor = false; */
-
-			ppsc->support_backdoor = support_backdoor;
-
-			break;
-		}
+	case 0:
+		/*Not support ASPM. */
+		ppsc->support_aspm = false;
+		break;
+	case 1:
+		/*Support ASPM. */
+		ppsc->support_aspm = true;
+		ppsc->support_backdoor = true;
+		break;
 	case 2:
 		/*ASPM value set by chipset. */
-		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL) {
-			bool support_aspm = true;
-			ppsc->support_aspm = support_aspm;
-		}
+		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL)
+			ppsc->support_aspm = true;
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -152,13 +139,11 @@ static bool _rtl_pci_platform_switch_dev
 			u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	bool bresult = false;
 
 	value |= 0x40;
-
 	pci_write_config_byte(rtlpci->pdev, 0x80, value);
 
-	return bresult;
+	return false;
 }
 
 /*When we set 0x01 to enable clk request. Set 0x0 to disable clk req.*/
@@ -166,14 +151,11 @@ static bool _rtl_pci_switch_clk_req(stru
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	u8 buffer;
-	bool bresult = false;
 
 	buffer = value;
-
 	pci_write_config_byte(rtlpci->pdev, 0x81, value);
-	bresult = true;
 
-	return bresult;
+	return true;
 }
 
 /*Disable RTL8192SE ASPM & Disable Pci Bridge ASPM*/
@@ -191,6 +173,7 @@ static void rtl_pci_disable_aspm(struct
 	u16 pcibridge_linkctrlreg = pcipriv->ndis_adapter.
 				pcibridge_linkctrlreg;
 	u16 aspmlevel = 0;
+	u8 tmp_u1b = 0;
 
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
@@ -204,11 +187,8 @@ static void rtl_pci_disable_aspm(struct
 		_rtl_pci_switch_clk_req(hw, 0x0);
 	}
 
-	if (1) {
-		/*for promising device will in L0 state after an I/O. */
-		u8 tmp_u1b;
-		pci_read_config_byte(rtlpci->pdev, 0x80, &tmp_u1b);
-	}
+	/*for promising device will in L0 state after an I/O. */
+	pci_read_config_byte(rtlpci->pdev, 0x80, &tmp_u1b);
 
 	/*Set corresponding value. */
 	aspmlevel |= BIT(0) | BIT(1);
@@ -224,7 +204,6 @@ static void rtl_pci_disable_aspm(struct
 	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, pcibridge_linkctrlreg);
 
 	udelay(50);
-
 }
 
 /*
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.h
@@ -192,8 +192,8 @@ struct rtl_pci {
 	u8 const_devicepci_aspm_setting;
 	/*If it supports ASPM, Offset[560h] = 0x40,
 	   otherwise Offset[560h] = 0x00. */
-	bool b_support_aspm;
-	bool b_support_backdoor;
+	bool support_aspm;
+	bool support_backdoor;
 
 	/*QOS & EDCA */
 	enum acm_method acm_method;
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -63,7 +63,6 @@ EXPORT_SYMBOL(rtl_ps_enable_nic);
 
 bool rtl_ps_disable_nic(struct ieee80211_hw *hw)
 {
-	bool status = true;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	/*<1> Stop all timer */
@@ -75,7 +74,7 @@ bool rtl_ps_disable_nic(struct ieee80211
 	/*<3> Disable Adapter */
 	rtlpriv->cfg->ops->hw_disable(hw);
 
-	return status;
+	return true;
 }
 EXPORT_SYMBOL(rtl_ps_disable_nic);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -765,7 +765,7 @@ struct rtl_rfkill {
 #define IQK_MATRIX_REG_NUM	8
 #define IQK_MATRIX_SETTINGS_NUM	(1 + 24 + 21)
 struct iqk_matrix_regs {
-	bool b_iqk_done;
+	bool iqk_done;
 	long value[1][IQK_MATRIX_REG_NUM];
 };
 
@@ -1620,19 +1620,19 @@ struct bt_coexist_info {
 	u32 bt_edca_ul;
 	u32 bt_edca_dl;
 
-	bool b_init_set;
-	bool b_bt_busy_traffic;
-	bool b_bt_traffic_mode_set;
-	bool b_bt_non_traffic_mode_set;
+	bool init_set;
+	bool bt_busy_traffic;
+	bool bt_traffic_mode_set;
+	bool bt_non_traffic_mode_set;
 
-	bool b_fw_coexist_all_off;
-	bool b_sw_coexist_all_off;
+	bool fw_coexist_all_off;
+	bool sw_coexist_all_off;
 	u32 current_state;
 	u32 previous_state;
 	u8 bt_pre_rssi_state;
 
-	u8 b_reg_bt_iso;
-	u8 b_reg_bt_sco;
+	u8 reg_bt_iso;
+	u8 reg_bt_sco;
 
 };
 

--------------050702030702040604040201--
