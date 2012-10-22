Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4669 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab2JVRhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:37:13 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 02/14] brcmfmac: remove unused iswl variable.
Date: Mon, 22 Oct 2012 10:36:15 -0700
Message-ID: <1350927387-25608-3-git-send-email-frankyl@broadcom.com> (sfid-20121022_193717_634348_2DEC20C8)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Variable iswl always gets initialised to the same and support for
this var is not needed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    3 ---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   10 +---------
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    2 +-
 4 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a73da9d..c915d33 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -629,7 +629,6 @@ struct brcmf_pub {
 	u8 wme_dp;		/* wme discard priority */
 
 	/* Dongle media info */
-	bool iswl;		/* Dongle-resident driver is wl */
 	unsigned long drv_version;	/* Version of dongle-resident driver */
 	u8 mac[ETH_ALEN];		/* MAC address obtained from dongle */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index a5c15ca..b07a438 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -481,9 +481,6 @@ int brcmf_proto_init(struct brcmf_pub *drvr)
 
 	ret = brcmf_c_preinit_dcmds(drvr);
 
-	/* Always assumes wl for now */
-	drvr->iswl = true;
-
 	return ret;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 189c5be..5f91fae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -619,12 +619,9 @@ static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
 			brcmf_dbg(ERROR, "dongle is not up\n");
 			return -ENODEV;
 		}
-
 		/* finally, report dongle driver type */
-		else if (drvr->iswl)
-			sprintf(info.driver, "wl");
 		else
-			sprintf(info.driver, "xx");
+			sprintf(info.driver, "wl");
 
 		sprintf(info.version, "%lu", drvr->drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
@@ -734,11 +731,6 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 		goto done;
 	}
 
-	if (!drvr->iswl) {
-		err = -EIO;
-		goto done;
-	}
-
 	/*
 	 * Intercept BRCMF_C_SET_KEY CMD - serialize M4 send and
 	 * set key CMD to prevent M4 encryption.
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 6bc4425..f3e72de 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -28,7 +28,7 @@ extern int brcmf_proto_attach(struct brcmf_pub *drvr);
 extern void brcmf_proto_detach(struct brcmf_pub *drvr);
 
 /* Initialize protocol: sync w/dongle state.
- * Sets dongle media info (iswl, drv_version, mac address).
+ * Sets dongle media info (drv_version, mac address).
  */
 extern int brcmf_proto_init(struct brcmf_pub *drvr);
 
-- 
1.7.6


