Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4647 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab1IPT2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/19] staging: brcm80211: remove fullmac module_param
 for ARP offload feature
Date: Fri, 16 Sep 2011 12:28:03 -0700
Message-ID: <1316201288-29635-15-git-send-email-frankyl@broadcom.com> (sfid-20110916_212835_294093_FEE0693D)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use macro to replace global variable for ARP offload configuration

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   10 ----------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    6 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    9 ---------
 3 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index e543640..de3f914 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -665,16 +665,6 @@ struct bcmevent_name {
 	const char *name;
 };
 
-/*
- * Insmod parameters for debug/test
- */
-
-/* ARP offload agent mode */
-extern uint brcmf_arp_mode;
-
-/* ARP offload enable */
-extern uint brcmf_arp_enable;
-
 /* Override to force tx queueing all the time */
 extern uint brcmf_force_tx_queueing;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 2e8db62..02c022a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -30,6 +30,7 @@
 #define DOT11_OUI_LEN			3
 #define BCMILCP_BCM_SUBTYPE_EVENT	1
 #define PKTFILTER_BUF_SIZE		2048
+#define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
 
 int brcmf_msg_level;
 
@@ -859,9 +860,8 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
 
 	/* Set and enable ARP offload feature */
-	if (brcmf_arp_enable)
-		brcmf_c_arp_offload_set(drvr, brcmf_arp_mode);
-	brcmf_c_arp_offload_enable(drvr, brcmf_arp_enable);
+	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);
+	brcmf_c_arp_offload_enable(drvr, true);
 
 	/* Set up pkt filter */
 	for (i = 0; i < drvr->pktfilter_count; i++) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 3b2d500..643c9c2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -82,15 +82,6 @@ struct brcmf_info {
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
 
-/* ARP offload agent mode : Enable ARP Host Auto-Reply
-and ARP Peer Auto-Reply */
-uint brcmf_arp_mode = 0xb;
-module_param(brcmf_arp_mode, uint, 0);
-
-/* ARP offload enable */
-uint brcmf_arp_enable = true;
-module_param(brcmf_arp_enable, uint, 0);
-
 /* Network inteface name */
 char iface_name[IFNAMSIZ] = "wlan";
 module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
-- 
1.7.1


