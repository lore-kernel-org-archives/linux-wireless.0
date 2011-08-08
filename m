Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3107 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab1HHN7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 08/82] staging: brcm80211: removed function
 declaration typedefs from dma.h part 2
Date: Mon, 8 Aug 2011 15:57:52 +0200
Message-ID: <1312811946-16713-9-git-send-email-arend@broadcom.com> (sfid-20110808_160222_860733_EE8AAB7E)
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
index 5fd5e8c..3e732c8d 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -389,16 +389,16 @@ static inline u32 parity32(u32 data);
 const struct di_fcn_s dma64proc = {
 	(void (*)(struct dma_pub *)) _dma_detach,
 	(void (*)(struct dma_pub *)) dma64_txinit,
-	(di_txreset_t) dma64_txreset,
-	(di_txenabled_t) dma64_txenabled,
+	(bool(*)(struct dma_pub *)) dma64_txreset,
+	(bool(*)(struct dma_pub *)) dma64_txenabled,
 	(void (*)(struct dma_pub *)) dma64_txsuspend,
 	(void (*)(struct dma_pub *)) dma64_txresume,
-	(di_txsuspended_t) dma64_txsuspended,
-	(di_txsuspendedidle_t) dma64_txsuspendedidle,
+	(bool(*)(struct dma_pub *)) dma64_txsuspended,
+	(bool(*)(struct dma_pub *)) dma64_txsuspendedidle,
 	(di_txfast_t) dma64_txfast,
 	(di_txunframed_t) dma64_txunframed,
 	(di_getpos_t) dma64_getpos,
-	(di_txstopped_t) dma64_txstopped,
+	(bool(*)(struct dma_pub *)) dma64_txstopped,
 	(di_txreclaim_t) dma64_txreclaim,
 	(di_getnexttxp_t) dma64_getnexttxp,
 	(di_peeknexttxp_t) _dma_peeknexttxp,
@@ -408,13 +408,13 @@ const struct di_fcn_s dma64proc = {
 	(void (*)(struct dma_pub *)) dma64_txrotate,
 
 	(void (*)(struct dma_pub *)) _dma_rxinit,
-	(di_rxreset_t) dma64_rxreset,
-	(di_rxidle_t) dma64_rxidle,
-	(di_rxstopped_t) dma64_rxstopped,
-	(di_rxenable_t) _dma_rxenable,
-	(di_rxenabled_t) dma64_rxenabled,
+	(bool(*)(struct dma_pub *)) dma64_rxreset,
+	(bool(*)(struct dma_pub *)) dma64_rxidle,
+	(bool(*)(struct dma_pub *)) dma64_rxstopped,
+	(bool(*)(struct dma_pub *)) _dma_rxenable,
+	(bool(*)(struct dma_pub *)) dma64_rxenabled,
 	(di_rx_t) _dma_rx,
-	(di_rxfill_t) _dma_rxfill,
+	(bool(*)(struct dma_pub *)) _dma_rxfill,
 	(void (*)(struct dma_pub *)) _dma_rxreclaim,
 	(di_getnextrxp_t) _dma_getnextrxp,
 	(di_peeknextrxp_t) _dma_peeknextrxp,
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 69f2e94..6d6dbd8 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -59,23 +59,12 @@ enum txd_range {
 };
 
 /* dma function type */
-typedef bool(*di_txreset_t) (struct dma_pub *dmah);
-typedef bool(*di_rxreset_t) (struct dma_pub *dmah);
-typedef bool(*di_rxidle_t) (struct dma_pub *dmah);
-typedef bool(*di_txenabled_t) (struct dma_pub *dmah);
-typedef bool(*di_txsuspended_t) (struct dma_pub *dmah);
-typedef bool(*di_txsuspendedidle_t) (struct dma_pub *dmah);
 typedef int (*di_txfast_t) (struct dma_pub *dmah, struct sk_buff *p,
 			    bool commit);
 typedef int (*di_txunframed_t) (struct dma_pub *dmah, void *p, uint len,
 				bool commit);
 typedef void *(*di_getpos_t) (struct dma_pub *di, bool direction);
-typedef bool(*di_txstopped_t) (struct dma_pub *dmah);
-typedef bool(*di_rxstopped_t) (struct dma_pub *dmah);
-typedef bool(*di_rxenable_t) (struct dma_pub *dmah);
-typedef bool(*di_rxenabled_t) (struct dma_pub *dmah);
 typedef void *(*di_rx_t) (struct dma_pub *dmah);
-typedef bool(*di_rxfill_t) (struct dma_pub *dmah);
 typedef void (*di_txreclaim_t) (struct dma_pub *dmah, enum txd_range range);
 typedef unsigned long (*di_getvar_t) (struct dma_pub *dmah,
 				      const char *name);
@@ -101,16 +90,16 @@ typedef uint(*di_txcommitted_t) (struct dma_pub *dmah);
 struct di_fcn_s {
 	void (*detach)(struct dma_pub *dmah);
 	void (*txinit)(struct dma_pub *dmah);
-	di_txreset_t txreset;
-	di_txenabled_t txenabled;
+	bool (*txreset)(struct dma_pub *dmah);
+	bool (*txenabled)(struct dma_pub *dmah);
 	void (*txsuspend)(struct dma_pub *dmah);
 	void (*txresume)(struct dma_pub *dmah);
-	di_txsuspended_t txsuspended;
-	di_txsuspendedidle_t txsuspendedidle;
+	bool (*txsuspended)(struct dma_pub *dmah);
+	bool (*txsuspendedidle)(struct dma_pub *dmah);
 	di_txfast_t txfast;
 	di_txunframed_t txunframed;
 	di_getpos_t getpos;
-	di_txstopped_t txstopped;
+	bool (*txstopped)(struct dma_pub *dmah);
 	di_txreclaim_t txreclaim;
 	di_getnexttxp_t getnexttxp;
 	di_peeknexttxp_t peeknexttxp;
@@ -120,13 +109,13 @@ struct di_fcn_s {
 	void (*txrotate) (struct dma_pub *dmah);
 
 	void (*rxinit)(struct dma_pub *dmah);
-	di_rxreset_t rxreset;
-	di_rxidle_t rxidle;
-	di_rxstopped_t rxstopped;
-	di_rxenable_t rxenable;
-	di_rxenabled_t rxenabled;
+	bool (*rxreset)(struct dma_pub *dmah);
+	bool (*rxidle)(struct dma_pub *dmah);
+	bool (*rxstopped)(struct dma_pub *dmah);
+	bool (*rxenable)(struct dma_pub *dmah);
+	bool (*rxenabled)(struct dma_pub *dmah);
 	di_rx_t rx;
-	di_rxfill_t rxfill;
+	bool (*rxfill)(struct dma_pub *dmah);
 	void (*rxreclaim)(struct dma_pub *dmah);
 	di_getnextrxp_t getnextrxp;
 	di_peeknextrxp_t peeknextrxp;
-- 
1.7.4.1


