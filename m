Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52595 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZKQQtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:23 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 09/16] wl1251: Set the correct dtim period to the firmware
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:16 +0200
Message-ID: <20091117164915.2236.92480.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidhya Govindan <vidhya.govindan@nokia.com>

This patch sets the dtim period obtained from the mac80211 to firmware.

Signed-off-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 41f5ad4..cc32ba6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1105,8 +1105,8 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->beacon_int = bss_conf->beacon_int;
 			wl->dtim_period = bss_conf->dtim_period;
 
-			/* FIXME: call join */
-
+			ret = wl1251_acx_wr_tbtt_and_dtim(wl, wl->beacon_int,
+							  wl->dtim_period);
 			wl->aid = bss_conf->aid;
 
 			ret = wl1251_build_ps_poll(wl, wl->aid);

