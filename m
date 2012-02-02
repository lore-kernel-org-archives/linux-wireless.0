Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58320 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2BBKSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:18:42 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so1675044wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:18:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] wl12xx: Revert "wl12xx: disable auto-arp"
Date: Thu,  2 Feb 2012 12:22:10 +0200
Message-Id: <1328178131-28938-3-git-send-email-eliad@wizery.com> (sfid-20120202_111846_026469_8FEA258F)
In-Reply-To: <1328178131-28938-1-git-send-email-eliad@wizery.com>
References: <1328178131-28938-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit e5e2f24b3eec67a7a35d43654a997f98ca21aff2.

The encryption consideration on auto-arp configuration,
along with a fw fix, seem to resolve the crashes that
occured when auto-arp was enabled, so we can re-enable it now.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f22c8b1..a50c116 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3836,7 +3836,8 @@ sta_not_found:
 			}
 
 			ret = wl1271_acx_arp_ip_filter(wl, wlvif,
-				ACX_ARP_FILTER_ARP_FILTERING,
+				(ACX_ARP_FILTER_ARP_FILTERING |
+				 ACX_ARP_FILTER_AUTO_ARP),
 				addr);
 		} else {
 			wlvif->ip_addr = 0;
-- 
1.7.6.401.g6a319

