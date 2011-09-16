Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3445 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/19] staging: brcm80211: remove global variable
 brcmf_radio_up from fullmac
Date: Fri, 16 Sep 2011 12:27:55 -0700
Message-ID: <1316201288-29635-7-git-send-email-frankyl@broadcom.com> (sfid-20110916_212831_720156_E1DAB18A)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary global variable

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    3 ---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    4 +---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    3 ---
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 5316df9..2967ada 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -673,9 +673,6 @@ extern uint brcmf_arp_mode;
 /* ARP offload enable */
 extern uint brcmf_arp_enable;
 
-/* Roaming mode control */
-extern uint brcmf_radio_up;
-
 /* Override to force tx queueing all the time */
 extern uint brcmf_force_tx_queueing;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index c02c8cd..2e8db62 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -845,9 +845,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 				  sizeof(iovbuf));
 
 	/* Force STA UP */
-	if (brcmf_radio_up)
-		brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_UP, (char *)&up,
-					  sizeof(up));
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
 
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f462a5f..16f7216 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -98,9 +98,6 @@ module_param(brcmf_arp_mode, uint, 0);
 uint brcmf_arp_enable = true;
 module_param(brcmf_arp_enable, uint, 0);
 
-/* Control radio state */
-uint brcmf_radio_up = 1;
-
 /* Network inteface name */
 char iface_name[IFNAMSIZ] = "wlan";
 module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
-- 
1.7.1


