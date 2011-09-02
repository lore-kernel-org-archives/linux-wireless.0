Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1780 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab1IBOAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:55 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/12] staging: brcm80211: use address space qualifier
 in brcmfmac
Date: Fri, 2 Sep 2011 16:00:30 +0200
Message-ID: <1314972039-27098-4-git-send-email-rvossen@broadcom.com> (sfid-20110902_160100_290040_957FA122)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several sparse warning were issued due to missing __user qualifier
for brcmfmac variables. This patch adds those.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index ee09c17..4d06d87 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -779,7 +779,7 @@ extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 /* Linux network driver ioctl encoding */
 struct brcmf_c_ioctl {
 	uint cmd;		/* common ioctl definition */
-	void *buf;		/* pointer to user buffer */
+	void __user *buf;	/* pointer to user buffer */
 	uint len;		/* length of user buffer */
 	bool set;		/* get or set request (optional) */
 	uint used;		/* bytes read or written (optional) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 470759a..bb0f718 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -835,7 +835,7 @@ static struct ethtool_ops brcmf_ethtool_ops = {
 	.get_drvinfo = brcmf_ethtool_get_drvinfo
 };
 
-static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
+static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 {
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
@@ -1001,7 +1001,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	}
 
 	/* To differentiate read 4 more byes */
-	if ((copy_from_user(&driver, (char *)ifr->ifr_data +
+	if ((copy_from_user(&driver, (char __user *)ifr->ifr_data +
 			    sizeof(struct brcmf_ioctl), sizeof(uint)) != 0)) {
 		bcmerror = -EINVAL;
 		goto done;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 60a04b3..db51c46 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -540,7 +540,7 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 	ioc.buf = arg;
 	ioc.len = len;
 	strcpy(ifr.ifr_name, dev->name);
-	ifr.ifr_data = (caddr_t)&ioc;
+	ifr.ifr_data = (char __user *)&ioc;
 
 	fs = get_fs();
 	set_fs(get_ds());
-- 
1.7.4.1


