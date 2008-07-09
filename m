Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:37107 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYGIGa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 02:30:29 -0400
Date: Wed, 9 Jul 2008 09:29:58 +0300
From: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
Message-ID: <20080709092958.72e82f25@promwad.com> (sfid-20080709_083035_261251_33DF632B)
In-Reply-To: <1215563092.476.58.camel@brick>
References: <20080709031850.2e7bf50f@promwad.com>
	<1215563092.476.58.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> There's helpers for this now: get_unaligned_le16
Ok, third pass - the first was in January... :)

Fixing unaligned memory access on the blackfin architecture (maybe on
the ARM also).

Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>

---

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 343ed38..4b27456 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -567,11 +567,11 @@ static int lbs_process_bss(struct bss_descriptor *bss,
	pos += 8;

	/* beacon interval is 2 bytes long */
-	bss->beaconperiod = le16_to_cpup((void *) pos);
+	bss->beaconperiod = get_unaligned_le16(pos);
	pos += 2;

	/* capability information is 2 bytes long */
-	bss->capability = le16_to_cpup((void *) pos);
+	bss->capability = get_unaligned_le16(pos);
	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
	pos += 2;

