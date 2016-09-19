Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34274 "EHLO
        mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756627AbcISLKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:25 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 7/9] brcmfmac: fix clearing entry IPv6 address
Date: Mon, 19 Sep 2016 12:09:57 +0100
Message-Id: <1474283399-14385-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131042_113373_21566E3F)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

When IPv6 address is to be cleared there is a possible out of
bound access. But also the clearing of the last entry and the
adjustment of total number of stored IPv6 addresses is not
updated. This patch fixes that bug. Bug was found using coverity.

Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 3394184..bb71199 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -873,9 +873,12 @@ static int brcmf_inet6addr_changed(struct notifier_block *nb,
 		}
 		break;
 	case NETDEV_DOWN:
-		if (i < NDOL_MAX_ENTRIES)
-			for (; i < ifp->ipv6addr_idx; i++)
+		if (i < NDOL_MAX_ENTRIES) {
+			for (; i < ifp->ipv6addr_idx - 1; i++)
 				table[i] = table[i + 1];
+			memset(&table[i], 0, sizeof(table[i]));
+			ifp->ipv6addr_idx--;
+		}
 		break;
 	default:
 		break;
-- 
1.9.1
