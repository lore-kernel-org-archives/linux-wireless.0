Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:54159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYLIVqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:46:36 -0500
Received: by nf-out-0910.google.com with SMTP id d3so44935nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 13:46:34 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/2] orinoco: Fix function names used in debug strings
Date: Tue,  9 Dec 2008 21:46:28 +0000
Message-Id: <1228859189-12867-1-git-send-email-kilroyd@googlemail.com> (sfid-20081209_224639_698714_4282C364)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco_cs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 6fcf2bd..14ff274 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -178,13 +178,17 @@ static int orinoco_cs_config_check(struct pcmcia_device *p_dev,
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

