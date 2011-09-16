Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4649 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab1IPT2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/19] staging: brcm80211: remove brcmfmac interface
 name override
Date: Fri, 16 Sep 2011 12:28:04 -0700
Message-ID: <1316201288-29635-16-git-send-email-frankyl@broadcom.com> (sfid-20110916_212831_177141_E52FDED8)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The brcmfmac had a module parameter which could be used to override
the name of the wireless net device name and it defaults to 'wlan'.
This is considered rather useless, because what is in a name.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   28 ++++++------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 643c9c2..9919fa5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -82,9 +82,6 @@ struct brcmf_info {
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
 
-/* Network inteface name */
-char iface_name[IFNAMSIZ] = "wlan";
-module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 
 static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
 {
@@ -311,10 +308,11 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 			unregister_netdev(ifp->net);
 			free_netdev(ifp->net);
 		}
-		/* Allocate etherdev, including space for private structure */
-		ifp->net = alloc_etherdev(sizeof(drvr_priv));
+		/* Allocate netdev, including space for private structure */
+		ifp->net = alloc_netdev(sizeof(drvr_priv), "wlan%d",
+					ether_setup);
 		if (!ifp->net) {
-			brcmf_dbg(ERROR, "OOM - alloc_etherdev\n");
+			brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
@@ -1009,10 +1007,10 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Allocate etherdev, including space for private structure */
-	net = alloc_etherdev(sizeof(drvr_priv));
+	/* Allocate netdev, including space for private structure */
+	net = alloc_netdev(sizeof(drvr_priv), "wlan%d", ether_setup);
 	if (!net) {
-		brcmf_dbg(ERROR, "OOM - alloc_etherdev\n");
+		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
 		goto fail;
 	}
 
@@ -1028,18 +1026,6 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	 */
 	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
-	/* Set network interface name if it was provided as module parameter */
-	if (iface_name[0]) {
-		int len;
-		char ch;
-		strncpy(net->name, iface_name, IFNAMSIZ);
-		net->name[IFNAMSIZ - 1] = 0;
-		len = strlen(net->name);
-		ch = net->name[len - 1];
-		if ((ch > '9' || ch < '0') && (len < IFNAMSIZ - 2))
-			strcat(net->name, "%d");
-	}
-
 	if (brcmf_add_if(drvr_priv, 0, net, net->name, NULL, 0, 0) ==
 	    BRCMF_BAD_IF)
 		goto fail;
-- 
1.7.1


