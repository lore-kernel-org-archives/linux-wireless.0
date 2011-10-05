Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2287 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934680Ab1JENUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/15] staging: brcm80211: clean up struct brcmf_if in
 fullmac
Date: Wed, 5 Oct 2011 15:20:13 +0200
Message-ID: <1317820814-7083-15-git-send-email-arend@broadcom.com> (sfid-20111005_152033_692115_B1541F49)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Some elements in structure brcmf_if are unused at all or
redundant. This patch cleans it up.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 804b2bc..b0202b7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -58,11 +58,7 @@ struct brcmf_if {
 	struct net_device_stats stats;
 	int idx;		/* iface idx in dongle */
 	int state;		/* interface state */
-	uint subunit;		/* subunit */
 	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
-	bool attached;		/* Delayed attachment when unset */
-	bool txflowcontrol;	/* Per interface flow control indicator */
-	char name[IFNAMSIZ];	/* linux interface name */
 };
 
 /* Local private structure (extension of pub) */
@@ -100,14 +96,16 @@ static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *ndev)
 int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 {
 	int i = BRCMF_MAX_IFS;
+	struct brcmf_if *ifp;
 
 	if (name == NULL || *name == '\0')
 		return 0;
 
-	while (--i > 0)
-		if (drvr_priv->iflist[i]
-		    && !strncmp(drvr_priv->iflist[i]->name, name, IFNAMSIZ))
+	while (--i > 0) {
+		ifp = drvr_priv->iflist[i];
+		if (ifp && !strncmp(ifp->ndev->name, name, IFNAMSIZ))
 			break;
+	}
 
 	brcmf_dbg(TRACE, "return idx %d for \"%s\"\n", i, name);
 
@@ -315,7 +313,6 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
-			strcpy(ifp->ndev->name, ifp->name);
 			memcpy(netdev_priv(ifp->ndev), &drvr_priv,
 			       sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
@@ -980,7 +977,6 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
 	memset(ifp, 0, sizeof(struct brcmf_if));
 	ifp->info = drvr_priv;
 	drvr_priv->iflist[ifidx] = ifp;
-	strlcpy(ifp->name, name, IFNAMSIZ);
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-- 
1.7.4.1


