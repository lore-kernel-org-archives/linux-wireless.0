Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms13.Sony.CO.JP ([211.125.136.230]:55561 "EHLO ms13.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbZC0IuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 04:50:20 -0400
Received: from ms5.sony.co.jp (ms5.Sony.CO.JP [211.125.136.201])
 by ms13.sony.co.jp (R8/Sony) with ESMTP id n2R8234D011478
 for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 17:02:03 +0900 (JST)
Message-Id: <200903270800.n2R804mS007321@imail.sm.sony.co.jp> (sfid-20090327_095038_744626_9382F8EE)
Date: Fri, 27 Mar 2009 17:00:17 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: <linville@tuxdriver.com>
Subject: [PATCH] ps3: gelic: Added error path
Cc: linux-wireless@vger.kernel.org,
	Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the bug that the driver tries to continue to
connect(associate) to AP even if gelic_wl_do_{wpa,wep}_setup() fails,

CC: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2101,6 +2101,9 @@ static int gelic_wl_associate_bss(struct
 	if (ret) {
 		pr_debug("%s: WEP/WPA setup failed %d\n", __func__,
 			 ret);
+		ret = -EPERM;
+		gelic_wl_send_iwap_event(wl, NULL);
+		goto out;
 	}
 
 	/* start association */

-- 
Masakazu Mokuno

