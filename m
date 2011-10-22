Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40208 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1JVT5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 15:57:19 -0400
Received: by bkbzt19 with SMTP id zt19so6314189bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 12:57:18 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] wl12xx: configure the probe response offloading support
Date: Sat, 22 Oct 2011 21:55:05 +0200
Message-Id: <1319313305-28847-1-git-send-email-guy@wizery.com> (sfid-20111022_215726_174118_1A9FA7EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the probe response offload wiphy struct with
the relevant protocols supported currently by the driver.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
v2:
now using the wiphy struct instead of a function and the conf_drv_settings

 drivers/net/wireless/wl12xx/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f76be5a..833f3e7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4965,6 +4965,12 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
 
+	wl->hw->wiphy->flags |= WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD;
+	wl->hw->wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
+
 	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
-- 
1.7.4.1

