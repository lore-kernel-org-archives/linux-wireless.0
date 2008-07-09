Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:52537 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYGIATO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 20:19:14 -0400
Date: Wed, 9 Jul 2008 03:18:50 +0300
From: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: fix memory alignment problems on the blackfin
Message-ID: <20080709031850.2e7bf50f@promwad.com> (sfid-20080709_021917_725502_2E867518)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing unaligned memory access on the blackfin architecture (maybe on the ARM also).

Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>

---

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 343ed38..9dbfad3 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -567,11 +567,11 @@ static int lbs_process_bss(struct bss_descriptor *bss,
	pos += 8;

	/* beacon interval is 2 bytes long */
-	bss->beaconperiod = le16_to_cpup((void *) pos);
+	bss->beaconperiod = le16_to_cpu(get_unaligned((__le16 *)pos));
	pos += 2;

	/* capability information is 2 bytes long */
-	bss->capability = le16_to_cpup((void *) pos);
+	bss->capability = le16_to_cpu(get_unaligned((__le16 *)pos));
	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
	pos += 2;

