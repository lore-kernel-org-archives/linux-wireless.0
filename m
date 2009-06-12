Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64932 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbZFLLRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:17:08 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 23/33] wl12xx: Assign value to rx msdu lifetime variable
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:45 +0300
Message-ID: <20090612111645.8877.20243.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidhya Govindan <vidhya.govindan@nokia.com>

The patch "wl12xx: cmd and acx interface rework" failed to assign MSDU
lifetime value in wl12xx_acx_rx_msdu_life_time() and breaks the functionality.
This patch fixes the regression by assigning the correct value.

Signed-off-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/acx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 8227d6d..328f88a 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -317,6 +317,7 @@ int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time)
 		goto out;
 	}
 
+	acx->lifetime = life_time;
 	ret = wl12xx_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
 				   acx, sizeof(*acx));
 	if (ret < 0) {

