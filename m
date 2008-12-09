Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:57686 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbYLIXFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 18:05:45 -0500
Received: by ey-out-2122.google.com with SMTP id 6so44802eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 15:05:42 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] spectrum_cs: Fix function names used in debug strings
Date: Tue,  9 Dec 2008 23:05:38 +0000
Message-Id: <1228863938-15836-1-git-send-email-kilroyd@googlemail.com> (sfid-20081210_000550_994831_91AF5C97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/spectrum_cs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index c6c6d12..1c3a951 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -248,13 +248,17 @@ static int spectrum_cs_config_check(struct pcmcia_device *p_dev,
 	/* Note that the CIS values need to be rescaled */
 	if (cfg->vcc.present & (1 << CISTPL_POWER_VNOM)) {
 		if (vcc != cfg->vcc.param[CISTPL_POWER_VNOM] / 10000) {
-			DEBUG(2, "spectrum_cs_config: Vcc mismatch (vcc = %d, CIS = %d)\n",  vcc, cfg->vcc.param[CISTPL_POWER_VNOM] / 10000);
+			DEBUG(2, "%s: Vcc mismatch (vcc = %d, CIS = %d)\n",
+			      __func__, vcc,
+			      cfg->vcc.param[CISTPL_POWER_VNOM] / 10000);
 			if (!ignore_cis_vcc)
 				goto next_entry;
 		}
 	} else if (dflt->vcc.present & (1 << CISTPL_POWER_VNOM)) {
 		if (vcc != dflt->vcc.param[CISTPL_POWER_VNOM] / 10000) {
-			DEBUG(2, "spectrum_cs_config: Vcc mismatch (vcc = %d, CIS = %d)\n",  vcc, dflt->vcc.param[CISTPL_POWER_VNOM] / 10000);
+			DEBUG(2, "%s: Vcc mismatch (vcc = %d, CIS = %d)\n",
+			      __func__, vcc,
+			      dflt->vcc.param[CISTPL_POWER_VNOM] / 10000);
 			if (!ignore_cis_vcc)
 				goto next_entry;
 		}
-- 
1.5.6.4

