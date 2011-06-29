Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4696 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 047/119] staging: brcm80211: remove unused prototypes
 from dhd.h
Date: Wed, 29 Jun 2011 16:47:11 -0700
Message-ID: <1309391303-22741-48-git-send-email-frankyl@broadcom.com> (sfid-20110630_014959_670907_2F4C164F)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

A couple of prototypes are not defined or not used and have been
removed from the driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    5 -----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    9 ---------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index d19d091..3f1b757 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -943,7 +943,6 @@ extern void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec);
 extern int brcmf_timeout_expired(dhd_timeout_t *tmo);
 
 extern int brcmf_ifname2idx(struct dhd_info *dhd, char *name);
-extern u8 *dhd_bssidx2bssid(dhd_pub_t *dhd, int idx);
 extern int brcmf_c_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
 			 brcmf_event_msg_t *, void **data_ptr);
 
@@ -964,11 +963,7 @@ extern void brcmf_vif_sendup(struct dhd_info *dhd, int ifidx,
 /* Send packet to dongle via data channel */
 extern int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pkt);
 
-/* Send event to host */
-extern void dhd_sendup_event(dhd_pub_t *dhdp, brcmf_event_msg_t *event,
-			     void *data);
 extern int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag);
-extern uint dhd_bus_status(dhd_pub_t *dhdp);
 extern int brcmf_bus_start(dhd_pub_t *dhdp);
 
 extern void brcmf_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 928220c..f326071 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2519,15 +2519,6 @@ dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 	return bcmerror;
 }
 
-/* send up locally generated event */
-void dhd_sendup_event(dhd_pub_t *dhdp, brcmf_event_msg_t *event, void *data)
-{
-	switch (be32_to_cpu(event->event_type)) {
-	default:
-		break;
-	}
-}
-
 void brcmf_wait_for_event(dhd_pub_t *dhd, bool *lockvar)
 {
 	struct dhd_info *dhdinfo = dhd->info;
-- 
1.7.1


