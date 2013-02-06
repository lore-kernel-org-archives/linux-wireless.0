Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4280 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab3BFRlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:09 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/12] brcmfmac: add function to retrieve chip
 information
Date: Wed, 6 Feb 2013 18:40:46 +0100
Message-ID: <1360172447-2424-12-git-send-email-arend@broadcom.com> (sfid-20130206_184124_000743_3401857E)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added function to obtain chip information for chip specific
code.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h       |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index f0e81a8..e17f68a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -552,5 +552,6 @@ extern int brcmf_net_attach(struct brcmf_if *ifp);
 extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
 				     s32 bssidx, char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
+extern u32 brcmf_get_chip_info(struct brcmf_if *ifp);
 
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a09c077..6202ad2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -895,6 +895,16 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 	return !err;
 }
 
+/*
+ * return chip id and rev of the device encoded in u32.
+ */
+u32 brcmf_get_chip_info(struct brcmf_if *ifp)
+{
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
+
+	return bus->chip << 4 | bus->chiprev;
+}
+
 static void brcmf_driver_init(struct work_struct *work)
 {
 	brcmf_debugfs_init();
-- 
1.7.10.4


