Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4647 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab1IPT2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:21 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/19] staging: brcm80211: remove SOFTAP code from
 fullmac
Date: Fri, 16 Sep 2011 12:27:50 -0700
Message-ID: <1316201288-29635-2-git-send-email-frankyl@broadcom.com> (sfid-20110916_212901_172255_0F85EB09)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dead code removal.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |   12 ------------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   21 ---------------------
 2 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 8898370..c351349 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -707,18 +707,6 @@ static inline void MUTEX_UNLOCK(struct brcmf_pub *drvr)
 {
 }
 
-static inline void MUTEX_LOCK_SOFTAP_SET_INIT(struct brcmf_pub *drvr)
-{
-}
-
-static inline void MUTEX_LOCK_SOFTAP_SET(struct brcmf_pub *drvr)
-{
-}
-
-static inline void MUTEX_UNLOCK_SOFTAP_SET(struct brcmf_pub *drvr)
-{
-}
-
 static inline void MUTEX_LOCK_WL_SCAN_SET_INIT(void)
 {
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 26a39ee..8286885 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -314,10 +314,6 @@ _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 	return ret;
 }
 
-#ifdef SOFTAP
-static struct net_device *ap_net_dev;
-#endif
-
 /* Virtual interfaces only ((ifp && ifp->info && ifp->idx == true) */
 static void brcmf_op_if(struct brcmf_if *ifp)
 {
@@ -357,18 +353,6 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 					  err);
 				ret = -EOPNOTSUPP;
 			} else {
-#ifdef SOFTAP
-				/* semaphore that the soft AP CODE
-					 waits on */
-				struct semaphore ap_eth_sema;
-
-				/* save ptr to wl0.1 netdev for use
-					 in wl_iw.c  */
-				ap_net_dev = ifp->net;
-				/* signal to the SOFTAP 'sleeper' thread,
-					 wl0.1 is ready */
-				up(&ap_eth_sema);
-#endif
 				brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
 					  current->pid, ifp->net->name);
 				ifp->state = 0;
@@ -395,11 +379,6 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 
 		drvr_priv->iflist[ifp->idx] = NULL;
 		kfree(ifp);
-#ifdef SOFTAP
-		if (ifp->net == ap_net_dev)
-			ap_net_dev = NULL;	/*  NULL  SOFTAP global
-							 wl0.1 as well */
-#endif				/*  SOFTAP */
 	}
 }
 
-- 
1.7.1


