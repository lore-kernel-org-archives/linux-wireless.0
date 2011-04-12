Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64365 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab1DLN7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:59:40 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so5384622bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:59:39 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx:: Revert "wl12xx: disable auto-arp"
Date: Tue, 12 Apr 2011 16:59:39 +0300
Message-Id: <1302616779-29012-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1302616779-29012-1-git-send-email-eliad@wizery.com>
References: <1302616779-29012-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit e5e2f24b3eec67a7a35d43654a997f98ca21aff2.

The encryption consideration on auto-arp configuration seems
to resolve the crashes that were occured when auto-arp was enabled,
so we can re-enable it now.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8ec80fe..44af7fd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2761,7 +2761,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			}
 
 			ret = wl1271_acx_arp_ip_filter(wl,
-				ACX_ARP_FILTER_ARP_FILTERING,
+				(ACX_ARP_FILTER_ARP_FILTERING |
+				 ACX_ARP_FILTER_AUTO_ARP),
 				addr);
 		} else {
 			wl->ip_addr = 0;
-- 
1.7.0.4

