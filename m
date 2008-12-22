Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30575 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYLVQeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 11:34:18 -0500
Received: by ug-out-1314.google.com with SMTP id 39so730021ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 08:34:16 -0800 (PST)
Message-ID: <494FC18C.3050102@gmail.com> (sfid-20081222_173422_145435_44AD7E27)
Date: Mon, 22 Dec 2008 17:34:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: solomon@linux-wlan.com, Greg KH <gregkh@suse.de>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] Staging: ! has a higher precedence than &
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 906ba43..c42cd7f 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1580,7 +1580,7 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 
 
   if ( ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY ) {
-    if ( ! ext->alg & IW_ENCODE_ALG_WEP) {
+    if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
       WLAN_LOG_DEBUG(1,"asked to set a non wep key :(");
       return -EINVAL;
     }
