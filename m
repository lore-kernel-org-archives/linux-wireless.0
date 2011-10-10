Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1JJINE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:04 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so8169287bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 16/29] wl12xx: make WL1271_FLAG_STA_STATE_SENT flag per-vif
Date: Mon, 10 Oct 2011 10:13:04 +0200
Message-Id: <1318234397-21081-17-git-send-email-eliad@wizery.com> (sfid-20111010_101309_229885_61169560)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    6 +++---
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9c0a1ac..92f38c5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -408,7 +408,7 @@ static int wl1271_check_operstate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (operstate != IF_OPER_UP)
 		return 0;
 
-	if (test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags))
+	if (test_and_set_bit(WLVIF_FLAG_STA_STATE_SENT, &wlvif->flags))
 		return 0;
 
 	ret = wl12xx_cmd_set_peer_state(wl, wlvif->sta.hlid);
@@ -3614,8 +3614,8 @@ sta_not_found:
 			    !!test_and_clear_bit(WLVIF_FLAG_STA_ASSOCIATED,
 						 &wlvif->flags);
 			bool was_ifup =
-			    !!test_and_clear_bit(WL1271_FLAG_STA_STATE_SENT,
-						 &wl->flags);
+			    !!test_and_clear_bit(WLVIF_FLAG_STA_STATE_SENT,
+						 &wlvif->flags);
 			wlvif->aid = 0;
 
 			/* free probe-request template */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 37498f2..6a1df2c 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -321,7 +321,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_IRQ_RUNNING,
 	WL1271_FLAG_IDLE,
 	WL1271_FLAG_PSPOLL_FAILURE,
-	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
 	WL1271_FLAG_IF_INITIALIZED,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
@@ -339,6 +338,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_AP_STARTED,
 	WLVIF_FLAG_PSM,
 	WLVIF_FLAG_PSM_REQUESTED,
+	WLVIF_FLAG_STA_STATE_SENT,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

