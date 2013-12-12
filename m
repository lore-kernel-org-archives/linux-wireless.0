Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:6952 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3LLK7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:13 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/18] brcmfmac: get rid of some void pointer parameters
Date: Thu, 12 Dec 2013 11:58:56 +0100
Message-ID: <1386845946-9859-9-git-send-email-arend@broadcom.com> (sfid-20131212_115917_076058_4AC431DF)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In sdio code a couple of functions use a void pointer as argument
type although it should be struct brcmf_sdio. Changing the functions
to have proper type checking.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |   13 ++++---------
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h |    9 ++++-----
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 24d69f4..c42d5a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3649,10 +3649,8 @@ exit:
 	return ret;
 }
 
-void brcmf_sdbrcm_isr(void *arg)
+void brcmf_sdbrcm_isr(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio *bus = (struct brcmf_sdio *) arg;
-
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (!bus) {
@@ -4037,7 +4035,7 @@ static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.gettxq = brcmf_sdbrcm_bus_gettxq,
 };
 
-void *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
+struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
@@ -4147,14 +4145,11 @@ fail:
 	return NULL;
 }
 
-void brcmf_sdbrcm_disconnect(void *ptr)
+void brcmf_sdbrcm_disconnect(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio *bus = (struct brcmf_sdio *)ptr;
-
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus)
-		brcmf_sdbrcm_release(bus);
+	brcmf_sdbrcm_release(bus);
 
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index d98b4bd..414aa16 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -165,7 +165,7 @@ struct brcmf_sdio_dev {
 	struct sdio_func *func[SDIO_MAX_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
 	u32 sbwad;			/* Save backplane window address */
-	void *bus;
+	struct brcmf_sdio *bus;
 	atomic_t suspend;		/* suspend flag */
 	wait_queue_head_t request_byte_wait;
 	wait_queue_head_t request_word_wait;
@@ -239,10 +239,9 @@ int brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 /* Issue an abort to the specified function */
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
-void *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev);
-void brcmf_sdbrcm_disconnect(void *ptr);
-void brcmf_sdbrcm_isr(void *arg);
-
+struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev);
+void brcmf_sdbrcm_disconnect(struct brcmf_sdio *bus);
+void brcmf_sdbrcm_isr(struct brcmf_sdio *bus);
 void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.10.4

