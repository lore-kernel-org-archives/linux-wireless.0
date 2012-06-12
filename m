Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46095 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2FLJoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 05:44:44 -0400
Received: by wibhn6 with SMTP id hn6so3907917wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 02:44:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wlcore: update basic rates on channel switch
Date: Tue, 12 Jun 2012 12:45:27 +0300
Message-Id: <1339494327-28246-1-git-send-email-eliad@wizery.com> (sfid-20120612_114448_078180_65CC9BA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On channel switch we have to update the basic rates, in
order to reflect possible band changes (otherwise, we
might start beaconing on 11a with the default rates
of 11g).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1156e3f..21e0547 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2454,6 +2454,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wlvif->channel_type = conf->channel_type;
 
 		if (is_ap) {
+			wl1271_set_band_rate(wl, wlvif);
 			ret = wl1271_init_ap_rates(wl, wlvif);
 			if (ret < 0)
 				wl1271_error("AP rate policy change failed %d",
-- 
1.7.6.401.g6a319

