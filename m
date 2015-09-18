Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15590 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbIRUIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/16] brcmfmac: Only assign primary netdev to if2bss array.
Date: Fri, 18 Sep 2015 22:08:07 +0200
Message-ID: <1442606899-31872-5-git-send-email-arend@broadcom.com> (sfid-20150918_221654_014954_7D53D291)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The if2bss allows for translation of ifidx to bssidx which has a 1:n
relation. Therefor only the first (primary) netdev should be
assigned in this array. This fixes the p2pon=1 module param usage.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 17658b5..571c305 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -53,6 +53,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define BRCMF_RXREORDER_EXPIDX_VALID		0x08
 #define BRCMF_RXREORDER_NEW_HOLE		0x10
 
+#define BRCMF_BSSIDX_INVALID			-1
+
 /* Error bits */
 int brcmf_msg_level;
 module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
@@ -837,7 +839,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		ifp = netdev_priv(ndev);
 		ifp->ndev = ndev;
 		/* store mapping ifidx to bssidx */
-		drvr->if2bss[ifidx] = bssidx;
+		if (drvr->if2bss[ifidx] == BRCMF_BSSIDX_INVALID)
+			drvr->if2bss[ifidx] = bssidx;
 	}
 
 	ifp->drvr = drvr;
@@ -862,15 +865,15 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	struct brcmf_if *ifp;
 
 	ifp = drvr->iflist[bssidx];
-	drvr->if2bss[ifp->ifidx] = -1;
 	drvr->iflist[bssidx] = NULL;
 	if (!ifp) {
 		brcmf_err("Null interface, idx=%d\n", bssidx);
 		return;
 	}
 	brcmf_dbg(TRACE, "Enter, idx=%d, ifidx=%d\n", bssidx, ifp->ifidx);
+	if (drvr->if2bss[ifp->ifidx] == bssidx)
+		drvr->if2bss[ifp->ifidx] = BRCMF_BSSIDX_INVALID;
 	if (ifp->ndev) {
-		drvr->if2bss[ifp->ifidx] = -1;
 		if (bssidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
 				rtnl_lock();
@@ -926,6 +929,7 @@ int brcmf_attach(struct device *dev)
 {
 	struct brcmf_pub *drvr = NULL;
 	int ret = 0;
+	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -934,7 +938,9 @@ int brcmf_attach(struct device *dev)
 	if (!drvr)
 		return -ENOMEM;
 
-	memset(drvr->if2bss, 0xFF, sizeof(drvr->if2bss));
+	for (i = 0; i < ARRAY_SIZE(drvr->if2bss); i++)
+		drvr->if2bss[i] = BRCMF_BSSIDX_INVALID;
+
 	mutex_init(&drvr->proto_block);
 
 	/* Link to bus module */
-- 
1.9.1

