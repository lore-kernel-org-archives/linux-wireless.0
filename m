Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4440 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2KFAWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:44 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 12/24] brcmfmac: remove obsolete function
 brcmf_c_mkiovar
Date: Mon, 5 Nov 2012 16:22:20 -0800
Message-ID: <1352161352-30405-13-git-send-email-frankyl@broadcom.com> (sfid-20121106_012307_859020_5E102868)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

the refactored firmware interface layer made this function obsolete.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 ---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   21 --------------------
 2 files changed, 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 8d4789b..9807092 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -671,9 +671,6 @@ static inline s32 brcmf_ndev_bssidx(struct net_device *ndev)
 
 extern const struct bcmevent_name bcmevent_names[];
 
-extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
-			  char *buf, uint len);
-
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
 /* Return pointer to interface name */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index a70393a..3b31139 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -68,27 +68,6 @@ struct msgtrace_hdr {
 } __packed;
 
 
-uint
-brcmf_c_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
-{
-	uint len;
-
-	len = strlen(name) + 1;
-
-	if ((len + datalen) > buflen)
-		return 0;
-
-	strncpy(buf, name, buflen);
-
-	/* append data onto the end of the name string */
-	if (data && datalen) {
-		memcpy(&buf[len], data, datalen);
-		len += datalen;
-	}
-
-	return len;
-}
-
 bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
 {
-- 
1.7.9.5


