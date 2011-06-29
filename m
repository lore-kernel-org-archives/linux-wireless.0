Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1910 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab1F2Xsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:47 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 062/119] staging: brcm80211: remove ARP_OFFLOAD_SUPPORT
 macro definition
Date: Wed, 29 Jun 2011 16:47:26 -0700
Message-ID: <1309391303-22741-63-git-send-email-frankyl@broadcom.com> (sfid-20110630_015019_630569_E8CFED9C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The conditional code for ARP offloading is now always enabled
in the fullmac driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile     |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 07b9340..8a7cbf3 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -16,7 +16,6 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y :=			\
-	-DARP_OFFLOAD_SUPPORT	\
 	-DBCMLXSDMMC		\
 	-DBCMPLATFORM_BUS	\
 	-DBCMSDIO		\
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index deb8566..8f593cf 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -1283,12 +1283,10 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
 
-#ifdef ARP_OFFLOAD_SUPPORT
 	/* Set and enable ARP offload feature */
 	if (brcmf_arp_enable)
 		brcmf_c_arp_offload_set(dhd, brcmf_arp_mode);
 	brcmf_c_arp_offload_enable(dhd, brcmf_arp_enable);
-#endif				/* ARP_OFFLOAD_SUPPORT */
 
 #ifdef PKT_FILTER_SUPPORT
 	{
-- 
1.7.1


