Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1DZKEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:04:37 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so496575wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:04:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 2/2] wl12xx: Revert "wl12xx: disable auto-arp"
Date: Tue, 26 Apr 2011 13:04:48 +0300
Message-Id: <1303812288-9388-2-git-send-email-eliad@wizery.com> (sfid-20110426_120451_564552_0D693153)
In-Reply-To: <1303812288-9388-1-git-send-email-eliad@wizery.com>
References: <1303812288-9388-1-git-send-email-eliad@wizery.com>
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
index 75397ed..c2ea8fc 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2762,7 +2762,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
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

