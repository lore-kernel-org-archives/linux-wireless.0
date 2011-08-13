Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from app1b.xlhost.de ([213.202.242.162]:55215 "EHLO app1b.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1HMKNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 06:13:40 -0400
From: Stefan Assmann <sassmann@kpanic.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	sassmann@kpanic.de
Subject: [PATCH V2] rtlwifi: add module parameter to set global debug level
Date: Sat, 13 Aug 2011 12:12:36 +0200
Message-Id: <1313230356-6868-1-git-send-email-sassmann@kpanic.de> (sfid-20110813_121344_015874_3417F79C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to recompile the module anymore to set the debug level.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/wireless/rtlwifi/debug.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
index 5fa7385..b2f897a 100644
--- a/drivers/net/wireless/rtlwifi/debug.c
+++ b/drivers/net/wireless/rtlwifi/debug.c
@@ -28,12 +28,16 @@
 
 #include "wifi.h"
 
+static unsigned int debug = DBG_EMERG;
+module_param(debug, uint, 0);
+MODULE_PARM_DESC(debug, "Set global debug level for rtlwifi (0,2-5)");
+
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 i;
 
-	rtlpriv->dbg.global_debuglevel = DBG_EMERG;
+	rtlpriv->dbg.global_debuglevel = debug;
 
 	rtlpriv->dbg.global_debugcomponents =
 	    COMP_ERR | COMP_FW | COMP_INIT | COMP_RECV | COMP_SEND |
-- 
1.7.6

