Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2951 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/31] staging: brcm80211: removed asserts from
 dhd_cdc.c and dhd_common.c
Date: Wed, 6 Jul 2011 00:02:34 +0200
Message-ID: <1309903378-29021-8-git-send-email-arend@broadcom.com> (sfid-20110706_000323_546418_62A78BB8)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |    2 --
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   21 +++++++++------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 4b8eb9c..d464606 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -288,8 +288,6 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	ASSERT(len <= BRCMF_C_IOCTL_MAXLEN);
-
 	if (len > BRCMF_C_IOCTL_MAXLEN)
 		goto done;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 12cb90d..59c2726 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -272,7 +272,6 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		eprec = prec;
 	else if (pktq_full(q)) {
 		p = brcmu_pktq_peek_tail(q, &eprec);
-		ASSERT(p);
 		if (eprec > prec)
 			return false;
 	}
@@ -280,7 +279,6 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 	/* Evict if needed */
 	if (eprec >= 0) {
 		/* Detect queueing to unconfigured precedence */
-		ASSERT(!pktq_pempty(q, eprec));
 		discard_oldest = AC_BITMAP_TST(drvr->wme_dp, eprec);
 		if (eprec == prec && !discard_oldest)
 			return false;	/* refuse newer (incoming) packet */
@@ -290,9 +288,7 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		if (p == NULL) {
 			BRCMF_ERROR(("%s: brcmu_pktq_penq() failed, oldest %d.",
 				     __func__, discard_oldest));
-			ASSERT(p);
 		}
-
 		brcmu_pkt_buf_free_skb(p);
 	}
 
@@ -300,10 +296,9 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 	p = brcmu_pktq_penq(q, prec, pkt);
 	if (p == NULL) {
 		BRCMF_ERROR(("%s: brcmu_pktq_penq() failed.", __func__));
-		ASSERT(p);
 	}
 
-	return true;
+	return p != NULL;
 }
 
 static int
@@ -317,14 +312,16 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	ASSERT(name);
-	ASSERT(len >= 0);
+	if (name == NULL || len <= 0)
+		return -EINVAL;
 
-	/* Get MUST have return space */
-	ASSERT(set || (arg && len));
+	/* Set does not take qualifiers */
+	if (set && (params || plen))
+		return -EINVAL;
 
-	/* Set does NOT take qualifiers */
-	ASSERT(!set || (!params && !plen));
+	/* Get must have return space;*/
+	if (!set && !(arg && len))
+		return -EINVAL;
 
 	vi = brcmu_iovar_lookup(brcmf_iovars, name);
 	if (vi == NULL) {
-- 
1.7.4.1


