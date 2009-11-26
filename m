Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58819 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900AbZKZJCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:02:49 -0500
Subject: [PATCH 3/3] wl1251: don't build null data template in
	wl1251_op_config()
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 10:56:13 +0200
Message-ID: <20091126085613.1564.36360.stgit@tikku>
In-Reply-To: <20091126085256.1564.77644.stgit@tikku>
References: <20091126085256.1564.77644.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The bssid can be zero when null data template is set in wl1251_op_config().
It's enough, and especially safe, to set it once after association.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 50d17fc..2f50a25 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -629,10 +629,6 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out_sleep;
 	}
 
-	ret = wl1251_build_null_data(wl);
-	if (ret < 0)
-		goto out_sleep;
-
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm enabled");
 

