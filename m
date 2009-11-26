Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40304 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZKZN5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 08:57:10 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: fixup cfg.h
Date: Thu, 26 Nov 2009 14:57:01 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261457.01111.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a) no need to include "dev.h"
b) declaration of lbs_send_specific_ssid_scan() and lbs_scan_networks()
   came in by accident from an experimental patch

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/cfg.h
+++ linux-wl/drivers/net/wireless/libertas/cfg.h
@@ -1,15 +1,11 @@
 #ifndef __LBS_CFG80211_H__
 #define __LBS_CFG80211_H__
 
-#include "dev.h"
+struct device;
+struct lbs_private;
 
 struct wireless_dev *lbs_cfg_alloc(struct device *dev);
 int lbs_cfg_register(struct lbs_private *priv);
 void lbs_cfg_free(struct lbs_private *priv);
 
-int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
-	u8 ssid_len);
-int lbs_scan_networks(struct lbs_private *priv, int full_scan);
-
-
 #endif

-- 
http://www.holgerschurig.de
