Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7542 "EHLO
        mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933195AbcISLKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:14 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/9] brcmfmac: fix memory leak in brcmf_flowring_add_tdls_peer()
Date: Mon, 19 Sep 2016 12:09:53 +0100
Message-Id: <1474283399-14385-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131031_071040_21D54CE2)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the error paths in brcmf_flowring_add_tdls_peer() the allocated
resource should be freed.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index 7e269f9..b16b367 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -495,14 +495,18 @@ void brcmf_flowring_add_tdls_peer(struct brcmf_flowring *flow, int ifidx,
 	} else {
 		search = flow->tdls_entry;
 		if (memcmp(search->mac, peer, ETH_ALEN) == 0)
-			return;
+			goto free_entry;
 		while (search->next) {
 			search = search->next;
 			if (memcmp(search->mac, peer, ETH_ALEN) == 0)
-				return;
+				goto free_entry;
 		}
 		search->next = tdls_entry;
 	}
 
 	flow->tdls_active = true;
+	return;
+
+free_entry:
+	kfree(tdls_entry);
 }
-- 
1.9.1
