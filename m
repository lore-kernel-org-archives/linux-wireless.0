Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50125 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1BVW1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 17:27:15 -0500
Received: by wyg36 with SMTP id 36so269256wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 14:27:14 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/2] wl12xx: always set mac_address when configuring ht caps
Date: Wed, 23 Feb 2011 00:27:07 +0200
Message-Id: <1298413627-19819-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1298413627-19819-1-git-send-email-eliad@wizery.com>
References: <1298413627-19819-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac_address should be set also when ht caps are disabled.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 33840d9..6d53129 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1328,10 +1328,9 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 		/* get data from A-MPDU parameters field */
 		acx->ampdu_max_length = ht_cap->ampdu_factor;
 		acx->ampdu_min_spacing = ht_cap->ampdu_density;
-
-		memcpy(acx->mac_address, mac_address, ETH_ALEN);
 	}
 
+	memcpy(acx->mac_address, mac_address, ETH_ALEN);
 	acx->ht_capabilites = cpu_to_le32(ht_capabilites);
 
 	ret = wl1271_cmd_configure(wl, ACX_PEER_HT_CAP, acx, sizeof(*acx));
-- 
1.7.0.4

