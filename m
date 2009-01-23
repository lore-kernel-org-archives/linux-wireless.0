Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56377 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbZAWQ5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:57:13 -0500
Subject: [PATCH] libertas: fix CF firmware loading for some cards
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	ryan@bluewatersys.com,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Cyril HAENEL <chaenel@free.fr>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 11:55:33 -0500
Message-Id: <1232729733.2577.13.camel@localhost.localdomain> (sfid-20090123_175718_412973_940E4BA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if_cs_poll_while_fw_download() returned the number of iterations
remaining on success, which in turn got returned as the value from
if_cs_prog_real() and if_cs_prog_helper().  But since if_cs_probe()
interprets non-zero return values from firmware load functions as an
error, this sometimes caused spurious firmware load failures.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 842a08d..8f8934a 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -151,7 +151,7 @@ static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint addr, u8 r
 	for (i = 0; i < 100000; i++) {
 		u8 val = if_cs_read8(card, addr);
 		if (val == reg)
-			return i;
+			return 0;
 		udelay(5);
 	}
 	return -ETIME;


