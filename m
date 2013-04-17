Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4874 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966742Ab3DQT0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/10] brcmfmac: reinitialize dequeue mask per node
Date: Wed, 17 Apr 2013 21:25:49 +0200
Message-ID: <1366226758-20641-2-git-send-email-arend@broadcom.com> (sfid-20130417_212629_622594_5CEDB5A7)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mask was only initialized for the first node, but it should be
done for each node that is handled in the loop.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 1bcd58c..9dae8fc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1070,7 +1070,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 	int num_nodes;
 	int node_pos;
 	int prec_out;
-	int pmsk = 3;
+	int pmsk;
 	int i;
 
 	table = (struct brcmf_fws_mac_descriptor *)&fws->desc;
@@ -1084,6 +1084,8 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 
 		if (entry->suppressed)
 			pmsk = 2;
+		else
+			pmsk = 3;
 		p = brcmu_pktq_mdeq(&entry->psq, pmsk << (fifo * 2), &prec_out);
 		if (p == NULL) {
 			if (entry->suppressed) {
-- 
1.7.10.4


