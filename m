Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2981 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/17] staging: brcm80211: simplification of
 brcmf_netdev_ioctl_priv()
Date: Tue, 13 Sep 2011 09:49:54 +0200
Message-ID: <1315900197-7260-15-git-send-email-rvossen@broadcom.com> (sfid-20110913_095039_080636_AA4C6364)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is only called from within the driver. Because of that
certain simplifications (not required to lock down user mem pages,
not required to check user permissions) could be performed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   14 +----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   69 +++------------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    5 +-
 3 files changed, 13 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 93a1bfc..a92a28e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -715,7 +715,8 @@ extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
 
-extern int brcmf_netdev_ioctl_priv(struct net_device *net, struct ifreq *ifr);
+extern int brcmf_netdev_ioctl_priv(struct net_device *net,
+				   struct brcmf_ioctl *ioc);
 
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(struct brcmf_pub *drvr);
@@ -771,17 +772,6 @@ extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
 
-/* Linux network driver ioctl encoding */
-struct brcmf_c_ioctl {
-	uint cmd;		/* common ioctl definition */
-	void __user *buf;	/* pointer to user buffer */
-	uint len;		/* length of user buffer */
-	bool set;		/* get or set request (optional) */
-	uint used;		/* bytes read or written (optional) */
-	uint needed;		/* bytes needed (optional) */
-	uint driver;		/* to identify target driver */
-};
-
 /* per-driver magic numbers */
 #define BRCMF_IOCTL_MAGIC		0x00444944
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 4bc231e..3898765 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -964,61 +964,19 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-/* called only from within this driver, handles cmd == SIOCDEVPRIVATE */
-int brcmf_netdev_ioctl_priv(struct net_device *net, struct ifreq *ifr)
+/* called only from within this driver */
+int brcmf_netdev_ioctl_priv(struct net_device *net, struct brcmf_ioctl *ioc)
 {
-	struct brcmf_c_ioctl ioc;
 	int bcmerror = 0;
 	int buflen = 0;
-	void *buf = NULL;
-	uint driver = 0;
 	bool is_set_key_cmd;
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 	int ifidx;
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
 
-	memset(&ioc, 0, sizeof(ioc));
-
-	/* Copy the ioc control structure part of ioctl request */
-	if (copy_from_user(&ioc, ifr->ifr_data, sizeof(struct brcmf_ioctl))) {
-		bcmerror = -EINVAL;
-		goto done;
-	}
-
-	/* Copy out any buffer passed */
-	if (ioc.buf) {
-		buflen = min_t(int, ioc.len, BRCMF_IOCTL_MAXLEN);
-		/* optimization for direct ioctl calls from kernel */
-		/*
-		   if (segment_eq(get_fs(), KERNEL_DS)) {
-		   buf = ioc.buf;
-		   } else {
-		 */
-		{
-			buf = kmalloc(buflen, GFP_ATOMIC);
-			if (!buf) {
-				bcmerror = -ENOMEM;
-				goto done;
-			}
-			if (copy_from_user(buf, ioc.buf, buflen)) {
-				bcmerror = -EINVAL;
-				goto done;
-			}
-		}
-	}
-
-	/* To differentiate read 4 more byes */
-	if ((copy_from_user(&driver, (char __user *)ifr->ifr_data +
-			    sizeof(struct brcmf_ioctl), sizeof(uint)) != 0)) {
-		bcmerror = -EINVAL;
-		goto done;
-	}
-
-	if (!capable(CAP_NET_ADMIN)) {
-		bcmerror = -EPERM;
-		goto done;
-	}
+	if (ioc->buf != NULL)
+		buflen = min_t(int, ioc->len, BRCMF_IOCTL_MAXLEN);
 
 	/* send to dongle (must be up, and wl) */
 	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
@@ -1036,25 +994,18 @@ int brcmf_netdev_ioctl_priv(struct net_device *net, struct ifreq *ifr)
 	 * Intercept BRCMF_C_SET_KEY IOCTL - serialize M4 send and
 	 * set key IOCTL to prevent M4 encryption.
 	 */
-	is_set_key_cmd = ((ioc.cmd == BRCMF_C_SET_KEY) ||
-			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("wsec_key", ioc.buf, 9))) ||
-			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("bsscfg:wsec_key", ioc.buf, 15))));
+	is_set_key_cmd = ((ioc->cmd == BRCMF_C_SET_KEY) ||
+			  ((ioc->cmd == BRCMF_C_SET_VAR) &&
+			   !(strncmp("wsec_key", ioc->buf, 9))) ||
+			  ((ioc->cmd == BRCMF_C_SET_VAR) &&
+			   !(strncmp("bsscfg:wsec_key", ioc->buf, 15))));
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(net);
 
 	bcmerror = brcmf_proto_ioctl(&drvr_priv->pub, ifidx,
-				     (struct brcmf_ioctl *)&ioc, buf, buflen);
+				     ioc, ioc->buf, buflen);
 
 done:
-	if (!bcmerror && buf && ioc.buf) {
-		if (copy_to_user(ioc.buf, buf, buflen))
-			bcmerror = -EFAULT;
-	}
-
-	kfree(buf);
-
 	if (bcmerror > 0)
 		bcmerror = 0;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 3fa0c1b..b001e40 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -272,7 +272,6 @@ static void convert_key_to_CPU(struct brcmf_wsec_key *key)
 static s32
 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 {
-	struct ifreq ifr;
 	struct brcmf_ioctl ioc;
 	mm_segment_t fs;
 	s32 err = 0;
@@ -281,12 +280,10 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 	ioc.cmd = cmd;
 	ioc.buf = arg;
 	ioc.len = len;
-	strcpy(ifr.ifr_name, dev->name);
-	ifr.ifr_data = (char __user *)&ioc;
 
 	fs = get_fs();
 	set_fs(get_ds());
-	err = brcmf_netdev_ioctl_priv(dev, &ifr);
+	err = brcmf_netdev_ioctl_priv(dev, &ioc);
 	set_fs(fs);
 
 	return err;
-- 
1.7.4.1


