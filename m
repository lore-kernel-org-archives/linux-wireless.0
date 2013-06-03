Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpe-075-189-159-031.nc.res.rr.com ([75.189.159.31]:35295 "EHLO
	jgpicker.rdu.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758145Ab3FCNrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 09:47:52 -0400
From: John Greene <jogreene@redhat.com>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH] brcmsmac: Reduce log spam in heavy tx, make err print in debug
Date: Mon,  3 Jun 2013 09:47:39 -0400
Message-Id: <1370267259-19712-1-git-send-email-jogreene@redhat.com> (sfid-20130603_154758_221201_49B0535E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move message to debug mode to reduce log spam under heavy tx (iperf) load.
This message prints in ht debug mode only:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 153

Signed-off-by: John Greene <jogreene@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 1585cc5..bd98285 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -900,7 +900,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		if (supr_status) {
 			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
-				brcms_err(wlc->hw->d11core,
+				brcms_dbg_ht(wlc->hw->d11core,
 					  "%s: Pkt tx suppressed, illegal channel possibly %d\n",
 					  __func__, CHSPEC_CHANNEL(
 					  wlc->default_bss->chanspec));
-- 
1.8.1.4

