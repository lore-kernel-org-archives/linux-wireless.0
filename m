Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2376 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab3FRL3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: rename variable prec to more appropriate
 name, ie. fifo
Date: Tue, 18 Jun 2013 13:29:23 +0200
Message-ID: <1371554970-23495-3-git-send-email-arend@broadcom.com> (sfid-20130618_132956_718260_BF78584B)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The term prec (precedence) is different from the fifo number. Rename
use of prec with fifo to be consistent and clear.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 1d8fa7d..e66b723 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -839,7 +839,7 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 
 static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 				 struct brcmf_fws_mac_descriptor *entry,
-				 int prec, bool send_immediately)
+				 int fifo, bool send_immediately)
 {
 	struct sk_buff *skb;
 	struct brcmf_bus *bus;
@@ -848,10 +848,10 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 	u32 len;
 
 	/* check delayedQ and suppressQ in one call using bitmap */
-	if (brcmu_pktq_mlen(&entry->psq, 3 << (prec * 2)) == 0)
-		entry->traffic_pending_bmp &= ~NBITVAL(prec);
+	if (brcmu_pktq_mlen(&entry->psq, 3 << (fifo * 2)) == 0)
+		entry->traffic_pending_bmp &= ~NBITVAL(fifo);
 	else
-		entry->traffic_pending_bmp |= NBITVAL(prec);
+		entry->traffic_pending_bmp |= NBITVAL(fifo);
 
 	entry->send_tim_signal = false;
 	if (entry->traffic_lastreported_bmp != entry->traffic_pending_bmp)
-- 
1.7.10.4


