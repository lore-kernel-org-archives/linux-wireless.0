Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63240 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbZKQQt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:26 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 07/16] wl1251: mask aid bits 14 and 15 in ps-poll template
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:00 +0200
Message-ID: <20091117164859.2236.92487.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

In ps-poll template aid bits 14 and 15 were not masked as required by the
standard. Mask them so that aid is sent in correct format.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 1f4c238..41f5ad4 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -580,7 +580,10 @@ static int wl1251_build_ps_poll(struct wl1251 *wl, u16 aid)
 
 	memcpy(template.bssid, wl->bssid, ETH_ALEN);
 	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
-	template.aid = aid;
+
+	/* aid in PS-Poll has its two MSBs each set to 1 */
+	template.aid = cpu_to_le16(1 << 15 | 1 << 14 | aid);
+
 	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
 
 	return wl1251_cmd_template_set(wl, CMD_PS_POLL, &template,

