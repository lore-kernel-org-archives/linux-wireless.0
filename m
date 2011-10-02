Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1733 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab1JBRO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/20] staging: brcm80211: removed unused smac tx ampdu
 packet queue
Date: Sun, 2 Oct 2011 10:14:27 -0700
Message-ID: <1317575685-3156-3-git-send-email-frankyl@broadcom.com> (sfid-20111002_191501_942640_A668C508)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

A remnant of the past.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    2 --
 drivers/staging/brcm80211/brcmsmac/scb.h  |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 4f79a42..e6bd3cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3358,8 +3358,6 @@ void brcms_c_init_scb(struct scb *scb)
 
 	scb->seqctl_nonqos = 0xFFFF;
 	scb->magic = SCB_MAGIC;
-	brcmu_pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
-		  AMPDU_MAX_SCB_TID * PKTQ_LEN_DEFAULT);
 }
 
 /* d11 core init
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index 122d3c3..51c79c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -51,7 +51,6 @@ struct scb_ampdu {
 	u8 release;		/* # of mpdus released at a time */
 	u16 min_len;		/* min mpdu len to support the density */
 	u32 max_rx_ampdu_bytes;	/* max ampdu rcv length; 8k, 16k, 32k, 64k */
-	struct pktq txq;	/* sdu transmit queue pending aggregation */
 
 	/*
 	 * This could easily be a ini[] pointer and we keep this info in wl
-- 
1.7.1


