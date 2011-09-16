Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3495 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/19] staging: brcm80211: remove fullmac module_param
 for packet filter feature
Date: Fri, 16 Sep 2011 12:27:53 -0700
Message-ID: <1316201288-29635-5-git-send-email-frankyl@broadcom.com> (sfid-20110916_212842_939705_7B049827)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use constant values for packet filter configuration

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    9 ---------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   13 ++++---------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   12 ------------
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index c351349..329851c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -673,15 +673,6 @@ extern uint brcmf_arp_mode;
 /* ARP offload enable */
 extern uint brcmf_arp_enable;
 
-/* Pkt filte enable control */
-extern uint brcmf_pkt_filter_enable;
-
-/*  Pkt filter init setup */
-extern uint brcmf_pkt_filter_init;
-
-/* Pkt filter mode control */
-extern uint brcmf_master_mode;
-
 /* Roaming mode control */
 extern uint brcmf_roam;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index fd39998..5ae4a40 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -865,15 +865,10 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	brcmf_c_arp_offload_enable(drvr, brcmf_arp_enable);
 
 	/* Set up pkt filter */
-	if (brcmf_pkt_filter_enable) {
-		for (i = 0; i < drvr->pktfilter_count; i++) {
-			brcmf_c_pktfilter_offload_set(drvr,
-						  drvr->pktfilter[i]);
-			brcmf_c_pktfilter_offload_enable(drvr,
-			     drvr->pktfilter[i],
-			     brcmf_pkt_filter_init,
-			     brcmf_master_mode);
-		}
+	for (i = 0; i < drvr->pktfilter_count; i++) {
+		brcmf_c_pktfilter_offload_set(drvr, drvr->pktfilter[i]);
+		brcmf_c_pktfilter_offload_enable(drvr, drvr->pktfilter[i],
+						 0, true);
 	}
 
 	brcmf_os_proto_unblock(drvr);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 8286885..8e729d8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -98,18 +98,6 @@ module_param(brcmf_arp_mode, uint, 0);
 uint brcmf_arp_enable = true;
 module_param(brcmf_arp_enable, uint, 0);
 
-/* Global Pkt filter enable control */
-uint brcmf_pkt_filter_enable = true;
-module_param(brcmf_pkt_filter_enable, uint, 0);
-
-/*  Pkt filter init setup */
-uint brcmf_pkt_filter_init;
-module_param(brcmf_pkt_filter_init, uint, 0);
-
-/* Pkt filter mode control */
-uint brcmf_master_mode = true;
-module_param(brcmf_master_mode, uint, 0);
-
 /* Contorl fw roaming */
 uint brcmf_roam = 1;
 
-- 
1.7.1


