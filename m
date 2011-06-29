Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4699 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757889Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 025/119] staging: brcm80211: removed unneeded 'if'
 statement
Date: Wed, 29 Jun 2011 16:46:49 -0700
Message-ID: <1309391303-22741-26-git-send-email-frankyl@broadcom.com> (sfid-20110630_014954_412441_A86DF5A0)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The 'if' is unnecessary, since no action is taken as a result of the test.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index bdaad20..90d1b32 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -349,7 +349,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 	/* TX FIFO suspend/flush completion */
 	if (macintstatus & MI_TXSTOP)
-		if (brcms_b_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO));
+		brcms_b_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO);
 
 	/* noise sample collected */
 	if (macintstatus & MI_BG_NOISE) {
-- 
1.7.1


