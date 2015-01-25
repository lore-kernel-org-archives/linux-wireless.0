Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7421 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944AbbAYTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:49 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/14] brcmfmac: prevent possible deadlock on resuming SDIO device.
Date: Sun, 25 Jan 2015 20:31:31 +0100
Message-ID: <1422214303-7816-3-git-send-email-arend@broadcom.com> (sfid-20150125_203233_500140_0F493E49)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When the system is resumed a deadlock can occur when DPC gets
entered before resume is complete. This patch fixes this by
properly checking the suspend state outside the claim_host code
block.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 33 ------------------------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 18 +++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h   |  2 --
 3 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 00ba90b8..8ba60f6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -97,25 +97,6 @@ static void brcmf_sdiod_dummy_irqhandler(struct sdio_func *func)
 {
 }
 
-static bool brcmf_sdiod_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
-{
-	bool is_err = false;
-#ifdef CONFIG_PM_SLEEP
-	is_err = atomic_read(&sdiodev->suspend);
-#endif
-	return is_err;
-}
-
-static void brcmf_sdiod_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
-				       wait_queue_head_t *wq)
-{
-#ifdef CONFIG_PM_SLEEP
-	int retry = 0;
-	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
-		wait_event_timeout(*wq, false, HZ/100);
-#endif
-}
-
 int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
@@ -244,10 +225,6 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		  write, fn, addr, regsz);
 
-	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
-	if (brcmf_sdiod_pm_resume_error(sdiodev))
-		return -EIO;
-
 	/* only allow byte access on F0 */
 	if (WARN_ON(regsz > 1 && !fn))
 		return -EINVAL;
@@ -462,10 +439,6 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	unsigned int req_sz;
 	int err;
 
-	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
-	if (brcmf_sdiod_pm_resume_error(sdiodev))
-		return -EIO;
-
 	/* Single skb use the standard mmc interface */
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
@@ -516,10 +489,6 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	if (!pktlist->qlen)
 		return -EINVAL;
 
-	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
-	if (brcmf_sdiod_pm_resume_error(sdiodev))
-		return -EIO;
-
 	target_list = pktlist;
 	/* for host with broken sg support, prepare a page aligned list */
 	__skb_queue_head_init(&local_list);
@@ -1077,8 +1046,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 #endif
 
 	atomic_set(&sdiodev->suspend, false);
-	init_waitqueue_head(&sdiodev->request_word_wait);
-	init_waitqueue_head(&sdiodev->request_buffer_wait);
 
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdiod_probe...\n");
 	err = brcmf_sdiod_probe(sdiodev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 99a3776..2c4f0cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2609,6 +2609,21 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	return ret;
 }
 
+static int brcmf_sdio_pm_resume_wait(struct brcmf_sdio_dev *sdiodev)
+{
+#ifdef CONFIG_PM_SLEEP
+	int retry;
+
+	/* Wait for possible resume to complete */
+	retry = 0;
+	while ((atomic_read(&sdiodev->suspend)) && (retry++ != 50))
+		msleep(20);
+	if (atomic_read(&sdiodev->suspend))
+		return -EIO;
+#endif
+	return 0;
+}
+
 static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
 	u32 newstatus = 0;
@@ -2619,6 +2634,9 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
+	if (brcmf_sdio_pm_resume_wait(bus->sdiodev))
+		return;
+
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* If waiting for HTAVAIL, check status */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
index 8eb4262..82494df 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
@@ -169,8 +169,6 @@ struct brcmf_sdio_dev {
 	u32 sbwad;			/* Save backplane window address */
 	struct brcmf_sdio *bus;
 	atomic_t suspend;		/* suspend flag */
-	wait_queue_head_t request_word_wait;
-	wait_queue_head_t request_buffer_wait;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
 	struct brcmfmac_sdio_platform_data *pdata;
-- 
1.9.1

