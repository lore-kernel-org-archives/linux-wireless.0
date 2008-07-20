Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:53092 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbYGTDvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:51:42 -0400
Date: Sun, 20 Jul 2008 06:52:21 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 12/12] ath5k: Fix a compilation error after reg list update
Message-ID: <20080720035221.GL7440@makis> (sfid-20080720_055144_608863_AC681AFF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Last minute fix...

 AR5K_CPCORN is changed to AR5K_CPCOVF in reg list update so we have to update debug.c in order to compile

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 41d5fa3..6fa6c8e 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -129,7 +129,7 @@ static struct reg regs[] = {
 	REG_STRUCT_INIT(AR5K_CPC1),
 	REG_STRUCT_INIT(AR5K_CPC2),
 	REG_STRUCT_INIT(AR5K_CPC3),
-	REG_STRUCT_INIT(AR5K_CPCORN),
+	REG_STRUCT_INIT(AR5K_CPCOVF),
 	REG_STRUCT_INIT(AR5K_RESET_CTL),
 	REG_STRUCT_INIT(AR5K_SLEEP_CTL),
 	REG_STRUCT_INIT(AR5K_INTPEND),
