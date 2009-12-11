Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63542 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762590AbZLKLlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:51 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <lucinao.coelho@nokia.com>
Subject: [PATCH 09/31] wl1271: set null data template when BSSID is known
Date: Fri, 11 Dec 2009 13:41:00 +0200
Message-Id: <1260531682-4695-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to wl1271_cmd_build_null_data() was missing when we got associated,
this was causing PS to fail.  This patch adds the call and now PS seems to
work.

Signed-off-by: Luciano Coelho <lucinao.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index ffd615e..4b5ee41 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1545,6 +1545,12 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
 			wl->rx_config |= CFG_BSSID_FILTER_EN;
 			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+			ret = wl1271_cmd_build_null_data(wl);
+			if (ret < 0) {
+				wl1271_warning("cmd buld null data failed %d",
+					       ret);
+				goto out_sleep;
+			}
 			ret = wl1271_cmd_join(wl);
 			if (ret < 0) {
 				wl1271_warning("cmd join failed %d", ret);
-- 
1.6.3.3

