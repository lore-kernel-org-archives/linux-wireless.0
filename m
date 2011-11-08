Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab1KHOgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:36:20 -0500
Received: by eye27 with SMTP id 27so396199eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:36:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 2/2] wl12xx: indicate probe-resp offloading support
Date: Tue,  8 Nov 2011 16:36:10 +0200
Message-Id: <1320762970-6860-2-git-send-email-arik@wizery.com> (sfid-20111108_153623_767561_E5C14A33)
In-Reply-To: <1320762970-6860-1-git-send-email-arik@wizery.com>
References: <1320762970-6860-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx driver supports probe-response offloading, and the  WPS, WPS2
and P2P special cases as well.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3750a6e..6c5f40b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -5017,6 +5017,12 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
 
+	wl->hw->wiphy->flags |= WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD;
+	wl->hw->wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
+
 	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
-- 
1.7.5.4

