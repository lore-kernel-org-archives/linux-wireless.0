Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58924 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbYEWByz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 21:54:55 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/5] hostap: remove private "monitor" ioctl
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>
Date: Thu, 22 May 2008 21:54:54 -0400
Message-ID: <20080523015454.16636.44068.stgit@dv.roinet.com> (sfid-20080523_035457_755875_532C60C7)
In-Reply-To: <20080523015442.16636.92254.stgit@dv.roinet.com>
References: <20080523015442.16636.92254.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an ioctl obsoleted by the monitor mode years ago.  Using it
would trigger a deprecation warning.  As the wireless drivers
standardize on the radiotap standard, the "monitor" ioctl cannot be
preserved to work as obsolete software expects.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_common.h |    2 +
 drivers/net/wireless/hostap/hostap_ioctl.c  |   53 ---------------------------
 2 files changed, 1 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_common.h b/drivers/net/wireless/hostap/hostap_common.h
index b470c74..2f92ecd 100644
--- a/drivers/net/wireless/hostap/hostap_common.h
+++ b/drivers/net/wireless/hostap/hostap_common.h
@@ -239,7 +239,7 @@ struct hfa384x_comms_quality {
 #define PRISM2_IOCTL_GET_PRISM2_PARAM (SIOCIWFIRSTPRIV + 1)
 #define PRISM2_IOCTL_WRITEMIF (SIOCIWFIRSTPRIV + 2)
 #define PRISM2_IOCTL_READMIF (SIOCIWFIRSTPRIV + 3)
-#define PRISM2_IOCTL_MONITOR (SIOCIWFIRSTPRIV + 4)
+/* #define PRISM2_IOCTL_MONITOR (SIOCIWFIRSTPRIV + 4) */
 #define PRISM2_IOCTL_RESET (SIOCIWFIRSTPRIV + 6)
 #define PRISM2_IOCTL_INQUIRE (SIOCIWFIRSTPRIV + 8)
 #define PRISM2_IOCTL_WDS_ADD (SIOCIWFIRSTPRIV + 10)
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 0ca0bfe..7dc8392 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2124,8 +2124,6 @@ static int prism2_ioctl_giwscan(struct net_device *dev,
 
 
 static const struct iw_priv_args prism2_priv[] = {
-	{ PRISM2_IOCTL_MONITOR,
-	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "monitor" },
 	{ PRISM2_IOCTL_READMIF,
 	  IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1,
 	  IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1, "readmif" },
@@ -2907,52 +2905,6 @@ static int prism2_ioctl_priv_writemif(struct net_device *dev,
 }
 
 
-static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
-{
-	struct hostap_interface *iface;
-	local_info_t *local;
-	int ret = 0;
-	u32 mode;
-
-	iface = netdev_priv(dev);
-	local = iface->local;
-
-	printk(KERN_DEBUG "%s: process %d (%s) used deprecated iwpriv monitor "
-	       "- update software to use iwconfig mode monitor\n",
-	       dev->name, task_pid_nr(current), current->comm);
-
-	/* Backward compatibility code - this can be removed at some point */
-
-	if (*i == 0) {
-		/* Disable monitor mode - old mode was not saved, so go to
-		 * Master mode */
-		mode = IW_MODE_MASTER;
-		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
-	} else if (*i == 1) {
-		/* netlink socket mode is not supported anymore since it did
-		 * not separate different devices from each other and was not
-		 * best method for delivering large amount of packets to
-		 * user space */
-		ret = -EOPNOTSUPP;
-	} else if (*i == 2 || *i == 3) {
-		switch (*i) {
-		case 2:
-			local->monitor_type = PRISM2_MONITOR_80211;
-			break;
-		case 3:
-			local->monitor_type = PRISM2_MONITOR_PRISM;
-			break;
-		}
-		mode = IW_MODE_MONITOR;
-		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
-		hostap_monitor_mode_enable(local);
-	} else
-		ret = -EINVAL;
-
-	return ret;
-}
-
-
 static int prism2_ioctl_priv_reset(struct net_device *dev, int *i)
 {
 	struct hostap_interface *iface;
@@ -4004,11 +3956,6 @@ int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		else ret = prism2_ioctl_priv_inquire(dev, (int *) wrq->u.name);
 		break;
 
-	case PRISM2_IOCTL_MONITOR:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_ioctl_priv_monitor(dev, (int *) wrq->u.name);
-		break;
-
 	case PRISM2_IOCTL_RESET:
 		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
 		else ret = prism2_ioctl_priv_reset(dev, (int *) wrq->u.name);
