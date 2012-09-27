Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41669 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2I0Kil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:41 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 13/31] wlcore: resume() only if sta is associated
Date: Thu, 27 Sep 2012 13:37:51 +0300
Message-Id: <1348742289-6587-14-git-send-email-luca@coelho.fi> (sfid-20120927_124006_202707_C74C5415)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

mac80211's resume() callback might get called even if
the sta is not associated (but only up). The
resume sequence in this case results in configuring
the wake-up conditions of a non-started role, which
causes fw assertion.

Fix it by bailing out if the STA is not connected
(like we do on suspend()).

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a797ce7..ae2b0fd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1672,6 +1672,9 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if ((!is_ap) && (!is_sta))
 		return;
 
+	if (is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+		return;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		return;
-- 
1.7.10.4

