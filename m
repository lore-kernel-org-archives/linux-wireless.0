Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62262 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3IQPlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 11:41:40 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so2875237eaj.28
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 08:41:39 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 03/11] wlcore: disable elp sleep while in plt mode
Date: Tue, 17 Sep 2013 18:41:22 +0300
Message-Id: <1379432490-22157-3-git-send-email-eliad@wizery.com> (sfid-20130917_174144_954134_C7E8B7B0)
In-Reply-To: <1379432490-22157-1-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
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

