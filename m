Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1193 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067Ab1JDVTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/26] staging: brcm80211: remove filtering of received
 frames
Date: Tue, 4 Oct 2011 23:18:49 +0200
Message-ID: <1317763152-17607-4-git-send-email-arend@broadcom.com> (sfid-20111004_231951_388800_ED6B9ED8)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the receive path of the brcmsmac driver probe request frames and
frames with invalid mac address fields are dropped. This is only
fine for STA mode. Anticipating coming AP and monitor mode functionality
this is unwanted behavior.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   23 +----------------------
 1 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index efc6682..39b91d6 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -8238,29 +8238,8 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	if (len < D11_PHY_HDR_LEN + sizeof(h->frame_control))
 		goto toss;
 
+	/* not supporting A-MSDU */
 	is_amsdu = rxh->RxStatus2 & RXS_AMSDU_MASK;
-
-	/* explicitly test bad src address to avoid sending bad deauth */
-	if (!is_amsdu) {
-		/* CTS and ACK CTL frames are w/o a2 */
-
-		if (ieee80211_is_data(h->frame_control) ||
-		    ieee80211_is_mgmt(h->frame_control)) {
-			if ((is_zero_ether_addr(h->addr2) ||
-			     is_multicast_ether_addr(h->addr2))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: dropping a "
-					  "frame with invalid src mac address,"
-					  " a2: %pM\n",
-					 wlc->pub->unit, __func__, h->addr2);
-				goto toss;
-			}
-		}
-	}
-
-	/* due to sheer numbers, toss out probe reqs for now */
-	if (ieee80211_is_probe_req(h->frame_control))
-		goto toss;
-
 	if (is_amsdu)
 		goto toss;
 
-- 
1.7.4.1


