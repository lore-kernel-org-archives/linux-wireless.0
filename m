Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3446 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/9] brcm80211: fmac: postpone dongle RF enabling.
Date: Wed, 11 Apr 2012 11:52:47 +0200
Message-ID: <1334137971-3972-6-git-send-email-arend@broadcom.com> (sfid-20120411_115345_547896_701F7156)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

BRCMF_C_UP is the command that asks the firmware to enable RF of
dongle. Some firmware initialization steps must be performed during
RF is down. Postpone BRCMF_C_UP firing until brcmf_netdev_open get
called to ensure firmware have enough time to finish
initialization.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    4 ----
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 4187435..236cb9f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -799,7 +799,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 {
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
-	uint up = 0;
 	char buf[128], *ptr;
 	u32 dongle_align = drvr->bus_if->align;
 	u32 glom = 0;
@@ -853,9 +852,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
-	/* Force STA UP */
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
-
 	/* Setup event_msgs */
 	brcmf_c_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 00b6270..8933f9b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -799,6 +799,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	struct brcmf_bus *bus_if = drvr->bus_if;
 	u32 toe_ol;
 	s32 ret = 0;
+	uint up = 0;
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
 
@@ -822,6 +823,10 @@ static int brcmf_netdev_open(struct net_device *ndev)
 			drvr->iflist[ifp->idx]->ndev->features &=
 				~NETIF_F_IP_CSUM;
 	}
+
+	/* make sure RF is ready for work */
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
+
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
 	drvr->bus_if->drvr_up = true;
-- 
1.7.5.4


