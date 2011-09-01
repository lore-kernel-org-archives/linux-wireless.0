Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1176 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/30] staging: brcm80211: remove static function
 declaration in dhd_linux
Date: Thu, 1 Sep 2011 11:17:09 +0200
Message-ID: <1314868640-9425-20-git-send-email-rvossen@broadcom.com> (sfid-20110901_111745_769801_E98EE3F1)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Reshuffle function order in dhd_linux of fullmac to get rid of
static function declaration

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   40 ++++++++++-------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 46f75b7..7121b16 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -120,12 +120,6 @@ uint brcmf_radio_up = 1;
 char iface_name[IFNAMSIZ] = "wlan";
 module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 
-static int brcmf_toe_get(struct brcmf_info *drvr_priv, int idx, u32 *toe_ol);
-static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
-static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
-			    void *pktdata, struct brcmf_event_msg *event_ptr,
-			    void **data_ptr);
-
 static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
 {
 	int i = 0;
@@ -600,6 +594,23 @@ void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 		netif_wake_queue(net);
 }
 
+static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
+			    void *pktdata, struct brcmf_event_msg *event,
+			    void **data)
+{
+	int bcmerror = 0;
+
+	bcmerror = brcmf_c_host_event(drvr_priv, ifidx, pktdata, event, data);
+	if (bcmerror != 0)
+		return bcmerror;
+
+	if (drvr_priv->iflist[*ifidx]->net)
+		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->net,
+				     event, *data);
+
+	return bcmerror;
+}
+
 void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 		  int numpkt)
 {
@@ -1483,23 +1494,6 @@ int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 	return 0;
 }
 
-static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
-			    void *pktdata, struct brcmf_event_msg *event,
-			    void **data)
-{
-	int bcmerror = 0;
-
-	bcmerror = brcmf_c_host_event(drvr_priv, ifidx, pktdata, event, data);
-	if (bcmerror != 0)
-		return bcmerror;
-
-	if (drvr_priv->iflist[*ifidx]->net)
-		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->net,
-				     event, *data);
-
-	return bcmerror;
-}
-
 int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 {
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
-- 
1.7.4.1


