Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35398 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcCZGPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 02:15:04 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org
Cc: Jes.Sorensen@redhat.com, joe@perches.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] Staging: rtl8723au: Remove unused functions
Date: Sat, 26 Mar 2016 11:44:52 +0530
Message-Id: <1458972892-14169-1-git-send-email-bhumirks@gmail.com> (sfid-20160326_071531_032161_74DB40B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions rtw_get_oper_bw23a and rtw_get_oper_ch23aoffset are never
used anywhere in the kernel. So, remove their definition and prototype.
Grepped to find occurences.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_wlan_util.c   | 10 ----------
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h |  2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index cc2b84b..694cf17 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -304,21 +304,11 @@ inline void rtw_set_oper_ch23a(struct rtw_adapter *adapter, u8 ch)
 	adapter_to_dvobj(adapter)->oper_channel = ch;
 }
 
-inline u8 rtw_get_oper_bw23a(struct rtw_adapter *adapter)
-{
-	return adapter_to_dvobj(adapter)->oper_bwmode;
-}
-
 inline void rtw_set_oper_bw23a(struct rtw_adapter *adapter, u8 bw)
 {
 	adapter_to_dvobj(adapter)->oper_bwmode = bw;
 }
 
-inline u8 rtw_get_oper_ch23aoffset(struct rtw_adapter *adapter)
-{
-	return adapter_to_dvobj(adapter)->oper_ch_offset;
-}
-
 inline void rtw_set_oper_ch23aoffset23a(struct rtw_adapter *adapter, u8 offset)
 {
 	adapter_to_dvobj(adapter)->oper_ch_offset = offset;
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
index ea2a6c9..0e7d3da 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
@@ -461,9 +461,7 @@ void Update23aTblForSoftAP(u8 *bssrateset, u32 bssratelen);
 
 u8 rtw_get_oper_ch23a(struct rtw_adapter *adapter);
 void rtw_set_oper_ch23a(struct rtw_adapter *adapter, u8 ch);
-u8 rtw_get_oper_bw23a(struct rtw_adapter *adapter);
 void rtw_set_oper_bw23a(struct rtw_adapter *adapter, u8 bw);
-u8 rtw_get_oper_ch23aoffset(struct rtw_adapter *adapter);
 void rtw_set_oper_ch23aoffset23a(struct rtw_adapter *adapter, u8 offset);
 
 void set_channel_bwmode23a(struct rtw_adapter *padapter, unsigned char channel,
-- 
1.9.1

