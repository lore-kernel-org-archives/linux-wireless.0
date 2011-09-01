Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1175 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/30] staging: brcm80211: use min_t() instead of min()
Date: Thu, 1 Sep 2011 11:16:59 +0200
Message-ID: <1314868640-9425-10-git-send-email-rvossen@broadcom.com> (sfid-20110901_111741_184814_157DBE7F)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Also eliminate a cast to int that could cause issues with very large values
of di->rxbufsize (as suggested by Dan Carpenter).

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 8859a77..6d9a0fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -917,7 +917,7 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
 		tail = head;
 		while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
 			tail->next = p;
-			pkt_len = min(resid, (int)di->rxbufsize);
+			pkt_len = min_t(uint, resid, di->rxbufsize);
 			__skb_trim(p, pkt_len);
 
 			tail = p;
-- 
1.7.4.1


