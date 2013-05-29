Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1466 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759328Ab3E2QjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 15/16] brcmfmac: Fix endless loop when
 brcmf_fws_commit_skb fails.
Date: Wed, 29 May 2013 18:39:05 +0200
Message-ID: <1369845546-31950-16-git-send-email-arend@broadcom.com> (sfid-20130529_183946_107360_2C364165)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 8b2297a..5d66f3a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1914,7 +1914,8 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 					brcmf_fws_return_credits(fws, fifo, 1);
 					break;
 				}
-				brcmf_fws_commit_skb(fws, fifo, skb);
+				if (brcmf_fws_commit_skb(fws, fifo, skb))
+					break;
 				if (fws->bus_flow_blocked)
 					break;
 			}
-- 
1.7.10.4


