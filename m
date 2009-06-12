Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63977 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812AbZFLLQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:44 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 19/33] wl12xx: protect wl12xx_op_set_rts_threshold()
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:20 +0300
Message-ID: <20090612111620.8877.30839.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The function doesn't lock the mutex before sending the acx.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8feba36..7ec1749 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -957,11 +957,15 @@ static int wl12xx_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	struct wl12xx *wl = hw->priv;
 	int ret;
 
+	mutex_lock(&wl->mutex);
+
 	ret = wl12xx_acx_rts_threshold(wl, (u16) value);
 
 	if (ret < 0)
 		wl12xx_warning("wl12xx_op_set_rts_threshold failed: %d", ret);
 
+	mutex_unlock(&wl->mutex);
+
 	return ret;
 }
 

