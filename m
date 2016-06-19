Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36540 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcFSQgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 12:36:23 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V2 RFC 2/2] brcmfmac: support removing AP interfaces with "interface_remove"
Date: Sun, 19 Jun 2016 18:23:25 +0200
Message-Id: <1466353420-30998-2-git-send-email-zajec5@gmail.com> (sfid-20160619_183701_071619_565E03CF)
In-Reply-To: <1466353420-30998-1-git-send-email-zajec5@gmail.com>
References: <1466273932-11554-1-git-send-email-zajec5@gmail.com>
 <1466353420-30998-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmwares (e.g. 10.10.69.36 for BCM4366) support "interface_remove"
for removing interfaces. Try to use this method on cfg80211 request. In
case of older firmwares (e.g. 7.35.177.56 for BCM43602 as I tested) this
will just result in firmware rejecting command and this won't change any
behavior.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Add extra chcek for ndev. Thanks Arend.
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 39 +++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 502b0a0..1e411dc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -785,12 +785,48 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	return err;
 }
 
+static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
+				       struct wireless_dev *wdev)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct net_device *ndev = wdev->netdev;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	int ret;
+	int err;
+
+	brcmf_cfg80211_arm_vif_event(cfg, ifp->vif);
+
+	err = brcmf_fil_bsscfg_data_set(ifp, "interface_remove", NULL, 0);
+	if (err) {
+		brcmf_err("interface_remove failed %d\n", err);
+		goto err_unarm;
+	}
+
+	/* wait for firmware event */
+	ret = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_DEL,
+					    BRCMF_VIF_EVENT_TIMEOUT);
+	if (!ret) {
+		brcmf_err("timeout occurred\n");
+		err = -EIO;
+		goto err_unarm;
+	}
+
+	brcmf_remove_interface(ifp, true);
+
+err_unarm:
+	brcmf_cfg80211_arm_vif_event(cfg, NULL);
+	return err;
+}
+
 static
 int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct net_device *ndev = wdev->netdev;
 
+	if (ndev && ndev == cfg_to_ndev(cfg))
+		return -ENOTSUPP;
+
 	/* vif event pending in firmware */
 	if (brcmf_cfg80211_vif_event_armed(cfg))
 		return -EBUSY;
@@ -807,12 +843,13 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 		return -EOPNOTSUPP;
+	case NL80211_IFTYPE_AP:
+		return brcmf_cfg80211_del_ap_iface(wiphy, wdev);
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
-- 
1.8.4.5

