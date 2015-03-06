Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:12856 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbbCFPSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 10:18:46 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcmfmac: Perform bound checking on vendor command buffer
Date: Fri, 6 Mar 2015 16:18:41 +0100
Message-ID: <1425655123-18916-1-git-send-email-arend@broadcom.com> (sfid-20150306_161850_149589_5E03D9AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontusf@broadcom.com>

A short or malformed vendor command buffer could cause reads outside
the command buffer.

Cc: stable@vger.kernel.org # v3.19
Signed-off-by: Pontus Fuchs <pontusf@broadcom.com>
[arend@broadcom.com: slightly modified debug trace output]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index 50cdf70..8eff275 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -39,13 +39,22 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	void *dcmd_buf = NULL, *wr_pointer;
 	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
 
-	brcmf_dbg(TRACE, "cmd %x set %d len %d\n", cmdhdr->cmd, cmdhdr->set,
-		  cmdhdr->len);
+	if (len < sizeof(*cmdhdr)) {
+		brcmf_err("vendor command too short: %d\n", len);
+		return -EINVAL;
+	}
 
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 	ifp = vif->ifp;
 
-	len -= sizeof(struct brcmf_vndr_dcmd_hdr);
+	brcmf_dbg(TRACE, "ifidx=%d, cmd=%d\n", ifp->ifidx, cmdhdr->cmd);
+
+	if (cmdhdr->offset > len) {
+		brcmf_err("bad buffer offset %d > %d\n", cmdhdr->offset, len);
+		return -EINVAL;
+	}
+
+	len -= cmdhdr->offset;
 	ret_len = cmdhdr->len;
 	if (ret_len > 0 || len > 0) {
 		if (len > BRCMF_DCMD_MAXLEN) {
-- 
1.9.1

