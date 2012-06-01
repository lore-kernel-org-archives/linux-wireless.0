Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35568 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964978Ab2FAQTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 12:19:08 -0400
Received: by dady13 with SMTP id y13so2986699dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2012 09:19:08 -0700 (PDT)
From: Grant Erickson <marathon96@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] wl12xx: Add support for an external 26 MHz crystal source
Date: Fri,  1 Jun 2012 09:19:01 -0700
Message-Id: <1338567541-25585-1-git-send-email-marathon96@gmail.com> (sfid-20120601_181912_465407_0AC8ADE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for an external 26 MHz crystal source.

Signed-off-by: Grant Erickson <marathon96@gmail.com>
---
  v1 Initial submission.
  v2 Add a body description to the commit.

 drivers/net/wireless/ti/wl12xx/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d7dd3de..8617403 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -863,6 +863,7 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
 	else if (wl->ref_clock == CONF_REF_CLK_26_E ||
+		 wl->ref_clock == CONF_REF_CLK_26_M_XTAL ||
 		 wl->ref_clock == CONF_REF_CLK_52_E)
 		/* ref clk: 26/52 */
 		clk = 0x5;
-- 
1.7.10.2

