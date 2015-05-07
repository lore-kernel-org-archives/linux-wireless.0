Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38056 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbEGTIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 15:08:10 -0400
Received: by wiun10 with SMTP id n10so2857693wiu.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2015 12:08:09 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] brcmfmac: fix debugging info for received hw messages with errors
Date: Thu,  7 May 2015 21:07:41 +0200
Message-Id: <1431025661-8879-2-git-send-email-zajec5@gmail.com> (sfid-20150507_210813_671968_FCE8FB31)
In-Reply-To: <1431025661-8879-1-git-send-email-zajec5@gmail.com>
References: <1431025661-8879-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code in function setting/querying device was treating every error as
Broadcom protocol specific one. It wasn't right thing to do as most of
subcalls return "normal" errors (errno-base.h). This resulted in e.g.:
brcmf_usb_rx_ctlpkt: rxctl wait timed out
brcmfmac: brcmf_fil_cmd_data Failed: BCME_NOTDOWN (-5)
which was misleading because of interpreting -EIO as BCME_NOTDOWN.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c | 5 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c | 3 +--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 8e0e91c..47941ab 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -203,8 +203,11 @@ retry:
 	}
 
 	/* Check the ERROR flag */
-	if (flags & BCDC_DCMD_ERROR)
+	if (flags & BCDC_DCMD_ERROR) {
 		ret = le32_to_cpu(msg->status);
+		brcmf_dbg(BCDC, "received message with error %s (%d)\n",
+			  brcmf_get_errstr((u32)(-ret)), ret);
+	}
 
 done:
 	return ret;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index bdbdc9e..c86a522 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -53,8 +53,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	if (err >= 0)
 		return 0;
 
-	brcmf_dbg(FIL, "Failed: %s (%d)\n",
-		  brcmf_get_errstr((u32)(-err)), err);
+	brcmf_dbg(FIL, "Failed: %d\n", err);
 	return -EBADE;
 }
 
-- 
1.8.4.5

