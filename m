Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4841 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab3FFLTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:19:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/22] brcmfmac: Signalling header push and pull on
 logic places.
Date: Thu, 6 Jun 2013 13:17:59 +0200
Message-ID: <1370517487-14395-15-git-send-email-arend@broadcom.com> (sfid-20130606_131923_184319_764D8825)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently suppressed packets get enque-ed with header which
then gets pulled before transmit. It is more logical and clean
to pull the header on return and push it unconditionally on xmit.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   42 ++++++--------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index a4b9985..bdf80ee 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1263,6 +1263,7 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	u32 hslot;
 	int ret;
+	u8 ifidx;
 
 	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 
@@ -1279,9 +1280,12 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 
 	entry->generation = genbit;
 
-	ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo, skb);
+	ret = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
+	if (ret == 0)
+		ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo,
+				    skb);
 	if (ret != 0) {
-		/* suppress q is full, drop this packet */
+		/* suppress q is full or hdrpull failed, drop this packet */
 		brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
 					true);
 	} else {
@@ -1585,18 +1589,10 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	bool first_time;
 	int hslot = BRCMF_FWS_HANGER_MAXITEMS;
 	u8 free_ctr;
-	u8 ifidx;
 	u8 flags;
 
 	first_time = skcb->state != BRCMF_FWS_SKBSTATE_SUPPRESSED;
 
-	if (!first_time) {
-		rc = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, p);
-		if (rc) {
-			brcmf_err("hdrpull failed\n");
-			return rc;
-		}
-	}
 	brcmf_skb_if_flags_set_field(p, TRANSMIT, 1);
 	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
 	brcmf_skb_htod_tag_set_field(p, GENERATION, entry->generation);
@@ -1619,15 +1615,14 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 		brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
 		brcmf_skb_htod_tag_set_field(p, FREERUN, free_ctr);
 		entry->transit_count++;
-	}
-
-	brcmf_fws_hdrpush(fws, p);
-	if (first_time) {
 		rc = brcmf_fws_hanger_pushpkt(&fws->hanger, p, hslot);
 		if (rc)
 			brcmf_err("hanger push failed: rc=%d\n", rc);
 	}
 
+	if (rc == 0)
+		brcmf_fws_hdrpush(fws, p);
+
 	return rc;
 }
 
@@ -1648,7 +1643,6 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 	struct sk_buff *pktout;
 	int rc = 0;
 	int hslot;
-	u8 ifidx;
 
 	state = brcmf_skbcb(skb)->state;
 	entry = brcmf_skbcb(skb)->mac;
@@ -1665,17 +1659,6 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 		} else {
 			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 
-			/* remove header first */
-			rc = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
-			if (rc) {
-				brcmf_err("header removal failed\n");
-				/* free the hanger slot */
-				brcmf_fws_hanger_poppkt(&fws->hanger, hslot,
-							&pktout, true);
-				rc = -EINVAL;
-				goto fail;
-			}
-
 			/* delay-q packets are going to delay-q */
 			pktout = brcmu_pktq_penq_head(&entry->psq,
 						      2 * fifo, skb);
@@ -1696,8 +1679,6 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 		rc = -ENOENT;
 	}
 
-
-fail:
 	if (rc) {
 		brcmf_fws_bustxfail(fws, skb);
 		fws->stats.rollback_failed++;
@@ -1767,6 +1748,7 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	struct brcmf_fws_mac_descriptor *entry;
 	struct brcmf_bus *bus = fws->drvr->bus_if;
 	int rc;
+	u8 ifidx;
 
 	entry = skcb->mac;
 	if (IS_ERR(entry))
@@ -1781,8 +1763,10 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	brcmf_dbg(DATA, "%s flags %X htod %X\n", entry->name, skcb->if_flags,
 		  skcb->htod);
 	rc = brcmf_bus_txdata(bus, skb);
-	if (rc < 0)
+	if (rc < 0) {
+		brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
 		goto rollback;
+	}
 
 	entry->seq[fifo]++;
 	fws->stats.pkt2bus++;
-- 
1.7.10.4


