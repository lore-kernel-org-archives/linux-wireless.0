Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:63245 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbcFCVbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:18 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wrightf <wright.feng@broadcom.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/6] brcmfmac: change rx_seq check log from error print to debug print
Date: Fri,  3 Jun 2016 23:31:11 +0200
Message-Id: <1464989472-29684-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233126_193355_E238510E)
In-Reply-To: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: wrightf <wright.feng@broadcom.com>

The bus rx sequence is not in order because that control and event
frames always cause immediate send, but data frames may be held
for glomming in firmware side. It is not actually an error as the
packets are still processed even if the RX sequence is not in order.
Therefor the error message is rephrased and changed to a debug
message.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Wright Feng <wright.feng@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 22b7dc0..5fb8b91 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1384,8 +1384,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 		return -ENXIO;
 	}
 	if (rd->seq_num != rx_seq) {
-		brcmf_err("seq %d: sequence number error, expect %d\n",
-			  rx_seq, rd->seq_num);
+		brcmf_dbg(SDIO, "seq %d, expected %d\n", rx_seq, rd->seq_num);
 		bus->sdcnt.rx_badseq++;
 		rd->seq_num = rx_seq;
 	}
-- 
1.9.1

