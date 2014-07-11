Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:34302 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaGKACD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:03 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so302694wes.7
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:01:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/14] wlcore: use correct LAA bit
Date: Fri, 11 Jul 2014 03:01:29 +0300
Message-Id: <1405036899-27396-5-git-send-email-eliad@wizery.com> (sfid-20140711_020206_692602_907C07BB)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LAA bit is second bit of the MSB, not of the
third byte.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1ab6dbd..4c16262 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5661,7 +5661,7 @@ static void wl12xx_derive_mac_addresses(struct wl1271 *wl, u32 oui, u32 nic)
 		memcpy(&wl->addresses[idx], &wl->addresses[0],
 		       sizeof(wl->addresses[0]));
 		/* LAA bit */
-		wl->addresses[idx].addr[2] |= BIT(1);
+		wl->addresses[idx].addr[0] |= BIT(1);
 	}
 
 	wl->hw->wiphy->n_addresses = WLCORE_NUM_MAC_ADDRESSES;
-- 
1.8.5.1.109.g3d252a9

