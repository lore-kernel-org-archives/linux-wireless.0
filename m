Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3803 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/20] staging: brcm80211: removed unused softmac code
 after macro cleanup
Date: Mon, 12 Sep 2011 12:14:58 +0200
Message-ID: <1315822504-24210-15-git-send-email-rvossen@broadcom.com> (sfid-20110912_121547_751801_CF6F0A14)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the macro's IS_MCS(0), RSPEC_STF(0) and PHY_TXC1_MODE_SISO all
expand to 0, inactive code could be removed.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    2 --
 drivers/staging/brcm80211/brcmsmac/stf.c  |   26 --------------------------
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d30116d..7ebe060 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5982,8 +5982,6 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 		for (i = 0; i < wlc->pub->_nbands; i++) {
 			memset(wlc->bandstate[i]->hw_rateset.mcs, 0,
 			       MCSSET_LEN);
-			if (IS_MCS(0))
-				brcms_c_reprate_init(wlc);
 		}
 		break;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 71c5d23..82805e0 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -291,32 +291,6 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 	if (txstreams > MAX_STREAMS_SUPPORTED)
 		return -EINVAL;
 
-	if (txstreams == 1) {
-		for (i = 0; i < wlc->pub->_nbands; i++)
-			if ((RSPEC_STF(0) !=
-			     PHY_TXC1_MODE_SISO)
-			    || (RSPEC_STF(0) !=
-				PHY_TXC1_MODE_SISO)) {
-				if (!force)
-					return -EBADE;
-
-				/* over-write the override rspec */
-				if (RSPEC_STF(0)
-				    != PHY_TXC1_MODE_SISO) {
-					wiphy_err(wlc->wiphy, "%s(): temp "
-						  "sense override non-SISO "
-						  "rspec_override\n",
-						  __func__);
-				}
-				if (RSPEC_STF(0) != PHY_TXC1_MODE_SISO) {
-					wiphy_err(wlc->wiphy, "%s(): temp "
-						  "sense override non-SISO "
-						  "mrspec_override\n",
-						  __func__);
-				}
-			}
-	}
-
 	wlc->stf->txchain = txchain;
 	wlc->stf->txstreams = txstreams;
 	brcms_c_stf_stbc_tx_set(wlc, wlc->band->band_stf_stbc_tx);
-- 
1.7.4.1


