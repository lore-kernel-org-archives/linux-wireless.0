Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:50581 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaHALf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2014 07:35:59 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	cmroliv@gmail.com
Subject: [PATCH] staging: rtl8723au: Fix static symbol sparse warning
Date: Fri,  1 Aug 2014 14:06:27 +0100
Message-Id: <1406898387-13987-1-git-send-email-cmroliv@gmail.com> (sfid-20140801_133621_432944_E462438C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix sparse warning:
drivers/staging/rtl8723au/core/rtw_efuse.c:579:5: warning: symbol 'efuse_GetCurrentSize23a' was not declared. Should it be static?

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8723au/include/rtw_efuse.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h b/drivers/staging/rtl8723au/include/rtw_efuse.h
index 07bdc34..304cc71 100644
--- a/drivers/staging/rtl8723au/include/rtw_efuse.h
+++ b/drivers/staging/rtl8723au/include/rtw_efuse.h
@@ -82,6 +82,7 @@ struct pg_pkt_struct {
 /*------------------------Export global variable----------------------------*/
 
 u16	efuse_GetMaxSize23a(struct rtw_adapter *padapter);
+int	efuse_GetCurrentSize23a(struct rtw_adapter *padapter, u16 *size);
 int	rtw_efuse_access23a(struct rtw_adapter *padapter, u8 bRead, u16 start_addr, u16 cnts, u8 *data);
 int	rtw_efuse_map_read23a(struct rtw_adapter *padapter, u16 addr, u16 cnts, u8 *data);
 u8	rtw_efuse_map_write(struct rtw_adapter *padapter, u16 addr, u16 cnts, u8 *data);
-- 
1.7.10.4

