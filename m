Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64648 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbZJOHfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 03:35:17 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Vidhya Govindan <vidhya.govindan@nokia.com>,
	=?utf-8?q?Janne=20Yl=C3=A4lehto?= <janne.ylalehto@nokia.com>
Subject: [PATCH 1/5] wl1271: Set IEEE80211_FCTL_TODS in the null data template
Date: Thu, 15 Oct 2009 10:33:26 +0300
Message-Id: <1255592010-10287-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
References: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Set the IEEE80211_FCTL_TODS bit in the FC of the null data template.
This is a mandatory requirement in specification.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: Vidhya Govindan <vidhya.govindan@nokia.com>
Cc: Janne Ylälehto <janne.ylalehto@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index fe4f1e6..1d64aa4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -769,7 +769,8 @@ int wl1271_cmd_build_null_data(struct wl1271 *wl)
 
 	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
 	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
-						IEEE80211_STYPE_NULLFUNC);
+						IEEE80211_STYPE_NULLFUNC |
+						IEEE80211_FCTL_TODS);
 
 	return wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, &template,
 				       sizeof(template));
-- 
1.5.6.5

