Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1GAN4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:56:13 -0400
Date: Fri, 01 Jul 2011 08:56:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: error27@gmail.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Fix error exit from hw_init
Message-ID: <4e0dd1fb.rhMbmPyCN5hPxkPv%Larry.Finger@lwfinger.net> (sfid-20110701_155616_394553_8A5AE780)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine rtl92de_hw_init(), there are two places where a failure is
not handled correctly.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -931,8 +931,8 @@ int rtl92de_hw_init(struct ieee80211_hw
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("Failed to download FW. Init HW "
 			 "without FW..\n"));
-		err = 1;
 		rtlhal->fw_ready = false;
+		return 1;
 	} else {
 		rtlhal->fw_ready = true;
 	}
@@ -1043,6 +1043,11 @@ int rtl92de_hw_init(struct ieee80211_hw
 				if (((tmp_rega & BIT(11)) == BIT(11)))
 					break;
 			}
+			/* check that loop was successful. If not, exit now */
+			if (i == 10000) {
+				rtlpci->init_ready = false;
+				return 1;
+			}
 		}
 	}
 	rtlpci->init_ready = true;
