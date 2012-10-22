Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1766 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2JVRgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:41 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 03/14] brcmfmac: change testmode command to use new
 firmware interface layer
Date: Mon, 22 Oct 2012 10:36:16 -0700
Message-ID: <1350927387-25608-4-git-send-email-frankyl@broadcom.com> (sfid-20121022_193651_624125_58F03E93)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

switch to new firmware interface layer and remove redundant code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   54 --------------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   10 +++-
 3 files changed, 9 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index c915d33..1589c1b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -714,9 +714,6 @@ extern uint brcmf_c_mkiovar_bsscfg(char *name, char *data, uint datalen,
 
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
-extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
-extern int brcmf_netlink_dcmd(struct net_device *ndev, struct brcmf_dcmd *dcmd);
-
 /* Return pointer to interface name */
 extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 5f91fae..c524b04 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -706,60 +706,6 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-/* called only from within this driver. Sends a command to the dongle. */
-s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
-{
-	struct brcmf_dcmd dcmd;
-	s32 err = 0;
-	int buflen = 0;
-	bool is_set_key_cmd;
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = ifp->drvr;
-
-	memset(&dcmd, 0, sizeof(dcmd));
-	dcmd.cmd = cmd;
-	dcmd.buf = arg;
-	dcmd.len = len;
-
-	if (dcmd.buf != NULL)
-		buflen = min_t(uint, dcmd.len, BRCMF_DCMD_MAXLEN);
-
-	/* send to dongle (must be up, and wl) */
-	if ((drvr->bus_if->state != BRCMF_BUS_DATA)) {
-		brcmf_dbg(ERROR, "DONGLE_DOWN\n");
-		err = -EIO;
-		goto done;
-	}
-
-	/*
-	 * Intercept BRCMF_C_SET_KEY CMD - serialize M4 send and
-	 * set key CMD to prevent M4 encryption.
-	 */
-	is_set_key_cmd = ((dcmd.cmd == BRCMF_C_SET_KEY) ||
-			  ((dcmd.cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("wsec_key", dcmd.buf, 9))) ||
-			  ((dcmd.cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("bsscfg:wsec_key", dcmd.buf, 15))));
-	if (is_set_key_cmd)
-		brcmf_netdev_wait_pend8021x(ndev);
-
-	err = brcmf_proto_dcmd(drvr, ifp->idx, &dcmd, buflen);
-
-done:
-	if (err > 0)
-		err = 0;
-
-	return err;
-}
-
-int brcmf_netlink_dcmd(struct net_device *ndev, struct brcmf_dcmd *dcmd)
-{
-	brcmf_dbg(TRACE, "enter: cmd %x buf %p len %d\n",
-		  dcmd->cmd, dcmd->buf, dcmd->len);
-
-	return brcmf_exec_dcmd(ndev, dcmd->cmd, dcmd->buf, dcmd->len);
-}
-
 static int brcmf_netdev_stop(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 0beb2c6..d354b2a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3458,7 +3458,15 @@ static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 	struct sk_buff *reply;
 	int ret;
 
-	ret = brcmf_netlink_dcmd(ndev, dcmd);
+	WL_TRACE("cmd %x set %d buf %p len %d\n", dcmd->cmd, dcmd->set,
+		 dcmd->buf, dcmd->len);
+
+	if (dcmd->set)
+		ret = brcmf_fil_cmd_data_set(ndev, dcmd->cmd, dcmd->buf,
+					     dcmd->len);
+	else
+		ret = brcmf_fil_cmd_data_get(ndev, dcmd->cmd, dcmd->buf,
+					     dcmd->len);
 	if (ret == 0) {
 		reply = cfg80211_testmode_alloc_reply_skb(wiphy, sizeof(*dcmd));
 		nla_put(reply, NL80211_ATTR_TESTDATA, sizeof(*dcmd), dcmd);
-- 
1.7.6


