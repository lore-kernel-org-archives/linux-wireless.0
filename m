Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3666 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2H3Rn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 13:43:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: add callback for nl80211 testmode command
Date: Thu, 30 Aug 2012 19:43:02 +0200
Message-ID: <1346348582-20095-6-git-send-email-arend@broadcom.com> (sfid-20120830_194338_148861_C240962E)
In-Reply-To: <1346348582-20095-1-git-send-email-arend@broadcom.com>
References: <1346348582-20095-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds callback for nl80211 testmode, which can be used
for testing and debugging purposes with driver and firmware.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    8 +++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   25 +++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a11fe54..37f5708 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -638,6 +638,7 @@ extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
 extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
+extern int brcmf_netlink_dcmd(struct net_device *ndev, struct brcmf_dcmd *dcmd);
 
 /* Return pointer to interface name */
 extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9ab2452..7f9ba82 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -775,6 +775,14 @@ done:
 	return err;
 }
 
+int brcmf_netlink_dcmd(struct net_device *ndev, struct brcmf_dcmd *dcmd)
+{
+	brcmf_dbg(TRACE, "enter: cmd %x buf %p len %d\n",
+		  dcmd->cmd, dcmd->buf, dcmd->len);
+
+	return brcmf_exec_dcmd(ndev, dcmd->cmd, dcmd->buf, dcmd->len);
+}
+
 static int brcmf_netdev_stop(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 28c5fbb..c7230f5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -28,6 +28,7 @@
 #include <linux/ieee80211.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
+#include <net/netlink.h>
 
 #include <brcmu_utils.h>
 #include <defs.h>
@@ -2723,6 +2724,25 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
 }
 
+#ifdef CONFIG_NL80211_TESTMODE
+static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_priv->wdev->netdev;
+	struct brcmf_dcmd *dcmd = data;
+	struct sk_buff *reply;
+	int ret;
+
+	ret = brcmf_netlink_dcmd(ndev, dcmd);
+	if (ret == 0) {
+		reply = cfg80211_testmode_alloc_reply_skb(wiphy, sizeof(*dcmd));
+		nla_put(reply, NL80211_ATTR_TESTDATA, sizeof(*dcmd), dcmd);
+		ret = cfg80211_testmode_reply(reply);
+	}
+	return ret;
+}
+#endif
+
 static struct cfg80211_ops wl_cfg80211_ops = {
 	.change_virtual_intf = brcmf_cfg80211_change_iface,
 	.scan = brcmf_cfg80211_scan,
@@ -2745,7 +2765,10 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.resume = brcmf_cfg80211_resume,
 	.set_pmksa = brcmf_cfg80211_set_pmksa,
 	.del_pmksa = brcmf_cfg80211_del_pmksa,
-	.flush_pmksa = brcmf_cfg80211_flush_pmksa
+	.flush_pmksa = brcmf_cfg80211_flush_pmksa,
+#ifdef CONFIG_NL80211_TESTMODE
+	.testmode_cmd = brcmf_cfg80211_testmode
+#endif
 };
 
 static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
-- 
1.7.9.5


