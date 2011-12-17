Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1465 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760842Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/30] brcm80211: fmac: remove oneline proto block
 functions
Date: Fri, 16 Dec 2011 18:36:52 -0800
Message-ID: <1324089440-8957-3-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_696482_FDB6CE68)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_os_proto_block and brcmf_os_proto_unblock are oneline
functions handling proto_block mutex. Place the mutex interface
call inline to increase readability.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 ---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   10 +++++-----
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    4 ++--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   19 -------------------
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index c87144c..74ea4b0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -734,9 +734,6 @@ extern void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp,
 extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				       uint cmd, void *buf, uint len);
 
-/* OS independent layer functions */
-extern int brcmf_os_proto_block(struct brcmf_pub *drvr);
-extern int brcmf_os_proto_unblock(struct brcmf_pub *drvr);
 #ifdef BCMDBG
 extern int brcmf_write_to_file(struct brcmf_pub *drvr, const u8 *buf, int size);
 #endif				/* BCMDBG */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index ebd53aa..87003f8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -284,7 +284,7 @@ brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx, struct brcmf_dcmd *dcmd,
 		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
 		return ret;
 	}
-	brcmf_os_proto_block(drvr);
+	mutex_lock(&drvr->proto_block);
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -338,7 +338,7 @@ brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx, struct brcmf_dcmd *dcmd,
 	prot->pending = false;
 
 done:
-	brcmf_os_proto_unblock(drvr);
+	mutex_unlock(&drvr->proto_block);
 
 	return ret;
 }
@@ -470,19 +470,19 @@ int brcmf_proto_init(struct brcmf_pub *drvr)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_os_proto_block(drvr);
+	mutex_lock(&drvr->proto_block);
 
 	/* Get the device MAC address */
 	strcpy(buf, "cur_etheraddr");
 	ret = brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR,
 					  buf, sizeof(buf));
 	if (ret < 0) {
-		brcmf_os_proto_unblock(drvr);
+		mutex_unlock(&drvr->proto_block);
 		return ret;
 	}
 	memcpy(drvr->mac, buf, ETH_ALEN);
 
-	brcmf_os_proto_unblock(drvr);
+	mutex_unlock(&drvr->proto_block);
 
 	ret = brcmf_c_preinit_dcmds(drvr);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 228b7ed..5e5a954 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -804,7 +804,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	int scan_unassoc_time = 40;
 	int i;
 
-	brcmf_os_proto_block(drvr);
+	mutex_lock(&drvr->proto_block);
 
 	/* Set Country code */
 	if (drvr->country_code[0] != 0) {
@@ -873,7 +873,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 						 0, true);
 	}
 
-	brcmf_os_proto_unblock(drvr);
+	mutex_unlock(&drvr->proto_block);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f9cc5f8..cd0a698 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1112,25 +1112,6 @@ void brcmf_detach(struct brcmf_pub *drvr)
 	}
 }
 
-int brcmf_os_proto_block(struct brcmf_pub *drvr)
-{
-	if (drvr) {
-		mutex_lock(&drvr->proto_block);
-		return 1;
-	}
-	return 0;
-}
-
-int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
-{
-	if (drvr) {
-		mutex_unlock(&drvr->proto_block);
-		return 1;
-	}
-
-	return 0;
-}
-
 static int brcmf_get_pend_8021x_cnt(struct brcmf_pub *drvr)
 {
 	return atomic_read(&drvr->pend_8021x_cnt);
-- 
1.7.5.4


