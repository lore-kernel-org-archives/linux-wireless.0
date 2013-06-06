Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1421 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab3FFLUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:20:03 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/22] brcmfmac: fix invalid ifp lookup in
 firmware-signalling
Date: Thu, 6 Jun 2013 13:17:57 +0200
Message-ID: <1370517487-14395-13-git-send-email-arend@broadcom.com> (sfid-20130606_132007_089133_97DDE4C8)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The destination entries for firmware-signalled flow control have
the interface id stored. This needs to be translated to bsscfg
index when looking up the ifp object for the interface.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 66b93e9..17802a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -882,7 +882,7 @@ static void
 brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
 			     u8 if_id)
 {
-	struct brcmf_if *ifp = fws->drvr->iflist[if_id];
+	struct brcmf_if *ifp = fws->drvr->iflist[!if_id ? 0 : if_id + 1];
 
 	if (WARN_ON(!ifp))
 		return;
-- 
1.7.10.4


