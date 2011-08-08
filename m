Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1680 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1HHN7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 07/82] staging: brcm80211: removed function
 declaration typedefs from dma.h part 1
Date: Mon, 8 Aug 2011 15:57:51 +0200
Message-ID: <1312811946-16713-8-git-send-email-arend@broadcom.com> (sfid-20110808_155928_883261_24624352)
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
 drivers/staging/brcm80211/brcmsmac/dma.c |   22 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/dma.h |   33 ++++++++++--------------------
 2 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index ea17671..5fd5e8c 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -387,12 +387,12 @@ static bool _dma64_addrext(dma64regs_t *dma64regs);
 static inline u32 parity32(u32 data);
 
 const struct di_fcn_s dma64proc = {
-	(di_detach_t) _dma_detach,
-	(di_txinit_t) dma64_txinit,
+	(void (*)(struct dma_pub *)) _dma_detach,
+	(void (*)(struct dma_pub *)) dma64_txinit,
 	(di_txreset_t) dma64_txreset,
 	(di_txenabled_t) dma64_txenabled,
-	(di_txsuspend_t) dma64_txsuspend,
-	(di_txresume_t) dma64_txresume,
+	(void (*)(struct dma_pub *)) dma64_txsuspend,
+	(void (*)(struct dma_pub *)) dma64_txresume,
 	(di_txsuspended_t) dma64_txsuspended,
 	(di_txsuspendedidle_t) dma64_txsuspendedidle,
 	(di_txfast_t) dma64_txfast,
@@ -402,12 +402,12 @@ const struct di_fcn_s dma64proc = {
 	(di_txreclaim_t) dma64_txreclaim,
 	(di_getnexttxp_t) dma64_getnexttxp,
 	(di_peeknexttxp_t) _dma_peeknexttxp,
-	(di_txblock_t) _dma_txblock,
-	(di_txunblock_t) _dma_txunblock,
+	(void (*)(struct dma_pub *)) _dma_txblock,
+	(void (*)(struct dma_pub *)) _dma_txunblock,
 	(di_txactive_t) _dma_txactive,
-	(di_txrotate_t) dma64_txrotate,
+	(void (*)(struct dma_pub *)) dma64_txrotate,
 
-	(di_rxinit_t) _dma_rxinit,
+	(void (*)(struct dma_pub *)) _dma_rxinit,
 	(di_rxreset_t) dma64_rxreset,
 	(di_rxidle_t) dma64_rxidle,
 	(di_rxstopped_t) dma64_rxstopped,
@@ -415,14 +415,14 @@ const struct di_fcn_s dma64proc = {
 	(di_rxenabled_t) dma64_rxenabled,
 	(di_rx_t) _dma_rx,
 	(di_rxfill_t) _dma_rxfill,
-	(di_rxreclaim_t) _dma_rxreclaim,
+	(void (*)(struct dma_pub *)) _dma_rxreclaim,
 	(di_getnextrxp_t) _dma_getnextrxp,
 	(di_peeknextrxp_t) _dma_peeknextrxp,
 	(di_rxparam_get_t) _dma_rx_param_get,
 
-	(di_fifoloopbackenable_t) _dma_fifoloopbackenable,
+	(void (*)(struct dma_pub *)) _dma_fifoloopbackenable,
 	(di_getvar_t) _dma_getvar,
-	(di_counterreset_t) _dma_counterreset,
+	(void (*)(struct dma_pub *)) _dma_counterreset,
 	(di_ctrlflags_t) _dma_ctrlflags,
 	NULL,
 	NULL,
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 9c8b9a6..69f2e94 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -59,15 +59,10 @@ enum txd_range {
 };
 
 /* dma function type */
-typedef void (*di_detach_t) (struct dma_pub *dmah);
 typedef bool(*di_txreset_t) (struct dma_pub *dmah);
 typedef bool(*di_rxreset_t) (struct dma_pub *dmah);
 typedef bool(*di_rxidle_t) (struct dma_pub *dmah);
-typedef void (*di_txinit_t) (struct dma_pub *dmah);
 typedef bool(*di_txenabled_t) (struct dma_pub *dmah);
-typedef void (*di_rxinit_t) (struct dma_pub *dmah);
-typedef void (*di_txsuspend_t) (struct dma_pub *dmah);
-typedef void (*di_txresume_t) (struct dma_pub *dmah);
 typedef bool(*di_txsuspended_t) (struct dma_pub *dmah);
 typedef bool(*di_txsuspendedidle_t) (struct dma_pub *dmah);
 typedef int (*di_txfast_t) (struct dma_pub *dmah, struct sk_buff *p,
@@ -75,7 +70,6 @@ typedef int (*di_txfast_t) (struct dma_pub *dmah, struct sk_buff *p,
 typedef int (*di_txunframed_t) (struct dma_pub *dmah, void *p, uint len,
 				bool commit);
 typedef void *(*di_getpos_t) (struct dma_pub *di, bool direction);
-typedef void (*di_fifoloopbackenable_t) (struct dma_pub *dmah);
 typedef bool(*di_txstopped_t) (struct dma_pub *dmah);
 typedef bool(*di_rxstopped_t) (struct dma_pub *dmah);
 typedef bool(*di_rxenable_t) (struct dma_pub *dmah);
@@ -83,7 +77,6 @@ typedef bool(*di_rxenabled_t) (struct dma_pub *dmah);
 typedef void *(*di_rx_t) (struct dma_pub *dmah);
 typedef bool(*di_rxfill_t) (struct dma_pub *dmah);
 typedef void (*di_txreclaim_t) (struct dma_pub *dmah, enum txd_range range);
-typedef void (*di_rxreclaim_t) (struct dma_pub *dmah);
 typedef unsigned long (*di_getvar_t) (struct dma_pub *dmah,
 				      const char *name);
 typedef void *(*di_getnexttxp_t) (struct dma_pub *dmah, enum txd_range range);
@@ -92,11 +85,7 @@ typedef void *(*di_peeknexttxp_t) (struct dma_pub *dmah);
 typedef void *(*di_peeknextrxp_t) (struct dma_pub *dmah);
 typedef void (*di_rxparam_get_t) (struct dma_pub *dmah, u16 *rxoffset,
 				  u16 *rxbufsize);
-typedef void (*di_txblock_t) (struct dma_pub *dmah);
-typedef void (*di_txunblock_t) (struct dma_pub *dmah);
 typedef uint(*di_txactive_t) (struct dma_pub *dmah);
-typedef void (*di_txrotate_t) (struct dma_pub *dmah);
-typedef void (*di_counterreset_t) (struct dma_pub *dmah);
 typedef uint(*di_ctrlflags_t) (struct dma_pub *dmah, uint mask, uint flags);
 typedef char *(*di_dump_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			    bool dumpring);
@@ -110,12 +99,12 @@ typedef uint(*di_txcommitted_t) (struct dma_pub *dmah);
 
 /* dma opsvec */
 struct di_fcn_s {
-	di_detach_t detach;
-	di_txinit_t txinit;
+	void (*detach)(struct dma_pub *dmah);
+	void (*txinit)(struct dma_pub *dmah);
 	di_txreset_t txreset;
 	di_txenabled_t txenabled;
-	di_txsuspend_t txsuspend;
-	di_txresume_t txresume;
+	void (*txsuspend)(struct dma_pub *dmah);
+	void (*txresume)(struct dma_pub *dmah);
 	di_txsuspended_t txsuspended;
 	di_txsuspendedidle_t txsuspendedidle;
 	di_txfast_t txfast;
@@ -125,12 +114,12 @@ struct di_fcn_s {
 	di_txreclaim_t txreclaim;
 	di_getnexttxp_t getnexttxp;
 	di_peeknexttxp_t peeknexttxp;
-	di_txblock_t txblock;
-	di_txunblock_t txunblock;
+	void (*txblock) (struct dma_pub *dmah);
+	void (*txunblock) (struct dma_pub *dmah);
 	di_txactive_t txactive;
-	di_txrotate_t txrotate;
+	void (*txrotate) (struct dma_pub *dmah);
 
-	di_rxinit_t rxinit;
+	void (*rxinit)(struct dma_pub *dmah);
 	di_rxreset_t rxreset;
 	di_rxidle_t rxidle;
 	di_rxstopped_t rxstopped;
@@ -138,14 +127,14 @@ struct di_fcn_s {
 	di_rxenabled_t rxenabled;
 	di_rx_t rx;
 	di_rxfill_t rxfill;
-	di_rxreclaim_t rxreclaim;
+	void (*rxreclaim)(struct dma_pub *dmah);
 	di_getnextrxp_t getnextrxp;
 	di_peeknextrxp_t peeknextrxp;
 	di_rxparam_get_t rxparam_get;
 
-	di_fifoloopbackenable_t fifoloopbackenable;
+	void (*fifoloopbackenable)(struct dma_pub *dmah);
 	di_getvar_t d_getvar;
-	di_counterreset_t counterreset;
+	void (*counterreset)(struct dma_pub *dmah);
 	di_ctrlflags_t ctrlflags;
 	di_dump_t dump;
 	di_dumptx_t dumptx;
-- 
1.7.4.1


