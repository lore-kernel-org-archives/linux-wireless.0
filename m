Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17977 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZKQQt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:56 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 14/16] wl1251: Send null data packet with "TODS" bit set
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:54 +0200
Message-ID: <20091117164953.2236.66490.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidhya Govindan <vidhya.govindan@nokia.com>

According to IEEE80211 standard all the data packets have to be sent with
TODS bit set. This patch fixes the null data packet format which was sent
without TODS bit set. This should fix many problems associated with
power save. Janne Ylalehto also found this fix in the same time as mine,
for a different bug he was working on.

Signed-off-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 2e1c10f..ff4be7b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -576,7 +576,8 @@ static int wl1251_build_null_data(struct wl1251 *wl)
 
 	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
 	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
-						IEEE80211_STYPE_NULLFUNC);
+						IEEE80211_STYPE_NULLFUNC |
+						IEEE80211_FCTL_TODS);
 
 	return wl1251_cmd_template_set(wl, CMD_NULL_DATA, &template,
 				       sizeof(template));

