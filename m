Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0AZWmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 17:42:03 -0500
Date: Tue, 26 Jan 2010 16:42:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, zajec5@gmail.com
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: N PHY: Fix compilation after removal of typdef
 b43_c32
Message-ID: <4b5f6fba.foXrkAD8gU11wYBv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the conversion between typedef and struct, two places that needed a "struct"
were missed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Without these, compilation fails.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/phy_n.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_n.c
+++ wireless-testing/drivers/net/wireless/b43/phy_n.c
@@ -822,7 +822,7 @@ static u16 b43_nphy_gen_load_samples(str
 {
 	int i;
 	u16 bw, len, rot, angle;
-	b43_c32 *samples;
+	struct b43_c32 *samples;
 
 
 	bw = (dev->phy.is_40mhz) ? 40 : 20;
@@ -840,7 +840,7 @@ static u16 b43_nphy_gen_load_samples(str
 		len = bw << 1;
 	}
 
-	samples = kzalloc(len * sizeof(b43_c32), GFP_KERNEL);
+	samples = kzalloc(len * sizeof(struct b43_c32), GFP_KERNEL);
 	rot = (((freq * 36) / bw) << 16) / 100;
 	angle = 0;
 
