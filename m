Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53042 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2B0Wlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:47 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm11so1607155wib.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:47 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/7] wl12xx: avoid starving the system hlid
Date: Tue, 28 Feb 2012 00:41:31 +0200
Message-Id: <1330382494-31148-4-git-send-email-arik@wizery.com> (sfid-20120227_234151_290882_DEE13924)
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-factor the Tx scheduler so that the system_hlid is taken into account
before restarting an iteration over the wlvifs. Previously this
hlid had a lower priority and would starve if some wlvif had many
packets.
In addition avoid iterating over wlvifs past last_wlvif when performing
the a second pass. If we had packets in those wlvifs they would have
been found earlier.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 311b5a2..76480a0 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -572,6 +572,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 	struct wl12xx_vif *wlvif = wl->last_wlvif;
 	struct sk_buff *skb = NULL;
 
+	/* continue from last wlvif (round robin) */
 	if (wlvif) {
 		wl12xx_for_each_wlvif_continue(wl, wlvif) {
 			skb = wl12xx_vif_skb_dequeue(wl, wlvif);
@@ -582,7 +583,11 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 		}
 	}
 
-	/* do another pass */
+	/* dequeue from the system HLID before the restarting wlvif list */
+	if (!skb)
+		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[wl->system_hlid]);
+
+	/* do a new pass over the wlvif list */
 	if (!skb) {
 		wl12xx_for_each_wlvif(wl, wlvif) {
 			skb = wl12xx_vif_skb_dequeue(wl, wlvif);
@@ -590,12 +595,16 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 				wl->last_wlvif = wlvif;
 				break;
 			}
+
+			/*
+			 * No need to continue after last_wlvif. The previous
+			 * pass should have found it.
+			 */
+			if (wlvif == wl->last_wlvif)
+				break;
 		}
 	}
 
-	if (!skb)
-		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[wl->system_hlid]);
-
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
 		int q;
-- 
1.7.5.4

