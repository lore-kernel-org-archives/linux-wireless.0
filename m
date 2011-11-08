Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39835 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab1KHQrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:47:04 -0500
Received: by eye27 with SMTP id 27so542972eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 08:47:03 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 2/2] wl12xx: indicate probe-resp offloading support
Date: Tue,  8 Nov 2011 18:46:55 +0200
Message-Id: <1320770815-23332-2-git-send-email-arik@wizery.com> (sfid-20111108_174708_813760_985FAEAD)
In-Reply-To: <1320770815-23332-1-git-send-email-arik@wizery.com>
References: <1320770815-23332-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx driver supports probe-response offloading, and the  WPS, WPS2
and P2P special cases as well.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v3->4: update name of wiphy flag

drivers/net/wireless/wl12xx/main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3750a6e..08b06ee 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -5017,6 +5017,13 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
 
+	/* the FW answers probe-requests in AP-mode */
+	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+	wl->hw->wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
+
 	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
-- 
1.7.5.4

