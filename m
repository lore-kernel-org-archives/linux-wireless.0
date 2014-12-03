Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28975 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaLCUFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:38 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: Fix bitmap malloc bug in msgbuf.
Date: Wed, 3 Dec 2014 21:05:27 +0100
Message-ID: <1417637133-6966-2-git-send-email-arend@broadcom.com> (sfid-20141203_210543_187922_E1F16984)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Cc: stable@vger.kernel.org # v3.17, v3.18
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 9f783db..5b0b70f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1354,6 +1354,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	}
 	INIT_WORK(&msgbuf->txflow_work, brcmf_msgbuf_txflow_worker);
 	count = BITS_TO_LONGS(if_msgbuf->nrof_flowrings);
+	count = count * sizeof(unsigned long);
 	msgbuf->flow_map = kzalloc(count, GFP_KERNEL);
 	if (!msgbuf->flow_map)
 		goto fail;
-- 
1.9.1

