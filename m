Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1359 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab3BFRmk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:42:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/12] brcmfmac: Cleanup function
 brcmf_notifiy_connect_status_ap.
Date: Wed, 6 Feb 2013 18:40:43 +0100
Message-ID: <1360172447-2424-9-git-send-email-arend@broadcom.com> (sfid-20130206_184245_459659_7EFDE045)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Clean up function, removing some unnecessary code and
initialisation.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 0f170cb..544257a5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3994,38 +3994,32 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       struct net_device *ndev,
 			       const struct brcmf_event_msg *e, void *data)
 {
-	s32 err = 0;
+	static int generation;
 	u32 event = e->event_code;
 	u32 reason = e->reason;
-	u32 len = e->datalen;
-	static int generation;
-
 	struct station_info sinfo;
 
 	brcmf_dbg(CONN, "event %d, reason %d\n", event, reason);
-	memset(&sinfo, 0, sizeof(sinfo));
 
-	sinfo.filled = 0;
 	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
-	    reason == BRCMF_E_STATUS_SUCCESS) {
+	    (reason == BRCMF_E_STATUS_SUCCESS)) {
+		memset(&sinfo, 0, sizeof(sinfo));
 		sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
 		if (!data) {
 			brcmf_err("No IEs present in ASSOC/REASSOC_IND");
 			return -EINVAL;
 		}
 		sinfo.assoc_req_ies = data;
-		sinfo.assoc_req_ies_len = len;
+		sinfo.assoc_req_ies_len = e->datalen;
 		generation++;
 		sinfo.generation = generation;
-		cfg80211_new_sta(ndev, e->addr, &sinfo, GFP_ATOMIC);
+		cfg80211_new_sta(ndev, e->addr, &sinfo, GFP_KERNEL);
 	} else if ((event == BRCMF_E_DISASSOC_IND) ||
 		   (event == BRCMF_E_DEAUTH_IND) ||
 		   (event == BRCMF_E_DEAUTH)) {
-		generation++;
-		sinfo.generation = generation;
-		cfg80211_del_sta(ndev, e->addr, GFP_ATOMIC);
+		cfg80211_del_sta(ndev, e->addr, GFP_KERNEL);
 	}
-	return err;
+	return 0;
 }
 
 static s32
-- 
1.7.10.4


