Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59531 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaBYTao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:44 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/14] brcmfmac: Correct header debug dump for sdio tx hdrs.
Date: Tue, 25 Feb 2014 20:30:29 +0100
Message-ID: <1393356639-19169-6-git-send-email-arend@broadcom.com> (sfid-20140225_203050_283403_38A14329)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ce1ee1e..ce99732 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2193,10 +2193,10 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		if (BRCMF_BYTES_ON() &&
 		    ((BRCMF_CTL_ON() && chan == SDPCM_CONTROL_CHANNEL) ||
 		     (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)))
-			brcmf_dbg_hex_dump(true, pkt_next, hd_info.len,
+			brcmf_dbg_hex_dump(true, pkt_next->data, hd_info.len,
 					   "Tx Frame:\n");
 		else if (BRCMF_HDRS_ON())
-			brcmf_dbg_hex_dump(true, pkt_next,
+			brcmf_dbg_hex_dump(true, pkt_next->data,
 					   head_pad + bus->tx_hdrlen,
 					   "Tx Header:\n");
 	}
-- 
1.7.10.4

