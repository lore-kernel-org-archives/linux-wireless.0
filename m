Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63358 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1JGQRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:17:52 -0400
Received: by yxl31 with SMTP id 31so3779968yxl.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 09:17:51 -0700 (PDT)
From: Shahar Lev <shahar@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Shahar Lev <shahar@wizery.com>
Subject: [PATCH] wl12xx: remove warning message during IBSS Tx
Date: Fri,  7 Oct 2011 18:17:25 +0200
Message-Id: <1318004245-18347-1-git-send-email-shahar@wizery.com> (sfid-20111007_181755_157242_AF6DA13F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 sets the carrier on an IBSS interface even when no network is
joined. Ignore garbage frames transmitted on a disconnected IBSS
interface without printing warnings.

Signed-off-by: Shahar Lev <shahar@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 1b3d8e3..a3b474b 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -431,7 +431,15 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	}
 	hlid = wl1271_tx_get_hlid(wl, vif, skb);
 	if (hlid == WL12XX_INVALID_LINK_ID) {
-		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
+		if (wlvif->bss_type == BSS_TYPE_IBSS &&
+		    !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) {
+			/* It's ok to drop packets when not joined to IBSS */
+			wl1271_debug(DEBUG_TX, "dropping skb while IBSS not "
+				     " joined");
+		} else {
+			wl1271_error("invalid hlid. dropping skb 0x%p", skb);
+		}
+
 		return -EINVAL;
 	}
 
-- 
1.7.4.1

