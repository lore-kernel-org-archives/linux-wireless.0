Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4560 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/20] staging: brcm80211: simplified internal ioctl
 function once more
Date: Mon, 19 Sep 2011 14:26:07 -0700
Message-ID: <1316467568-27683-20-git-send-email-frankyl@broadcom.com> (sfid-20110919_232808_700699_F024466F)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Merged two functions.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    3 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   40 ++++++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   16 ---------
 3 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index a16f731..514f779 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -724,8 +724,7 @@ extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
-extern int brcmf_netdev_ioctl_priv(struct net_device *ndev,
-				   struct brcmf_ioctl *ioc);
+extern s32 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len);
 
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(struct brcmf_pub *drvr);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 827022e..3ae0d43 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -849,30 +849,36 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-/* called only from within this driver */
-int brcmf_netdev_ioctl_priv(struct net_device *ndev, struct brcmf_ioctl *ioc)
+/* called only from within this driver. Sends an ioctl to the dongle. */
+s32 brcmf_dev_ioctl(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 {
-	int bcmerror = 0;
+	struct brcmf_ioctl ioc;
+	s32 err = 0;
 	int buflen = 0;
 	bool is_set_key_cmd;
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-			  netdev_priv(ndev);
+					netdev_priv(ndev);
 	int ifidx;
 
+	memset(&ioc, 0, sizeof(ioc));
+	ioc.cmd = cmd;
+	ioc.buf = arg;
+	ioc.len = len;
+
 	ifidx = brcmf_net2idx(drvr_priv, ndev);
 
-	if (ioc->buf != NULL)
-		buflen = min_t(uint, ioc->len, BRCMF_IOCTL_MAXLEN);
+	if (ioc.buf != NULL)
+		buflen = min_t(uint, ioc.len, BRCMF_IOCTL_MAXLEN);
 
 	/* send to dongle (must be up, and wl) */
 	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
 		brcmf_dbg(ERROR, "DONGLE_DOWN\n");
-		bcmerror = -EIO;
+		err = -EIO;
 		goto done;
 	}
 
 	if (!drvr_priv->pub.iswl) {
-		bcmerror = -EIO;
+		err = -EIO;
 		goto done;
 	}
 
@@ -880,21 +886,21 @@ int brcmf_netdev_ioctl_priv(struct net_device *ndev, struct brcmf_ioctl *ioc)
 	 * Intercept BRCMF_C_SET_KEY IOCTL - serialize M4 send and
 	 * set key IOCTL to prevent M4 encryption.
 	 */
-	is_set_key_cmd = ((ioc->cmd == BRCMF_C_SET_KEY) ||
-			  ((ioc->cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("wsec_key", ioc->buf, 9))) ||
-			  ((ioc->cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("bsscfg:wsec_key", ioc->buf, 15))));
+	is_set_key_cmd = ((ioc.cmd == BRCMF_C_SET_KEY) ||
+			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
+			   !(strncmp("wsec_key", ioc.buf, 9))) ||
+			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
+			   !(strncmp("bsscfg:wsec_key", ioc.buf, 15))));
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(ndev);
 
-	bcmerror = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, ioc, buflen);
+	err = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, buflen);
 
 done:
-	if (bcmerror > 0)
-		bcmerror = 0;
+	if (err > 0)
+		err = 0;
 
-	return bcmerror;
+	return err;
 }
 
 static int brcmf_netdev_stop(struct net_device *ndev)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b707bc0..b956c90 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -249,22 +249,6 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
-static s32
-brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
-{
-	struct brcmf_ioctl ioc;
-	s32 err = 0;
-
-	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = cmd;
-	ioc.buf = arg;
-	ioc.len = len;
-
-	err = brcmf_netdev_ioctl_priv(dev, &ioc);
-
-	return err;
-}
-
 /* function for reading/writing a single u32 from/to the dongle */
 static int
 brcmf_dev_ioctl_u32(struct net_device *ndev, u32 cmd, u32 *par)
-- 
1.7.1


