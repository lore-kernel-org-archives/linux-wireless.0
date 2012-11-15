Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767933Ab2KOOIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 03/22] brcmsmac: Add helper function for updating txavail count
Date: Thu, 15 Nov 2012 08:07:53 -0600
Message-Id: <1352988492-21340-4-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150837_728252_FE9D2116)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use this helper function rather than open-coding the same calculation in
multiple places.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 5e53305..6444cf1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -1264,6 +1264,17 @@ bool dma_rxreset(struct dma_pub *pub)
 	return status == D64_RS0_RS_DISABLED;
 }
 
+/* Update count of available tx descriptors based on current DMA state */
+static void dma_update_txavail(struct dma_info *di)
+{
+	/*
+	 * Available space is number of descriptors less the number of
+	 * active descriptors and the number of queued AMPDU frames.
+	 */
+	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
+}
+
+
 /*
  * !! tx entry routine
  * WARNING: call must check the return value for error.
@@ -1325,7 +1336,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 		      di->xmtptrbase + I2B(txout, struct dma64desc));
 
 	/* tx flow control */
-	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
+	dma_update_txavail(di);
 
 	return 0;
 
@@ -1412,7 +1423,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	di->txin = i;
 
 	/* tx flow control */
-	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
+	dma_update_txavail(di);
 
 	return txp;
 
-- 
1.7.9.5

