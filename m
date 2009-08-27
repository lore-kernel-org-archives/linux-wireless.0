Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24536 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZH0VA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:28 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 06/13] wl1271: mask aid bits 14 and 15 in ps-poll template
Date: Fri, 28 Aug 2009 00:00:00 +0300
Message-Id: <1251406807-31495-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In ps-poll template aid bits 14 and 15 were not masked as required by
the standard. Mask them so that aid is sent in correct format.

This patch is a direct port of the respective patch for the wl1251
driver by Kalle Valo.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 1ee1b2b..bd65b38 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -682,7 +682,10 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 
 	memcpy(template.bssid, wl->bssid, ETH_ALEN);
 	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
-	template.aid = aid;
+
+	/* aid in PS-Poll has its two MSBs each set to 1 */
+	template.aid = cpu_to_le16(1 << 15 | 1 << 14 | aid);
+
 	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
 
 	return wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, &template,
-- 
1.5.6.5

