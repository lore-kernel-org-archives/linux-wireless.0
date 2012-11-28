Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61071 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2K1Jn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:29 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384896wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:28 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 17/20] wl18xx: support MIMO only if HT mode is not forced to SISO
Date: Wed, 28 Nov 2012 11:42:46 +0200
Message-Id: <1354095769-8724-18-git-send-email-arik@wizery.com> (sfid-20121128_104342_876678_EDB458A8)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't use MIMO rates when HT mode is forced to SISO, even if we have
multiple antennas.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ada4616..ed44ba6 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1109,7 +1109,13 @@ static bool wl18xx_is_mimo_supported(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
 
-	return priv->conf.phy.number_of_assembled_ant2_4 >= 2;
+	/*
+	 * only support MIMO with multiple antennas, and when SISO
+	 * is not forced through config
+	 */
+	return (priv->conf.phy.number_of_assembled_ant2_4 >= 2) &&
+	       (priv->conf.ht.mode != HT_MODE_WIDE) &&
+	       (priv->conf.ht.mode != HT_MODE_SISO20);
 }
 
 /*
-- 
1.7.9.5

