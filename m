Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57511 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3ICOeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:23 -0400
Received: by mail-wi0-f174.google.com with SMTP id hj3so2052032wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] wlcore: disable elp sleep while in plt mode
Date: Tue,  3 Sep 2013 17:33:59 +0300
Message-Id: <1378218848-7853-3-git-send-email-eliad@wizery.com> (sfid-20130903_163447_030466_8A507CC1)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

We now disable elp sleep during plt mode to allow normal operation of
plt tools such as calibrator.

Having elp_sleep enabled during plt mode is actually not required and
in fact it disrupt plt operations such as rx statistics etc.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/ps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 98066d4..26bfc36 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -83,6 +83,10 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	struct wl12xx_vif *wlvif;
 	u32 timeout;
 
+	/* We do not enter elp sleep in PLT mode */
+	if (wl->plt)
+		return;
+
 	if (wl->sleep_auth != WL1271_PSM_ELP)
 		return;
 
-- 
1.8.3.rc1.35.g9b79519

