Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2552 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab3ABOXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/18] brcmfmac: Remove unused caching dongle error.
Date: Wed, 2 Jan 2013 15:22:48 +0100
Message-ID: <1357136572-18273-16-git-send-email-arend@broadcom.com> (sfid-20130102_152325_455097_AACF08F8)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

CDC errors are retained. However, it is never used so it can
be removed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h     |    3 ---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c |   22 ++-------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 0388599..bbefaf3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -496,9 +496,6 @@ struct brcmf_pub {
 	/* Last error return */
 	int bcmerror;
 
-	/* Last error from dongle */
-	int dongle_error;
-
 	/* Suspend disable flag  flag */
 	int suspend_disable_flag;	/* "1" to disable all extra powersaving
 					 during suspend */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index db3bc2e..4557709 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -147,18 +147,6 @@ brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	brcmf_dbg(CDC, "Enter, cmd %d len %d\n", cmd, len);
 
-	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
-	if (cmd == BRCMF_C_GET_VAR && buf) {
-		if (!strcmp((char *)buf, "bcmerrorstr")) {
-			strncpy((char *)buf, "bcm_error",
-				BCME_STRLEN);
-			goto done;
-		} else if (!strcmp((char *)buf, "bcmerror")) {
-			*(int *)buf = drvr->dongle_error;
-			goto done;
-		}
-	}
-
 	memset(msg, 0, sizeof(struct brcmf_proto_cdc_dcmd));
 
 	msg->cmd = cpu_to_le32(cmd);
@@ -207,11 +195,8 @@ retry:
 	}
 
 	/* Check the ERROR flag */
-	if (flags & CDC_DCMD_ERROR) {
+	if (flags & CDC_DCMD_ERROR)
 		ret = le32_to_cpu(msg->status);
-		/* Cache error from dongle */
-		drvr->dongle_error = ret;
-	}
 
 done:
 	return ret;
@@ -258,11 +243,8 @@ int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	}
 
 	/* Check the ERROR flag */
-	if (flags & CDC_DCMD_ERROR) {
+	if (flags & CDC_DCMD_ERROR)
 		ret = le32_to_cpu(msg->status);
-		/* Cache error from dongle */
-		drvr->dongle_error = ret;
-	}
 
 done:
 	return ret;
-- 
1.7.10.4


