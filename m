Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:36847 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750975Ab0I3Khu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 06:37:50 -0400
Date: Thu, 30 Sep 2010 12:25:08 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point' type
Message-ID: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless: fix alignment problem

With the current definition, IW_EV_POINT_PK_LEN is 12 on 64-bit and 8 on 32-bit systems,
due to the way struct iw_event is packed (24 byte on 64-bit systems instead of 20 byte
on 32-bit systems). Furthermore, the iwe_stream_add_point() in include/net/iw_handler.h
also uses IW_EV_LCP_PK_LEN as header length. 

The current definition appears to be a typo (PK_LEN instead of LEN); it causes 
misalignment on 64 bit systems.

Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
---
 include/linux/wireless.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
	
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -1157,6 +1157,6 @@ struct __compat_iw_event {
 #define IW_EV_PARAM_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_param))
 #define IW_EV_ADDR_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct sockaddr))
 #define IW_EV_QUAL_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_quality))
-#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_LEN + 4)
+#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_PK_LEN + 4)
 
 #endif	/* _LINUX_WIRELESS_H */

