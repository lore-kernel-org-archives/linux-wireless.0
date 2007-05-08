Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4775 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966153AbXEHQCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2007 12:02:40 -0400
Date: Tue, 8 May 2007 11:50:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: include <linux/delay.h> instead of <asm/delay.h>
Message-ID: <20070508155011.GD6479@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geert Uytterhoeven <geert@linux-m68k.org>

|   CC      net/mac80211/ieee80211_sta.o
| In file included from linux/net/mac80211/ieee80211_sta.c:31:
| include2/asm/delay.h: In function '__const_udelay':
| include2/asm/delay.h:33: error: 'loops_per_jiffy' undeclared (first use in this function)
| include2/asm/delay.h:33: error: (Each undeclared identifier is reported only once
| include2/asm/delay.h:33: error: for each function it appears in.)

mac80211: include <linux/delay.h> instead of <asm/delay.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 822917d..3e07e9d 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -17,6 +17,7 @@
  * scan result table filtering (by capability (privacy, IBSS/BSS, WPA/RSN IE,
  *    SSID)
  */
+#include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
@@ -27,7 +28,6 @@
 #include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
-#include <asm/delay.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-- 
1.5.0.6
