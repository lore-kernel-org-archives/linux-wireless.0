Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29671 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbXGDG7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 02:59:51 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Wed, 4 Jul 2007 08:59:49 +0200
Subject: [PATCH 2/2] libertas: remove bss_descriptor->timestamp
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707040859.49814.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Noone used this variable.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/scan.c |    1 -
 drivers/net/wireless/libertas/scan.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index aea2e90..5c730b9 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -903,7 +903,6 @@ static int libertas_process_bss(struct bss_descriptor * bss,
 	pos++;
 
 	/* time stamp is 8 bytes long */
-	bss->timestamp = le64_to_cpup((void *) pos);
 	pos += 8;
 
 	/* beacon interval is 2 bytes long */
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
index 28decf3..9bb1a43 100644
--- a/drivers/net/wireless/libertas/scan.h
+++ b/drivers/net/wireless/libertas/scan.h
@@ -157,7 +157,6 @@ struct bss_descriptor {
 	/* zero-terminated array of supported data rates */
 	u8 rates[MAX_RATES + 1];
 
-	__le64 timestamp;	//!< TSF value included in the beacon/probe response
 	unsigned long last_scanned;
 
 	union ieeetypes_phyparamset phyparamset;
-- 
1.5.2.1

