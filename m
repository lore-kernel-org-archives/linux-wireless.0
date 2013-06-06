Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4845 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab3FFLSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/22] brcmfmac: fix send_pkts statistic counter in
 firmware-signalling
Date: Thu, 6 Jun 2013 13:18:02 +0200
Message-ID: <1370517487-14395-18-git-send-email-arend@broadcom.com> (sfid-20130606_131855_352432_051B1FBA)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The statistic counter send_pkts was wrongly counted conditionally.
Correcting the mistake.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index ea37bd4..534507a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1763,10 +1763,9 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		entry->suppr_transit_count++;
 	entry->seq[fifo]++;
 	fws->stats.pkt2bus++;
-	if (brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
-		fws->stats.send_pkts[fifo]++;
+	fws->stats.send_pkts[fifo]++;
+	if (brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
 		fws->stats.fifo_credits_sent[fifo]++;
-	}
 
 	return rc;
 
-- 
1.7.10.4


