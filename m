Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45679 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933792AbcISLKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:24 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 9/9] brcmfmac: simplify mapping of auth type
Date: Mon, 19 Sep 2016 12:09:59 +0100
Message-Id: <1474283399-14385-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131036_312416_1F56D173)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

The 802.11 standard only has four valid auth type configurations of which
our firmware only supports two, ie. Open System and Shared Key. Simplify
the mapping falling back to automatic for other types specified by
user-space.

Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 386ad7e..3b7c0f6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1595,15 +1595,9 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		val = 1;
 		brcmf_dbg(CONN, "shared key\n");
 		break;
-	case NL80211_AUTHTYPE_AUTOMATIC:
-		val = 2;
-		brcmf_dbg(CONN, "automatic\n");
-		break;
-	case NL80211_AUTHTYPE_NETWORK_EAP:
-		brcmf_dbg(CONN, "network eap\n");
 	default:
 		val = 2;
-		brcmf_err("invalid auth type (%d)\n", sme->auth_type);
+		brcmf_dbg(CONN, "automatic, auth type (%d)\n", sme->auth_type);
 		break;
 	}
 
-- 
1.9.1
