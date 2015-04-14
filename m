Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:28011 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbbDNSeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:34:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: <stable@vger.kernel.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3.18.y] brcmfmac: Perform bound checking on vendor command buffer
Date: Tue, 14 Apr 2015 20:34:07 +0200
Message-ID: <1429036447-26135-1-git-send-email-arend@broadcom.com> (sfid-20150414_203416_251719_90BB8329)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontusf@broadcom.com>

commit 3f1615340acea54e21f4b9d4d65921540dca84b2 upstream.

A short or malformed vendor command buffer could cause reads outside
the command buffer.

Signed-off-by: Pontus Fuchs <pontusf@broadcom.com>
[arend@broadcom.com: slightly modified debug trace output]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c | 30 +++++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index 5960d82..e29674e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -31,18 +31,30 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
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
 	void *dcmd_buf = NULL, *wr_pointer;
 	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
 
-	brcmf_dbg(TRACE, "cmd %x set %d len %d\n", cmdhdr->cmd, cmdhdr->set,
-		  cmdhdr->len);
+	if (len < sizeof(*cmdhdr)) {
+		brcmf_err("vendor command too short: %d\n", len);
+		return -EINVAL;
+	}
+
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	ifp = vif->ifp;
+
+	brcmf_dbg(TRACE, "ifidx=%d, cmd=%d\n", ifp->ifidx, cmdhdr->cmd);
+
+	if (cmdhdr->offset > len) {
+		brcmf_err("bad buffer offset %d > %d\n", cmdhdr->offset, len);
+		return -EINVAL;
+	}
 
-	len -= sizeof(struct brcmf_vndr_dcmd_hdr);
+	len -= cmdhdr->offset;
 	ret_len = cmdhdr->len;
 	if (ret_len > 0 || len > 0) {
 		if (len > BRCMF_DCMD_MAXLEN) {
@@ -63,11 +75,11 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
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

