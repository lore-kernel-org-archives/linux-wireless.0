Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082Ab2FUSII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:08:08 -0400
Date: Thu, 21 Jun 2012 13:08:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Change debug level for deletion of an entry in
 CAM
Message-ID: <4fe36304.lMYlG4cX+pzWriXy%Larry.Finger@lwfinger.net> (sfid-20120621_200812_532541_879455AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running in AP mode, the driver reports all deletions from CAM in
a cryptic manner that makes users think it is an error. change so that
the condition is only reported at higher-levels of debugging.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 3.6 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/cam.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/cam.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/cam.c
@@ -128,7 +128,7 @@ u8 rtl_cam_add_one_entry(struct ieee8021
 	u32 us_config;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 		 "EntryNo:%x, ulKeyId=%x, ulEncAlg=%x, ulUseDK=%x MacAddr %pM\n",
 		 ul_entry_idx, ul_key_id, ul_enc_alg,
 		 ul_default_key, mac_addr);
@@ -342,7 +342,8 @@ void rtl_cam_del_entry(struct ieee80211_
 			/* Remove from HW Security CAM */
 			memset(rtlpriv->sec.hwsec_cam_sta_addr[i], 0, ETH_ALEN);
 			rtlpriv->sec.hwsec_cam_bitmap &= ~(BIT(0) << i);
-			pr_info("&&&&&&&&&del entry %d\n", i);
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 "del CAM entry %d\n", i);
 		}
 	}
 	return;
