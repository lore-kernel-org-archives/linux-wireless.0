Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1650 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759501Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/24] brcm80211: fmac: rename wait queue name to match
 using function
Date: Tue, 22 Nov 2011 17:21:45 -0800
Message-ID: <1322011319-24863-11-git-send-email-frankyl@broadcom.com> (sfid-20111123_022259_855887_888C29C6)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The wait queue request_packet_wait was used in request_chain function
and for sake of consistency it has been renamed to request_chain_wait.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 ++++++--
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index ccb32c0..adee305 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -229,6 +229,10 @@ brcmf_sdioh_request_data(struct brcmf_sdio_dev *sdiodev, uint write, bool fifo,
 	return err_ret;
 }
 
+/*
+ * This function takes a queue of packets. The packets on the queue
+ * are assumed to be properly aligned by the caller.
+ */
 int
 brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 			  uint write, uint func, uint addr,
@@ -242,7 +246,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_packet_wait);
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_chain_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
@@ -478,7 +482,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		atomic_set(&sdiodev->suspend, false);
 		init_waitqueue_head(&sdiodev->request_byte_wait);
 		init_waitqueue_head(&sdiodev->request_word_wait);
-		init_waitqueue_head(&sdiodev->request_packet_wait);
+		init_waitqueue_head(&sdiodev->request_chain_wait);
 		init_waitqueue_head(&sdiodev->request_buffer_wait);
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 1e4a0bb..4e501f8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -132,7 +132,7 @@ struct brcmf_sdio_dev {
 	atomic_t suspend;		/* suspend flag */
 	wait_queue_head_t request_byte_wait;
 	wait_queue_head_t request_word_wait;
-	wait_queue_head_t request_packet_wait;
+	wait_queue_head_t request_chain_wait;
 	wait_queue_head_t request_buffer_wait;
 
 };
-- 
1.7.5.4


