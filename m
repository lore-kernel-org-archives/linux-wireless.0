Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7640 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbXGCPX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:29 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:23 +0200
Subject: [PATCH] libertas: remove adapter->regiontableindex
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.23975.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value was computed, but then never used.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmdresp.c |    2 --
 drivers/net/wireless/libertas/dev.h     |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 0c2f5e9..fe2d4e5 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -179,7 +179,6 @@ static int wlan_ret_get_hw_spec(wlan_private * priv,
 	for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
 		/* use the region code to search for the index */
 		if (adapter->regioncode == libertas_region_code_to_index[i]) {
-			adapter->regiontableindex = (u16) i;
 			break;
 		}
 	}
@@ -187,7 +186,6 @@ static int wlan_ret_get_hw_spec(wlan_private * priv,
 	/* if it's unidentified region code, use the default (USA) */
 	if (i >= MRVDRV_MAX_REGION_CODE) {
 		adapter->regioncode = 0x10;
-		adapter->regiontableindex = 0;
 		lbs_pr_info("unidentified region code; using the default (USA)\n");
 	}
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index c52ce0b..5bb8e51 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -298,7 +298,6 @@ struct _wlan_adapter {
 	u16 currentpacketfilter;
 	u32 connect_status;
 	u16 regioncode;
-	u16 regiontableindex;
 	u16 txpowerlevel;
 
 	/** POWER MANAGEMENT AND PnP SUPPORT */
-- 
1.5.2.1

