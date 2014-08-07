Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42512 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaHGMpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 08:45:14 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 2/2] brcmfmac: fix memory leakage in msgbuf
Date: Thu, 7 Aug 2014 14:45:09 +0200
Message-ID: <1407415509-22442-3-git-send-email-arend@broadcom.com> (sfid-20140807_144532_658797_C23A1258)
In-Reply-To: <1407415509-22442-1-git-send-email-arend@broadcom.com>
References: <1407415509-22442-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kbuild robot came up with the following warning:

tree:   .../kernel/git/linville/wireless-next.git master
head:   dc6be9f54a4ecb0a09765d1f515ed947d86b7528
commit: 9a1bb60250d2b6b546a62e5b73f55c4f1d22016b
	 [5/13] brcmfmac: Adding msgbuf protocol.

coccinelle warnings:
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c:1309:1-28:
   alloc with no test, possible model on line 1318

Looking into the issue, it turned out that the referred allocation
buffer was not being released in failure path nor upon module
unload.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 535c7eb..8f8b937 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1318,6 +1318,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	msgbuf->nrof_flowrings = if_msgbuf->nrof_flowrings;
 	msgbuf->flowring_dma_handle = kzalloc(msgbuf->nrof_flowrings *
 		sizeof(*msgbuf->flowring_dma_handle), GFP_ATOMIC);
+	if (!msgbuf->flowring_dma_handle)
+		goto fail;
 
 	msgbuf->rx_dataoffset = if_msgbuf->rx_dataoffset;
 	msgbuf->max_rxbufpost = if_msgbuf->max_rxbufpost;
@@ -1362,6 +1364,7 @@ fail:
 		kfree(msgbuf->flow_map);
 		kfree(msgbuf->txstatus_done_map);
 		brcmf_msgbuf_release_pktids(msgbuf);
+		kfree(msgbuf->flowring_dma_handle);
 		if (msgbuf->ioctbuf)
 			dma_free_coherent(drvr->bus_if->dev,
 					  BRCMF_TX_IOCTL_MAX_MSG_SIZE,
@@ -1391,6 +1394,7 @@ void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr)
 				  BRCMF_TX_IOCTL_MAX_MSG_SIZE,
 				  msgbuf->ioctbuf, msgbuf->ioctbuf_handle);
 		brcmf_msgbuf_release_pktids(msgbuf);
+		kfree(msgbuf->flowring_dma_handle);
 		kfree(msgbuf);
 		drvr->proto->pd = NULL;
 	}
-- 
1.9.1

