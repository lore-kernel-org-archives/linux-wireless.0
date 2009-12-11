Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61353 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbZLKNlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:32 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 10/31] wl1271: use the correct macro when setting the basic rates
Date: Fri, 11 Dec 2009 15:40:49 +0200
Message-Id: <1260538870-32297-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were using CONF_TX_RATE_MASK_ALL when calling wl1271_acx_rate_policies()
during init.  We should use WL1271_DEFAULT_BASIC_RATE_SET instead.  The
values are the same, but the latter is just the correct macro to use.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 11249b4..d72ccc6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -280,7 +280,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl, CONF_TX_RATE_MASK_ALL);
+	ret = wl1271_acx_rate_policies(wl, WL1271_DEFAULT_BASIC_RATE_SET);
 	if (ret < 0)
 		goto out_free_memmap;
 
-- 
1.6.3.3

