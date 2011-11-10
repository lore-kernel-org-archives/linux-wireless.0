Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3752 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/19] brcm80211: fmac: add function to free the glom
 skb queue
Date: Thu, 10 Nov 2011 20:30:31 +0100
Message-ID: <1320953434-16859-18-git-send-email-arend@broadcom.com> (sfid-20111110_203136_758601_36B43991)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In several places in dhd_sdio.c a skb packet queue was being emptied
and the packets freed. This warrants to have a function in place to
do this.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   34 ++++++++-----------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c406b46..d8a521a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1119,6 +1119,16 @@ static uint brcmf_sdbrcm_glom_len(struct brcmf_bus *bus)
 	return total;
 }
 
+static void brcmf_sdbrcm_free_glom(struct brcmf_bus *bus)
+{
+	struct sk_buff *cur, *next;
+
+	skb_queue_walk_safe(&bus->glom, cur, next) {
+		skb_unlink(cur, &bus->glom);
+		brcmu_pkt_buf_free_skb(cur);
+	}
+}
+
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
@@ -1203,11 +1213,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			}
 			pfirst = pnext = NULL;
 		} else {
-			if (!skb_queue_empty(&bus->glom))
-				skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
-					skb_unlink(pfirst, &bus->glom);
-					brcmu_pkt_buf_free_skb(pfirst);
-				}
+			brcmf_sdbrcm_free_glom(bus);
 			num = 0;
 		}
 
@@ -1274,10 +1280,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				bus->glomerr = 0;
 				brcmf_sdbrcm_rxfail(bus, true, false);
 				bus->rxglomfail++;
-				skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
-					skb_unlink(pfirst, &bus->glom);
-					brcmu_pkt_buf_free_skb(pfirst);
-				}
+				brcmf_sdbrcm_free_glom(bus);
 			}
 			return 0;
 		}
@@ -1399,10 +1402,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				bus->glomerr = 0;
 				brcmf_sdbrcm_rxfail(bus, true, false);
 				bus->rxglomfail++;
-				skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
-					skb_unlink(pfirst, &bus->glom);
-					brcmu_pkt_buf_free_skb(pfirst);
-				}
+				brcmf_sdbrcm_free_glom(bus);
 			}
 			bus->nextlen = 0;
 			return 0;
@@ -3369,8 +3369,6 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 	u8 saveclk;
 	uint retries;
 	int err;
-	struct sk_buff *cur;
-	struct sk_buff *next;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3430,11 +3428,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
 		brcmu_pkt_buf_free_skb(bus->glomd);
-	if (!skb_queue_empty(&bus->glom))
-		skb_queue_walk_safe(&bus->glom, cur, next) {
-			skb_unlink(cur, &bus->glom);
-			brcmu_pkt_buf_free_skb(cur);
-		}
+	brcmf_sdbrcm_free_glom(bus);
 
 	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
-- 
1.7.5.4


