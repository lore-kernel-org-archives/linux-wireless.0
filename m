Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65266 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2EOOJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:14 -0400
Received: by wibhn6 with SMTP id hn6so3638454wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:13 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/10] wlcore: use correct link for bcast/multicast frames
Date: Tue, 15 May 2012 17:08:55 +0300
Message-Id: <1337090940-13750-5-git-send-email-arik@wizery.com> (sfid-20120515_160919_810838_6D948724)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Multicast management frames (e.g. global deauth)
should be sent out on the bcast link, rather than
the global, which should be used only for pre-added
stations (e.g. for auth/assoc resp).

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 200d091..e8a2998 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -148,10 +148,10 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			return wl->system_hlid;
 
 		hdr = (struct ieee80211_hdr *)skb->data;
-		if (ieee80211_is_mgmt(hdr->frame_control))
-			return wlvif->ap.global_hlid;
-		else
+		if (is_multicast_ether_addr(ieee80211_get_DA(hdr)))
 			return wlvif->ap.bcast_hlid;
+		else
+			return wlvif->ap.global_hlid;
 	}
 }
 
-- 
1.7.9.5

