Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45756 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbZHGKfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:35:01 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 17/23] wl1251: fix channel setting in wl1251_op_config()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:49 +0300
Message-ID: <20090807103448.31717.69202.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

There is a bug in wl1251_op_config(). It was calling join with previous
channel. Fix it by setting assigning wl->channel before calling join command.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index e575b78..568b640 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -593,12 +593,12 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	if (channel != wl->channel) {
+		wl->channel = channel;
+
 		ret = wl1251_join(wl, wl->bss_type, wl->channel,
 				  wl->beacon_int, wl->dtim_period);
 		if (ret < 0)
 			goto out_sleep;
-
-		wl->channel = channel;
 	}
 
 	ret = wl1251_build_null_data(wl);

