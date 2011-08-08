Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3122 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1HHN7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 09/82] staging: brcm80211: removed function
 declaration typedefs from dma.h part 3
Date: Mon, 8 Aug 2011 15:57:53 +0200
Message-ID: <1312811946-16713-10-git-send-email-arend@broadcom.com> (sfid-20110808_160135_542741_AC06B282)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |    8 ++++----
 drivers/staging/brcm80211/brcmsmac/dma.h |   12 ++++--------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 3e732c8d..ebc0848 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -404,7 +404,7 @@ const struct di_fcn_s dma64proc = {
 	(di_peeknexttxp_t) _dma_peeknexttxp,
 	(void (*)(struct dma_pub *)) _dma_txblock,
 	(void (*)(struct dma_pub *)) _dma_txunblock,
-	(di_txactive_t) _dma_txactive,
+	(uint (*)(struct dma_pub *)) _dma_txactive,
 	(void (*)(struct dma_pub *)) dma64_txrotate,
 
 	(void (*)(struct dma_pub *)) _dma_rxinit,
@@ -427,9 +427,9 @@ const struct di_fcn_s dma64proc = {
 	NULL,
 	NULL,
 	NULL,
-	(di_rxactive_t) _dma_rxactive,
-	(di_txpending_t) _dma_txpending,
-	(di_txcommitted_t) _dma_txcommitted,
+	(uint (*)(struct dma_pub *)) _dma_rxactive,
+	(uint (*)(struct dma_pub *)) _dma_txpending,
+	(uint (*)(struct dma_pub *)) _dma_txcommitted,
 	39
 };
 
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 6d6dbd8..5dc7e0b 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -74,7 +74,6 @@ typedef void *(*di_peeknexttxp_t) (struct dma_pub *dmah);
 typedef void *(*di_peeknextrxp_t) (struct dma_pub *dmah);
 typedef void (*di_rxparam_get_t) (struct dma_pub *dmah, u16 *rxoffset,
 				  u16 *rxbufsize);
-typedef uint(*di_txactive_t) (struct dma_pub *dmah);
 typedef uint(*di_ctrlflags_t) (struct dma_pub *dmah, uint mask, uint flags);
 typedef char *(*di_dump_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			    bool dumpring);
@@ -82,9 +81,6 @@ typedef char *(*di_dumptx_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			      bool dumpring);
 typedef char *(*di_dumprx_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			      bool dumpring);
-typedef uint(*di_rxactive_t) (struct dma_pub *dmah);
-typedef uint(*di_txpending_t) (struct dma_pub *dmah);
-typedef uint(*di_txcommitted_t) (struct dma_pub *dmah);
 
 /* dma opsvec */
 struct di_fcn_s {
@@ -105,7 +101,7 @@ struct di_fcn_s {
 	di_peeknexttxp_t peeknexttxp;
 	void (*txblock) (struct dma_pub *dmah);
 	void (*txunblock) (struct dma_pub *dmah);
-	di_txactive_t txactive;
+	uint (*txactive)(struct dma_pub *dmah);
 	void (*txrotate) (struct dma_pub *dmah);
 
 	void (*rxinit)(struct dma_pub *dmah);
@@ -128,9 +124,9 @@ struct di_fcn_s {
 	di_dump_t dump;
 	di_dumptx_t dumptx;
 	di_dumprx_t dumprx;
-	di_rxactive_t rxactive;
-	di_txpending_t txpending;
-	di_txcommitted_t txcommitted;
+	uint (*rxactive)(struct dma_pub *dmah);
+	uint (*txpending)(struct dma_pub *dmah);
+	uint (*txcommitted)(struct dma_pub *dmah);
 	uint endnum;
 };
 
-- 
1.7.4.1


