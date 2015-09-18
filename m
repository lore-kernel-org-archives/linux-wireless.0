Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:3119 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbIRUI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/16] brcmfmac: Fix p2p bug for older firmwares.
Date: Fri, 18 Sep 2015 22:08:14 +0200
Message-ID: <1442606899-31872-12-git-send-email-arend@broadcom.com> (sfid-20150918_220835_488138_850DC670)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Some devices with older firmwares are reporting new p2p device
interface with the wrong type. Accept this type to get p2p
working for these devices.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 3330f30..dc34d3a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -186,11 +186,13 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		  ifevent->action, ifevent->ifidx, ifevent->bssidx,
 		  ifevent->flags, ifevent->role);
 
-	/* The P2P Device interface event must not be ignored
-	 * contrary to what firmware tells us.
+	/* The P2P Device interface event must not be ignored contrary to what
+	 * firmware tells us. Older firmware uses p2p noif, with sta role.
+	 * This should be accepted.
 	 */
-	is_p2pdev = (ifevent->flags & BRCMF_E_IF_FLAG_NOIF) &&
-		    ifevent->role == BRCMF_E_IF_ROLE_P2P_CLIENT;
+	is_p2pdev = ((ifevent->flags & BRCMF_E_IF_FLAG_NOIF) &&
+		     (ifevent->role == BRCMF_E_IF_ROLE_P2P_CLIENT ||
+		      ifevent->role == BRCMF_E_IF_ROLE_STA));
 	if (!is_p2pdev && (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
 		brcmf_dbg(EVENT, "event can be ignored\n");
 		return;
-- 
1.9.1

