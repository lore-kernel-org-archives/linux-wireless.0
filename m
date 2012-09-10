Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4778 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab2IJNRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:17:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/10] brcmfmac: Fix big endian host configuration data.
Date: Mon, 10 Sep 2012 15:16:55 +0200
Message-ID: <1347283018-24223-8-git-send-email-arend@broadcom.com> (sfid-20120910_151723_033401_AD9CF588)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Fixes big endian host configuration parameters.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   26 ++++++++++++--------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 2621dd3..6f70953 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -764,8 +764,11 @@ static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 {
 	char iovbuf[32];
 	int retcode;
+	__le32 arp_mode_le;
 
-	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
+	arp_mode_le = cpu_to_le32(arp_mode);
+	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode_le, 4, iovbuf,
+			sizeof(iovbuf));
 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
@@ -781,8 +784,11 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 {
 	char iovbuf[32];
 	int retcode;
+	__le32 arp_enable_le;
 
-	brcmf_c_mkiovar("arpoe", (char *)&arp_enable, 4,
+	arp_enable_le = cpu_to_le32(arp_enable);
+
+	brcmf_c_mkiovar("arpoe", (char *)&arp_enable_le, 4,
 			iovbuf, sizeof(iovbuf));
 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
@@ -800,10 +806,10 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
 	char buf[128], *ptr;
-	u32 roaming = 1;
-	uint bcn_timeout = 3;
-	int scan_assoc_time = 40;
-	int scan_unassoc_time = 40;
+	__le32 roaming_le = cpu_to_le32(1);
+	__le32 bcn_timeout_le = cpu_to_le32(3);
+	__le32 scan_assoc_time_le = cpu_to_le32(40);
+	__le32 scan_unassoc_time_le = cpu_to_le32(40);
 	int i;
 	struct brcmf_bus_dcmd *cmdlst;
 	struct list_head *cur, *q;
@@ -829,14 +835,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
-	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
+	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout_le, 4, iovbuf,
 		    sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	brcmf_c_mkiovar("roam_off", (char *)&roaming, 4,
+	brcmf_c_mkiovar("roam_off", (char *)&roaming_le, 4,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
@@ -848,9 +854,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 				  sizeof(iovbuf));
 
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
+		 (char *)&scan_assoc_time_le, sizeof(scan_assoc_time_le));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
+		 (char *)&scan_unassoc_time_le, sizeof(scan_unassoc_time_le));
 
 	/* Set and enable ARP offload feature */
 	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);
-- 
1.7.9.5


