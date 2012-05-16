Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:41481 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966323Ab2EPDAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 23:00:11 -0400
Received: by lagy4 with SMTP id y4so180910lag.15
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 20:00:08 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wlcore: fix pointer print out in wl1271_acx_set_rx_filter()
Date: Wed, 16 May 2012 05:59:59 +0300
Message-Id: <1337137200-32538-2-git-send-email-coelho@ti.com> (sfid-20120516_050017_580273_0D9BBC92)
In-Reply-To: <1337137200-32538-1-git-send-email-coelho@ti.com>
References: <1337137200-32538-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug print in wl1271_acx_set_rx_filter() was causing the
following warning:

  CC      drivers/net/wireless/ti/wlcore/acx.o
drivers/net/wireless/ti/wlcore/acx.c: In function ‘wl1271_acx_set_rx_filter’:
drivers/net/wireless/ti/wlcore/acx.c:1759:2: warning: cast from pointer to integer of different size

Instead of casting the pointer to an integer, use %p to print it our
instead.

Reported-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/acx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 0fd78a0..509aa88 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1756,8 +1756,9 @@ int wl1271_acx_set_rx_filter(struct wl1271 *wl, u8 index, bool enable,
 	WARN_ON(enable && !filter);
 	WARN_ON(index >= WL1271_MAX_RX_FILTERS);
 
-	wl1271_debug(DEBUG_ACX, "acx set rx filter idx: %d enable: %d"
-		     "filter: 0x%x", index, enable, (unsigned int)filter);
+	wl1271_debug(DEBUG_ACX,
+		     "acx set rx filter idx: %d enable: %d filter: %p",
+		     index, enable, filter);
 
 	if (enable) {
 		fields_size = wl1271_rx_filter_get_fields_size(filter);
-- 
1.7.10

