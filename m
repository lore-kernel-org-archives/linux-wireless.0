Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1757 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/9] brcmfmac: remove (ab)use of NL80211_NUM_ACS
Date: Wed, 26 Jun 2013 14:20:15 +0200
Message-ID: <1372249222-4858-3-git-send-email-arend@broadcom.com> (sfid-20130626_142118_433539_AE798BAC)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used NL80211_NUM_ACS to indicate the BCMC fifo used in the driver
which has the same value now, but it is a bad idea relying on that.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 41f902d..e4fd13a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1851,7 +1851,7 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	fws = container_of(worker, struct brcmf_fws_info, fws_dequeue_work);
 
 	brcmf_fws_lock(fws->drvr, flags);
-	for (fifo = NL80211_NUM_ACS; fifo >= 0 && !fws->bus_flow_blocked;
+	for (fifo = BRCMF_FWS_FIFO_BCMC; fifo >= 0 && !fws->bus_flow_blocked;
 	     fifo--) {
 		while ((fws->fifo_credit[fifo]) || ((!fws->bcmc_credit_check) &&
 		       (fifo == BRCMF_FWS_FIFO_BCMC))) {
-- 
1.7.10.4


