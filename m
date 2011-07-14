Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4332 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/35] staging: brcm80211: removed function declaration
 typedefs from dma.h part 4
Date: Thu, 14 Jul 2011 14:29:05 -0700
Message-ID: <1310678971-28952-10-git-send-email-frankyl@broadcom.com> (sfid-20110714_233116_615684_2040F3CB)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |   24 ++++++------
 drivers/staging/brcm80211/brcmsmac/dma.h |   60 ++++++++++-------------------
 2 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index ebc0848..517dc61 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -395,13 +395,13 @@ const struct di_fcn_s dma64proc = {
 	(void (*)(struct dma_pub *)) dma64_txresume,
 	(bool(*)(struct dma_pub *)) dma64_txsuspended,
 	(bool(*)(struct dma_pub *)) dma64_txsuspendedidle,
-	(di_txfast_t) dma64_txfast,
-	(di_txunframed_t) dma64_txunframed,
-	(di_getpos_t) dma64_getpos,
+	(int (*)(struct dma_pub *, struct sk_buff *, bool)) dma64_txfast,
+	(int (*)(struct dma_pub *, void *, uint, bool)) dma64_txunframed,
+	(void *(*)(struct dma_pub *, bool)) dma64_getpos,
 	(bool(*)(struct dma_pub *)) dma64_txstopped,
-	(di_txreclaim_t) dma64_txreclaim,
-	(di_getnexttxp_t) dma64_getnexttxp,
-	(di_peeknexttxp_t) _dma_peeknexttxp,
+	(void (*)(struct dma_pub *, enum txd_range)) dma64_txreclaim,
+	(void *(*)(struct dma_pub *, enum txd_range)) dma64_getnexttxp,
+	(void *(*)(struct dma_pub *)) _dma_peeknexttxp,
 	(void (*)(struct dma_pub *)) _dma_txblock,
 	(void (*)(struct dma_pub *)) _dma_txunblock,
 	(uint (*)(struct dma_pub *)) _dma_txactive,
@@ -413,17 +413,17 @@ const struct di_fcn_s dma64proc = {
 	(bool(*)(struct dma_pub *)) dma64_rxstopped,
 	(bool(*)(struct dma_pub *)) _dma_rxenable,
 	(bool(*)(struct dma_pub *)) dma64_rxenabled,
-	(di_rx_t) _dma_rx,
+	(void *(*)(struct dma_pub *)) _dma_rx,
 	(bool(*)(struct dma_pub *)) _dma_rxfill,
 	(void (*)(struct dma_pub *)) _dma_rxreclaim,
-	(di_getnextrxp_t) _dma_getnextrxp,
-	(di_peeknextrxp_t) _dma_peeknextrxp,
-	(di_rxparam_get_t) _dma_rx_param_get,
+	(void *(*)(struct dma_pub *, bool)) _dma_getnextrxp,
+	(void *(*)(struct dma_pub *)) _dma_peeknextrxp,
+	(void (*)(struct dma_pub *, u16 *, u16 *)) _dma_rx_param_get,
 
 	(void (*)(struct dma_pub *)) _dma_fifoloopbackenable,
-	(di_getvar_t) _dma_getvar,
+	(unsigned long (*)(struct dma_pub *, const char *)) _dma_getvar,
 	(void (*)(struct dma_pub *)) _dma_counterreset,
-	(di_ctrlflags_t) _dma_ctrlflags,
+	(uint (*)(struct dma_pub *, uint, uint)) _dma_ctrlflags,
 	NULL,
 	NULL,
 	NULL,
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 5dc7e0b..3ff109f 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -58,30 +58,6 @@ enum txd_range {
 	DMA_RANGE_TRANSFERED
 };
 
-/* dma function type */
-typedef int (*di_txfast_t) (struct dma_pub *dmah, struct sk_buff *p,
-			    bool commit);
-typedef int (*di_txunframed_t) (struct dma_pub *dmah, void *p, uint len,
-				bool commit);
-typedef void *(*di_getpos_t) (struct dma_pub *di, bool direction);
-typedef void *(*di_rx_t) (struct dma_pub *dmah);
-typedef void (*di_txreclaim_t) (struct dma_pub *dmah, enum txd_range range);
-typedef unsigned long (*di_getvar_t) (struct dma_pub *dmah,
-				      const char *name);
-typedef void *(*di_getnexttxp_t) (struct dma_pub *dmah, enum txd_range range);
-typedef void *(*di_getnextrxp_t) (struct dma_pub *dmah, bool forceall);
-typedef void *(*di_peeknexttxp_t) (struct dma_pub *dmah);
-typedef void *(*di_peeknextrxp_t) (struct dma_pub *dmah);
-typedef void (*di_rxparam_get_t) (struct dma_pub *dmah, u16 *rxoffset,
-				  u16 *rxbufsize);
-typedef uint(*di_ctrlflags_t) (struct dma_pub *dmah, uint mask, uint flags);
-typedef char *(*di_dump_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
-			    bool dumpring);
-typedef char *(*di_dumptx_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
-			      bool dumpring);
-typedef char *(*di_dumprx_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
-			      bool dumpring);
-
 /* dma opsvec */
 struct di_fcn_s {
 	void (*detach)(struct dma_pub *dmah);
@@ -92,13 +68,14 @@ struct di_fcn_s {
 	void (*txresume)(struct dma_pub *dmah);
 	bool (*txsuspended)(struct dma_pub *dmah);
 	bool (*txsuspendedidle)(struct dma_pub *dmah);
-	di_txfast_t txfast;
-	di_txunframed_t txunframed;
-	di_getpos_t getpos;
+	int (*txfast)(struct dma_pub *dmah, struct sk_buff *p, bool commit);
+	int (*txunframed)(struct dma_pub *dmah, void *p, uint len, bool commit);
+
+	void *(*getpos)(struct dma_pub *di, bool direction);
 	bool (*txstopped)(struct dma_pub *dmah);
-	di_txreclaim_t txreclaim;
-	di_getnexttxp_t getnexttxp;
-	di_peeknexttxp_t peeknexttxp;
+	void (*txreclaim)(struct dma_pub *dmah, enum txd_range range);
+	void *(*getnexttxp)(struct dma_pub *dmah, enum txd_range range);
+	void *(*peeknexttxp) (struct dma_pub *dmah);
 	void (*txblock) (struct dma_pub *dmah);
 	void (*txunblock) (struct dma_pub *dmah);
 	uint (*txactive)(struct dma_pub *dmah);
@@ -110,20 +87,25 @@ struct di_fcn_s {
 	bool (*rxstopped)(struct dma_pub *dmah);
 	bool (*rxenable)(struct dma_pub *dmah);
 	bool (*rxenabled)(struct dma_pub *dmah);
-	di_rx_t rx;
+	void *(*rx)(struct dma_pub *dmah);
 	bool (*rxfill)(struct dma_pub *dmah);
 	void (*rxreclaim)(struct dma_pub *dmah);
-	di_getnextrxp_t getnextrxp;
-	di_peeknextrxp_t peeknextrxp;
-	di_rxparam_get_t rxparam_get;
+	void *(*getnextrxp)(struct dma_pub *dmah, bool forceall);
+	void *(*peeknextrxp)(struct dma_pub *dmah);
+	void (*rxparam_get)(struct dma_pub *dmah, u16 *rxoffset,
+			    u16 *rxbufsize);
 
 	void (*fifoloopbackenable)(struct dma_pub *dmah);
-	di_getvar_t d_getvar;
+	unsigned long (*d_getvar)(struct dma_pub *dmah, const char *name);
+
 	void (*counterreset)(struct dma_pub *dmah);
-	di_ctrlflags_t ctrlflags;
-	di_dump_t dump;
-	di_dumptx_t dumptx;
-	di_dumprx_t dumprx;
+	uint (*ctrlflags)(struct dma_pub *dmah, uint mask, uint flags);
+	char *(*dump)(struct dma_pub *dmah, struct brcmu_strbuf *b,
+		      bool dumpring);
+	char *(*dumptx)(struct dma_pub *dmah, struct brcmu_strbuf *b,
+			bool dumpring);
+	char *(*dumprx)(struct dma_pub *dmah, struct brcmu_strbuf *b,
+			bool dumpring);
 	uint (*rxactive)(struct dma_pub *dmah);
 	uint (*txpending)(struct dma_pub *dmah);
 	uint (*txcommitted)(struct dma_pub *dmah);
-- 
1.7.1


