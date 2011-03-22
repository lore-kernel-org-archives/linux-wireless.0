Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35697 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1CVQtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 12:49:16 -0400
Received: by qyk7 with SMTP id 7so3720814qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 09:49:15 -0700 (PDT)
Message-ID: <4d88d30b.cf4ee50a.763f.5820@mx.google.com>
Date: Tue, 22 Mar 2011 09:49:15 -0700 (PDT)
From: armadefuego@gmail.com
Subject: [PATCH 2.6.38-rc8-wl 1/1] orinoco: Clear dangling pointer on hardware busy
To: orinoco-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On hardware busy the scan request pointer should be cleared, as higher
levels will release. This avoids a crash when that pointer is
erroneously used later.

Signed-off-by: Joseph J. Gunn <armadefuego@yahoo.com>
---
When the hardware is busy the error is propagated to higher levels on
the stack. Those layers release the buffer. Therefore the copy of the
pointer must be erased. Otherwise subsequent events checking this pointer
may crash.
---
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 09fae2f..736bbb9 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -153,6 +153,9 @@ static int orinoco_scan(struct wiphy *wiphy, struct net_device *dev,
 	priv->scan_request = request;
 
 	err = orinoco_hw_trigger_scan(priv, request->ssids);
+	/* On error the we aren't processing the request */
+	if (err)
+		priv->scan_request = NULL;
 
 	return err;
 }
