Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbXIAEhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:13 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 440CA618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:12 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 31/35] Simplify logic in at76_is_hidden_ssid()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:11 -0400
Message-ID: <20070901043711.2498.5859.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index e612dc5..89eca8d 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -542,9 +542,13 @@ static inline int at76_is_hidden_ssid(u8 *ssid, int length)
 {
 	static const u8 zeros[32];
 
-	return (length == 0) ||
-	    (length == 1 && *ssid == ' ') ||
-	    (length > 0 && !memcmp(ssid, zeros, length));
+	if (length == 0)
+		return 1;
+
+	if (length == 1 && ssid[0] == ' ')
+		return 1;
+
+	return (memcmp(ssid, zeros, length) == 0);
 }
 
 static inline void at76_free_bss_list(struct at76_priv *priv)
