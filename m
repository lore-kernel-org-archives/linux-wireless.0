Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1AXSTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:19:48 -0500
Received: by bwz15 with SMTP id 15so3838654bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 10:19:45 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: disable auto-arp
Date: Mon, 24 Jan 2011 20:19:03 +0200
Message-Id: <1295893143-6981-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The auto-arp feature sometimes has unexpected side effects (e.g. firmware
crashes, no ARP replies, etc.)
disable it until it will be solved.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8a35491..ec64b9b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2426,8 +2426,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			}
 
 			ret = wl1271_acx_arp_ip_filter(wl,
-				(ACX_ARP_FILTER_ARP_FILTERING |
-				 ACX_ARP_FILTER_AUTO_ARP),
+				ACX_ARP_FILTER_ARP_FILTERING,
 				addr);
 		} else
 			ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
-- 
1.7.0.4

