Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6017 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaLCUFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:40 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/7] brcmfmac: Fix vendor cmds used interface.
Date: Wed, 3 Dec 2014 21:05:31 +0100
Message-ID: <1417637133-6966-6-git-send-email-arend@broadcom.com> (sfid-20141203_210548_930352_4479AAEE)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The vendor specific commands was always using main interface,
change this to use the by caller supplied interface.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index 222f26a..50cdf70 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -31,8 +31,8 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 						 struct wireless_dev *wdev,
 						 const void *data, int len)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
 	const struct brcmf_vndr_dcmd_hdr *cmdhdr = data;
 	struct sk_buff *reply;
 	int ret, payload, ret_len;
@@ -42,6 +42,9 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	brcmf_dbg(TRACE, "cmd %x set %d len %d\n", cmdhdr->cmd, cmdhdr->set,
 		  cmdhdr->len);
 
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	ifp = vif->ifp;
+
 	len -= sizeof(struct brcmf_vndr_dcmd_hdr);
 	ret_len = cmdhdr->len;
 	if (ret_len > 0 || len > 0) {
@@ -63,11 +66,11 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	}
 
 	if (cmdhdr->set)
-		ret = brcmf_fil_cmd_data_set(netdev_priv(ndev), cmdhdr->cmd,
-					     dcmd_buf, ret_len);
+		ret = brcmf_fil_cmd_data_set(ifp, cmdhdr->cmd, dcmd_buf,
+					     ret_len);
 	else
-		ret = brcmf_fil_cmd_data_get(netdev_priv(ndev), cmdhdr->cmd,
-					     dcmd_buf, ret_len);
+		ret = brcmf_fil_cmd_data_get(ifp, cmdhdr->cmd, dcmd_buf,
+					     ret_len);
 	if (ret != 0)
 		goto exit;
 
-- 
1.9.1

