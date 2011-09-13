Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2853 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab1IMHuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:07 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/17] staging: brcm80211: fix for fullmac build problem
Date: Tue, 13 Sep 2011 09:49:44 +0200
Message-ID: <1315900197-7260-5-git-send-email-rvossen@broadcom.com> (sfid-20110913_095013_195673_753888B5)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fullmac had a build error for CONFIG_PM_SLEEP=n

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 0aff62d..7cb8f3f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -49,12 +49,10 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
-#ifdef CONFIG_PM_SLEEP
 static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
 static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
 static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
 static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
-#endif		/* CONFIG_PM_SLEEP */
 
 static bool
 brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
-- 
1.7.4.1


