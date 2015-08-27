Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34128 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbH0NKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 09:10:03 -0400
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH 2/3] staging/rtl8723au: Use %pM format specifier to print mac address
Date: Thu, 27 Aug 2015 19:09:27 +0600
Message-Id: <1440680967-9514-1-git-send-email-kuleshovmail@gmail.com> (sfid-20150827_151032_948348_BFE97830)
In-Reply-To: <1440680785-9327-1-git-send-email-kuleshovmail@gmail.com>
References: <1440680785-9327-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

printk() supports %pM format specifier for printing 6-byte MAC/FDDI
addresses in hex notation small buffers, let's use it intead of %x:%x...

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index be9a3d5..fca22ba 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -5934,11 +5934,8 @@ int set_stakey_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 			   macid = aid+1; */
 			cam_id = psta->mac_id + 3;
 
-			DBG_8723A("Write CAM, mac_addr =%x:%x:%x:%x:%x:%x, "
-				  "cam_entry =%d\n", pparm->addr[0],
-				  pparm->addr[1], pparm->addr[2],
-				  pparm->addr[3], pparm->addr[4],
-				  pparm->addr[5], cam_id);
+			DBG_8723A("Write CAM, mac_addr =%pM, "
+				  "cam_entry =%d\n", pparm->addr, cam_id);
 
 			rtl8723a_cam_write(padapter, cam_id, ctrl,
 					   pparm->addr, pparm->key);
-- 
2.5.0

