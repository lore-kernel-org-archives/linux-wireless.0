Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1556 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab3GVKqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 06:46:40 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.11 2/2] brcmfmac: bail out of
 brcmf_txflowblock_if() for non-netdev interface
Date: Mon, 22 Jul 2013 12:46:24 +0200
Message-ID: <1374489984-18250-3-git-send-email-arend@broadcom.com> (sfid-20130722_124643_277618_C98997FC)
In-Reply-To: <1374489984-18250-1-git-send-email-arend@broadcom.com>
References: <1374489984-18250-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To avoid ending up in a NULL-pointer access, the function
brcmf_txflowblock_if() should only be called for interfaces
that have a netdev associated with it.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8e89755..8009901 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -242,7 +242,7 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 {
 	unsigned long flags;
 
-	if (!ifp)
+	if (!ifp || !ifp->ndev)
 		return;
 
 	brcmf_dbg(TRACE, "enter: idx=%d stop=0x%X reason=%d state=%d\n",
-- 
1.7.10.4


