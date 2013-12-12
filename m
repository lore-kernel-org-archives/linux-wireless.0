Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32343 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3LLK7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:16 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/18] brcmfmac: add missing curly braces in brcmf_fws_txstatus_suppressed()
Date: Thu, 12 Dec 2013 11:58:49 +0100
Message-ID: <1386845946-9859-2-git-send-email-arend@broadcom.com> (sfid-20131212_122500_281369_C04BB153)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0-day testing from Fenguang Wu issued the following warning:

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   4b074b07625f603d40d4d04937f8874a00415dc4
commit: 1e86d69662d7d86360624f74bbe1b5fa1b8ffb13
    [33/59] brcmfmac: Update fwsignal to fix out of order tx.

>> drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c:1393:2-56:
    code aligned with following code on line 1394

vim +1393 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c

84bcc0c3  1387 	}
84bcc0c3  1388
84bcc0c3  1389 	entry->generation = genbit;
84bcc0c3  1390
2747e5f7  1391 	ret = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
2747e5f7  1392 	if (ret == 0)
1e86d696 @1393 		brcmf_skb_htod_tag_set_field(skb, GENERATION, ..
1e86d696 @1394 		brcmf_skbcb(skb)->htod_seq = seq;
1e86d696  1395 		if (brcmf_skb_htod_seq_get_field(skb, FROMFW)) {
1e86d696  1396 			brcmf_skb_htod_seq_set_field(skb, ..
1e86d696  1397 			brcmf_skb_htod_seq_set_field(skb, ..

This warning is valid and the if statement needs curly braces here.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index e9bdfdb..a593784 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1393,7 +1393,7 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 	entry->generation = genbit;
 
 	ret = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
-	if (ret == 0)
+	if (ret == 0) {
 		brcmf_skb_htod_tag_set_field(skb, GENERATION, genbit);
 		brcmf_skbcb(skb)->htod_seq = seq;
 		if (brcmf_skb_htod_seq_get_field(skb, FROMFW)) {
@@ -1404,6 +1404,8 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 		}
 		ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo,
 				    skb);
+	}
+
 	if (ret != 0) {
 		/* suppress q is full or hdrpull failed, drop this packet */
 		brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
-- 
1.7.10.4

