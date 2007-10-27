Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:39314 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXJ0XoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:44:20 -0400
Date: Sun, 28 Oct 2007 02:44:18 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 7/7] ath5k: Warn on partially supported chips
Message-ID: <20071027234418.GG5973@localhost.domain.invalid> (sfid-20071028_004424_495674_C4BE682B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 *Warn on partially supported chips (eg. 5414/5424)

These chips need work on PHY part, recently Reyk posted
a workaround so that they can work on 2GHz but i believe
that the problem is related to PHY initialization. Plz
we need help with these...

I did some tests on a 5414 at 5GHz and it seemed to work
but i didn't test it at 2GHz.

I'll try to find one of these and play with.

Changes-licensed-under: ISC
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index c95ae4b..ac105c6 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -285,6 +285,11 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		goto err_free;
 	}
 
+	/* Warn for partially supported chips (unsupported phy etc) */
+	if(srev >= AR5K_SREV_VER_AR2424){
+		printk(KERN_DEBUG "ath5k: Device partially supported.\n");
+	}
+
 	/* Identify single chip solutions */
 	if((srev <= AR5K_SREV_VER_AR5414) &&
 	(srev >= AR5K_SREV_VER_AR2424)) {



