Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55241 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1KHOH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:07:57 -0500
Received: by wwi36 with SMTP id 36so796692wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:07:56 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: don't explicitly check for unjoined ibss
Date: Tue,  8 Nov 2011 16:07:52 +0200
Message-Id: <1320761272-20915-1-git-send-email-eliad@wizery.com> (sfid-20111108_150800_412316_917266DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the ibss carrier issue was fixed, we can revert
the following patch:

commit 48309fd477ef867babb6819f67fe082c133a5fa9
Author: Shahar Lev <shahar@wizery.com>
Date:   Fri Oct 7 18:17:25 2011 +0200

    wl12xx: remove warning message during IBSS Tx

    mac80211 sets the carrier on an IBSS interface even when no network is
    joined. Ignore garbage frames transmitted on a disconnected IBSS
    interface without printing warnings.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on "mac80211: set carrier_on for ibss vifs only while joined"

 drivers/net/wireless/wl12xx/tx.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 3a9d2a6..c12645c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -425,15 +425,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
 	if (hlid == WL12XX_INVALID_LINK_ID) {
-		if (wlvif->bss_type == BSS_TYPE_IBSS &&
-		    !test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) {
-			/* It's ok to drop packets when not joined to IBSS */
-			wl1271_debug(DEBUG_TX, "dropping skb while IBSS not "
-				     " joined");
-		} else {
-			wl1271_error("invalid hlid. dropping skb 0x%p", skb);
-		}
-
+		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
 		return -EINVAL;
 	}
 
-- 
1.7.6.401.g6a319

