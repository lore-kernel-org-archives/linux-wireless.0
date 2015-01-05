Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:58650 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbbAET6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 14:58:00 -0500
From: Arend van Spriel <arend@broadcom.com>
To: <stable@vger.kernel.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH for-3.17] brcmfmac: Fix bitmap malloc bug in msgbuf.
Date: Mon, 5 Jan 2015 20:57:56 +0100
Message-ID: <1420487876-11288-1-git-send-email-arend@broadcom.com> (sfid-20150105_205808_300364_9CE6E354)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

commit 333c2aa029b847051a2db76a6ca59f699a520030 upstream.

Backported to linux-3.17.y branch of stable repository.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 8f8b937..9d61ee9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1282,6 +1282,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	}
 	INIT_WORK(&msgbuf->txflow_work, brcmf_msgbuf_txflow_worker);
 	count = BITS_TO_LONGS(if_msgbuf->nrof_flowrings);
+	count = count * sizeof(unsigned long);
 	msgbuf->flow_map = kzalloc(count, GFP_ATOMIC);
 	if (!msgbuf->flow_map)
 		goto fail;
-- 
1.9.1

