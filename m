Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2853 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/17] staging: brcm80211: separated public from private
 ioctl functions
Date: Tue, 13 Sep 2011 09:49:53 +0200
Message-ID: <1315900197-7260-14-git-send-email-rvossen@broadcom.com> (sfid-20110913_095045_657092_AF02EA2F)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net_device ioctl handler was called both by the OS as by the driver
itself. Split the ioctl handler into two functions to make code paths
more clear.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    2 +
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   24 ++++++++++++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 9f84837..93a1bfc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -715,6 +715,8 @@ extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
 
+extern int brcmf_netdev_ioctl_priv(struct net_device *net, struct ifreq *ifr);
+
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(struct brcmf_pub *drvr);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index cfdd645..4bc231e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -950,13 +950,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 				    int cmd)
 {
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
-	struct brcmf_c_ioctl ioc;
-	int bcmerror = 0;
-	int buflen = 0;
-	void *buf = NULL;
-	uint driver = 0;
 	int ifidx;
-	bool is_set_key_cmd;
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
 	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifidx, cmd);
@@ -967,8 +961,22 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	if (cmd == SIOCETHTOOL)
 		return brcmf_ethtool(drvr_priv, ifr->ifr_data);
 
-	if (cmd != SIOCDEVPRIVATE)
-		return -EOPNOTSUPP;
+	return -EOPNOTSUPP;
+}
+
+/* called only from within this driver, handles cmd == SIOCDEVPRIVATE */
+int brcmf_netdev_ioctl_priv(struct net_device *net, struct ifreq *ifr)
+{
+	struct brcmf_c_ioctl ioc;
+	int bcmerror = 0;
+	int buflen = 0;
+	void *buf = NULL;
+	uint driver = 0;
+	bool is_set_key_cmd;
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	int ifidx;
+
+	ifidx = brcmf_net2idx(drvr_priv, net);
 
 	memset(&ioc, 0, sizeof(ioc));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 198f0cc..3fa0c1b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -286,7 +286,7 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 
 	fs = get_fs();
 	set_fs(get_ds());
-	err = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, SIOCDEVPRIVATE);
+	err = brcmf_netdev_ioctl_priv(dev, &ifr);
 	set_fs(fs);
 
 	return err;
-- 
1.7.4.1


