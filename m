Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4543 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab3DWKxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 06:53:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Wei Yongjun" <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH 4/5] brcmfmac: correct error handling in
 brcmf_fws_init()
Date: Tue, 23 Apr 2013 12:53:14 +0200
Message-ID: <1366714395-13416-5-git-send-email-arend@broadcom.com> (sfid-20130423_125341_679273_7F196C6A)
In-Reply-To: <1366714395-13416-1-git-send-email-arend@broadcom.com>
References: <1366714395-13416-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_fws_init() the error flows were not properly handled
and the caller ignored the return value. The only action that
is allowed to fail in brcmf_fws_init() is setting the tlv in
firmware as the feature is not supported on all devices.

Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    5 +++-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   28 ++++++++++++++------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a0afef2..59c2546 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -899,7 +899,10 @@ int brcmf_bus_start(struct device *dev)
 		goto fail;
 
 	drvr->fw_signals = true;
-	(void)brcmf_fws_init(drvr);
+	ret = brcmf_fws_init(drvr);
+	if (ret < 0)
+		goto fail;
+
 	brcmf_fws_add_interface(ifp);
 
 	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b0591e3..f9153b1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1897,16 +1897,20 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		       BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS |
 		       BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE;
 
-	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
+	rc = brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
+				 brcmf_fws_notify_credit_map);
 	if (rc < 0) {
-		brcmf_err("failed to set bdcv2 tlv signaling\n");
+		brcmf_err("register credit map handler failed\n");
 		goto fail;
 	}
 
-	if (brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
-				brcmf_fws_notify_credit_map)) {
-		brcmf_err("register credit map handler failed\n");
-		goto fail;
+	/* setting the iovar may fail if feature is unsupported
+	 * so leave the rc as is so driver initialization can
+	 * continue.
+	 */
+	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv)) {
+		brcmf_err("failed to set bdcv2 tlv signaling\n");
+		goto fail_event;
 	}
 
 	brcmf_fws_hanger_init(&drvr->fws->hanger);
@@ -1922,9 +1926,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		  drvr->fw_signals ? "enabled" : "disabled", tlv);
 	return 0;
 
+fail_event:
+	brcmf_fweh_unregister(drvr, BRCMF_E_FIFO_CREDIT_MAP);
 fail:
-	/* disable flow control entirely */
-	drvr->fw_signals = false;
 	brcmf_fws_deinit(drvr);
 	return rc;
 }
@@ -1937,6 +1941,14 @@ void brcmf_fws_deinit(struct brcmf_pub *drvr)
 	if (!fws)
 		return;
 
+	/* disable firmware signalling entirely
+	 * to avoid using the workqueue.
+	 */
+	drvr->fw_signals = false;
+
+	if (drvr->fws->fws_wq)
+		destroy_workqueue(drvr->fws->fws_wq);
+
 	/* cleanup */
 	brcmf_fws_lock(drvr, flags);
 	brcmf_fws_cleanup(fws, -1);
-- 
1.7.10.4


