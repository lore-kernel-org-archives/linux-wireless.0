Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3455 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/19] staging: brcm80211: remove global variable
 brcmf_roam from fullmac
Date: Fri, 16 Sep 2011 12:27:54 -0700
Message-ID: <1316201288-29635-6-git-send-email-frankyl@broadcom.com> (sfid-20110916_212854_062080_FE881D62)
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
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    3 ++-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    3 ---
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 329851c..5316df9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -674,9 +674,6 @@ extern uint brcmf_arp_mode;
 extern uint brcmf_arp_enable;
 
 /* Roaming mode control */
-extern uint brcmf_roam;
-
-/* Roaming mode control */
 extern uint brcmf_radio_up;
 
 /* Override to force tx queueing all the time */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 5ae4a40..c02c8cd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -794,6 +794,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	char buf[128], *ptr;
 	u32 dongle_align = BRCMF_SDALIGN;
 	u32 glom = 0;
+	u32 roaming = 1;
 	uint bcn_timeout = 3;
 	int scan_assoc_time = 40;
 	int scan_unassoc_time = 40;
@@ -838,7 +839,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	brcmu_mkiovar("roam_off", (char *)&brcmf_roam, 4,
+	brcmu_mkiovar("roam_off", (char *)&roaming, 4,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 8e729d8..f462a5f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -98,9 +98,6 @@ module_param(brcmf_arp_mode, uint, 0);
 uint brcmf_arp_enable = true;
 module_param(brcmf_arp_enable, uint, 0);
 
-/* Contorl fw roaming */
-uint brcmf_roam = 1;
-
 /* Control radio state */
 uint brcmf_radio_up = 1;
 
-- 
1.7.1


