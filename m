Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1649 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 21/24] brcmfmac: check bus state to be data before
 sending data.
Date: Mon, 5 Nov 2012 16:22:29 -0800
Message-ID: <1352161352-30405-22-git-send-email-frankyl@broadcom.com> (sfid-20121106_012429_789100_45978753)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_netdev_start_xmit and brcmf_fil_cmd_data are checking
bus state for down. These functions should check for data
state.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 0f81f31..a0d8950 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -216,7 +216,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	/* Reject if down */
 	if (!drvr->bus_if->drvr_up ||
-	    (drvr->bus_if->state == BRCMF_BUS_DOWN)) {
+	    (drvr->bus_if->state != BRCMF_BUS_DATA)) {
 		brcmf_dbg(ERROR, "xmit rejected drvup=%d state=%d\n",
 			  drvr->bus_if->drvr_up,
 			  drvr->bus_if->state);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index f121d41..62e0960 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -35,7 +35,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 
-	if (drvr->bus_if->state == BRCMF_BUS_DOWN) {
+	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
 		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
 		return -EIO;
 	}
-- 
1.7.9.5


