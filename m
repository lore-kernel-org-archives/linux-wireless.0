Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3376 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933250Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 09/19] brcmfmac: fix NULL pointer access in
 brcmf_fweh_detach()
Date: Wed, 14 Nov 2012 18:46:13 -0800
Message-ID: <1352947583-25341-10-git-send-email-frankyl@broadcom.com> (sfid-20121115_034654_871807_FAC0869F)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_fweh_detach can be called while ifp is already NULL, due to
init error. Fix NULL pointer access by checking ifp.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index e1521af..283acee 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -374,11 +374,13 @@ void brcmf_fweh_detach(struct brcmf_pub *drvr)
 	struct brcmf_if *ifp = drvr->iflist[0];
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 
-	/* clear all events */
-	memset(eventmask, 0, BRCMF_EVENTING_MASK_LEN);
-	(void)brcmf_fil_iovar_data_set(ifp, "event_msgs",
-				       eventmask, BRCMF_EVENTING_MASK_LEN);
-
+	if (ifp) {
+		/* clear all events */
+		memset(eventmask, 0, BRCMF_EVENTING_MASK_LEN);
+		(void)brcmf_fil_iovar_data_set(ifp, "event_msgs",
+					       eventmask,
+					       BRCMF_EVENTING_MASK_LEN);
+	}
 	/* cancel the worker */
 	cancel_work_sync(&fweh->event_work);
 	WARN_ON(!list_empty(&fweh->event_q));
-- 
1.7.9.5


